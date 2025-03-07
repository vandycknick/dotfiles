if status is-login
  set -Ux EDITOR nvim
  set -Ux TERMINAL ghostty
  set -Ux BROWSER Zed.app

  set -Ux XDG_CONFIG_HOME "$HOME/.config"
  set -Ux XDG_DATA_HOME "$HOME/.local/share"
  set -Ux XDG_BIN_HOME "$HOME/.local/bin"
  set -Ux XDG_CACHE_HOME "$HOME/.cache"
end
