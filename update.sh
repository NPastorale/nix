#!/usr/bin/env bash
set -euo pipefail

cd "${NIX_FLAKE_DIR:-$HOME/Nix}" || exit 1

BLUE='\033[1;34m'
NC='\033[0m'

print_header() {
  local text="$1"
  local width=60
  local text_len=${#text}
  local padding_needed=$((width - text_len - 2))

  if [ "$padding_needed" -lt 0 ]; then
    printf "\n%b%s%b\n" "$BLUE" "$text" "$NC"
    return
  fi

  local left_padding=$((padding_needed / 2))
  local right_padding=$((padding_needed - left_padding))
  local border
  border=$(printf '%*s' "$width" '' | tr ' ' '=')

  printf "\n%b" "$BLUE"
  printf "%s\n" "$border"
  printf "%s %s %s\n" \
    "$(printf '%*s' "$left_padding" '' | tr ' ' '=')" \
    "$text" \
    "$(printf '%*s' "$right_padding" '' | tr ' ' '=')"
  printf "%s\n" "$border"
  printf "%b" "$NC"
}

print_step() {
  printf "\n-> %s\n" "$1"
}

# Detect host
HOSTNAME=$(hostname -s)
print_header "Flake update"
print_step "Working directory: $(pwd)"
print_step "Refreshing flake inputs"
sudo -H nix flake update -vv

print_header "Config switch"
case "$HOSTNAME" in
  "nahue-air")
    print_step "Applying darwin configuration: air"
    sudo -H darwin-rebuild switch --flake .#air
    ;;
  "XPS")
    print_step "Applying NixOS configuration: xps"
    sudo -H nixos-rebuild switch --flake .#xps
    ;;
  *)
    echo "Unknown host: $HOSTNAME"
    exit 1
    ;;
esac

print_header "Garbage collection"
STORE_BEFORE=$(du -sk /nix/store 2>/dev/null | cut -f1 || echo 0)

# -d drops old generations of the invoking user's profiles, then runs the GC,
# so a separate `nix store gc` afterwards would be a no-op.
print_step "Deleting old user/home-manager generations"
nix-collect-garbage -d -vv

print_step "Deleting old system/root generations and unused store paths"
sudo -H nix-collect-garbage -d -vv

print_header "Store optimisation"
print_step "Hard-linking duplicate files in the store"
sudo -H nix store optimise

STORE_AFTER=$(du -sk /nix/store 2>/dev/null | cut -f1 || echo 0)
print_step "Store size: $((STORE_BEFORE / 1024)) MiB -> $((STORE_AFTER / 1024)) MiB"
