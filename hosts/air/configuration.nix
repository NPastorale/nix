{ pkgs, lib, ... }:

{
  system.stateVersion = 6;
  system.primaryUser = "nahue";

  nixpkgs.config.allowUnfree = true;

  users.users.nahue = {
    home = "/Users/nahue";
    shell = pkgs.zsh;
  };

  homebrew = {
    enable = true;
    enableZshIntegration = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };
    brews = [
      "mole"
    ];
    casks = [
      "aws-vpn-client"
      "bambu-studio"
      "elgato-stream-deck"
      "elgato-wave-link"
      "firefox"
      "freelens"
      "google-chrome"
      "hiddenbar"
      "keepassxc"
      "orbstack"
      "protonvpn"
      "slack"
      "steam"
      "syncthing-app"
      "tailscale-app"
      "tidal"
      "utm"
      "visual-studio-code"
      "wireshark-app"
    ];
  };

  networking = {
    applicationFirewall = {
      enable = true;
      allowSigned = true;
      allowSignedApp = true;
      blockAllIncoming = false;
    };
    computerName = "Nahue's Air";
    hostName = "nahue-air";
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  services.aerospace = {
    enable = true;
    settings = {

      config-version = 2;
      after-startup-command = [ ];
      enable-normalization-flatten-containers = true;
      enable-normalization-opposite-orientation-for-nested-containers = true;
      accordion-padding = 30;
      default-root-container-layout = "tiles";
      default-root-container-orientation = "auto";
      on-focused-monitor-changed = [ "move-mouse monitor-lazy-center" ];
      automatically-unhide-macos-hidden-apps = false;
      persistent-workspaces = [
        "1"
        "2"
        "3"
        "4"
        "5"
        "6"
        "7"
        "8"
        "9"
      ];
      on-mode-changed = [ ];
      on-window-detected = [
        {
          "if" = {
            app-name-regex-substring = "Terminal|iTerm|kitty|Alacritty|WezTerm|Warp";
          };
          run = "move-node-to-workspace 1";
        }
        {
          "if" = {
            app-id = "com.google.Chrome";
          };
          run = "move-node-to-workspace 2";
        }
        {
          "if" = {
            app-id = "com.apple.Safari";
          };
          run = "move-node-to-workspace 2";
        }
        {
          "if" = {
            app-id = "com.microsoft.VSCode";
          };
          run = "move-node-to-workspace 3";
        }
        {
          "if" = {
            app-name-regex-substring = "keepass";
          };
          run = "move-node-to-workspace 4";
        }
        {
          "if" = {
            app-id = "com.apple.SecurityAgent";
          };
          run = "layout floating";
        }
        {
          "if" = {
            app-id = "com.apple.finder";
          };
          run = "layout floating";
        }
        {
          "if" = {
            app-id = "com.apple.systempreferences";
          };
          run = "layout floating";
        }
        {
          run = "move-node-to-workspace 5";
        }
      ];
      key-mapping.preset = "qwerty";
      gaps.inner.horizontal = 10;
      gaps.inner.vertical = 10;
      gaps.outer.left = 10;
      gaps.outer.bottom = 10;
      gaps.outer.top = 10;
      gaps.outer.right = 10;

      mode.main.binding = {
        "alt-slash" = "layout tiles horizontal vertical";
        "alt-comma" = "layout accordion horizontal vertical";

        "alt-h" = "focus left";
        "alt-j" = "focus down";
        "alt-k" = "focus up";
        "alt-l" = "focus right";

        "alt-shift-h" = "move left";
        "alt-shift-j" = "move down";
        "alt-shift-k" = "move up";
        "alt-shift-l" = "move right";

        "alt-minus" = "resize smart -50";
        "alt-equal" = "resize smart +50";

        "alt-1" = "workspace 1";
        "alt-2" = "workspace 2";
        "alt-3" = "workspace 3";
        "alt-4" = "workspace 4";
        "alt-5" = "workspace 5";
        "alt-6" = "workspace 6";
        "alt-7" = "workspace 7";
        "alt-8" = "workspace 8";
        "alt-9" = "workspace 9";

        "alt-shift-1" = "move-node-to-workspace 1";
        "alt-shift-2" = "move-node-to-workspace 2";
        "alt-shift-3" = "move-node-to-workspace 3";
        "alt-shift-4" = "move-node-to-workspace 4";
        "alt-shift-5" = "move-node-to-workspace 5";
        "alt-shift-6" = "move-node-to-workspace 6";
        "alt-shift-7" = "move-node-to-workspace 7";
        "alt-shift-8" = "move-node-to-workspace 8";
        "alt-shift-9" = "move-node-to-workspace 9";

        "alt-tab" = "workspace-back-and-forth";
        "alt-shift-tab" = "move-workspace-to-monitor --wrap-around next";

        "alt-shift-semicolon" = "mode service";
      };

      mode.service.binding = {
        esc = [
          "reload-config"
          "mode main"
        ];
        r = [
          "flatten-workspace-tree"
          "mode main"
        ];
        f = [
          "layout floating tiling"
          "mode main"
        ];
        backspace = [
          "close-all-windows-but-current"
          "mode main"
        ];

        "alt-shift-h" = [
          "join-with left"
          "mode main"
        ];
        "alt-shift-j" = [
          "join-with down"
          "mode main"
        ];
        "alt-shift-k" = [
          "join-with up"
          "mode main"
        ];
        "alt-shift-l" = [
          "join-with right"
          "mode main"
        ];
      };

    };
  };

  system.defaults = {
    NSGlobalDomain.AppleShowAllExtensions = false;
    NSGlobalDomain.AppleShowScrollBars = "Always";
    NSGlobalDomain.NSUseAnimatedFocusRing = false;
    NSGlobalDomain.NSNavPanelExpandedStateForSaveMode = true;
    NSGlobalDomain.NSNavPanelExpandedStateForSaveMode2 = true;
    NSGlobalDomain.PMPrintingExpandedStateForPrint = true;
    NSGlobalDomain.PMPrintingExpandedStateForPrint2 = true;
    NSGlobalDomain.NSDocumentSaveNewDocumentsToCloud = false;
    NSGlobalDomain.ApplePressAndHoldEnabled = false;
    NSGlobalDomain.InitialKeyRepeat = 20;
    NSGlobalDomain.KeyRepeat = 2;
    NSGlobalDomain.NSWindowShouldDragOnGesture = true;
    NSGlobalDomain.NSAutomaticSpellingCorrectionEnabled = false;
    LaunchServices.LSQuarantine = false;
    loginwindow.GuestEnabled = false;
    finder.FXPreferredViewStyle = "Nlsv";
  };

  system.defaults.CustomUserPreferences = {
    "com.apple.finder" = {
      ShowExternalHardDrivesOnDesktop = true;
      ShowHardDrivesOnDesktop = false;
      ShowMountedServersOnDesktop = false;
      ShowRemovableMediaOnDesktop = true;
      _FXSortFoldersFirst = true;
      FXDefaultSearchScope = "SCcf";
      DisableAllAnimations = true;
      NewWindowTarget = "PfLo";
      NewWindowTargetPath = "file://$\{HOME\}";
      AppleShowAllExtensions = true;
      FXEnableExtensionChangeWarning = false;
      ShowStatusBar = true;
      ShowPathbar = true;
      WarnOnEmptyTrash = false;
    };

    "com.apple.desktopservices" = {
      DSDontWriteNetworkStores = true;
      DSDontWriteUSBStores = true;
    };

    "com.apple.HIToolbox" = {
      AppleFnUsageType = 1;
      AppleKeyboardUIMode = 3;
      AppleSymbolicHotKeys."60".enabled = false;
      AppleModifierKeyRemapping."1452-630-0" = {
        HIDKeyboardModifierMappingSrc = 30064771129;
        HIDKeyboardModifierMappingDst = 30064771299;
      };
    };

    "com.apple.TextEdit" = {
      NSShowAppCentricOpenPanelInsteadOfUntitledFile = false;
      RichText = false;
    };

    "com.apple.dock" = {
      autohide = true;
      launchanim = false;
      static-only = false;
      show-recents = false;
      show-process-indicators = true;
      orientation = "bottom";
      tilesize = 64;
      minimize-to-application = true;
      mineffect = "scale";
      enable-window-tool = false;
    };

    "com.apple.ActivityMonitor" = {
      OpenMainWindow = true;
      IconType = 5;
      SortColumn = "CPUUsage";
      SortDirection = 0;
    };

    "com.apple.AdLib".allowApplePersonalizedAdvertising = false;

    "com.apple.SoftwareUpdate" = {
      AutomaticCheckEnabled = true;
      ScheduleFrequency = 1;
      AutomaticDownload = 1;
      CriticalUpdateInstall = 1;
    };

    "com.apple.TimeMachine".DoNotOfferNewDisksForBackup = true;
    "com.apple.ImageCapture".disableHotPlug = true;
    "com.apple.commerce".AutoUpdate = true;

    "com.google.Chrome" = {
      AppleEnableSwipeNavigateWithScrolls = true;
      DisablePrintPreview = true;
      PMPrintingExpandedStateForPrint2 = true;
    };
    time.timeZone = "Europe/Madrid";
  };

  system.activationScripts.postActivation.text = ''
    sudo -u nahue /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u || true
    echo "nix-darwin: restarting Finder and Dock..."
    sudo -u nahue killall Finder 2>/dev/null || true
    sudo -u nahue killall Dock 2>/dev/null || true
  '';
}
