# My Dotfiles

My personal collection of dotfiles, managed with Nix and GNU Stow.

## Install

Run the bootstrap directly from GitHub:

```sh
curl -fsSL https://raw.githubusercontent.com/vandycknick/dotfiles/main/install | sh
```

The bootstrap supports x86_64/aarch64 Linux and Apple Silicon macOS. It installs
Git when needed, clones this repository to `~/.dotfiles`, installs multi-user
Nix using the official installer, builds `.config/nix/profile/flake.nix`, and
links the dotfiles into the home directory with GNU Stow. On Linux, it also
registers the Nix profile's Fish binary in `/etc/shells` and makes it the
current user's login shell.

Run `dot` from any directory to repeat the process. Subsequent runs require a
clean checkout, fast-forward `main` from GitHub, update the Nix profile, and
restow the repository.

Stow links individual files rather than folding whole directories into the
repository. Directories such as `~/.config/fish`, `~/.local/bin`, and
`~/.local/share/gnupg` therefore remain real directories, so application state
created alongside the managed links stays outside the dotfiles checkout.

The repository is authoritative: files in the home directory that conflict
with managed dotfiles are replaced. Untracked or uncommitted repository changes
are never overwritten; the bootstrap stops and reports them instead.

On Linux, the Nix installation and login shell configuration require systemd
and `sudo`. On macOS, Git is provided by the Xcode Command Line Tools; if they
are absent, the bootstrap starts their installer and must be run again after it
finishes.
