local binz = require 'binz'
return {
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        jsonls = {
          cmd = { binz.get_bin 'jsonls', '--stdio' },
        },
      },
    },
  },
}
