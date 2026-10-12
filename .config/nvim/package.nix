{ pkgs }:
let
  lib = pkgs.lib;
  bashOptions = [
    "errexit"
    "nounset"
    "pipefail"
  ];
  plugins = pkgs.symlinkJoin {
    name = "nvim-plugins";
    paths = [
      pkgs.astro-language-server
      pkgs.bash-language-server
      pkgs.black
      pkgs.lua-language-server
      pkgs.stylua
      pkgs.gopls
      pkgs.gotools
      pkgs.gofumpt
      pkgs.harper
      pkgs.helm-ls
      pkgs.isort
      pkgs.oxlint
      pkgs.pyright
      pkgs.rust-analyzer
      pkgs.tree-sitter
      pkgs.nixd
      pkgs.nixfmt
      pkgs.prettierd
      pkgs.terraform-ls
      pkgs.typescript
      pkgs.vscode-langservers-extracted
    ]
    ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
      pkgs.inotify-tools # Lsp file watching requires inotify tools to be installed on Linux: https://gitlab.b-data.ch/neovim/neovim/-/blob/master/runtime/lua/vim/lsp/_watchfiles.lua?ref_type=heads#L11
    ];
  };
in
pkgs.writeShellScriptBin "nvim" ''
  ${lib.concatMapStringsSep "\n" (option: "set -o ${option}") bashOptions}
  export PATH="${plugins}/bin:$PATH"
  # sqlite.lua (yanky's ring storage) dlopens libsqlite3 and only probes
  # FHS and Homebrew paths, which NixOS and a formula-free Homebrew lack.
  export LIBSQLITE="${pkgs.sqlite.out}/lib/libsqlite3${pkgs.stdenv.hostPlatform.extensions.sharedLibrary}"

  exec ${pkgs.neovim}/bin/nvim "$@"
''
