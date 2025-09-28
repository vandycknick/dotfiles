local binz = require 'binz'

return {
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        astro = {
          cmd = { binz.get_bin 'astro' },
        },
      },
    },
  },

  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        astro = { 'prettierd' },
      },
    },
  },
}
