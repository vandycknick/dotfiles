local binz = require 'binz'
return {
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        terraformls = {
          cmd = { binz.get_bin 'terraformls', 'serve' },
        },
      },
    },
  },
}
