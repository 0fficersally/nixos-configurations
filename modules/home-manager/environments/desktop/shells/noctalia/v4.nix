# Legacy
{ config, lib, pkgs, ... }: let noctalia = config.modules.environments.desktop.shells.noctalia; in {
  config = lib.mkIf (noctalia.enable && noctalia.version == "v4") {
    programs.noctalia-shell = {
      enable = true;
      package = pkgs.noctalia-shell; # Override Flake

      settings = {
        settingsVersion = 59;

        bar = {
          barType = "floating";
          position = "top";
          monitors = [ ];
          density = "comfortable";
          showOutline = true;
          showCapsule = true;
          capsuleOpacity = 1;
          capsuleColorKey = "none";
          widgetSpacing = 4;
          contentPadding = 0;
          fontScale = 1;
          enableExclusionZoneInset = false;
          backgroundOpacity = 0;
          useSeparateOpacity = true;
          marginVertical = 8;
          marginHorizontal = 8;
          frameThickness = 8;
          frameRadius = 12;
          outerCorners = true;
          hideOnOverview = false;
          displayMode = "always_visible";
          autoHideDelay = 500;
          autoShowDelay = 150;
          showOnWorkspaceSwitch = true;

          widgets = {
            left = [
              {
                blacklist = [ ];
                chevronColor = "none";
                colorizeIcons = false;
                drawerEnabled = false;
                hidePassive = false;
                id = "Tray";
                pinned = [ ];
              }

              {
                characterCount = 2;
                colorizeIcons = false;
                emptyColor = "none";
                enableScrollWheel = true;
                focusedColor = "primary";
                followFocusedScreen = false;
                fontWeight = "bold";
                groupedBorderOpacity = 1;
                hideUnoccupied = true;
                iconScale = 1;
                id = "Workspace";
                labelMode = "index";
                occupiedColor = "secondary";
                pillSize = 0.7;
                showApplications = true;
                showApplicationsHover = false;
                showBadge = true;
                showLabelsOnlyWhenOccupied = false;
                unfocusedIconsOpacity = 0.5;
              }

              {
                compactMode = true;
                hideMode = "idle";
                hideWhenIdle = false;
                id = "MediaMini";
                maxWidth = 320;
                panelShowAlbumArt = true;
                scrollingMode = "hover";
                showAlbumArt = true;
                showArtistFirst = true;
                showProgressRing = false;
                showVisualizer = true;
                textColor = "none";
                useFixedWidth = false;
                visualizerType = "wave";
              }
            ];

            center = [
              {
                colorizeIcons = false;
                hideMode = "hidden";
                id = "ActiveWindow";
                maxWidth = 320;
                scrollingMode = "hover";
                showIcon = true;
                showText = true;
                textColor = "none";
                useFixedWidth = false;
              }
            ];

            right = [
              {
                displayMode = "onhover";
                iconColor = "none";
                id = "Network";
                textColor = "none";
              }

              {
                displayMode = "onhover";
                iconColor = "none";
                id = "VPN";
                textColor = "none";
              }

              {
                displayMode = "onhover";
                iconColor = "none";
                id = "Bluetooth";
                textColor = "none";
              }

              {
                id = "plugin:usb-drive-manager";
              }

              {
                displayMode = "alwaysShow";
                iconColor = "none";
                id = "Volume";
                middleClickCommand = "";
                textColor = "none";
              }

              {
                applyToAllMonitors = false;
                displayMode = "alwaysShow";
                iconColor = "none";
                id = "Brightness";
                textColor = "none";
              }

              {
                iconColor = "none";
                id = "KeepAwake";
                textColor = "none";
              }

              {
                deviceNativePath = "__default__";
                displayMode = "icon-always";
                hideIfIdle = false;
                hideIfNotDetected = true;
                id = "Battery";
                showNoctaliaPerformance = true;
                showPowerProfiles = true;
              }

              {
                clockColor = "none";
                customFont = "Maple Mono NF CN";
                formatHorizontal = "yyyy-MM-dd | HH:mm:ss";
                formatVertical = "HH mm ss - yy MM dd";
                id = "Clock";
                tooltipFormat = "dddd d MMMM";
                useCustomFont = false;
              }
            ];
          };

          mouseWheelAction = "content";
          reverseScroll = true;
          mouseWheelWrap = true;
          middleClickAction = "launcherPanel";
          middleClickFollowMouse = true;
          middleClickCommand = "";
          rightClickAction = "controlCenter";
          rightClickFollowMouse = true;
          rightClickCommand = "";
          screenOverrides = [ ];
        };

        general = {
          avatarImage = "${config.home.homeDirectory}/Nextcloud/Media/Images/Profiles/ZeroFisher/ZeroFisher_Old.png";
          dimmerOpacity = 0.1;
          showScreenCorners = false;
          forceBlackScreenCorners = true;
          scaleRatio = 1;
          radiusRatio = 0.75;
          iRadiusRatio = 0.75;
          boxRadiusRatio = 1;
          screenRadiusRatio = 0.75;
          animationSpeed = 1;
          animationDisabled = false;
          compactLockScreen = true;
          lockScreenAnimations = true;
          lockOnSuspend = true;
          showSessionButtonsOnLockScreen = true;
          showHibernateOnLockScreen = false;
          enableLockScreenMediaControls = true;
          enableShadows = true;
          enableBlurBehind = true;
          shadowDirection = "bottom";
          shadowOffsetX = 0;
          shadowOffsetY = 3;
          language = "";
          allowPanelsOnScreenWithoutBar = true;
          showChangelogOnStartup = false;
          telemetryEnabled = false;
          enableLockScreenCountdown = true;
          lockScreenCountdownDuration = 5000;
          autoStartAuth = true;
          allowPasswordWithFprintd = true;
          clockStyle = "custom";
          clockFormat = "HH\nmm\nss";
          passwordChars = false;
          lockScreenMonitors = [ "eDP-2" ];
          lockScreenBlur = 0.9;
          lockScreenTint = 0;

          keybinds = {
            keyUp = [ "Up" ];
            keyDown = [ "Down" ];
            keyLeft = [ "Left" ];
            keyRight = [ "Right" ];
            keyEnter = [ "Return" "Enter" ];
            keyEscape = [ "Esc" ];
            keyRemove = [ "Del" ];
          };

          reverseScroll = false;
          smoothScrollEnabled = true;
        };

        ui = {
          fontDefault = "Maple Mono NF CN";
          fontFixed = "Maple Mono NF CN";
          fontDefaultScale = 1.1;
          fontFixedScale = 1.1;
          tooltipsEnabled = true;
          scrollbarAlwaysVisible = true;
          boxBorderEnabled = false;
          panelBackgroundOpacity = 0.9;
          translucentWidgets = false;
          panelsAttachedToBar = false;
          settingsPanelMode = "centered";
          settingsPanelSideBarCardStyle = true;
        };

        location = {
          weatherEnabled = true;
          weatherShowEffects = true;
          weatherTaliaMascotAlways = false;
          useFahrenheit = false;
          use12hourFormat = false;
          showWeekNumberInCalendar = true;
          showCalendarEvents = true;
          showCalendarWeather = true;
          analogClockInCalendar = false;
          firstDayOfWeek = -1;
          hideWeatherTimezone = false;
          hideWeatherCityName = true;
          autoLocate = true;
        };

        calendar = {
          cards = [
            {
              id = "calendar-header-card";
              enabled = true;
            }

            {
              id = "calendar-month-card";
              enabled = true;
            }

            {
              id = "weather-card";
              enabled = true;
            }
          ];
        };

        wallpaper = {
          enabled = true;
          overviewEnabled = false;
          directory = "${config.home.homeDirectory}/Nextcloud/Media/Images/Wallpapers/Landscape";

          monitorDirectories = [
            {
              directory = "${config.home.homeDirectory}/Nextcloud/Media/Images/Wallpapers/Landscape";
              name = "eDP-2";
              wallpaper = "";
            }
          ];

          enableMultiMonitorDirectories = true;
          showHiddenFiles = false;
          viewMode = "browse";
          setWallpaperOnAllMonitors = true;
          linkLightAndDarkWallpapers = true;
          fillMode = "crop";
          fillColor = "#000000";
          useSolidColor = false;
          solidColor = "#1a1a2e";
          automationEnabled = false;
          wallpaperChangeMode = "random";
          randomIntervalSec = 3600;
          transitionDuration = 1500;
          transitionType = [ "wipe" ];
          skipStartupTransition = true;
          transitionEdgeSmoothness = 0.05;
          panelPosition = "follow_bar";
          hideWallpaperFilenames = false;
          useOriginalImages = false;
          overviewBlur = 0.4;
          overviewTint = 0.6;
          useWallhaven = false;
          wallhavenQuery = "";
          wallhavenSorting = "relevance";
          wallhavenOrder = "desc";
          wallhavenCategories = "111";
          wallhavenPurity = "100";
          wallhavenRatios = "";
          wallhavenApiKey = "";
          wallhavenResolutionMode = "atleast";
          wallhavenResolutionWidth = "";
          wallhavenResolutionHeight = "";
          sortOrder = "name";
          favorites = [ ];
        };

        appLauncher = {
          enableClipboardHistory = true;
          autoPasteClipboard = false;
          enableClipPreview = true;
          clipboardWrapText = true;
          enableClipboardSmartIcons = true;
          enableClipboardChips = true;
          clipboardWatchTextCommand = "${lib.getExe' pkgs.wl-clipboard "wl-paste"} --type text --watch cliphist store";
          clipboardWatchImageCommand = "${lib.getExe' pkgs.wl-clipboard "wl-paste"} --type image --watch cliphist store";
          position = "top_center";
          pinnedApps = [ "floorp" "steam" "codium" ];
          sortByMostUsed = false;
          terminalCommand = "";
          customLaunchPrefixEnabled = false;
          customLaunchPrefix = "";
          viewMode = "grid";
          showCategories = true;
          iconMode = "tabler";
          showIconBackground = false;
          enableSettingsSearch = true;
          enableWindowsSearch = true;
          enableSessionSearch = true;
          ignoreMouseInput = false;
          screenshotAnnotationTool = "${lib.getExe pkgs.satty} --filename -";
          overviewLayer = true;
          density = "default";
        };

        controlCenter = {
          position = "close_to_bar_button";
          diskPath = "/";

          shortcuts = {
            left = [
              {
                id = "PowerProfile";
              }

              {
                id = "AirplaneMode";
              }
            ];

            right = [
              {
                id = "Notifications";
              }

              {
                id = "WallpaperSelector";
              }
            ];
          };

          cards = [
            {
              id = "profile-card";
              enabled = true;
            }

            {
              id = "shortcuts-card";
              enabled = true;
            }

            {
              id = "media-sysmon-card";
              enabled = true;
            }

            {
              id = "brightness-card";
              enabled = false;
            }

            {
              id = "audio-card";
              enabled = false;
            }

            {
              id = "weather-card";
              enabled = false;
            }
          ];
        };

        systemMonitor = {
          cpuWarningThreshold = 80;
          cpuCriticalThreshold = 90;
          tempWarningThreshold = 80;
          tempCriticalThreshold = 90;
          gpuWarningThreshold = 80;
          gpuCriticalThreshold = 90;
          memWarningThreshold = 80;
          memCriticalThreshold = 90;
          swapWarningThreshold = 80;
          swapCriticalThreshold = 90;
          diskWarningThreshold = 80;
          diskCriticalThreshold = 90;
          diskAvailWarningThreshold = 20;
          diskAvailCriticalThreshold = 10;
          batteryWarningThreshold = 20;
          batteryCriticalThreshold = 10;
          enableDgpuMonitoring = false;
          useCustomColors = false;
          warningColor = "#c6a0f6";
          criticalColor = "#ed8796";
          externalMonitor = "";
        };

        noctaliaPerformance = {
          disableWallpaper = true;
          disableDesktopWidgets = true;
        };

        dock = {
          enabled = true;
          position = "bottom";
          displayMode = "auto_hide";
          dockType = "floating";
          backgroundOpacity = 0.9;
          floatingRatio = 0.65;
          size = 1.1;
          onlySameOutput = true;
          monitors = [ ];
          pinnedApps = [ ];
          colorizeIcons = false;
          showLauncherIcon = false;
          launcherPosition = "end";
          launcherUseDistroLogo = false;
          launcherIcon = "";
          launcherIconColor = "none";
          pinnedStatic = true;
          inactiveIndicators = false;
          groupApps = true;
          groupContextMenuMode = "extended";
          groupClickAction = "list";
          groupIndicatorStyle = "number";
          deadOpacity = 0.5;
          animationSpeed = 1;
          sitOnFrame = false;
          showDockIndicator = false;
          indicatorThickness = 3;
          indicatorColor = "none";
          indicatorOpacity = 0.5;
        };

        network = {
          bluetoothRssiPollingEnabled = true;
          bluetoothRssiPollIntervalMs = 60000;
          networkPanelView = "wifi";
          wifiDetailsViewMode = "grid";
          bluetoothDetailsViewMode = "grid";
          bluetoothHideUnnamedDevices = true;
          disableDiscoverability = false;
          bluetoothAutoConnect = true;
        };

        sessionMenu = {
          enableCountdown = true;
          countdownDuration = 5000;
          position = "center";
          showHeader = false;
          showKeybinds = true;
          largeButtonsStyle = false;
          largeButtonsLayout = "single-row";

          powerOptions = [
            {
              action = "suspend";
              command = "";
              countdownEnabled = true;
              enabled = true;
              keybind = "1";
            }

            {
              action = "logout";
              command = "";
              countdownEnabled = true;
              enabled = true;
              keybind = "2";
            }

            {
              action = "reboot";
              command = "";
              countdownEnabled = true;
              enabled = true;
              keybind = "3";
            }

            {
              action = "rebootToUefi";
              command = "";
              countdownEnabled = true;
              enabled = true;
              keybind = "4";
            }

            {
              action = "shutdown";
              command = "";
              countdownEnabled = true;
              enabled = true;
              keybind = "5";
            }

            {
              action = "lock";
              command = "";
              countdownEnabled = true;
              enabled = false;
              keybind = "";
            }

            {
              action = "hibernate";
              command = "";
              countdownEnabled = true;
              enabled = false;
              keybind = "";
            }

            {
              action = "userspaceReboot";
              command = "";
              countdownEnabled = true;
              enabled = false;
              keybind = "";
            }
          ];
        };

        notifications = {
          enabled = true;
          enableMarkdown = true;
          density = "default";
          monitors = [ "eDP-2" ];
          location = "top_left";
          overlayLayer = false;
          backgroundOpacity = 0.8;
          respectExpireTimeout = false;
          lowUrgencyDuration = 2.5;
          normalUrgencyDuration = 5;
          criticalUrgencyDuration = 10;
          clearDismissed = false;

          saveToHistory = {
            low = false;
            normal = true;
            critical = true;
          };

          sounds = {
            enabled = true;
            volume = 1;
            separateSounds = true;
            lowSoundFile = "";
            normalSoundFile = "";
            criticalSoundFile = "";
            excludedApps = "floorp,vesktop";
          };

          enableMediaToast = false;
          enableKeyboardLayoutToast = true;
          enableBatteryToast = true;
        };

        osd = {
          enabled = true;
          location = "top_right";
          autoHideMs = 2500;
          overlayLayer = true;
          backgroundOpacity = 0.8;
          enabledTypes = [ 0 1 2 3 ];
          monitors = [ ];
        };

        audio = {
          volumeStep = 5;
          volumeOverdrive = false;
          spectrumFrameRate = 60;
          visualizerType = "linear";
          spectrumMirrored = true;
          mprisBlacklist = [ ];
          preferredPlayer = "";
          volumeFeedback = true;
          volumeFeedbackSoundFile = "";
        };

        brightness = {
          brightnessStep = 10;
          enforceMinimum = true;
          enableDdcSupport = true;
          backlightDeviceMappings = [ ];
        };

        colorSchemes = {
          useWallpaperColors = false;
          predefinedScheme = "Catppuccin";
          darkMode = true;
          schedulingMode = "off";
          manualSunrise = "06:30";
          manualSunset = "18:30";
          generationMethod = "tonal-spot";
          monitorForColors = "";
          syncGsettings = true;
        };

        templates = {
          activeTemplates = [ ];
          enableUserTheming = false;
        };

        nightLight = {
          enabled = false;
          forced = false;
          autoSchedule = true;
          nightTemp = "4000";
          dayTemp = "6500";
          manualSunrise = "06:30";
          manualSunset = "18:30";
        };

        hooks = {
          enabled = true;
          wallpaperChange = "";
          darkModeChange = "";
          screenLock = "";
          screenUnlock = "";
          performanceModeEnabled = "";
          performanceModeDisabled = "";
          startup = "";
          session = "";
          colorGeneration = "";
        };

        plugins = {
          autoUpdate = false;
          notifyUpdates = false;
        };

        idle = {
          enabled = true;
          screenOffTimeout = 150;
          lockTimeout = 300;
          suspendTimeout = 600;
          fadeDuration = 5;
          screenOffCommand = "";
          lockCommand = "";
          suspendCommand = "";
          resumeScreenOffCommand = "";
          resumeLockCommand = "";
          resumeSuspendCommand = "";

          customCommands = builtins.toJSON [ {
            name = "Toast";
            timeout = 145;

            command = "noctalia-shell ipc call toast send '${builtins.toJSON {
              type = "warning";
              title = "Turning Off Screen";
              body = "The screen will turn off in five seconds.";
              duration = 5000;
            }}'";

            resumeCommand = "";
          } ];
        };

        desktopWidgets = {
          enabled = false;
          overviewEnabled = true;
          gridSnap = false;
          gridSnapScale = false;

          monitorWidgets = [
            {
              name = "eDP-2";
              widgets = [ ];
            }
          ];
        };
      };

      plugins = {
        version = 2;

        sources = [
          {
            name = "Noctalia Plugins";
            url = "https://github.com/noctalia-dev/legacy-v4-plugins";
            enabled = true;
          }
        ];

        states = {
          polkit-agent = {
            enabled = true;
            sourceUrl = "https://github.com/noctalia-dev/legacy-v4-plugins";
          };

          unicode-picker = {
            enabled = true;
            sourceUrl = "https://github.com/noctalia-dev/legacy-v4-plugins";
          };

          usb-drive-manager = {
            enabled = true;
            sourceUrl = "https://github.com/noctalia-dev/legacy-v4-plugins";
          };
        };
      };

      pluginSettings = {
        usb-drive-manager = {
          autoMount = false;
          terminalCommand = "kitty";
          fileBrowser = "dolphin";
          showNotifications = true;
          hideWhenEmpty = true;
          showBadge = true;
          iconColor = "none";
        };
      };

      colors = with config.modules.appearance.colors.schemes.catppuccin.macchiato; {
        mPrimary = sky;
        mOnPrimary = crust;
        mSecondary = green;
        mOnSecondary = crust;
        mTertiary = mauve;
        mOnTertiary = crust;
        mError = red;
        mOnError = crust;
        mHover = teal;
        mOnHover = crust;
        mSurface = base;
        mOnSurface = text;
        mSurfaceVariant = surface0;
        mOnSurfaceVariant = lavender;
        mOutline = surface1;
        mShadow = crust;
      };
    };
  };
}
