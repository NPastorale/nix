{ pkgs, lib, ... }:

{
  system.stateVersion = "25.11";

  nixpkgs.config.allowUnfree = true;

  users.users.nahue = {
    isNormalUser = true;
    home = "/home/nahue";
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
  };

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  boot.zfs.package = pkgs.zfs_unstable;

  fileSystems."/" = {
    device = "rpool/safe/root";
    fsType = "zfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-partuuid/REPLACE_WITH_EFI_PARTUUID";
    fsType = "vfat";
  };

  networking = {
    hostName = "XPS";
    networkmanager.enable = true;
    hostId = "deadbeef";
  };

  programs.zsh.enable = true;
  programs.hyprland.enable = true;

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --greeting 'Welcome to NixOS'";
        user = "nahue";
      };
    };
  };

  services.openssh.enable = true;

  hardware.enableRedistributableFirmware = true;
}
