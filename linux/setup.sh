#! /bin/bash

# Update pkg listse
echo ""
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

echo ""
echo "Installing utilities"
sudo apt install -y entr bash-completion

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
./linux/scripts/dotnet-install.sh --channel Current

# Setup bin
echo ""
echo "Setup bin folder"
mkdir -p ~/bin
rsync -avh --no-perms ./linux/scripts/. ~/bin

echo ""
echo "Installing z (https://github.com/rupa/z)"
git clone https://github.com/rupa/z ~/bin/z

# Setup system files
echo ""
echo "Sync bash config files"
rsync -avh --no-perms ./linux/profile/. ~

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

# Synchronise configuration
function doIt() {
    rsync -avh --no-perms . ~
    source ~/.bash_profile
}

CURRENT_DIR="$(pwd)"
cd "$(dirname "${BASH_SOURCE[0]}")/profile"

echo ""
echo "Synchronise profile script"
if [ "$1" == "--force" -o "$1" == "-f" ]; then
    doIt
else
    read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        doIt
    fi
fi
unset doIt

cd $CURRENT_DIR
