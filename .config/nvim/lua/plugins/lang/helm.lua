local binz = require 'binz'

return {
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        helm_ls = {
          cmd = { binz.get_bin 'helm_ls', 'serve' },
        },
      },
    },
  },
}
