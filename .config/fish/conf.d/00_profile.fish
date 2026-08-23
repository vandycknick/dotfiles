# The official daemon hook configures NIX_PROFILES and the global Nix CLI.
if not set -q __ETC_PROFILE_NIX_SOURCED
  set -l nix_daemon_profile /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
  test -r $nix_daemon_profile; and source $nix_daemon_profile
end

# These paths are required in interactive non-login shells too.
fish_add_path --global --prepend --move /nix/var/nix/profiles/default/bin
fish_add_path --global --prepend --move "$HOME/.local/state/nix/profiles/profile/bin"
fish_add_path --global --prepend --move "$HOME/.local/bin"

status is-login; or return

set -Ux EDITOR nvim
set -Ux TERMINAL ghostty

set -Ux XDG_CONFIG_HOME "$HOME/.config"
set -Ux XDG_DATA_HOME "$HOME/.local/share"
set -Ux XDG_BIN_HOME "$HOME/.local/bin"
set -Ux XDG_CACHE_HOME "$HOME/.cache"
set -Ux XDG_STATE_HOME "$HOME/.local/state"

switch (uname)
case Linux
  # set -Ux BROWSER ""
case Darwin
  set -Ux BROWSER "/Applications/Zen.app/Contents/MacOS/zen"
end

# Pi coding agent
set -Ux PI_CODING_AGENT_DIR "$XDG_CONFIG_HOME/pi"
set -Ux PI_CODING_AGENT_SESSION_DIR "$XDG_DATA_HOME/pi/sessions"

# Golang:
set -Ux GOPATH "$XDG_DATA_HOME/go"

# AWS Cli
# https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html
set -Ux AWS_CONFIG_FILE "$XDG_CONFIG_HOME/aws/config"
set -Ux AWS_SHARED_CREDENTIALS_FILE "$XDG_CONFIG_HOME/aws/credentials"

# NPM
set -Ux NPM_CONFIG_USERCONFIG "$XDG_CONFIG_HOME/npm/npmrc"

# Rust:
set -Ux CARGO_HOME "$XDG_DATA_HOME/cargo"
set -Ux RUSTUP_HOME "$XDG_DATA_HOME/rustup"

# Password Store
set -Ux PASSWORD_STORE_DIR "$XDG_DATA_HOME/password-store"
