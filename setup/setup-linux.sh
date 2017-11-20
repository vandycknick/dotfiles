#!/bin/bash

# Update pkg lists
echo "Updating package lists..."
sudo apt update

# Installing git and completions
echo ""
echo "Now installing git and bash-completion..."
sudo apt install git bash-completion -y

echo ""
echo "Installing build dependencies"
sudo apt install -y make build-essential libssl-dev zlib1g-dev libbz2-dev \
libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
xz-utils tk-dev

# Installing htop
echo ""
echo "Now installing htop, "
sudo apt install htop

# Midnight commander install
echo ""
echo "Now installing Midnight commander..."
echo ""
sudo apt install mc -y

echo ""
echo "Installing pyenv"
git clone https://github.com/pyenv/pyenv.git ~/.pyenv

# Setup bin
echo "Copy bin folder"
cp -r ./bin ~

# Setup system files
echo "Copy setup files"
cp ./system/.aliases ~/.aliases
cp ./system/.bash_profile ~/.bash_profile
cp ./system/.bash_prompt ~/.bash_prompt
cp ./system/.bashrc ~/.bashrc
cp ./system/.completions ~/.completions
cp ./system/.curl-timings.txt ~/.curl-timings.txt
cp ./system/.dircolors ~/.dircolors
cp ./system/.exports ~/.exports
cp ./system/.functions ~/.functions
cp ./system/.inputrc ~/.inputrc
cp ./system/.npmrc ~/.npmrc
cp ./system/.vimrc ~/.vimrc

# Setup vim
echo "Copy vim folder"
cp -r ./vim ~