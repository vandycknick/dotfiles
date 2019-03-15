#!/usr/bin/env bash

# Install homebrew
export HOMEBREW_NO_ANALYTICS=1

if [ ! -f /usr/local/bin/brew ]; then
    echo "Homebrew not found. Installing ..."
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Install Applications
source "$(dirname "${BASH_SOURCE[0]}")/brew.sh"

# Settings
source "$(dirname "${BASH_SOURCE[0]}")/settings.sh"

# Synchronise configuration
function doIt() {
    rsync -avh --no-perms . ~
    source ~/.bash_profile
}

CURRENT_DIR="$(pwd)"
cd "$(dirname "${BASH_SOURCE[0]}")/profile"

echo ""
echo "Synchronise profile script"
if [ "$1" == "--force" -o "$1" == "-f" ]; then
    doIt
else
    read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        doIt
    fi
fi
unset doIt

cd $CURRENT_DIR
