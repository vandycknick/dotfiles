local binz = require 'binz'
return {
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        rust_analyzer = {
          cmd = { binz.get_bin 'rust_analyzer' },
        },
      },
    },
  },
}
