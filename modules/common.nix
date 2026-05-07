{ pkgs, lib, ... }:

{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  environment.variables.EDITOR = "nvim";

  environment.systemPackages =
    with pkgs;
    [
      bat
      btop
      bun
      gh
      git
      gnupg
      go
      grpcurl
      kind
      kubectl
      kubernetes-helm
      mpv
      mtr
      nixd
      nixfmt
      nodejs
      opencode
      procps
      talosctl
      terraform
      vault
      yt-dlp
    ]
    ++ lib.optionals pkgs.stdenv.hostPlatform.isDarwin [
      pinentry_mac
    ]
    ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
      pinentry-curses
    ];

  programs.tmux.enable = true;
}
