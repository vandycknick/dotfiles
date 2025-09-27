local binz = require 'binz'

return {
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        nixd = {
          mason_install = false,
          cmd = { binz.get_bin 'nixd' },
          settings = {
            nixd = {
              formatting = {
                command = { binz.get_bin 'nixfmt' },
              },
            },
          },
        },
      },
    },
  },
}
