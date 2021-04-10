#!/usr/bin/env bash

echo ""
echo "Configuring zsh"

echo "Changing shell to zsh"
chsh -s "$(which zsh)"

echo "Install oh my zsh"
ZSH_OHMY="$ZDOTDIR/oh-my-zsh"
if [ ! -d "$ZSH_OHMY" ]; then
  git clone https://github.com/ohmyzsh/ohmyzsh.git "$ZSH_OHMY"
fi

echo "Installing zsh autosuggestions"
ZSH_SUGGESTIONS="$ZSH_OHMY/custom/plugins/zsh-autosuggestions"
if [ ! -d "$ZSH_SUGGESTIONS" ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_SUGGESTIONS"
fi

echo "Installing zsh syntax highlighting"
ZSH_SYNTAX="$ZSH_OHMY/custom/plugins/zsh-syntax-highlighting"
if [ ! -d "$ZSH_SYNTAX" ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_SYNTAX"
fi
