# Zsh
ZDOTDIR="$HOME/.config/shell"

# History in cache directory:
HISTSIZE=10000000
SAVEHIST=10000000
HISTFILE=~/.cache/shell/history

# Oh my zsh
ZSH="$ZDOTDIR/oh-my-zsh"
ZSH_THEME="robbyrussell"
ZSH_CUSTOM="$ZDOTDIR/custom"

plugins=(
    colored-man-pages
    git
    gpg-agent
    nvm
    pyenv
    ssh-agent
    tmux
    z
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# Use lf to switch directories and bind it to ctrl-o
lfcd () {
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp" >/dev/null
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}
bindkey -s '^o' 'lfcd\n'

# Exports
export FUNCTIONS_CORE_TOOLS_TELEMETRY_OPTOUT="true"
export DOTNET_CLI_TELEMETRY_OPTOUT="true"
export OMNISHARPHOME="$XDG_CONFIG_HOME/omnisharp"

# Settings
export LESSOPEN="| /usr/share/source-highlight/src-hilite-lesspipe.sh %s"
export LESS=" -R "

# Utils
eval "$(pyenv init -)"

# Load aliases and shortcuts if existent.
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shortcutrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shortcutrc"
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc"
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/zshnameddirrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/zshnameddirrc"
