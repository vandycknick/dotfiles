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
|-- home.nix                        # Packages, file links (platform/desktop-gated), activation steps
|-- modules/roles/                  # The dotfiles.desktop option
|-- modules/shell/                  # Session variables, generated Fish and login profiles
|-- modules/git/                    # Git config (personal + agent), Fish Git aliases and helpers
|-- modules/gpg/                    # GnuPG settings and the single gpg-agent
|-- modules/bin/                    # Nix-built commands: coding-agent wrappers, with-agent, scripts/
|-- modules/nix/                    # nix.conf settings and weekly garbage collection
|-- modules/darwin/                 # macOS defaults and the Brewfile (desktop apps)
|-- modules/linux/                  # Linux-only packages
|-- install.sh                      # POSIX-sh bootstrap and dot CLI
|-- .config/
|   |-- nvim/                       # Lua config, plugins, and Nix wrapper
|   |-- fish/                       # Interactive shell, prompt, and functions
|   |-- shell/                      # Shared login environment and zsh config
|   |-- aerospace/                  # macOS tiling window manager (macOS desktops only)
|   |-- hypr/                       # Wayland compositor, idle, and lock config
|   |-- i3/, compton/               # X11 window manager and compositor
|   |-- waybar/, walker/, rofi/     # Linux status bar and launchers
|   |-- ghostty/, tmux/             # Terminal environment
|   |-- lazygit/, k9s/              # Development tool configuration
|   `-- opencode/                   # OpenCode agents, models, and UI settings
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
| Add or remove a user CLI tool | `home.nix` (`home.packages`); platform-only tools in `modules/darwin/` or `modules/linux/` |
| Change which repo files are linked into `$HOME` | `home.nix` (`repoOnly`) |
| Change Nix CLI settings or garbage collection | `modules/nix` |
| Change packaged Neovim or LSP tools | `.config/nvim/package.nix` (also `nix run .#nvim`) |
| Allow an unfree package or track one from nixpkgs master | `flake.nix` (`allowUnfreePredicate`, `fromMaster`) |
| Change Neovim startup | `.config/nvim/init.lua` |
| Change Neovim options, mappings, or autocommands | `.config/nvim/lua/config/` |
| Add a general Neovim plugin | `.config/nvim/lua/plugins/` |
| Add language-specific Neovim support | `.config/nvim/lua/plugins/lang/` |
| Change Fish interactive startup, keybindings, or general aliases | `modules/shell/default.nix` (`programs.fish`) |
| Change direnv, zoxide, or Atuin integration | `modules/shell/default.nix` (`programs.direnv`, `programs.zoxide`, `programs.atuin`) |
| Change Fish Git aliases or Git helper functions | `modules/git/default.nix` (`programs.fish.shellAliases`, `programs.fish.functions`) |
| Change the Fish prompt | `.config/fish/conf.d/my_prompt.fish`, `.config/fish/functions/` |
| Add a Fish function | `.config/fish/functions/` |
| Change shared environment variables | `modules/shell/default.nix` (`home.sessionVariables`) |
| Change machine-identity routing | `modules/shell/default.nix` (`programs.fish.shellInit`), `.config/shell/profile`, `modules/bin/default.nix` (`with-agent`) |
| Change which SSH key each identity uses | `.ssh/config` (`Match … MACHINE_IDENTITY` blocks) |
| Change login PATH or zsh behavior | `.config/shell/profile`, `.config/shell/.zshrc` |
| Add a personal command | `modules/bin/scripts/<name>.sh` plus a `mkScript` entry with its `runtimeInputs` |
| Add a coding-agent CLI | `modules/bin/default.nix` (`agentClis`) |
| Change GnuPG, gpg-agent, cache TTLs, or pinentry | `modules/gpg/default.nix` (`programs.gpg`, `services.gpg-agent`) |
| Add a macOS desktop application or font | cask in `modules/darwin/Brewfile` |
| Change macOS preferences | `modules/darwin/default.nix` (`targets.darwin.defaults`, `finderDesktopView`) |
| Make a machine a desktop | `flake.nix`: a `"<user>@<hostname>"` entry with `desktop = true` |
| Change AeroSpace bindings or workspace rules | `.config/aerospace/aerospace.toml` |
| Change Hyprland, lock, idle, or wallpaper behavior | `.config/hypr/` |
| Change legacy X11 desktop behavior | `.config/i3/`, `.config/compton/`, `.config/rofi/` |
| Change Waybar or Walker UI | `.config/waybar/`, `.config/walker/` |
| Change terminal or multiplexer behavior | `.config/ghostty/`, `.config/tmux/` |
| Change Git defaults or the agent Git config | `modules/git/default.nix` (`programs.git`, `xdg.configFile."git/agent"`) |
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
- Commands are Nix packages in `modules/bin`, not tracked files: scripts are
  `writeShellApplication`s (shellchecked at build time, tools in
  `runtimeInputs`), and coding-agent CLIs get a `hiPrio` wrapper over their
  package. `~/.nix-profile/bin` precedes `~/.local/bin` on `PATH`, so binaries
  other installers drop there (Tern's `omp` link, curl installs) never shadow
  Nix tools. Codex's self-update check is disabled; it updates via nixpkgs.
- `homeConfigurations` are keyed `<user>@<hostname>` for specific machines
  (desktops) and `<user>@<flavor>` (`nixos`, `linux`, `darwin`) as the
  fallback; `install.sh` tries `id -un`@`uname -n` (short) first, then the
  flavor. Fallbacks are headless except `nickvd@darwin`. Targets are
  `x86_64-linux` and `aarch64-darwin`.
- `dotfiles.desktop` (set per target from `flake.nix`, declared in
  `modules/roles`) gates the window-manager configs (`linuxDesktop` and
  `darwinDesktop` in `home.nix`), the Brewfile, clipboard tools, and the
  graphical pinentry; headless machines get `pinentry-curses`.
- User-facing CLI tools belong in `home.packages` in `home.nix`. Unfree
  packages must be listed in `allowUnfreePredicate` in `flake.nix`; packages
  that track nixpkgs master (claude-code, codex) are listed in its `fromMaster`
  overlay, so modules always use plain `pkgs`.
- Neovim runtime executables and LSP tools belong in `.config/nvim/package.nix`;
  `home.nix` installs it and the root flake exposes it as `packages.nvim`.
- On macOS, desktop applications (and fonts) are Homebrew casks in
  `modules/darwin/Brewfile`; every CLI comes from Nix. Activation applies the
  Brewfile on desktop Macs and runs `brew bundle cleanup --force`, so anything
  not listed, formulae included, is uninstalled. Homebrew directories must not
  be added to `PATH`.
- Keep `install.sh` compatible with POSIX `sh`. Other scripts must satisfy the
  interpreter named by their shebang.
- One gpg-agent serves every context: the YubiKey (personal) and the agent SSH
  key, imported with `ssh-add` and kept passphrase-protected in its key store.
  `MACHINE_IDENTITY` selects the Git config and, in `.ssh/config`, the key
  order: personal uses only the YubiKey; agent tries the agent key first and
  falls back to the YubiKey. Coding-agent CLIs run through `with-agent` when
  `MACHINE_IDENTITY=agent` or the agent key is present.
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

- Editing managed files directly under `~/.config` or `~/.ssh`.
- Tracking scripts under `.local/bin`; add them to `modules/bin` instead.
- Adding a Homebrew formula or `PATH` entry, or a downloaded global-tool
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
dot init     # install Nix (and Homebrew on macOS) if missing, switch, set Fish as login shell
dot switch   # home-manager switch --flake .#<user>@<hostname>, else .#<user>@<flavor>; -b hm-bak
dot update   # nix flake update, then switch; leaves flake.lock to commit
dot help
```

All commands except `help` mutate the environment.

## KEY CONFIGS

| Area | Entry point | Important behavior |
|---|---|---|
| Bootstrap | `install.sh` | Installs multi-user Nix, links `~/.dotfiles` to the checkout, runs the Home Manager switch, and sets the Fish login shell. |
| Home Manager | `home.nix` | Declares user CLI packages and links tracked files. Tools and pi extensions come from Nix; activation never installs from npm or other registries. |
| Neovim | `.config/nvim/init.lua` | Loads options, mappings, autocommands, and lazy.nvim configuration. |
| Fish | `modules/shell/default.nix` | Generates `config.fish`: session variables, the gpg-agent socket (kept when forwarded over SSH), agent Git routing, vi bindings, interactive-only aliases, and the wtp hook. The direnv (with nix-direnv), zoxide, and Atuin modules add their own hooks; Atuin settings stay in `.config/atuin/config.toml`. |
| Shared shell | `modules/shell/default.nix`, `.config/shell/profile` | Declares XDG and tool variables once; the generated `.profile`/`.zprofile` source them, then set the user command path and identity routing. |
| macOS | `modules/darwin/` | Desktop Macs: Dock/Spaces/global defaults, the nested Finder desktop view, and the cask-only Brewfile with cleanup. |
| Nix | `modules/nix/default.nix` | Generates `~/.config/nix/nix.conf` (flakes enabled; checked against `pkgs.nix` at build). A weekly `nix-collect-garbage --delete-older-than 30d` (launchd on macOS, systemd timer on Linux) also prunes Home Manager generations. `install.sh` passes `NIX_CONFIG` for the first run. |
| Git | `modules/git/default.nix` | Generates `~/.config/git/config` (personal OpenPGP defaults, Nix-pinned gpg and git-lfs) and `~/.config/git/agent`, which includes it first and switches to SSH signing without reading Coder's `~/.gitconfig`. Activation ensures `~/.gitconfig` exists so `git config --global` writes there. |
| SSH | `.ssh/config` | Enforces strict host checking and separates public service anchors from private host config. |
| GnuPG | `modules/gpg/default.nix` | drduh-style `gpg.conf`; one gpg-agent with SSH support, 60/120 s passphrase cache, 24 h cache for the agent SSH key, platform pinentry. systemd socket activation on Linux; on macOS every login and `with-agent` run `gpgconf --launch`, because gpg-agent cannot take launchd sockets. |
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

Run before committing (on macOS it builds the darwin target and only
evaluates the Linux ones):

```sh
nix fmt
nix flake check                          # this system's targets, shellcheck, nixfmt
nix flake check --all-systems --no-build # evaluate every target
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
  (`with-agent`) wins.
- Each machine imports the agent key into gpg-agent once:
  `ssh-add ~/.ssh/agent_ed25519` (asks for the key's passphrase, then a
  passphrase to protect it in the agent). It survives agent restarts and
  reboots and works with the YubiKey unplugged.
