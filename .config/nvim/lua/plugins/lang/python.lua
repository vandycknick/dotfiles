local binz = require 'binz'
return {
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        pyright = {
          cmd = { binz.get_bin 'pyright', '--stdio' },
        },
      },
    },
  },
  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        python = { 'black', 'isort' },
      },
    },
  },
}
