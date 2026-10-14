# The official daemon hook configures NIX_PROFILES and the global Nix CLI.
if not set -q __ETC_PROFILE_NIX_SOURCED
  set -l nix_daemon_profile /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
  test -r $nix_daemon_profile; and source $nix_daemon_profile
end

# These paths are required in interactive non-login shells too. Nix comes
# first; ~/.local/bin, where other installers (Tern, curl scripts) drop
# binaries, follows it so it cannot shadow Nix tools. The session variables
# (Home Manager, sourced by config.fish) own everything else.
fish_add_path --global --prepend --move /nix/var/nix/profiles/default/bin
fish_add_path --global --prepend --move "$HOME/.nix-profile/bin"
fish_add_path --global --append --move "$HOME/.local/bin"
