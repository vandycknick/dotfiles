# DOTFILES

Personal Linux and Apple Silicon macOS configuration. The repository root is a
GNU Stow package that follows `$HOME`; managed files are linked individually
with `--no-folding`. Nix owns the user CLI environment, while `install` provides
the bootstrap and ongoing `dot` command.

## STRUCTURE

```text
.dotfiles/
|-- install                         # POSIX-sh bootstrap and dot CLI
|-- .config/
|   |-- nix/
|   |   |-- profile/                # Declarative user CLI profile
|   |   `-- nix.conf                # Nix CLI features and policy
|   |-- nvim/                       # Lua config, plugins, and Nix wrapper
|   |-- fish/                       # Interactive shell, prompt, and functions
|   |-- shell/                      # Shared login environment and zsh config
|   |-- osx/                        # Homebrew casks and macOS defaults
|   |-- aerospace/                  # macOS tiling window manager
|   |-- hypr/                       # Wayland compositor, idle, and lock config
|   |-- i3/, compton/               # X11 window manager and compositor
|   |-- waybar/, walker/, rofi/     # Linux status bar and launchers
|   |-- ghostty/, tmux/             # Terminal environment
|   |-- git/, lazygit/, k9s/        # Development tool configuration
|   `-- opencode/                   # OpenCode agents, models, and UI settings
|-- .local/
|   |-- bin/                        # Personal commands and dot symlink
|   `-- share/gnupg/                # GnuPG policy, never private key material
|-- .ssh/                           # SSH policy and public trust anchors
|-- .profile, .zprofile             # Symlinks to the shared login profile
|-- systemd/                        # Host artifacts, intentionally not stowed
|-- .stow-local-ignore              # Stow exclusions
|-- .gitignore                      # Private and runtime state exclusions
|-- AGENTS.md
`-- README.md
```

## WHERE TO LOOK

| Task | Location |
|---|---|
| Bootstrap, update, Stow, doctor, platform support | `install` |
| Add or remove a user CLI tool | `.config/nix/profile/flake.nix` |
| Change Nix CLI behavior | `.config/nix/nix.conf` |
| Change packaged Neovim or LSP tools | `.config/nvim/flake.nix` |
| Change Neovim startup | `.config/nvim/init.lua` |
| Change Neovim options, mappings, or autocommands | `.config/nvim/lua/config/` |
| Add a general Neovim plugin | `.config/nvim/lua/plugins/` |
| Add language-specific Neovim support | `.config/nvim/lua/plugins/lang/` |
| Change Fish interactive startup | `.config/fish/config.fish` |
| Change Fish environment, aliases, Git helpers, or prompt | `.config/fish/conf.d/` |
| Add a Fish function | `.config/fish/functions/` |
| Change shared login environment or zsh behavior | `.config/shell/profile`, `.config/shell/.zshrc` |
| Add a personal command | `.local/bin/` |
| Change GnuPG agent or pinentry policy | `.local/share/gnupg/`, `.local/bin/pinentry` |
| Add a macOS application or font | `.config/osx/Brewfile` |
| Change Homebrew bootstrap/update behavior | `.config/osx/homebrew` |
| Change macOS preferences | `.config/osx/defaults` |
| Change AeroSpace bindings or workspace rules | `.config/aerospace/aerospace.toml` |
| Change Hyprland, lock, idle, or wallpaper behavior | `.config/hypr/` |
| Change legacy X11 desktop behavior | `.config/i3/`, `.config/compton/`, `.config/rofi/` |
| Change Waybar or Walker UI | `.config/waybar/`, `.config/walker/` |
| Change terminal or multiplexer behavior | `.config/ghostty/`, `.config/tmux/` |
| Change Git defaults | `.config/git/config` |
| Change OpenCode models or agent routing | `.config/opencode/opencode.jsonc` |
| Change SSH trust or authentication policy | `.ssh/config`, `.ssh/README.md` |
| Change Stow or state exclusions | `.stow-local-ignore`, `.gitignore` |
| Change host service artifacts | `systemd/` |
| Change host or devbox provisioning | `/home/nickvd/Projects/boxes` |

## CONVENTIONS

- Edit files in this checkout, never the linked counterpart in `$HOME`.
- The repository root is the Stow package. Always use `--no-folding` so
  managed links can coexist with application-owned state in real directories.
- `dot stow` uses `--adopt --restow --no-folding`, restores tracked files
  immediately, and refuses to run against a dirty checkout.
- User-facing CLI tools belong in `.config/nix/profile/flake.nix`. The profile
  supports `x86_64-linux`, `aarch64-linux`, and `aarch64-darwin`.
- Neovim runtime executables and LSP tools belong in `.config/nvim/flake.nix`;
  the personal profile consumes the packaged Neovim output.
- Homebrew declarations are macOS-only taps and casks. Formulae are forbidden,
  and Homebrew directories must not be added to shell `PATH`.
- Keep `install`, `.config/osx/homebrew`, `.config/osx/defaults`, and
  `.local/bin/pinentry` compatible with POSIX `sh`. Other scripts must satisfy
  the interpreter named by their shebang.
- Put Fish startup snippets in `conf.d/` and named functions in `functions/`.
  Keep `config.fish` focused on global interactive setup.
- Neovim plugin specifications are Lua modules under `lua/plugins/`; language
  modules belong under `lua/plugins/lang/`. Update `lazy-lock.json` only when
  intentionally changing plugin resolution.
- Keep credentials, private SSH hosts, cloud state, GnuPG keyrings, and
  generated application files out of Git. Check `.gitignore` before adding
  stateful paths.
