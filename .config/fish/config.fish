set fish_greeting ""
set -g fish_key_bindings fish_vi_key_bindings

set -g hydro_color_prompt green

fish_add_path $XDG_BIN_HOME
fish_add_path "/opt/homebrew/bin"
fish_add_path "/opt/homebrew/opt/coreutils/libexec/gnubin"

if status is-interactive
  # mise activate fish | source
  zoxide init fish | source
  atuin init fish | source
end

bind -M insert \cp up-or-search
bind -M insert \cn down-or-search
bind -M insert \cy accept-autosuggestion
