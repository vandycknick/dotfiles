# Only run in TMUX on MacOS
# Tmux uses a login causing it to reload /etc/profile again on macos. This contains a utility called path_helper on macos and which reorders my whole path: https://superuser.com/questions/544989/does-tmux-sort-the-path-variable
# Hence on macos every shell tmux spawns will reset the path reload /etc/profile and source my .profile again to get back to a pristine setup!
if [[ "$OSTYPE" == "darwin"* ]] && [ -n "$TMUX" ] && [ -f /etc/profile ]; then
  PATH=""
  source /etc/profile
  source $HOME/.profile
fi

# Load current distro information on Linux when present
if [ -f /etc/os-release ]; then
  source /etc/os-release
fi

# MacOS specific
if [[ "$OSTYPE" == "darwin"* ]]; then
  export PATH="/opt/homebrew/bin:/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"
fi

# Zsh
ZDOTDIR="$HOME/.config/shell"

# History in cache directory:
HISTSIZE=10000000
SAVEHIST=10000000
HISTFILE=~/.cache/shell/history

if [ ! -f "$HISTFILE" ]; then
  mkdir -p "$(dirname "$HISTFILE")"
fi

# ZSH="$HOME/.config/ohmyzsh"
ZSH_CUSTOM="$ZDOTDIR/custom"

# Colors
autoload -Uz colors && colors
PROMPT="%{$fg[cyan]%}%c%{$reset_color%} %(?:%{$fg_bold[green]%}❱ :%{$fg_bold[red]%}❱ )%{$reset_color%}"

# Settings
export LESSOPEN="| /usr/share/source-highlight/src-hilite-lesspipe.sh %s"
export LESS=" -R "

# Aliases
[ -x "$(command -v nvim)" ] && alias vim="nvim" vimdiff="nvim -d"

alias \
    cp="cp -iv" \
    mv="mv -iv" \
    rm="rm -vI" \
    bc="bc -ql" \
    mkd="mkdir -pv" \
    ip="ip --color=auto"

alias tfs="tfswitch -b /home/nickvd/.local/bin/terraform"

alias myip="dig txt ch +short whoami.cloudflare @1.1.1.1"
alias myip6="dig txt ch +short whoami.cloudflare @2606:4700:4700::1111"
alias tun0="ip -o -4 addr list tun0 | awk -F ' *|/' '{print \$4}'"
alias path="echo \$PATH | sed 's/:/\n/g'"
alias tms="tmux-sessionizer"
alias ls="eza --git"
alias tree="eza --tree --long --ignore-glob .git"
alias cat="bat"
alias k="kubectl"

if [[ "$OSTYPE" == "darwin"* ]]; then
    alias clip="pbcopy"
else
    alias clip="xclip -selection clipboard"
    alias clip="wl-copy"
    alias open=xdg-open
fi

# Shell integrations
eval "$(atuin init zsh)"
eval "$(mise activate zsh)"
eval "$(zoxide init zsh)"
