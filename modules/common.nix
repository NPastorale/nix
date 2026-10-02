{ pkgs, lib, ... }:

{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Fallback for when update.sh isn't run: keep only the current generation.
  # Runs as root, so user/home-manager generations are only cleaned by update.sh.
  nix.gc = {
    automatic = true;
    options = "--delete-old";
  };

  # Dedup via hard links. Preferred over nix.settings.auto-optimise-store,
  # which is unreliable on macOS.
  nix.optimise.automatic = true;

  environment.variables.EDITOR = "nvim";

  environment.systemPackages =
    with pkgs;
    [
      ansible
      bat
      btop
      bun
      claude-code
      docker
      docker-credential-helpers
      gh
      git
      git-lfs
      gnupg
      go
      gopls
      grpcurl
      kind
      kubectl
      kubectl-cnpg
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
