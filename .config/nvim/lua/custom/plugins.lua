local plugins = {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- Common
        "markdown",

        -- Python
        "black",
        "pyright",
        "ruff",

        -- Lua
        "lua_ls",

        -- Astro
        "astro-language-server",

        -- Typescript/javascript
        "tsserver",
        "eslint",

        -- Rust
        "rust-analyzer",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    config = function ()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end,
  },
  {
    "simrat39/rust-tools.nvim",
    ft = "rust",
    dependencies = "neovim/nvim-lspconfig",
    opts = function ()
      return require "custom.configs.rust-tools"
    end,
    config = function(_, opts)
      require("rust-tools").setup(opts)
    end
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    ft = {"python"},
    opts = function()
      return require("custom.configs.null-ls")
    end
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        -- defaults
        "lua",

        -- web dev
        "html",
        "css",
        "javascript",
        "typescript",
        "tsx",
        "json",
        "astro",

        -- backend
        "python",
        "go",

        -- low level
        "c",
        "rust",
      }
    },
  },
  {
    "tpope/vim-fugitive",
    cmd = { "G", "Git", },
  }
}

return plugins
