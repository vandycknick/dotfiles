#!/usr/bin/env bash
set -eou pipefail

DOTFILES="${VARIABLE:-$HOME/dotfiles}"
REPO_URL="https://github.com/vandycknick/dotfiles.git"

if [ ! -d $DOTFILES ]; then
  git clone --recursive "$REPO_URL" $DOTFILES
fi

pushd $DOTFILES > /dev/null

# TODO: silently fail here
git pull --rebase

stow .
popd > /dev/null

# TODO: I don't want to run the other commands just yet.
exit 0

# Install all the things
pacman -Syu
pacman -S linux-headers

# Utilities
pacman -S brightnessctl loginctl

pacman -S hyprland hypridle hyprlock hyprpaper waybar wofi

pacman -S atuin

# systemctl --user enable --now hypridle.service

# Fonts
pacman -S ttf-jetbrains-mono-nerd
pacman -S jq

# Tools
pacman -S zsh tmux
pacman -S less openssh ripgrep fzf fd rsync eza bat tokei
pacman -S wireplumber xdg-desktop-portal-hyprland

# Applications
pacman -S thunar firefox nautilus

pacman -S nfs-utils

# KVM
# Reference: https://gist.github.com/tatumroaquin/c6464e1ccaef40fd098a4f31db61ab22
# Reference: https://archlinux.org/news/qemu-700-changes-split-package-setup/
# Reference: Emulated TPM 2: https://www.reddit.com/r/archlinux/comments/15mjqap/tpm_version_20_is_not_supported_qemukvm/
pacman -S virt-manager virt-viewer qemu-full swtpm edk2-ovmf dnsmasq bridge-utils openbsd-netcat libguestfs
systemctl enable libvirtd.service
systemctl start libvirtd.service

# KVM: Are these really needed?
# vde2 iptables-nft (has a conflict with already installed iptables)

## Dev Tools
# yay -S https://aur.archlinux.org/nvm.git

## Infinitybook from Tuxedo Computers
yay -Syu
yay -S tuxedo-drivers-dkms tuxedo-control-center-bin
yay -S mise

chsh nickvd -s /usr/bin/zsh

# Install ohmyzsh plugins
# git clone git@github.com:ohmyzsh/ohmyzsh.git ~/.config/ohmyzsh
# git clone https://github.com/zsh-users/zsh-autosuggestions ~/.config/shell/custom/plugins/zsh-autosuggestions
# git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.config/shell/custom/plugins/zsh-syntax-highlighting
