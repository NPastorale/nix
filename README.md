# Nix Config

Multi-machine Nix flake managing a MacBook Air (nix-darwin) and an XPS 13 (NixOS) with shared home-manager config.

## Structure

| Path                          | Purpose                                     |
| ----------------------------- | ------------------------------------------- |
| `flake.nix`                   | Entry point — defines both machines         |
| `modules/common.nix`          | Shared system config (packages, tmux, etc.) |
| `home-manager/nahue.nix`      | Shared user config (zsh, GPG, aliases)      |
| `hosts/air/configuration.nix` | macOS-specific: brew, aerospace, defaults   |
| `hosts/xps/configuration.nix` | Linux-specific: Hyprland, ZFS, greetd, NM   |
| `update.sh`                   | Auto-detects host and applies config        |

## Usage

### Update & apply

```bash
~/Nix/update.sh
```

This auto-detects the host and runs `darwin-rebuild switch --flake .#air` on the Air or `nixos-rebuild switch --flake .#xps` on the XPS.

### Apply without updating inputs

```bash
# macOS (Air)
sudo darwin-rebuild switch --flake ~/Nix#air

# Linux (XPS)
sudo nixos-rebuild switch --flake ~/Nix#xps
```

### Check flake evaluates

```bash
nix flake check
```

## Initial NixOS Installation (XPS)

### 1. Boot the NixOS minimal ISO

Boot from a [NixOS minimal ISO](https://nixos.org/download). Connect to WiFi:

```bash
iwctl station wlan0 connect <SSID>
```

### 2. Partition the disk

Create a GPT layout with an EFI partition and a ZFS root partition:

```bash
DISK=/dev/nvme0n1
parted $DISK -- mklabel gpt
parted $DISK -- mkpart ESP fat32 1MiB 512MiB
parted $DISK -- set 1 esp on
parted $DISK -- mkpart rpool 512MiB 100%
```

### 3. Create ZFS pool and datasets

```bash
# Create the pool
zpool create -f -o ashift=12 -O compression=zstd \
  -O mountpoint=none -O acltype=posixacl -O xattr=sa \
  -O atime=off -R /mnt \
  rpool $DISK\part2

# Root dataset
zfs create -o mountpoint=legacy rpool/root
zfs create -o mountpoint=legacy rpool/home

# Format and mount EFI partition
mkfs.fat -F 32 -n ESP $DISK\part1
```

### 4. Mount filesystems

```bash
mount -t zfs rpool/root /mnt
mkdir -p /mnt/boot /mnt/home
mount $DISK\part1 /mnt/boot
mount -t zfs rpool/home /mnt/home
```

### 5. Clone this repo and generate hardware config

```bash
nix-shell -p git --run "git clone https://github.com/your-org/nix /mnt/etc/nixos"
nixos-generate-config --root /mnt --dir /mnt/etc/nixos/hosts/xps
```

This creates `hosts/xps/hardware-configuration.nix`. Include it in the XPS config:

```nix
# hosts/xps/configuration.nix
{
  imports = [ ./hardware-configuration.nix ];
  # ...
}
```

### 6. Adjust partition UUIDs

Update `hosts/xps/configuration.nix` with the correct EFI PARTUUID (find it with `blkid $DISK\part1`) and set a proper `networking.hostId`:

```bash
# Generate a hostId (8 hex chars)
head -c8 /dev/urandom | od -A none -t x8 | head -1 | tr -d ' '
```

### 7. Install

```bash
nixos-install --flake /mnt/etc/nixos#xps
```

Set the root password when prompted, then reboot.
