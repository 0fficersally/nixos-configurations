# Code Editor
{ config, lib, pkgs, nix4vscode, ... }: {
  options = {
    modules.applications.gui.vscodium.enable = lib.mkEnableOption "the VSCodium code editor";
  };

  config = lib.mkIf config.modules.applications.gui.vscodium.enable {
    nixpkgs.overlays = [ nix4vscode.overlays.default ];

    programs.vscodium = {
      enable = true;

      profiles.default = {
        extensions = pkgs.nix4vscode.forOpenVsx [
          "bierner.markdown-mermaid" # Markdown Preview Mermaid Support
          "bradlc.vscode-tailwindcss" # Tailwind CSS IntelliSense
          "catppuccin.catppuccin-vsc" # Catppuccin for VSCode
          "catppuccin.catppuccin-vsc-icons" # Catppuccin Icons for VSCode
          "charliermarsh.ruff" # Ruff
          "denoland.vscode-deno" # Deno
          "detachhead.basedpyright" # BasedPyright
          "jnoortheen.nix-ide" # Nix IDE
          "ms-azuretools.vscode-containers" # Container Tools
          "ms-python.python" # Python
          "tamasfe.even-better-toml" # Even Better TOML
          "wakatime.vscode-wakatime" # WakaTime
          "yzhang.markdown-all-in-one" # Markdown All in One
        ];

        userSettings = {
          "diffEditor.ignoreTrimWhitespace" = false;
          "diffEditor.renderSideBySide" = false;
          "editor.acceptSuggestionOnEnter" = "smart";
          "editor.codeActionsOnSave"."source.sortImports" = "always";
          "editor.fontFamily" = "Maple Mono NF CN";
          "editor.fontLigatures" = true;
          "editor.fontSize" = 16;
          "editor.formatOnPaste" = true;
          "editor.guides.bracketPairs" = true;
          "editor.guides.bracketPairsHorizontal" = true;
          "editor.linkedEditing" = true;
          "editor.mouseWheelZoom" = true;
          "editor.quickSuggestions".strings = "on";
          "editor.semanticHighlighting.enabled" = true;
          "editor.stickyScroll.enabled" = true;
          "editor.suggest.insertMode" = "replace";
          "editor.wordWrap" = "on";
          "explorer.confirmDragAndDrop" = false;
          "explorer.confirmPasteNative" = false;
          "explorer.sortOrder" = "type";
          "files.associations"."*.css" = "tailwindcss";
          "files.trimFinalNewlines" = true;
          "git.openRepositoryInParentFolders" = "always";
          "html.format.indentInnerHtml" = true;
          "javascript.updateImportsOnFileMove.enabled" = "always";
          "telemetry.telemetryLevel" = "off";
          "terminal.integrated.cursorBlinking" = true;
          "terminal.integrated.cursorStyle" = "line";
          "terminal.integrated.fontLigatures.enabled" = true;
          "terminal.integrated.gpuAcceleration" = "on";
          "terminal.integrated.minimumContrastRatio" = 1;
          "terminal.integrated.smoothScrolling" = true;
          "update.showReleaseNotes" = false;
          "window.titleBarStyle" = "custom";
          "workbench.activityBar.location" = "top";
          "workbench.colorTheme" = "Catppuccin Macchiato";
          "workbench.editor.highlightModifiedTabs" = true;
          "workbench.iconTheme" = "catppuccin-macchiato";
          "workbench.startupEditor" = "none";

          # Extensions

          "basedpyright.analysis.diagnosticSeverityOverrides".reportMissingTypeStubs = "none";
          "catppuccin.accentColor" = "sky";
          "containers.containerClient" = "com.microsoft.visualstudio.containers.podman";
          "containers.networks.showBuiltInNetworks" = false;
          "containers.orchestratorClient" = "com.microsoft.visualstudio.orchestrators.podmancompose";
          "markdown.extension.completion.enabled" = true;
          "markdown.extension.preview.autoShowPreviewToSide" = true;
          "markdown.extension.print.absoluteImgPath" = false;
          "markdown.extension.print.theme" = "dark";
          "markdown.extension.toc.orderedList" = true;
          "python.createEnvironment.contentButton" = "show";
          "python.terminal.activateEnvInCurrentTerminal" = true;
        };
      };
    };
  };
}
