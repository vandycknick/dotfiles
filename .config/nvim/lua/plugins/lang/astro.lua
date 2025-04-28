return {
  {
    'neovim/nvim-lspconfig',
    opts = {
      ensure_installed = { astro = { 'prettierd' } },
      servers = {
        astro = {},
      },
    },
  },

  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        astro = { 'prettierd', 'prettier', stop_after_first = true },
      },
    },
  },
}
