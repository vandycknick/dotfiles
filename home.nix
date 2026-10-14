{
  config,
  lib,
  pkgs,
  machineIdentity,
  ...
}:
let
  # Checkout path; install.sh guarantees it exists (symlink allowed). Only the
  # mutable files below and the dot wrapper refer to it.
  dotfiles = "${config.home.homeDirectory}/.dotfiles";

  # Top-level repo entries that are not part of $HOME.
  repoOnly = [
    "flake.nix"
    "flake.lock"
    "home.nix"
    "modules"
    "install.sh"
    "README.md"
    "AGENTS.md"
    "LICENSE"
    ".editorconfig"
    ".gitignore"
  ];

  # Files the owning application rewrites at runtime. A read-only store copy
  # would break them, so they link to the checkout and changes show up in git.
  mutable = [
    ".config/k9s/config.yaml"
    ".config/pi/settings.json"
  ];

  root = toString ./.;

  # Desktop-session configs, linked only on desktops of that platform.
  linuxDesktop = [
    ".config/hypr"
    ".config/i3"
    ".config/compton"
    ".config/rofi"
    ".config/waybar"
    ".config/walker"
    ".xsessionrc"
  ];
  darwinDesktop = [ ".config/aerospace" ];

  inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;
  inherit (config.dotfiles) desktop;
  excluded =
    lib.optionals (!(desktop && isLinux)) linuxDesktop
    ++ lib.optionals (!(desktop && isDarwin)) darwinDesktop;
  isExcluded = rel: lib.any (dir: rel == dir || lib.hasPrefix "${dir}/" rel) excluded;

  # The flake source contains only git-tracked files, so ignored state
  # (fish_variables, .ssh/config.d/private, pubring.kbx) is never linked.
  managed = lib.pipe (lib.filesystem.listFilesRecursive ./.) [
    (map (path: lib.removePrefix "${root}/" (toString path)))
    (lib.filter (
      rel:
      !(lib.elem (lib.head (lib.splitString "/" rel)) repoOnly)
      && baseNameOf rel != ".gitignore"
      && !(isExcluded rel)
    ))
  ];

  dot = pkgs.writeShellScriptBin "dot" ''
    exec "${dotfiles}/install.sh" "$@"
  '';
in
{
  imports = [
    ./modules/roles
    ./modules/shell
    ./modules/git
    ./modules/gpg
    ./modules/bin
    ./modules/nix
    ./modules/darwin
    ./modules/linux
  ];

  home.stateVersion = "26.05";
  programs.home-manager.enable = true;

  assertions = [
    {
      assertion = lib.elem machineIdentity [
        "personal"
        "agent"
      ];
      message = "machineIdentity must be personal or agent";
    }
  ];

  # One store-backed link per tracked file, so directories stay real and
  # application state can live next to managed files. Edits apply on switch.
  home.file =
    lib.genAttrs managed (rel: {
      source =
        if lib.elem rel mutable then
          config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${rel}"
        else
          ./. + "/${rel}";
    })
    // {
      # Tern starts outside a login shell, so it reads omp's default folder
      # instead of PI_CODING_AGENT_DIR; both see the same themes.
      ".omp/agent/themes".source =
        config.lib.file.mkOutOfStoreSymlink "${config.xdg.configHome}/pi/themes";
    };

  home.packages = with pkgs; [
    # Shell & environment
    tmux
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

    # Git (git and git-lfs come from programs.git)
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
    docker-compose
    gcx
    github-cli

    # Secrets (gnupg comes from programs.gpg)
    openssh

    # Dotfiles CLI
    dot

    # Editors & AI (coding-agent CLIs come from modules/bin)
    python3Packages.ansible-core
    shellcheck
    (import ./.config/nvim/package.nix { inherit pkgs; })
  ];
}
