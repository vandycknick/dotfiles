# DOTFILES

Personal Linux and Apple Silicon macOS configuration applied with standalone
Home Manager. Below the top-level repository files the tree follows `$HOME`;
`home.nix` links every git-tracked file individually from a read-only Nix
store copy and declares the user CLI packages.
`install.sh` provides the bootstrap and ongoing `dot` command.

## STRUCTURE

```text
.dotfiles/
|-- flake.nix, flake.lock           # Inputs and per-host homeConfigurations
|-- home.nix                        # Packages, file links, activation steps
|-- modules/shell/                  # Session variables, generated Fish and login profiles
|-- install.sh                      # POSIX-sh bootstrap and dot CLI
|-- .config/
|   |-- nix/nix.conf                # Nix CLI features and policy
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
|-- .gitignore                      # Private and runtime state exclusions
|-- AGENTS.md
`-- README.md
```

## WHERE TO LOOK

| Task | Location |
|---|---|
| Bootstrap, switch, update, login shell | `install.sh` |
| Add a host or user configuration | `flake.nix` |
| Add or remove a user CLI tool | `home.nix` (`home.packages`) |
| Change which repo files are linked into `$HOME` | `home.nix` (`repoOnly`) |
| Change Nix CLI behavior | `.config/nix/nix.conf` |
| Change packaged Neovim or LSP tools | `.config/nvim/package.nix` |
| Change Neovim startup | `.config/nvim/init.lua` |
| Change Neovim options, mappings, or autocommands | `.config/nvim/lua/config/` |
| Add a general Neovim plugin | `.config/nvim/lua/plugins/` |
| Add language-specific Neovim support | `.config/nvim/lua/plugins/lang/` |
| Change Fish interactive startup or keybindings | `modules/shell/default.nix` (`programs.fish`) |
| Change Fish environment, aliases, Git helpers, or prompt | `.config/fish/conf.d/` |
| Add a Fish function | `.config/fish/functions/` |
| Change shared environment variables | `modules/shell/default.nix` (`home.sessionVariables`) |
| Change machine-identity routing | `modules/shell/identity.fish`, `.config/shell/profile` |
| Change login PATH or zsh behavior | `.config/shell/profile`, `.config/shell/.zshrc` |
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
| Change SSH trust or authentication policy | `.ssh/config` |
| Change state exclusions | `.gitignore` |
| Change host or devbox provisioning | `/home/nickvd/Projects/boxes` |

## CONVENTIONS

- Edit files in this checkout, never the linked counterpart in `$HOME`.
- Home Manager links one file at a time from the Nix store, so managed links
  coexist with application-owned state in real directories. Edits take effect
  on `dot switch`. Only git-tracked files are linked (the flake source excludes
  untracked files); new files need `git add`. New top-level repo-only files
  must be added to `repoOnly` in `home.nix`; nested `.gitignore` files are
  never linked. Do not track symlinks: they dangle once copied to the store;
  declare the alias in `home.file` instead (as for `.profile`). Files a Home
  Manager module generates (`~/.config/fish/config.fish`) must not be tracked.
- Files an application rewrites at runtime (`lazy-lock.json`, k9s
  `config.yaml`, pi `settings.json`) are listed in `mutable` in `home.nix` and
  link straight to `~/.dotfiles` so the writes land in the checkout.
- Paths another installer re-links (Tern's `~/.local/bin/omp`) are listed in
  `forced` in `home.nix`; Home Manager overwrites them instead of failing,
  because it never backs up foreign symlinks.
- `homeConfigurations` are keyed `<user>@<flavor>` (`nixos`, `linux`,
  `darwin`); `install.sh` derives the key from `id -un` and the OS. Targets are
  `x86_64-linux` and `aarch64-darwin`.
- User-facing CLI tools belong in `home.packages` in `home.nix`. Unfree
  packages are allowed; `pkgsMaster` exposes nixpkgs master.
- Neovim runtime executables and LSP tools belong in `.config/nvim/package.nix`;
  both `home.nix` and the standalone `.config/nvim/flake.nix` import it.
- Homebrew declarations are macOS-only taps and casks. Formulae are forbidden,
  and Homebrew directories must not be added to shell `PATH`.
- Keep `install.sh`, `.config/osx/homebrew`, `.config/osx/defaults`, and
  `.local/bin/pinentry` compatible with POSIX `sh`. Other scripts must satisfy
  the interpreter named by their shebang.
- Environment variables belong in `home.sessionVariables`, never in Fish
  `set -U`/`set -Ux` or a shell profile; every shell sources the generated
  `hm-session-vars`. Use Nix values (`config.xdg.*`) rather than shell
  expansion, since the generated file exports variables alphabetically.
- Put Fish startup snippets in `conf.d/` and named functions in `functions/`.
  `conf.d/` runs before the generated `config.fish` and cannot see the session
  variables; code that needs them goes in `programs.fish.shellInit`.
- Neovim plugin specifications are Lua modules under `lua/plugins/`; language
  modules belong under `lua/plugins/lang/`. Update `lazy-lock.json` only when
  intentionally changing plugin resolution.
- Keep credentials, private SSH hosts, cloud state, GnuPG keyrings, and
  generated application files out of Git. Check `.gitignore` before adding
  stateful paths.

## ANTI-PATTERNS

- Editing managed files directly under `~/.config`, `~/.local`, or `~/.ssh`.
- Adding a Homebrew formula, Homebrew `PATH` entry, or downloaded global-tool
  directory to the shared shell environment.
- Adding Go, Cargo, npm-global, mise, or equivalent tool bins globally; use the
  Home Manager packages or a project development shell.
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
dot init     # install Nix if missing, switch, set Fish as login shell
dot switch   # nix run --inputs-from . home-manager -- switch --flake .#<user>@<flavor> -b hm-bak
dot update   # nix flake update, then switch; leaves flake.lock to commit
dot help
```

