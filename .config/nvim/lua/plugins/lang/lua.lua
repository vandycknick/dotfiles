local binz = require 'binz'

return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'folke/lazydev.nvim', opts = {} },
    },
    opts = {
      servers = {
        lua_ls = {
          cmd = { binz.get_bin 'lua_ls' },
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
