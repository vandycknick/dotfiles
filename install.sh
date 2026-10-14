#!/bin/sh

set -eu

: "${HOME:?HOME is not set}"

NIX_DAEMON_PROFILE="/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
NIX_BIN="$HOME/.nix-profile/bin"
NIX_FLAKES="extra-experimental-features = nix-command flakes"
BASHRC="$HOME/.bashrc"
FISH_HANDOFF_BEGIN="# >>> dot: fish handoff >>>"
FISH_HANDOFF_END="# <<< dot: fish handoff <<<"

# The dot wrapper execs ~/.dotfiles/install.sh; resolving symlinks finds the
# real checkout however the script is invoked.
DOTFILES_DIR=$(dirname "$(readlink -f "$0")")

info() {
    printf '\n==> %s\n' "$1"
}

die() {
    printf 'error: %s\n' "$1" >&2
    exit 1
}

usage() {
    cat <<EOF
dot - manage the personal development environment

Usage:
  dot COMMAND

Commands:
  init      Install Nix (and Homebrew on macOS) if needed, apply Home Manager,
            and set Fish as login shell
  switch    Apply the Home Manager configuration
  update    Update flake inputs, then apply the Home Manager configuration
  help      Show this help
EOF
}

require_regular_user() {
    [ "$(id -u)" -ne 0 ] || die "run this command as your regular user, not root"
}

run_as_root() {
    command -v sudo >/dev/null 2>&1 \
        || die "sudo is required for system installation and configuration"
    sudo "$@"
}

load_nix() {
    if [ -r "$NIX_DAEMON_PROFILE" ]; then
        set +u
        # shellcheck disable=SC1090
        . "$NIX_DAEMON_PROFILE"
        set -u
    fi
}

is_nixos() {
    [ -e /etc/NIXOS ]
}

ensure_nix() {
    load_nix

    # NixOS runs the daemon from the system configuration and ships no
    # nix-daemon.sh profile hook, so a working nix is all we can check for.
    if is_nixos; then
        command -v nix >/dev/null 2>&1 || die "nix is unavailable on this NixOS host"
        return
    fi

    if command -v nix >/dev/null 2>&1; then
        [ -r "$NIX_DAEMON_PROFILE" ] \
            || die "an existing non-daemon Nix installation was found; migrate it to multi-user Nix first"
        return
    fi

    if [ "$(uname -s)" = "Linux" ] && [ ! -d /run/systemd/system ]; then
        die "multi-user Nix on Linux requires systemd"
    fi

    command -v curl >/dev/null 2>&1 || die "curl is required to install Nix"
    info "Installing multi-user Nix"
    curl -fsSL https://nixos.org/nix/install | sh -s -- --daemon
    load_nix
    command -v nix >/dev/null 2>&1 || die "Nix was installed but is unavailable in this shell"
}

# The dot wrapper and the app-writable files link into ~/.dotfiles, so that
# path must resolve to this checkout even when Coder cloned it elsewhere.
ensure_home_link() {
    if [ ! -e "$HOME/.dotfiles" ] && [ ! -L "$HOME/.dotfiles" ]; then
        info "Linking $HOME/.dotfiles to $DOTFILES_DIR"
        ln -s "$DOTFILES_DIR" "$HOME/.dotfiles"
        return
    fi

    linked_dir=$(readlink -f "$HOME/.dotfiles")
    [ "$linked_dir" = "$DOTFILES_DIR" ] \
        || die "$HOME/.dotfiles points at $linked_dir, not this checkout ($DOTFILES_DIR)"
}

flavor_name() {
    case "$(uname -s)" in
        Darwin)
            printf 'darwin\n'
            ;;
        Linux)
            if is_nixos; then
                printf 'nixos\n'
            else
                printf 'linux\n'
            fi
            ;;
        *)
            die "unsupported OS: $(uname -s)"
            ;;
    esac
}

# Prefer a "<user>@<hostname>" entry, else the "<user>@<flavor>" fallback.
config_name() {
    user=$(id -un)
    node=$(uname -n)
    host_key="$user@${node%%.*}"
    flavor_key="$user@$(flavor_name)"
    names=$(cd "$DOTFILES_DIR" && NIX_CONFIG="$NIX_FLAKES" \
        nix eval --json .#homeConfigurations --apply builtins.attrNames) \
        || die "cannot list homeConfigurations in $DOTFILES_DIR"
    case "$names" in
        *"\"$host_key\""*) printf '%s\n' "$host_key" ;;
        *"\"$flavor_key\""*) printf '%s\n' "$flavor_key" ;;
        *) die "no homeConfigurations entry for $host_key or $flavor_key; add one in flake.nix" ;;
    esac
}

