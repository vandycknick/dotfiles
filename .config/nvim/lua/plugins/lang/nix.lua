return {
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        nixd = {
          cmd = { 'nixd' },
          settings = {
            nixd = {
              formatting = {
                command = { 'nixfmt' },
              },
            },
          },
        },
      },
    },
  },
}
