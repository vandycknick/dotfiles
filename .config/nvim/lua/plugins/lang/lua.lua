return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'folke/neodev.nvim', opts = {} },
    },
    opts = {
      ensure_installed = { lua = { 'stylua' } },

      servers = {
        lua_ls = {
          -- cmd = {...},
          -- filetypes = { ...},
          -- capabilities = {},
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },
      },
    },
  },

  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        lua = { 'stylua' },
      },
    },
  },
}
