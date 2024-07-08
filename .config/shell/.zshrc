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

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# History in cache directory:
HISTSIZE=10000000
SAVEHIST=10000000
HISTFILE=~/.cache/shell/history

if [ ! -f "$HISTFILE" ]; then
  mkdir -p "$(dirname "$HISTFILE")"
fi

# ZSH="$HOME/.config/ohmyzsh"
ZSH_CUSTOM="$ZDOTDIR/custom"
ZSH_THEME=$([[ "$ID" == "kali" ]] && echo "kali-linux" || echo "nickvd")

# Load completions
autoload -Uz compinit && compinit
zinit cdreplay -q

export ZSH_COMPDUMP="$HOME/.cache/shell/.zcompdump-${HOST/.*/}-${ZSH_VERSION}"

zinit light ohmyzsh/ohmyzsh
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions

zinit snippet OMZP::colored-man-pages
zinit snippet OMZP::git
zinit snippet OMZP::gpg-agent
zinit snippet OMZP::nvm
zinit snippet OMZP::pyenv
zinit snippet OMZP::ssh-agent

# Not sure if this is something I like yet.
# eval "$(starship init zsh)"

# Settings
export LESSOPEN="| /usr/share/source-highlight/src-hilite-lesspipe.sh %s"
export LESS=" -R "

# Load aliases and shortcuts if existent.
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shortcutrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shortcutrc"
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc"
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/zshnameddirrc" ] && source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/zshnameddirrc"

# Shell integrations
# eval "$(fzf --zsh)"
eval "$(zoxide init zsh)"
