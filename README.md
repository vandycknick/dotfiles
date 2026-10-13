# Dotfiles

Personal Linux and Apple Silicon macOS configuration managed with standalone
Home Manager.

## Quick Start

Clone the repository and run the installer:

```sh
git clone https://github.com/vandycknick/dotfiles.git ~/.dotfiles
~/.dotfiles/install.sh
```

The installer installs multi-user Nix when it is missing, applies the Home
Manager configuration for the current user and OS, and configures Fish as the
login shell. It also runs unchanged as a Coder dotfiles script: when the
checkout is not at `~/.dotfiles`, it links `~/.dotfiles` to it.

Configurations are keyed `<user>@<flavor>`, where flavor is `nixos`, `linux`
(non-NixOS, using `targets.genericLinux`) or `darwin`. The installer picks the
key from `id -un` and the OS; add a `homeConfigurations` entry in `flake.nix`
for a new user or host. Linux installation of Nix requires systemd and `sudo`.

Open a new shell after initialization to load the updated environment.

## Dot Command

`dot` is installed by Home Manager and runs `~/.dotfiles/install.sh`:

| Command | Purpose |
|---|---|
| `dot init` | Install Nix if needed, apply Home Manager, and set Fish as login shell |
| `dot switch` | Apply the Home Manager configuration |
| `dot update` | Update flake inputs, then apply the configuration |
| `dot help` | Show help |

`dot switch` is equivalent to:

```sh
nix run --inputs-from . home-manager -- switch --flake .#<user>@<flavor> -b hm-bak
```

`dot update` leaves the updated `flake.lock` for you to commit; it does not
pull the checkout.

## Package Management

User-facing command-line tools are declared in `home.packages` in `home.nix`.
Homebrew is reserved for macOS applications and fonts declared in
`.config/osx/Brewfile`; the Brewfile contains no formulae, and Homebrew
directories are not added to the shell `PATH`. Run `.config/osx/homebrew` and
`.config/osx/defaults` manually on macOS.

Use project development shells for project-specific language runtimes and
toolchains rather than installing global Go, Cargo, npm, or mise tools.

## Repository

Outside the top-level repository files, the tree follows the layout of
`$HOME`:

```text
~/.dotfiles/
|-- flake.nix         Inputs and per-host homeConfigurations
|-- flake.lock
|-- home.nix          Packages, file links, and activation steps
|-- install.sh        Bootstrap and dot command implementation
|-- .config/          Application, shell, Nix, editor, and desktop config
|-- .local/bin/       Personal commands
|-- .local/share/     Managed user data such as GnuPG policy
|-- .ssh/             SSH policy and public trust material
|-- AGENTS.md         Repository guidance for coding agents
`-- README.md
```

Home Manager links every git-tracked file individually from a read-only copy
in the Nix store, so application-owned state can sit next to managed files.
Edit files in the checkout and run `dot switch` to apply them; new files must
be `git add`ed first. The few files applications rewrite themselves
(`lazy-lock.json`, k9s `config.yaml`, pi `settings.json`) are listed in
`mutable` in `home.nix` and link directly to the `~/.dotfiles` checkout.

## Migrating From Stow

On a host still using Stow and the old `nix profile`, pull this checkout, then:

```sh
cd ~/.dotfiles
stow --delete --no-folding --dir="$HOME/.dotfiles" --target="$HOME" .
rm -r ~/.config/nix/profile   # stale links Stow no longer knows about
nix profile remove .config/nix/profile
./install.sh init
```

## Platform Configuration

macOS applications and preferences live in `.config/osx/`. Linux desktop
configuration for Hyprland, i3, Waybar, Walker, Rofi, and related tools is
tracked here, but the surrounding desktop session and system services remain
host-managed.

Host provisioning and service deployment are outside the bootstrap workflow.

## SSH

The tracked SSH configuration uses strict host-key checking and separates
public service trust anchors from ignored private host configuration. See
`.ssh/README.md` before adding or changing hosts.
