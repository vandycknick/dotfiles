#!/usr/bin/env bash

# Ask for the administrator password upfront.
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Make sure we’re using the latest and greatest.
brew cask update

# daily
brew cask install skype

# dev
brew cask install visual-studio-code
brew cask install sublime-text3
brew cask install github
brew cask install parallels-desktop

# fun
brew cask install gitter
brew cask install vlc
brew cask install spotify

# browsers
brew cask install google-chrome
brew cask install google-chrome-canary
brew cask install torbrowser

#other
brew cask install disk-inventory-x

#Cleanup the house
brew cask cleanup