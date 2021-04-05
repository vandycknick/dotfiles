# Zsh
ZDOTDIR="$HOME/.config/zsh"

# History in cache directory:
HISTSIZE=10000000
SAVEHIST=10000000
HISTFILE=~/.cache/zsh/history

# Oh my zsh
ZSH="$HOME/.config/zsh/oh-my-zsh"
ZSH_THEME="robbyrussell"

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

# Path

# Aliases
alias clip="xclip -selection clipboard"
alias code="code --user-data-dir $XDG_DATA_HOME/vscode --extensions-dir $XDG_DATA_HOME/vscode/extensions"
