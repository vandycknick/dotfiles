{ pkgs }:
let
  inherit (pkgs) lib vimPlugins;

  # lazy.nvim plugin name (the repository name in each spec) -> nixpkgs package.
  # lua/config/lazy.lua loads every spec from here and never clones.
  plugins = with vimPlugins; {
    "blink.cmp" = blink-cmp;
    "conform.nvim" = conform-nvim;
    "diffview.nvim" = diffview-nvim;
    "friendly-snippets" = friendly-snippets;
    "gitsigns.nvim" = gitsigns-nvim;
    "kanagawa.nvim" = kanagawa-nvim;
    "lazydev.nvim" = lazydev-nvim;
    "mini.ai" = mini-ai;
    "mini.hipatterns" = mini-hipatterns;
    "mini.icons" = mini-icons;
    "mini.statusline" = mini-statusline;
    "mini.surround" = mini-surround;
    "no-neck-pain.nvim" = no-neck-pain-nvim;
    "nvim-lspconfig" = nvim-lspconfig;
    "nvim-treesitter" = nvim-treesitter;
    "oil.nvim" = oil-nvim;
    "opencode.nvim" = opencode-nvim;
    "smear-cursor.nvim" = smear-cursor-nvim;
    "snacks.nvim" = snacks-nvim;
    "sqlite.lua" = sqlite-lua;
    "tabby.nvim" = tabby-nvim;
    "vim-dadbod" = vim-dadbod;
    "vim-dadbod-completion" = vim-dadbod-completion;
    "vim-dadbod-ui" = vim-dadbod-ui;
    "vim-fugitive" = vim-fugitive;
    "vim-sleuth" = vim-sleuth;
    "which-key.nvim" = which-key-nvim;
    "yanky.nvim" = yanky-nvim;
  };

  # Parsers (parser/*.so) and their queries in one runtimepath directory.
  grammars = pkgs.symlinkJoin {
    name = "nvim-treesitter-grammars";
    paths =
      (vimPlugins.nvim-treesitter.withPlugins (
        g: with g; [
          bash
          c
          css
          d
          diff
          dockerfile
          dtd
          fish
          git_config
          git_rebase
          gitcommit
          gitignore
          go
          gomod
          hcl
          helm
          html
          javascript
          jq
          jsdoc
          json
          kitty
          lua
          luadoc
          luau
          make
          markdown
          markdown_inline
          nix
          pem
          proto
          python
          query
          rasi
          requirements
          ruby
          rust
          sql
          ssh_config
          swift
          terraform
          toml
          tsx
          typescript
          vim
          vimdoc
          xml
          yaml
          zsh
        ]
      )).dependencies;
  };

  # Store paths for lua/config/lazy.lua.
  nixPaths = {
    lazy = "${vimPlugins.lazy-nvim}";
    plugins = "${pkgs.linkFarm "nvim-plugins" plugins}";
    grammars = "${grammars}";
  };

  # Language servers and formatters, on PATH for Neovim only.
  tools = pkgs.symlinkJoin {
    name = "nvim-tools";
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
  set -o errexit -o nounset -o pipefail
  export PATH="${tools}/bin:$PATH"
  exec ${pkgs.neovim}/bin/nvim \
    --cmd ${lib.escapeShellArg "lua vim.g.nix = ${lib.generators.toLua { multiline = false; } nixPaths}"} "$@"
''
