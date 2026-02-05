# MPD Client
{ config, lib, ... }: {
  options = {
    modules.applications.tui.rmpc.enable = lib.mkEnableOption "the rmpc MPD client";
  };

  config = lib.mkIf config.modules.applications.tui.rmpc.enable {
    programs.rmpc = {
      enable = true;

      # RON
      config = ''
        #![enable(implicit_some)]
        #![enable(unwrap_newtypes)]
        #![enable(unwrap_variant_newtypes)]

        (
          address: "/run/user/1000/mpd/socket", // XDG Runtime Directory
          theme: Some("catppuccin_macchiato"),
          cache_dir: Some("~/.cache/rmpc"), // YouTube Downloads
          lyrics_dir: Some("~/Nextcloud/Media/Audio/Music/Lyrics"), // LRC Files
          wrap_navigation: true,
          select_current_song_on_change: true,

          keybinds: (
            clear: true,

            global: {
              ":":       CommandMode,
              ",":       VolumeDown,
              "s":       Stop,
              ".":       VolumeUp,
              "<Tab>":   NextTab,
              "<S-Tab>": PreviousTab,
              "1":       SwitchToTab("Queue"),
              "2":       SwitchToTab("Directories"),
              "3":       SwitchToTab("Artists"),
              "4":       SwitchToTab("Album Artists"),
              "5":       SwitchToTab("Albums"),
              "6":       SwitchToTab("Playlists"),
              "7":       SwitchToTab("Search"),
              "q":       Quit,
              ">":       NextTrack,
              "p":       TogglePause,
              "<":       PreviousTrack,
              "f":       SeekForward,
              "z":       ToggleRepeat,
              "x":       ToggleRandom,
              "c":       ToggleConsume,
              "v":       ToggleSingle,
              "b":       SeekBack,
              "~":       ShowHelp,
              "u":       Update,
              "U":       Rescan,
              "I":       ShowCurrentSongInfo,
              "O":       ShowOutputs,
              "P":       ShowDecoders,
              "R":       AddRandom
            },

            navigation: {
              "k":         Up,
              "j":         Down,
              "h":         Left,
              "l":         Right,
              "<Up>":      Up,
              "<Down>":    Down,
              "<Left>":    Left,
              "<Right>":   Right,
              "<C-k>":     PaneUp,
              "<C-j>":     PaneDown,
              "<C-h>":     PaneLeft,
              "<C-l>":     PaneRight,
              "<C-u>":     UpHalf,
              "N":         PreviousResult,
              "a":         Add,
              "A":         AddAll,
              "r":         Rename,
              "n":         NextResult,
              "g":         Top,
              "<Space>":   Select,
              "<C-Space>": InvertSelection,
              "G":         Bottom,
              "<CR>":      Confirm,
              "i":         FocusInput,
              "J":         MoveDown,
              "<C-d>":     DownHalf,
              "/":         EnterSearch,
              "<C-c>":     Close,
              "<Esc>":     Close,
              "K":         MoveUp,
              "D":         Delete,
              "B":         ShowInfo,
              "<C-z>":     ContextMenu(),
              "<C-s>":     Save(kind: Modal(all: false, duplicates_strategy: Ask))
            },

            queue: {
              "D":       DeleteAll,
              "<CR>":    Play,
              "a":       AddToPlaylist,
              "d":       Delete,
              "C":       JumpToCurrent,
              "X":       Shuffle
            }
          ),

          tabs: [
            (
              name: "Queue",

              pane: Split(
                direction: Horizontal,

                panes: [
                  (
                    size: "60%",
                    pane: Pane(Queue)
                  ),

                  (
                    size: "40%",

                    pane: Split(
                      direction: Vertical,

                      panes: [
                        (
                          size: "3",
                          pane: Pane(Lyrics)
                        ),

                        (
                          size: "100%",
                          pane: Pane(AlbumArt)
                        )
                      ]
                    )
                  )
                ]
              )
            ),

            (
              name: "Directories",
              pane: Pane(Directories)
            ),

            (
              name: "Artists",
              pane: Pane(Artists)
            ),

            (
              name: "Album Artists",
              pane: Pane(AlbumArtists)
            ),

            (
              name: "Albums",
              pane: Pane(Albums)
            ),

            (
              name: "Playlists",
              pane: Pane(Playlists)
            ),

            (
              name: "Search",
              pane: Pane(Search)
            )
          ]
        )
      '';
    };

    # Catppuccin Macchiato
    xdg.configFile."rmpc/themes/catppuccin_macchiato.ron".text = with config.modules.appearance.colors.schemes.catppuccin.macchiato; ''
      #![enable(implicit_some)]
      #![enable(unwrap_newtypes)]
      #![enable(unwrap_variant_newtypes)]

      (
        default_album_art_path: None,
        show_song_table_header: true,
        draw_borders: true,
        format_tag_separator: " | ",
        browser_column_widths: [20, 38, 42],
        background_color: None,
        text_color: None,
        header_background_color: None,
        modal_background_color: None,
        modal_backdrop: false,
        preview_label_style: (fg: "${yellow}"),
        preview_metadata_group_style: (fg: "${yellow}", modifiers: "Bold"),

        tab_bar: (
          active_style: (fg: "${base}", bg: "${sky}", modifiers: "Bold"),
          inactive_style: ()
        ),

        highlighted_item_style: (fg: "${sky}", modifiers: "Bold"),
        current_item_style: (fg: "${base}", bg: "${sky}", modifiers: "Bold"),
        borders_style: (fg: "${sky}"),
        highlight_border_style: (fg: "${sky}"),

        symbols: (
          song: "S",
          dir: "D",
          playlist: "P",
          marker: "M",
          ellipsis: "...",
          song_style: None,
          dir_style: None,
          playlist_style: None
        ),

        level_styles: (
          info: (fg: "${blue}", bg: "${overlay0}"),
          warn: (fg: "${yellow}", bg: "${overlay0}"),
          error: (fg: "${red}", bg: "${overlay0}"),
          debug: (fg: "${green}", bg: "${overlay0}"),
          trace: (fg: "${mauve}", bg: "${overlay0}")
        ),

        progress_bar: (
          symbols: ["[", "-", ">", " ", "]"],
          track_style: (fg: "${mantle}"),
          elapsed_style: (fg: "${sky}"),
          thumb_style: (fg: "${sky}", bg: "${mantle}"),
          use_track_when_empty: false
        ),

        scrollbar: (
          symbols: ["│", "█", "▲", "▼"],
          track_style: (),
          ends_style: (),
          thumb_style: (fg: "${sky}")
        ),

        song_table_format: [
          (
            prop: (kind: Property(Artist),
              default: (kind: Text("Unknown"))
            ),

            width: "20%"
          ),

          (
            prop: (kind: Property(Title),
              default: (kind: Text("Unknown"))
            ),

            width: "35%"
          ),

          (
            prop: (kind: Property(Album), style: (fg: "${text}"),
              default: (kind: Text("Unknown Album"), style: (fg: "${text}"))
            ),

            width: "30%"
          ),

          (
            prop: (kind: Property(Duration),
              default: (kind: Text("-"))
            ),

            width: "15%",
            alignment: Right
          )
        ],

        components: {},

        layout: Split(
          direction: Vertical,

          panes: [
            (
              pane: Pane(Header),
              size: "2"
            ),

            (
              pane: Pane(Tabs),
              size: "3"
            ),

            (
              pane: Pane(TabContent),
              size: "100%"
            ),

            (
              pane: Pane(ProgressBar),
              size: "1"
            )
          ]
        ),

        header: (
          rows: [
            (
              left: [
                (kind: Text("["), style: (fg: "${yellow}", modifiers: "Bold")),
                (kind: Property(Status(StateV2(playing_label: "Playing", paused_label: "Paused", stopped_label: "Stopped"))), style: (fg: "${yellow}", modifiers: "Bold")),
                (kind: Text("]"), style: (fg: "${yellow}", modifiers: "Bold"))
              ],

              center: [
                (kind: Property(Song(Title)), style: (modifiers: "Bold"),
                  default: (kind: Text("No Song"), style: (modifiers: "Bold"))
                )
              ],

              right: [
                (kind: Property(Widget(ScanStatus)), style: (fg: "${blue}")),
                (kind: Property(Widget(Volume)), style: (fg: "${blue}"))
              ]
            ),

            (
              left: [
                (kind: Property(Status(Elapsed))),
                (kind: Text(" / ")),
                (kind: Property(Status(Duration))),
                (kind: Text(" (")),
                (kind: Property(Status(Bitrate))),
                (kind: Text(" kbps)"))
              ],

              center: [
                (kind: Property(Song(Artist)), style: (fg: "${yellow}", modifiers: "Bold"),
                  default: (kind: Text("Unknown"), style: (fg: "${yellow}", modifiers: "Bold"))
                ),

                (kind: Text(" - ")),

                (kind: Property(Song(Album)),
                  default: (kind: Text("Unknown Album"))
                )
              ],

              right: [
                (
                  kind: Property(Widget(States(
                    active_style: (fg: "${text}", modifiers: "Bold"),
                    separator_style: (fg: "${text}")))
                  ),

                  style: (fg: "${subtext0}")
                )
              ]
            )
          ]
        ),

        browser_song_format: [
          (
            kind: Group([
              (kind: Property(Track)),
              (kind: Text(" "))
            ])
          ),

          (
            kind: Group([
              (kind: Property(Artist)),
              (kind: Text(" - ")),
              (kind: Property(Title))
            ]),

            default: (kind: Property(Filename))
          )
        ],

        lyrics: (
          timestamp: false
        )
      )
    '';
  };
}
