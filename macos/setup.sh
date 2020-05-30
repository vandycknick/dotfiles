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

# Sync profile config
echo ""
echo "Sync profile config"
source ./unix/setup.sh --force
