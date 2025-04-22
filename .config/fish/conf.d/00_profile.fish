if status is-login
  set -Ux EDITOR nvim
  set -Ux TERMINAL ghostty
  set -Ux BROWSER Zen.app

  set -Ux XDG_CONFIG_HOME "$HOME/.config"
  set -Ux XDG_DATA_HOME "$HOME/.local/share"
  set -Ux XDG_BIN_HOME "$HOME/.local/bin"
  set -Ux XDG_CACHE_HOME "$HOME/.cache"

  # Golang:
  set -Ux GOPATH "$XDG_DATA_HOME/go"
  fish_add_path "/usr/local/go/bin"
  fish_add_path "$GOPATH/bin"

  # AWS Cli
  # https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html
  set -Ux AWS_CONFIG_FILE "$XDG_CONFIG_HOME/aws/config"
  set -Ux AWS_SHARED_CREDENTIALS_FILE "$XDG_CONFIG_HOME/aws/credentials"
end
