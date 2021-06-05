#!/usr/bin/env bash

. config/shell/profile

echo ""
echo "Sync config files"
rsync -rpltv ./config/* "$XDG_CONFIG_HOME"

ln -sf "$XDG_CONFIG_HOME/shell/profile" "$HOME/.profile"
ln -sf "$HOME/.profile" "$HOME/.zprofile"

echo "Sync local bin"
mkdir -p "$HOME/.local/bin"
rsync -rpltv ./local/bin/* "$HOME/.local/bin"

echo ""
echo "Updating package lists..."
sudo apt update

echo ""
echo "Install dev utilities"
sudo apt install -y \
    build-essential \
    apt-transport-https \
    ca-certificates \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    llvm \
    tk-dev \
    libncurses5-dev \
    xz-utils tk-dev \
    libxml2-dev \
    libxmlsec1-dev \
    libffi-dev \
    liblzma-dev \
    lsb-release

echo ""
echo "Install CLI Utilities"
sudo apt install -y \
    curl \
    wget \
    make \
    jq

echo ""
echo "Installing htop"
sudo apt install -y htop

echo ""
echo "Installing zsh"
sudo apt install -y zsh

. install/zsh.sh

echo ""
echo "Installing vim"
sudo apt install -y neovim

echo ""
echo "Installing tmux"
sudo apt install -y tmux

. install/tmux.sh

echo ""
echo "Installing bpftrace"
sudo apt install -y bpftrace

echo ""
echo "Installing pyenv"
if [ ! -d "$PYENV_ROOT" ]; then
    git clone https://github.com/pyenv/pyenv.git "$PYENV_ROOT"
else
    pushd "$PYENV_ROOT" || exit 1
    git pull --rebase
    popd || exit 1
fi

echo ""
echo "less is more"
# Some utilities for less sytntax highlighting
sudo apt install source-highlight libsource-highlight-common

echo ""
echo "Installing nvm"
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.38.0/install.sh | bash

echo ""
echo "Installing yarn"
if ! [ -x "$(command -v yarn)" ]; then
    echo "Yarn not installed"
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
    sudo apt update
fi

sudo apt install yarn --no-install-recommends yarn

echo ""
echo "Installing gpg"
sudo apt install -y gnupg

echo ""
echo "Setting up azure tools"
. install/az.sh

echo ""
echo "Setting up vscode"
. install/code.sh

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
