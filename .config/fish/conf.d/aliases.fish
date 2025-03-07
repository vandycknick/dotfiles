# Use neovim for vim if present.
if type --query nvim
  alias vim "nvim"
  alias vimdiff "nvim -d"
end

alias cp "cp -iv"
alias mv "mv -iv"
alias rm "rm -vI"
alias bc "bc -ql"
alias mkd "mkdir -pv"
alias ip "ip --color=auto"

# Utilities
alias myip "dig txt ch +short whoami.cloudflare @1.1.1.1"
alias myip6 "dig txt ch +short whoami.cloudflare @2606:4700:4700::1111"
alias tun0 "ip -o -4 addr list tun0 | awk -F ' *|/' '{print \$4}'"
alias show_path "echo \$PATH | string split ' '"
alias tms "tmux-sessionizer"
alias ls "eza --git"
alias tree "eza --tree --long --ignore-glob .git"
alias cat "bat"
alias k "kubectl"

# Git Utils
alias gri 'git rebase -i $(git log --oneline --color=always | fzf --ansi | awk '"'"'{print $1}'"'"')'

switch (uname)
case Linux
  alias clip "xclip -selection clipboard"
  alias clip "wl-copy"
case Darwin
  alias clip "pbcopy"
#case '*'
#    echo Catch All
end
