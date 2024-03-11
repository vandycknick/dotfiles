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
    export PATH="/opt/homebrew/bin:/usr/local/opt/coreutils/libexec/gnubin:$PATH"
fi

# Zsh
ZDOTDIR="$HOME/.config/shell"

# History in cache directory:
HISTSIZE=10000000
SAVEHIST=10000000
HISTFILE=~/.cache/shell/history

# Oh my zsh
ZSH="$ZDOTDIR/oh-my-zsh"
ZSH_CUSTOM="$ZDOTDIR/custom"
ZSH_THEME=$([[ "$ID" == "kali" ]] && echo "kali-linux" || echo "nickvd")

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

# Load aliases and shortcuts if existent.
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shortcutrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shortcutrc"
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc"
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/zshnameddirrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/zshnameddirrc"