- `systemd/` contains host-side artifacts and is excluded from Stow. `dot`
  does not install or enable them.

## ANTI-PATTERNS

- Editing managed files directly under `~/.config`, `~/.local`, or `~/.ssh`.
- Running `dot init`, `dot update`, or `dot stow` with a dirty checkout.
- Adding a Homebrew formula, Homebrew `PATH` entry, or downloaded global-tool
  directory to the shared shell environment.
- Adding Go, Cargo, npm-global, mise, or equivalent tool bins globally; use the
  Nix profile or a project development shell.
- Tracking runtime state, credentials, private keys, cloud configuration, or
  application-generated files.
- Assuming desktop configuration is desktop provisioning. Hyprland, i3,
  Waybar, Walker, Rofi, and their session services remain host-managed.
- Weakening the restrictive default SSH policy or accepting host keys without
  independent verification.
- Hard-coding a home directory when `$HOME` or an XDG path is appropriate.
- Adding provisioning playbooks here; provisioning belongs in the boxes
  repository.

## COMMANDS

```sh
dot init [--skip-nix] [--skip-stow] [--skip-shell] [--skip-homebrew] [--skip-defaults]
dot update
dot stow
dot doctor
dot help [COMMAND]
```

`dot init`, `dot update`, and `dot stow` mutate the environment and require a
clean checkout. `dot doctor` is read-only and returns nonzero for critical
requirements or unhealthy Stow links.

## KEY CONFIGS

| Area | Entry point | Important behavior |
|---|---|---|
| Bootstrap | `install` | Manages checkout updates, multi-user Nix, the user profile, Stow links, Fish login shell, and macOS steps. |
| Nix profile | `.config/nix/profile/flake.nix` | Single declarative user CLI environment; permits required unfree packages. |
| Neovim | `.config/nvim/init.lua` | Loads options, mappings, autocommands, and lazy.nvim configuration. |
| Fish | `.config/fish/config.fish` | Uses vi bindings and initializes direnv, zoxide, Atuin, and wtp interactively. |
| Shared shell | `.config/shell/profile` | Establishes XDG paths and the Nix/user command path. |
| macOS | `.config/osx/` | Keeps application installation and OS defaults separate. |
| Git | `.config/git/config` | Uses GPG signing, pull rebase, current-branch pushes, Git LFS, and hunk as the pager. |
| SSH | `.ssh/config` | Enforces strict host checking and separates public service anchors from private host config. |
| GnuPG | `.local/share/gnupg/gpg-agent.conf` | Enables SSH-agent support and delegates platform pinentry selection to the wrapper. |
| OpenCode | `.config/opencode/opencode.jsonc` | Disables sharing and routes primary, delegated, and lightweight work to explicit models. |

## DISTINCTIVE STYLES

- Fish uses vi mode. Insert-mode `Ctrl-P` and `Ctrl-N` search history, while
  `Ctrl-Y` accepts the current autosuggestion.
- The Fish prompt computes Git state asynchronously and marks virtual machines
  and SSH sessions. The prompt symbol is `>`-shaped and command failures retain
  pipeline status information.
- Neovim uses Space as leader, `Ctrl-S` to write, `Ctrl-H/J/K/L` for split
  navigation, `Shift-H/J/K/L` for resizing, and `Esc Esc` to leave terminal
  mode. Normal-mode arrow keys intentionally refuse movement.
- Neovim uses Kanagawa, OSC52 clipboard integration, relative numbers,
  tree-sitter folds, blink.cmp, Snacks pickers, and `Ctrl-.` for OpenCode.
- Ghostty and tmux use Kanagawa-derived styling. Some Linux UI configuration
  uses Catppuccin; do not assume a single repository-wide theme.
- Tmux keeps its standard prefix, vi copy mode, and a top status bar. `f` opens
  the project sessionizer, `h/j/k/l` navigate panes, and `H/J/K/L` resize them.
- AeroSpace uses `Alt-H/J/K/L` to focus, `Alt-Shift-H/J/K/L` to move windows,
  and number keys for workspaces.
- Hyprland uses Super as its primary modifier; Super-Space launches Walker and
  Super plus a number selects a workspace.

## VALIDATION

Run checks relevant to the changed files:

```sh
sh -n install
sh -n .config/osx/homebrew
sh -n .config/osx/defaults
sh -n .local/bin/pinentry
shellcheck install .config/osx/homebrew .config/osx/defaults .local/bin/pinentry
nix --extra-experimental-features 'nix-command flakes' \
  flake check --all-systems --no-write-lock-file .config/nix/profile
stow --simulate --restow --no-folding --dir="$HOME/.dotfiles" --target="$HOME" .
git diff --check
```

Also run the declared interpreter's syntax checker for changed Fish, Bash, Lua,
or other scripts. Do not use `dot init`, `dot update`, or `dot stow` as a
validation shortcut: they can change the checkout, links, profile, shell,
applications, or system settings.

## NOTES

- `.local/bin/dot` is a tracked symlink to `install`; Stow exposes it under
  `~/.local/bin`.
- `.profile` and `.zprofile` are tracked symlinks to `.config/shell/profile`.
- The Nix profile owns user CLI tools but not complete desktop sessions or
  system-service daemons.
- Private SSH host fragments belong under ignored `.ssh/config.d/private/`.
  Public GitHub and Codeberg trust anchors are tracked separately.
- The tracked `.ssh/id_rsa` file contains public key material despite its
  private-key-style name. Never add the corresponding private key.
- `systemd/nvim-remote.service` and its firewall helper are host-specific and
  are not installed by `dot`.
