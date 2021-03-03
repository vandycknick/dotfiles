echo ""
echo "Configuring tmux"

echo "Linking rc files"
ln -sf ~/.dotfiles/tmux/.tmux.conf ~/.tmux.conf

echo "Installing tmux plugin manager"
if [ ! -d $HOME/.tmux/plugins/tpm ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi
