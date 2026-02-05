#!/usr/bin/env bash
# Control Display Power State

# Ensure Single Argument
if [[ $# -ne 1 ]] || [[ ! "$1" =~ ^(on|off)$ ]]; then
  echo "Usage: $0 [on|off]" >&2; exit 1
fi

state="$1"

# Alter Screen State
case "$XDG_CURRENT_DESKTOP" in
  hyprland) hyprctl dispatch dpms "$state" ;;
  niri) niri msg action power-"$state"-monitors ;;
  sway) swaymsg "output * power $state" ;;
  *) echo "The active Wayland compositor is unsupported." >&2; exit 1 ;;
esac
