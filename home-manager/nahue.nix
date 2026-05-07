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
    };
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
