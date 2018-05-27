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

echo ""
echo "Installing nvm"
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash

# Setup bin
echo "Copy bin folder"
cp -r ./bin ~

echo ""
echo "Installing z (https://github.com/rupa/z)"
git clone https://github.com/rupa/z ~/bin/z

# Setup system files
echo "Copy bash config files"
cp ./bash/.aliases ~/.aliases
cp ./bash/.bash_profile ~/.bash_profile
cp ./bash/.bash_prompt ~/.bash_prompt
cp ./bash/.bashrc ~/.bashrc
cp ./bash/.completions ~/.completions
cp ./bash/.curl-timings.txt ~/.curl-timings.txt
cp ./bash/.dircolors ~/.dircolors
cp ./bash/.exports ~/.exports
cp ./bash/.functions ~/.functions
cp ./bash/.inputrc ~/.inputrc
cp ./bash/.npmrc ~/.npmrc
cp ./bash/.vimrc ~/.vimrc

# Setup config files
cp ./config/.gitconfig ~/.gitconfig

# Setup vim
echo "Copy vim folder"
cp -r ./vim/* ~/.vim

# Install vim plugin manager
echo "Installing Plug for vim "
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
echo "Plugin manager installed! Run :PlugInstall inside vim to install plugins"
