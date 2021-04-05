echo ""
echo "Configuring zsh"

echo "Changing shell to zsh"
chsh -s $(which zsh)

echo "Linking rc file"
ln -sf ~/.dotfiles/zsh/.zshrc ~/.zshrc

echo "Install oh my zsh"
if [ ! -d $HOME/.oh-my-zsh ]; then
  git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
fi

echo "Installing zsh autosuggestions"
if [ ! -d $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi

echo "Installing zsh syntax highlighting"
if [ ! -d $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi
