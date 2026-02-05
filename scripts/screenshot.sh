#!/usr/bin/env bash
# Wayland Screenshot Utility

save_screenshot="false"

while getopts ":s" opt; do
  case "$opt" in
    s) save_screenshot="true" ;;
    \?) echo "An option is invalid." >&2; exit 1 ;;
  esac
done

shift "$((OPTIND - 1))"
screenshot_type="$1"

case "$screenshot_type" in
  full|window|region) ;;
  *) echo "Usage: $0 [-s] {full|window|region}" >&2; exit 1 ;;
esac

get_active_monitor_geometry() {
  local monitor_geometry

  if [ "$XDG_CURRENT_DESKTOP" = "hyprland" ]; then
    monitor_geometry="$(hyprctl -j monitors | jq -r '
      .[] | select(.focused==true) | "\(.x),\(.y) \(.width)x\(.height)"
    ')"
  elif [ "$XDG_CURRENT_DESKTOP" = "sway" ]; then
    monitor_geometry="$(swaymsg --type get_outputs | jq -r '
      .[] | select(.focused==true) | "\(.rect.x),\(.rect.y) \(.rect.width)x\(.rect.height)"
    ')"
  else
    echo "Cannot take full screenshot; the active Wayland compositor is unsupported." >&2; exit 1
  fi

  if [ -z "$monitor_geometry" ]; then
    echo "Failed to get the active monitor geometry." >&2; exit 1
  fi

  echo "$monitor_geometry"
}

get_active_window_geometry() {
  local window_geometry

  if [ "$XDG_CURRENT_DESKTOP" = "hyprland" ]; then
    window_geometry="$(hyprctl -j activewindow | jq -r '
      "\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"
    ')"
  elif [ "$XDG_CURRENT_DESKTOP" = "sway" ]; then
    window_geometry="$(swaymsg --type get_tree | jq -r '
      .. | select(.focused?) | .rect | "\(.x),\(.y) \(.width)x\(.height)"
    ')"
  else
    echo "Cannot take window screenshot; only Hyprland and Sway are supported." >&2; exit 1
  fi

  if [ -z "$window_geometry" ]; then
    echo "Failed to get the active window geometry." >&2; exit 1
  fi

  echo "$window_geometry"
}

# Screenshot Commands
ss_full=(grim -g "$(get_active_monitor_geometry)" -t ppm -)
ss_window=(grim -g "$(get_active_window_geometry)" -t ppm -)
ss_region=(grim -g "$(slurp -c '#ed8796ff' -d)" -t ppm -)

# Post-Processing Commands
pp_save=(satty --actions-on-enter="save-to-file,exit" --filename -)
pp_copy=(satty --actions-on-enter="save-to-clipboard,exit" --filename -)

case "$screenshot_type" in
  full)
    if [ "$save_screenshot" = "true" ]; then
      "${ss_full[@]}" | "${pp_save[@]}"
    else
      "${ss_full[@]}" | "${pp_copy[@]}"
    fi
    ;;
  window)
    if [ "$save_screenshot" = "true" ]; then
      "${ss_window[@]}" | "${pp_save[@]}"
    else
      "${ss_window[@]}" | "${pp_copy[@]}"
    fi
    ;;
  region)
    if [ "$save_screenshot" = "true" ]; then
      "${ss_region[@]}" | "${pp_save[@]}"
    else
      "${ss_region[@]}" | "${pp_copy[@]}"
    fi
    ;;
esac
