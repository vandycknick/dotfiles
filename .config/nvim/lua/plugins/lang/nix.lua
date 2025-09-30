return {
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        nixd = {
          mason_install = false,
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