hm_switch() {
    config=$(config_name)
    info "Applying Home Manager configuration $config"
    cd "$DOTFILES_DIR"
    NIX_CONFIG="$NIX_FLAKES" \
        nix run --inputs-from . home-manager -- \
        switch --flake ".#$config" -b hm-bak
}

# The Brewfile (modules/darwin) needs Homebrew installed first.
ensure_homebrew() {
    if [ -x /opt/homebrew/bin/brew ] || [ -x /usr/local/bin/brew ]; then
        return
    fi
    command -v curl >/dev/null 2>&1 || die "curl is required to install Homebrew"
    info "Installing Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

current_login_shell() {
    current_user=$(id -un)
    case "$(uname -s)" in
        Darwin)
            dscl . -read "/Users/$current_user" UserShell 2>/dev/null | awk '{print $2}'
            ;;
        Linux)
            getent passwd "$current_user" 2>/dev/null | awk -F: '{print $7}'
            ;;
    esac
}

has_fish_handoff() {
    [ -r "$BASHRC" ] && grep -Fqx "$FISH_HANDOFF_BEGIN" "$BASHRC"
}

# NixOS owns /etc/shells (a read-only store link) and, with immutable users,
# rewrites the login shell from the system configuration on every activation,
# so chsh cannot stick. Interactive bash sessions hand off to Fish instead.
# The TTY and parent checks keep scripted, agent, and nested shells on bash.
configure_fish_handoff() {
    if has_fish_handoff; then
        return
    fi

    info "Handing interactive bash sessions off to Nix Fish"
    cat >>"$BASHRC" <<EOF
$FISH_HANDOFF_BEGIN
# Managed by dot on NixOS. Set DOT_NO_FISH=1 to stay in bash.
case \$- in
    *i*)
        if [ -z "\${DOT_NO_FISH:-}" ] && [ -t 0 ] && [ -t 1 ] \\
            && [ -x "$NIX_BIN/fish" ] \\
            && [ "\$(ps -o comm= -p "\$PPID" 2>/dev/null)" != fish ]; then
            if shopt -q login_shell; then
                exec "$NIX_BIN/fish" --login
            fi
            exec "$NIX_BIN/fish"
        fi
        ;;
esac
$FISH_HANDOFF_END
EOF
}

configure_login_shell() {
    fish_shell="$NIX_BIN/fish"
    [ -x "$fish_shell" ] || die "Fish is not installed by Home Manager"

    if is_nixos; then
        configure_fish_handoff
        return
    fi

    if ! grep -Fqx "$fish_shell" /etc/shells 2>/dev/null; then
        info "Registering Nix Fish as a login shell"
        printf '%s\n' "$fish_shell" | run_as_root tee -a /etc/shells >/dev/null
    fi

    configured_shell=$(current_login_shell)
    [ -n "$configured_shell" ] || die "could not inspect the current login shell"
    if [ "$configured_shell" != "$fish_shell" ]; then
        info "Changing the login shell to Nix Fish"
        run_as_root chsh -s "$fish_shell" "$(id -un)"
    fi
}

cmd_init() {
    require_regular_user
    ensure_nix
    ensure_home_link
    if [ "$(uname -s)" = Darwin ]; then
        ensure_homebrew
    fi
    hm_switch
    configure_login_shell
    printf '\nOpen a new shell to load the updated environment.\n'
}

cmd_switch() {
    require_regular_user
    load_nix
    ensure_home_link
    hm_switch
}

cmd_update() {
    require_regular_user
    load_nix
    ensure_home_link
    info "Updating flake inputs"
    NIX_CONFIG="$NIX_FLAKES" nix flake update --flake "$DOTFILES_DIR"
    hm_switch
}

main() {
    command_name=${1:-init}
    case "$command_name" in
        init | switch | update)
            [ "$#" -le 1 ] || die "unexpected argument: $2"
            "cmd_$command_name"
            ;;
        help | -h | --help)
            usage
            ;;
        *)
            usage >&2
            die "unknown command: $command_name"
            ;;
    esac
}

main "$@"
