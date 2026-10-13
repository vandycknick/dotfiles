# Dotfiles

Personal Linux and Apple Silicon macOS configuration managed with standalone
Home Manager. Includes Fish, Neovim, terminal and desktop settings, CLI tools,
and separate personal YubiKey and coding-agent SSH/Git identities.

`flake.nix` selects the machine configuration; `home.nix` declares packages and
links tracked configuration files into your home directory. Coder workspaces
default to the agent identity; personal machines keep their YubiKey setup.
Private keys are never stored here.

## Getting started

On a new machine:

```sh
git clone https://github.com/vandycknick/dotfiles.git ~/.dotfiles
~/.dotfiles/install.sh
```

The installer installs Nix if needed, applies the configuration for your user
and OS, and sets Fish as the login shell. Linux requires systemd and `sudo`.
Existing targets are `coder@nixos`, `nickvd@nixos`, `nickvd@linux`, and
`nickvd@darwin`; add a target in `flake.nix` for other users. Open a fresh login
session afterward. Existing Stow installations need a separate migration first.

To pull and apply dotfiles changes:

```sh
git -C ~/.dotfiles pull --ff-only
dot switch
```

Edit managed files in this checkout, not their installed links. Add new files
with `git add` before applying. Use `dot update` to update Nix dependencies and
apply them; it does not pull this repository.

SSH keys require separate provisioning and unlock.
