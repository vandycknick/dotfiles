#!/usr/bin/env bash

# Ask for the administrator password upfront.
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

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
