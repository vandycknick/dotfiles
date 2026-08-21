# Dotfiles

Personal Linux and Apple Silicon macOS configuration managed with Nix and GNU
Stow.

## Quick Start

Bootstrap a new machine directly from GitHub:

```sh
curl -fsSL https://raw.githubusercontent.com/vandycknick/dotfiles/main/install \
  | sh -s -- init
```

The installer supports x86_64 and aarch64 Linux plus Apple Silicon macOS. It
clones this repository to `~/.dotfiles`, installs multi-user Nix, builds the
personal CLI profile, links the configuration, and configures Fish as the login
shell. On macOS it also installs the configured applications and applies the
tracked defaults.

Linux installation requires systemd and `sudo`. macOS requires the Xcode
Command Line Tools; the installer starts their installation when necessary.

Open a new shell after initialization to load the updated environment.

## Dot Command

After initialization, use `dot` to maintain the environment:

| Command | Purpose |
|---|---|
| `dot init` | Install or initialize the environment |
| `dot update` | Update the checkout, tools, applications, and links |
| `dot stow` | Relink managed files |
| `dot doctor` | Diagnose the installed environment without changing it |
| `dot help [COMMAND]` | Show general or command-specific help |

Initialization steps can be skipped explicitly:

```sh
dot init --skip-nix
dot init --skip-stow --skip-shell
dot init --skip-homebrew --skip-defaults
```

Run `dot init --help` for the complete option list.

## Package Management

User-facing command-line tools are declared in
`.config/nix/profile/flake.nix`. Homebrew is reserved for macOS applications
and fonts declared in `.config/osx/Brewfile`; the Brewfile contains no
formulae, and Homebrew directories are not added to the shell `PATH`.

Use project development shells for project-specific language runtimes and
toolchains rather than installing global Go, Cargo, npm, or mise tools.

## Repository

The repository root is the Stow package and follows the layout of `$HOME`:

```text
~/.dotfiles/
|-- .config/          Application, shell, Nix, editor, and desktop config
|-- .local/bin/       Personal commands, including dot
|-- .local/share/     Managed user data such as GnuPG policy
|-- .ssh/             SSH policy and public trust material
|-- systemd/          Host service artifacts not installed by dot
|-- install           Bootstrap and dot command implementation
|-- AGENTS.md         Repository guidance for coding agents
`-- README.md
```

GNU Stow links managed files individually, allowing application-owned state to
remain outside the checkout. The checkout is authoritative, and commands that
update or relink files require it to be clean.

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

## Diagnostics

Run the read-only health check after installation or when configuration drifts:

```sh
dot doctor
```

Warnings describe non-critical drift. Missing requirements or unhealthy Stow
links produce a nonzero exit status.
