#!/usr/bin/env bash

echo ""
echo "Updating package lists..."
sudo apt update

echo ""
echo "Install dev utilities"
sudo apt install -y \
    make \
    build-essential \
    wget \
    curl \
    apt-transport-https \
    ca-certificates

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
if [ ! -d $HOME/.pyenv ]; then
    git clone https://github.com/pyenv/pyenv.git ~/.pyenv
else
    pushd $HOME/.pyenv
    git pull --rebase
    popd
fi

echo ""
echo "Installing nvm"
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.37.2/install.sh | bash


echo ""
echo "Installing gpg"
sudo apt install -y gnupg

echo ""
echo "Installing Docker"
if [ ! -f /etc/apt/sources.list.d/docker.list ]; then
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo \
        "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update
fi
sudo apt install docker-ce docker-ce-cli containerd.io
