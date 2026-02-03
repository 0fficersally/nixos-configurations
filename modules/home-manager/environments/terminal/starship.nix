# Cross-Shell Prompt
{ config, lib, ... }: {
  options = {
    modules.environments.terminal.starship.enable = lib.mkEnableOption "the Starship cross-shell prompt";
  };

  config = lib.mkIf config.modules.environments.terminal.starship.enable {
    programs.starship = {
      enable = true;

      # TOML
      settings = with config.modules.appearance.colors.schemes.catppuccin.macchiato; {
        format = lib.concatStrings [
          "[](fg:${teal})"
          "$container"
          "$os"
          "$hostname"
          "[](bg:${blue} fg:${teal})"
          "$username"
          "[](bg:${teal} fg:${blue})"
          "$shell"
          "$nix_shell"
          "[](bg:${blue} fg:${teal})"
          "$directory"
          "[](bg:${teal} fg:${blue})"
          "$git_branch"
          "$git_status"
          "[](bg:${blue} fg:${teal})"
          "$docker_context"
          "$conda"
          "[](bg:${teal} fg:${blue})"
          "$c"
          "$cpp"
          "$deno"
          "$golang"
          "$haskell"
          "$java"
          "$kotlin"
          "$nodejs"
          "$php"
          "$python"
          "$rust"
          "[](bg:${blue} fg:${teal})"
          "$time"
          "[](fg:${blue})"
          "$line_break"
          "$character"
        ];

        container = {
          symbol = "";
          style = "bg:${teal} fg:${base}";
          format = "[ $symbol $name]($style)";
        };

        os = {
          disabled = false;

          symbols = {
            Android = "";
            Arch = "󰣇";
            Debian = "󰣚";
            Linux = "";
            Macos = "󰀶";
            NixOS = "";
            openSUSE = "";
            Unknown = "";
          };

          style = "bg:${teal} fg:${base}";
          format = "[ $symbol ]($style)";
        };

        hostname = {
          ssh_only = false;
          style = "bg:${teal} fg:${base}";
          format = "[$hostname ]($style)";
        };

        username = {
          show_always = true;
          style_root = "bg:${blue} fg:${base}";
          style_user = "bg:${blue} fg:${base}";
          format = "[ $user ]($style)";
        };

        shell = {
          disabled = false;
          bash_indicator = "bash";
          fish_indicator = "fish";
          powershell_indicator = "powershell";
          unknown_indicator = "unknown";
          style = "bg:${teal} fg:${base}";
          format = "[ $indicator ]($style)";
        };

        nix_shell = {
          symbol = "";
          style = "bg:${teal} fg:${base}";
          format = "[$symbol $name ]($style)";
        };

        directory = {
          truncation_symbol = "…/";

          substitutions = {
            "Documents" = "󱔗";
            "Downloads" = "";
            "Pictures" = "󰉔";
          };

          read_only = "󰏯";
          style = "bg:${blue} fg:${base}";
          format = "[ $path $read_only ]($style)";
        };

        git_branch = {
          symbol = "";
          style = "bg:${teal} fg:${base}";
          format = "[ $symbol $branch(:$remote_branch) ]($style)";
        };

        git_status = {
          style = "bg:${teal} fg:${base}";
          format = "[\\[$all_status $ahead_behind\\] ]($style)";
        };

        docker_context = {
          symbol = "";
          style = "bg:${blue} fg:${base}";
          format = "[ $symbol $context ]($style)";
        };

        conda = {
          symbol = "";
          style = "bg:${blue} fg:${base}";
          format = "[$symbol $environment ]($style)";
        };

        c = {
          symbol = "";
          style = "bg:${teal} fg:${base}";
          format = "[ $symbol ($version(-$name)) ]($style)";
        };

        cpp = {
          symbol = "";
          style = "bg:${teal} fg:${base}";
          format = "[$symbol ($version(-$name)) ]($style)";
        };

        deno = {
          symbol = "";
          style = "bg:${teal} fg:${base}";
          format = "[$symbol ($version) ]($style)";
        };

        golang = {
          symbol = "";
          style = "bg:${teal} fg:${base}";
          format = "[$symbol ($version) ]($style)";
        };

        haskell = {
          symbol = "";
          style = "bg:${teal} fg:${base}";
          format = "[$symbol ($version) ]($style)";
        };

        java = {
          symbol = "";
          style = "bg:${teal} fg:${base}";
          format = "[$symbol ($version) ]($style)";
        };

        kotlin = {
          symbol = "";
          style = "bg:${teal} fg:${base}";
          format = "[$symbol ($version) ]($style)";
        };

        nodejs = {
          symbol = "";
          style = "bg:${teal} fg:${base}";
          format = "[$symbol ($version) ]($style)";
        };

        php = {
          symbol = "";
          style = "bg:${teal} fg:${base}";
          format = "[$symbol ($version) ]($style)";
        };

        python = {
          symbol = "";
          style = "bg:${teal} fg:${base}";
          format = "[$symbol $pyenv_prefix($version )(\\($virtualenv\\)) ]($style)";
        };

        rust = {
          symbol = "";
          style = "bg:${teal} fg:${base}";
          format = "[$symbol ($version) ]($style)";
        };

        time = {
          disabled = false;
          style = "bg:${blue} fg:${base}";
          format = "[ $time ]($style)";
        };

        character = {
          success_symbol = "[❯](bold fg:${green})";
          error_symbol = "[❯](bold fg:${red})";
          vimcmd_symbol = "[❮](bold fg:${green})";
          vimcmd_visual_symbol = "[❮](bold fg:${yellow})";
          vimcmd_replace_symbol = "[❮](bold fg:${mauve})";
          vimcmd_replace_one_symbol = "[❮](bold fg:${mauve})";
          format = "$symbol ";
        };
      };
    };
  };
}
