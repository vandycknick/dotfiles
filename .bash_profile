# Load  ~/.bash_prompt, ~/.exports, ~/.aliases and ~/.functions
for file in ~/.{bash_prompt,exports,aliases,functions,completions}; do
	[ -r "$file" ] && source "$file"
done
unset file

# generic colouriser
GRC=`which grc`
if [ "$TERM" != dumb ] && [ -n "$GRC" ] 
    then
        alias colourify="$GRC -es --colour=auto"
        alias configure='colourify ./configure' 
        for app in {diff,make,gcc,g++,mtr,ping,traceroute}; do
            alias "$app"='colourify '$app
        done
fi

##
## gotta tune that bash_history…
##

# timestamps for later analysis. www.debian-administration.org/users/rossen/weblog/1
export HISTTIMEFORMAT='%F %T '

##
## Completion…
##

# bash completion.
if which brew > /dev/null && [ -f "$(brew --prefix)/share/bash-completion/bash_completion" ]; then
    source "$(brew --prefix)/share/bash-completion/bash_completion";
elif [ -f /etc/bash_completion ]; then
    source /etc/bash_completion;
fi;

# homebrew completion
source `brew --repository`/Library/Contributions/brew_bash_completion.sh

# Enable tab completion for `g` by marking it as an alias for `git`
if type _git &> /dev/null && [ -f /usr/local/etc/bash_completion.d/git-completion.bash ]; then
    complete -o default -o nospace -F _git g;
fi;

##
## better `cd`'ing
## 

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;

# Autocorrect typos in path names when using `cd`
shopt -s cdspell;

# z beats cd most of the time.
#   github.com/rupa/z
source ~/bin/z/z.sh

#Load .NET Version Manager (DNVM)
source dnvm.sh