{
  config,
  lib,
  pkgs,
  pkgsMaster,
  ...
}:
let
  # Live checkout; install.sh guarantees this path exists (symlink allowed).
  dotfiles = "${config.home.homeDirectory}/.dotfiles";

  # Top-level repo entries that are not part of $HOME.
  repoOnly = [
    "flake.nix"
    "flake.lock"
    "home.nix"
    "install.sh"
    "systemd"
    "README.md"
    "AGENTS.md"
    "LICENSE"
    ".editorconfig"
    ".gitignore"
  ];

  root = toString ./.;

  # The flake source contains only git-tracked files, so ignored state
  # (fish_variables, .ssh/config.d/private, pubring.kbx) is never linked.
  managed = lib.pipe (lib.filesystem.listFilesRecursive ./.) [
    (map (path: lib.removePrefix "${root}/" (toString path)))
    (lib.filter (
      rel: !(lib.elem (lib.head (lib.splitString "/" rel)) repoOnly) && baseNameOf rel != ".gitignore"
    ))
  ];

  onePasswordVersion = "2.39.0-beta.02";

  onePasswordSource =
    {
      x86_64-linux = {
        platform = "linux_amd64";
        extension = "zip";
      };

      aarch64-darwin = {
        platform = "apple_universal";
        extension = "pkg";
      };
    }
    .${pkgs.stdenv.hostPlatform.system}
      or (throw "1Password CLI beta is not supported on ${pkgs.stdenv.hostPlatform.system}");

  onePasswordCliBeta = pkgs._1password-cli.overrideAttrs (_old: {
    version = onePasswordVersion;

    src =
      if onePasswordSource.extension == "zip" then
        pkgs.fetchzip {
          url = "https://cache.agilebits.com/dist/1P/op2/pkg/v${onePasswordVersion}/op_${onePasswordSource.platform}_v${onePasswordVersion}.zip";
          hash = "sha256-ZbqkqY2InfeBU3jxh27F9WPMy6EyrERUbO1PM9i0ycA=";
          stripRoot = false;
        }
      else
        pkgs.fetchurl {
          url = "https://cache.agilebits.com/dist/1P/op2/pkg/v${onePasswordVersion}/op_${onePasswordSource.platform}_v${onePasswordVersion}.pkg";
          hash = "sha256-af3G2rc4JsqN7fn9uitN4S5z1x/DVLadHbszCUQswz0=";
        };
  });
in
{
  home.stateVersion = "26.05";
  programs.home-manager.enable = true;

  # One link per tracked file into the live checkout; this replaces
  # `stow --no-folding`. Edits apply without a rebuild, and app-written files
  # (lazy-lock.json, k9s config.yaml, pi settings.json) stay writable.
  home.file = lib.genAttrs managed (rel: {
    source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${rel}";
  });

  home.packages =
    with pkgs;
    [
      # Shell & environment
      fish
      tmux
      zoxide
      atuin
      direnv
      wtp

      # File & text navigation
      eza
      bat
      ripgrep
      fd
      fzf

      # Data & code inspection
      jq
      yq-go
      tokei
      bc
      bind
      gum
      tealdeer
      wget

      # Git
      git
      git-lfs
      lazygit
      hunk

      # Cloud & infrastructure
      awscli2
      ssm-session-manager-plugin
      google-cloud-sdk
      terraform
      kubectl
      kubernetes-helm
      k9s
      coder
      docker-client
      gcx
      github-cli

      # Secrets
      gnupg
      openssh
      onePasswordCliBeta

      # Editors & AI
      python3Packages.ansible-core
      pkgsMaster.claude-code
      opencode
      pi-coding-agent
      omp
      shellcheck
      (import ./.config/nvim/package.nix { inherit pkgs; })
    ]
    ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
      # Linux user utilities
      iproute2
      pinentry-gnome3
      procps
      wl-clipboard
      xclip
    ]
    ++ lib.optionals pkgs.stdenv.hostPlatform.isDarwin [
      # macOS only
      pinentry_mac
    ];

  # ~/.gitconfig is the per-host layer over ~/.config/git/config (Coder writes
  # the signing identity there). Without it, `git config --global` writes to
  # the XDG file and replaces the managed link with a regular file.
  home.activation.hostGitconfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -e "$HOME/.gitconfig" ]; then
      run touch "$HOME/.gitconfig"
    fi
  '';

  # pi installs npm: sources with npm, which activation's PATH does not carry.
  home.activation.piPackages = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    ${pkgs.jq}/bin/jq -r '.packages[]? | if type == "string" then . else .source end' \
      "${dotfiles}/.config/pi/settings.json" |
    while IFS= read -r source; do
      run env PI_CODING_AGENT_DIR="$HOME/.config/pi" PATH="${pkgs.nodejs}/bin:$PATH" \
        ${pkgs.pi-coding-agent}/bin/pi install "$source"
    done
  '';
}