All commands except `help` mutate the environment.

## KEY CONFIGS

| Area | Entry point | Important behavior |
|---|---|---|
| Bootstrap | `install.sh` | Installs multi-user Nix, links `~/.dotfiles` to the checkout, runs the Home Manager switch, and sets the Fish login shell. |
| Home Manager | `home.nix` | Declares user CLI packages, links tracked files, and ensures `~/.gitconfig`. Tools and pi extensions come from Nix; activation never installs from npm or other registries. |
| Neovim | `.config/nvim/init.lua` | Loads options, mappings, autocommands, and lazy.nvim configuration. |
| Fish | `modules/shell/default.nix` | Generates `config.fish`: session variables, machine identity and GPG agent, vi bindings, and the direnv, zoxide, Atuin, and wtp hooks. |
| Shared shell | `modules/shell/default.nix`, `.config/shell/profile` | Declares XDG and tool variables once; the generated `.profile`/`.zprofile` source them, then set the user command path and identity routing. |
| macOS | `.config/osx/` | Keeps application installation and OS defaults separate. |
| Git | `.config/git/config`, `.config/git/agent` | Personal OpenPGP defaults; agent contexts select the alternate global config for SSH signing without reading Coder's `~/.gitconfig`. |
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
- Tmux keeps its standard prefix, vi copy mode, and a top status bar. `s` or
  `Alt-o` opens the native session tree, `h/j/k/l` navigate panes, and
  `H/J/K/L` resize them.
- AeroSpace uses `Alt-H/J/K/L` to focus, `Alt-Shift-H/J/K/L` to move windows,
  and number keys for workspaces.
- Hyprland uses Super as its primary modifier; Super-Space launches Walker and
  Super plus a number selects a workspace.

## VALIDATION

Run checks relevant to the changed files:

```sh
sh -n install.sh
sh -n .config/osx/homebrew
sh -n .config/osx/defaults
sh -n .local/bin/pinentry
shellcheck install.sh .config/osx/homebrew .config/osx/defaults .local/bin/pinentry
for c in coder@nixos nickvd@nixos nickvd@linux nickvd@darwin; do
  nix eval --raw ".#homeConfigurations.\"$c\".activationPackage.drvPath"
done
nix build --no-link ".#homeConfigurations.\"$(id -un)@nixos\".activationPackage"
git diff --check
```

Also run the declared interpreter's syntax checker for changed Fish, Bash, Lua,
or other scripts. Do not use `dot init`, `dot switch`, or `dot update` as a
validation shortcut: they can change links, packages, the shell, or
`flake.lock`.

## NOTES

- `dot` is a Home Manager package that execs `~/.dotfiles/install.sh`;
  `install.sh` links `~/.dotfiles` to the checkout when it lives elsewhere.
- `.profile` and `.zprofile` are generated in `modules/shell/default.nix`: the
  Home Manager session variables followed by `.config/shell/profile`.
- Home Manager owns user CLI tools but not complete desktop sessions or
  system-service daemons.
- Private SSH host fragments belong under ignored `.ssh/config.d/private/`.
  Public GitHub and Codeberg trust anchors are tracked separately.
- The tracked `.ssh/id_rsa` file contains public key material despite its
  private-key-style name. Never add the corresponding private key.
- `MACHINE_IDENTITY` selects personal versus agent routing; each target's
  `machineIdentity` is its session-variable default, and an inherited value
  (`with-agent`) wins. The dedicated SSH agent never replaces personal socket
  defaults.
