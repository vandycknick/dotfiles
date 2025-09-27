set fish_greeting ""
set -g fish_key_bindings fish_vi_key_bindings

set -g hydro_color_prompt green

if status is-interactive
  direnv hook fish | source
  mise activate fish | source
  zoxide init fish | source
  atuin init fish | source
end

bind -M insert \cp up-or-search
bind -M insert \cn down-or-search
bind -M insert \cy accept-autosuggestion

if test (uname) = Linux; and test (tty) = /dev/tty1
  if uwsm check may-start; and uwsm select
    exec uwsm start default
  end
end
