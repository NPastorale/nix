{ config, lib, ... }:

# Deploys the git identity setup from ./../git-identities so that git commits
# and SSH auth use the right identity (personal vs work) based on repo path.
#
# Layout on disk (see ../git-identities/keys/README.md for details):
#   ~/.gitconfig                                -> selects identity via includeIf
#   ~/.ssh/config                                -> includes the git-identities ssh config
#   ~/.config/git-identities/personal.gitconfig  -> personal identity (GPG signing)
#   ~/.config/git-identities/work.gitconfig      -> work identity (SSH signing)
#   ~/.config/git-identities/ssh/config          -> github-personal / github-work host aliases
#   ~/.config/git-identities/keys/*.pub          -> public keys referenced above (placeholders)
#   ~/.config/git-identities/allowed_signers     -> maps identities to SSH keys for signature verification
#
# TODO: replace the placeholder public keys below with the real ones, and
# replace <WORK_NAME>/<WORK_EMAIL> in ../git-identities/work.gitconfig.
#
# All files are force-written, taking priority over anything already present
# on disk at those paths.
let
  forced = attrs: lib.mapAttrs (_: v: v // { force = true; }) attrs;

  # Some tools that read these files (notably git's gpg.ssh signing-key
  # resolution) do not reliably expand a leading `~`, even though git's own
  # includeIf.path and ssh's IdentityFile do. To be safe and consistent, every
  # file under ./../git-identities is deployed through this helper, which
  # substitutes `~/` for the real, platform-correct home directory
  # (config.home.homeDirectory) at build time. The checked-in files keep `~`
  # for readability/portability.
  withExpandedHome =
    path: builtins.replaceStrings [ "~/" ] [ "${config.home.homeDirectory}/" ] (builtins.readFile path);
in
{
  home.file = forced {
    ".gitconfig".text = withExpandedHome ../git-identities/.gitconfig;
    ".ssh/config".text = withExpandedHome ../git-identities/ssh/config;

    ".config/git-identities/personal.gitconfig".text =
      withExpandedHome ../git-identities/personal.gitconfig;
    ".config/git-identities/work.gitconfig".text = withExpandedHome ../git-identities/work.gitconfig;
    ".config/git-identities/allowed_signers".text = withExpandedHome ../git-identities/allowed_signers;
    ".config/git/ignore".text = withExpandedHome ../git-identities/gitignore_global;

    # Placeholder public keys — replace with real keys, then this file's
    # contents can be deleted (or the placeholders overwritten in-repo).
    ".config/git-identities/keys/personal_github.pub".text = ''
      ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJr7n9CSeiGCawxLQhalJ0ooka4/5G+36VKNIvnMCyWT
    '';
    ".config/git-identities/keys/work_github.pub".text = ''
      ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH4XpPLQllEJIJurapIK/PHZHpUlQ2jlUD5uAGIJmKy6
    '';
    ".config/git-identities/keys/work_signing.pub".text = ''
      ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH4XpPLQllEJIJurapIK/PHZHpUlQ2jlUD5uAGIJmKy6
    '';
  };
}
