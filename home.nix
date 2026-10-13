{
  config,
  lib,
  pkgs,
  pkgsMaster,
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
    ".config/nvim/lazy-lock.json"
    ".config/k9s/config.yaml"
    ".config/pi/settings.json"
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

  dot = pkgs.writeShellScriptBin "dot" ''
    exec "${dotfiles}/install.sh" "$@"
  '';
in
{
  home.stateVersion = "26.05";
  programs.home-manager.enable = true;

  services.ssh-agent = {
    enable = true;
    socket = "dotfiles-agent";
    defaultMaximumIdentityLifetime = null;
  };
  # Keep the dedicated agent out of ordinary personal sessions.
  sshAuthSock.enable = lib.mkForce false;

  assertions = [
    {
      assertion = lib.elem machineIdentity [ "personal" "agent" ];
      message = "machineIdentity must be personal or agent";
    }
  ];
  xdg.configFile."machine-identity".text = "${machineIdentity}\n";

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
      ".profile".source = ./.config/shell/profile;
      ".zprofile".source = ./.config/shell/profile;
    };

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

      # Dotfiles CLI
      dot

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
}
