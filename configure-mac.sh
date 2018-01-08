#!/usr/bin/env bash

# don't run it.
echo "do not run this script in one go. hit ctrl-c NOW"
read -n 1

#Install homebrew : http://brew.sh/
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew tap homebrew/versions
brew tap caskroom/versions

#Install cask : http://caskroom.io/
brew install caskroom/cask/brew-cask

## Should be safe from this point

# Install command-line tools using Homebrew.

# Ask for the administrator password upfront.
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Install GNU core utilities (those that come with OS X are outdated)
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
brew install coreutils
# Install some other useful utilities like `sponge`
brew install moreutils
# Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed
brew install findutils
# Install GNU `sed`, overwriting the built-in `sed`
brew install gnu-sed --with-default-names
# Install htop
brew install htop

#Install z <3
brew install z

# Install Bash 4.
# Note: don’t forget to add `/usr/local/bin/bash` to `/etc/shells` before
# running `chsh`.
brew install bash
# brew tap homebrew/versions : done in setup.sh
brew install bash-completion2

# Programming binaries
brew install go
brew install mono
brew install pyenv

# Libraries
brew install libgit2

# Some tools
brew install cf-cli
brew install jq
brew install vim

#Cleanup the house
brew cleanup

# Make sure we’re using the latest and greatest.
brew cask update

# tools
brew cask install 1password

# daily
brew cask install skype
brew cask install slack

# dev
brew cask install visual-studio-code
brew cask install visual-studio-code-insiders
brew cask install iterm2
brew cask install parallels-desktop
brew cask install java
brew cask install dash
brew cask install docker

# personal
brew cask install vlc
brew cask install spotify
brew cask install transmission
brew cask install android-file-transfer

# browsers
brew cask install google-chrome
brew cask install google-chrome-canary
brew cask install firefox
brew cask install torbrowser

#other
brew cask install disk-inventory-x

#Cleanup the house
brew cask cleanup
