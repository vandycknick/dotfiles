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
## better `cd`'ing
## 

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;

# Autocorrect typos in path names when using `cd`
shopt -s cdspell;

# Pyenv initialisation
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

# Initialize nvm
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Initialize z (https://github.com/rupa/z)
. ~/bin/z/z.sh
