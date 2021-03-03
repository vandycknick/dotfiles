#!/usr/bin/env bash

echo ""
echo "Updating package lists..."
sudo apt update

echo ""
echo "Install dev utilities"
sudo apt install -y make build-essential wget curl

echo ""
echo "Installing htop"
sudo apt install -y htop

echo ""
echo "Installing zsh"
sudo apt install -y zsh

source ./zsh/configure.sh

echo ""
echo "Installing tmux"
sudo apt install -y tmux

source ./tmux/configure.sh

echo ""
echo "Installing pyenv"
git clone https://github.com/pyenv/pyenv.git ~/.pyenv

echo ""
echo "Installing nvm"
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.37.2/install.sh | bash


echo ""
echo "Installing gpg"
sudo apt install -y gnupg
