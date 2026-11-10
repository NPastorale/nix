{ pkgs, lib, ... }:

let
  pinentryPkg = if pkgs.stdenv.hostPlatform.isDarwin then pkgs.pinentry_mac else pkgs.pinentry-curses;
  pinentryPath =
    if pkgs.stdenv.hostPlatform.isDarwin then
      "${pinentryPkg}/Applications/pinentry-mac.app/Contents/MacOS/pinentry-mac"
    else
      "${pinentryPkg}/bin/pinentry-curses";
in
{
  imports = [
    ./git-identities.nix
  ];

  home = {
    username = "nahue";
    homeDirectory = if pkgs.stdenv.hostPlatform.isDarwin then "/Users/nahue" else "/home/nahue";
    stateVersion = "25.11";
    sessionVariables = {
      NIX_FLAKE_DIR = "$HOME/Nix";
      CONTEXT7_API_KEY = "PLACEHOLDER";
    };

    # Mole's `mo clean` wipes KeePassXC's recent-database state, stored in
    # ~/Library/Caches/KeePassXC. Keep that dir in Mole's whitelist. Mole
    # rewrites this file itself, so it can't be a read-only home.file symlink:
    # seed Mole's defaults when absent, then append the entry idempotently.
    activation.keepassxcMoleWhitelist = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin (
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        whitelistFile="$HOME/.config/mole/whitelist"
        entry="~/Library/Caches/KeePassXC"

        run mkdir -p "$(dirname "$whitelistFile")"

        if [ ! -e "$whitelistFile" ]; then
          run cat > "$whitelistFile" <<'MOLE_WHITELIST_EOF'
        # Mole Whitelist - Protected paths won't be deleted
        # Default protections: Playwright browsers, HuggingFace models, Maven repo, Ollama models, Surge Mac, R renv, Finder metadata
        # Add one pattern per line to keep items safe.

        ~/Library/Caches/ms-playwright*
        ~/.gradle/caches/*
        ~/.gradle/daemon/*
        ~/.ollama/models/*
        ~/Library/Caches/com.nssurge.surge-mac/*
        ~/Library/Application Support/com.nssurge.surge-mac/*
        ~/Library/Caches/org.R-project.R/R/renv/*
        ~/Library/Caches/JetBrains*
        ~/Library/Caches/com.jetbrains.toolbox*
        ~/Library/Caches/tealdeer/tldr-pages
        ~/Library/Application Support/JetBrains*
        ~/Library/Caches/com.apple.finder
        ~/Library/Mobile Documents*
        FINDER_METADATA
        MOLE_WHITELIST_EOF
        fi

        if ! grep -qxF "$entry" "$whitelistFile" 2>/dev/null; then
          run printf '%s\n' "$entry" >> "$whitelistFile"
        fi
      ''
    );
  };

  home.file.".gnupg/gpg-agent.conf" = {
    text = ''
      pinentry-program ${pinentryPath}
    '';
    onChange = ''
      ${pkgs.gnupg}/bin/gpgconf --kill gpg-agent
    '';
  };

  programs = {
    zsh = {
      enable = true;
      autosuggestion = {
        enable = true;
      };
      syntaxHighlighting = {
        enable = true;
      };
      oh-my-zsh = {
        enable = true;
        theme = "robbyrussell";
        plugins = [
          "git"
          "docker"
        ];
      };
      shellAliases = {
        update = "~/Nix/update.sh";
      };
      initContent = ''
        export GPG_TTY=$(tty)
      '';
    };

    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      withNodeJs = true;
      plugins = with pkgs.vimPlugins; [
        nvim-treesitter.withAllGrammars
      ];
      extraConfig = ''
        syntax on
        filetype plugin indent on
        set number
      '';
    };

    home-manager = {
      enable = true;
    };
  };
}
