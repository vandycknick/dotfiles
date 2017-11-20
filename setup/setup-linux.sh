#!/bin/bash

# Update pkg lists
echo "Updating package lists..."
sudo apt-get update

# Installing git and completions
echo ''
echo "Now installing git and bash-completion..."
sudo apt-get install git bash-completion -y

# Installing extras
echo ''
echo 'Now installing htop, '
sudo apt-get install htop

# Midnight commander install
echo ''
echo "Now installing Midnight commander..."
echo ''
sudo apt-get install mc -y

# Setup bin
cp -r ./bin ~/bin

# Setup system files
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
cp -r ./vim ~/.vim