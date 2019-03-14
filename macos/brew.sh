#!/usr/bin/env bash

# Install command-line tools using Homebrew.

# Make sure we’re using the latest Homebrew.
echo ""
echo "Updating homebrew"
brew update

# Upgrade any already-installed formulae.
echo ""
echo "Upgrading homebrew"
brew upgrade

# Save Homebrew’s installed location.
echo ""
echo "Setting homebrew prefix to $(brew --prefix)"
BREW_PREFIX=$(brew --prefix)

# Install GNU core utilities (those that come with macOS are outdated).
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
echo ""
echo "Install coreutils, moreutils, findutils, gnu-sed"
brew install coreutils
if [ ! -f "${BREW_PREFIX}/bin/sha256sum" ]; then
    ln -sf "${BREW_PREFIX}/bin/gsha256sum" "${BREW_PREFIX}/bin/sha256sum"
fi

# Install some other useful utilities like `sponge`
brew install moreutils
# Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed
brew install findutils
# Install GNU `sed`, overwriting the built-in `sed`
brew install gnu-sed

# Install htop
echo ""
echo "Installing htop"
brew install htop

#Install z <3
echo ""
echo "Install z"
brew install z

# Install Bash 4.
# Note: don’t forget to add `/usr/local/bin/bash` to `/etc/shells` before
# running `chsh`.
brew install bash
# brew tap homebrew/versions : done in setup.sh
brew install bash-completion2

# Switch to using brew-installed bash as default shell
if ! fgrep -q "${BREW_PREFIX}/bin/bash" /etc/shells; then
    echo "${BREW_PREFIX}/bin/bash" | sudo tee -a /etc/shells
    chsh -s "${BREW_PREFIX}/bin/bash"
fi

# Programming binaries
echo ""
echo "Installing some code related stuff"
brew install go
brew install mono
brew install pyenv
brew install nvm
brew install azure-cli

# Libraries
echo ""
echo "Installing libraries"
brew install libgit2

# Some tools
echo ""
echo "Installing some interesting tools"
brew install jq
brew install vim

# Install applications
echo ""
echo "Installing application"
# tools
brew cask install 1password
brew cask install slack

# dev
brew cask install visual-studio-code
brew cask install iterm2
brew cask install docker

# personal
# brew cask install vlc
brew cask install spotify
brew cask install transmission
brew cask install android-file-transfer

# browsers
brew cask install google-chrome
brew cask install homebrew/cask-versions/google-chrome-canary
brew cask install firefox
brew cask install tor-browser

# other
brew cask install amethyst
brew cask install disk-inventory-x
    
# Cleanup the house
echo ""
echo "Homebrew cleanup"
brew cleanup

# Setup config files
echo ""
echo "Copy common config files"
cp ./common/config/.gitconfig ~/.gitconfig

# Install vim plugin manager
echo ""
echo "Installing Plug for vim"
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
echo "Plugin manager installed! Run :PlugInstall inside vim to install plugins."

# Setup vim
echo ""
echo "Sync vim config folder"
mkdir -p ~/.vim
rsync -avh --no-perms ./common/vim/. ~/.vim
