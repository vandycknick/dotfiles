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
xz-utils tk-dev libunwind8 libcurl4

# Installing htop
echo ""
echo "Now installing htop"
sudo apt install -y htop

# Midnight commander install
echo ""
echo "Now installing Midnight commander..."
sudo apt install -y mc

echo ""
echo "Installing pyenv"
git clone https://github.com/pyenv/pyenv.git ~/.pyenv

echo ""
echo "Installing nvm"
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash

echo ""
echo "Installing dotnet"
./scripts/dotnet-install.sh --channel Current

# Setup bin
echo ""
echo "Setup bin folder"
mkdir -p ~/bin
rsync -avh --no-perms --exclude='*.ps1' ./scripts/. ~/bin

echo ""
echo "Installing z (https://github.com/rupa/z)"
git clone https://github.com/rupa/z ~/bin/z

# Setup system files
echo ""
echo "Sync bash config files"
rsync -avh --no-perms ./bash/. ~

# Setup config files
cp ./config/.gitconfig ~/.gitconfig

# Install vim plugin manager
echo ""
echo "Installing Plug for vim"
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
echo "Plugin manager installed! Run :PlugInstall inside vim to install plugins."

# Setup vim
echo ""
echo "Sync vim config folder"
mkdir -p ~/.vim
rsync -avh --no-perms ./vim/. ~/.vim
