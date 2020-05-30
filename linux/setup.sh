#!/usr/bin/env bash

# Update pkg lists
echo ""
echo "Updating package lists..."
sudo apt update

echo ""
echo "Installing build dependencies"
sudo apt install -y make build-essential libssl-dev zlib1g-dev libbz2-dev \
    libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
    xz-utils tk-dev libunwind8 libcurl4

echo ""
echo "Installing utilities"
sudo apt install -y git entr bash-completion

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
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.35.3/install.sh | bash

echo ""
echo "Installing yarn"
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update && sudo apt install yarn --no-install-recommends yarn

echo ""
echo "Installing dotnet"
source ./unix/scripts/dotnet-install.sh --channel Current

# Setup bin
echo ""
echo "Setup bin folder"
mkdir -p ~/bin
rsync -avh --no-perms unix/scripts/. ~/bin

echo ""
echo "Installing z (https://github.com/rupa/z)"
if [ ! -d ~/bin/z ]; then
  git clone https://github.com/rupa/z ~/bin/z
fi

# Setup config files
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

# Sync profile config
echo ""
echo "Sync profile config"
. ./unix/setup.sh --force
