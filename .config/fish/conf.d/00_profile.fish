status is-login || exit

set -Ux EDITOR nvim
set -Ux TERMINAL ghostty
set -Ux BROWSER Zen.app

set -Ux XDG_CONFIG_HOME "$HOME/.config"
set -Ux XDG_DATA_HOME "$HOME/.local/share"
set -Ux XDG_BIN_HOME "$HOME/.local/bin"
set -Ux XDG_CACHE_HOME "$HOME/.cache"

switch (uname)
# case Linux
case Darwin
  fish_add_path $XDG_BIN_HOME
  fish_add_path "/opt/homebrew/bin"
  fish_add_path "/opt/homebrew/opt/coreutils/libexec/gnubin"
end

# Golang:
set -Ux GOPATH "$XDG_DATA_HOME/go"
fish_add_path "/usr/local/go/bin"
fish_add_path "$GOPATH/bin"

# AWS Cli
# https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html
set -Ux AWS_CONFIG_FILE "$XDG_CONFIG_HOME/aws/config"
set -Ux AWS_SHARED_CREDENTIALS_FILE "$XDG_CONFIG_HOME/aws/credentials"

# NPM
set -Ux NPM_CONFIG_USERCONFIG "$XDG_CONFIG_HOME/npm/npmrc"

# Rust:
set -Ux CARGO_HOME "$XDG_DATA_HOME/cargo"
set -Ux RUSTUP_HOME "$XDG_DATA_HOME/rustup"
fish_add_path "$CARGO_HOME/bin"
