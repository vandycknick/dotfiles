return {
  { -- Highlight, edit, and navigate code. Parsers come from Nix (package.nix).
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    config = function()
      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('nvd-treesitter', { clear = true }),
        callback = function(args)
          if pcall(vim.treesitter.start, args.buf) then
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
}
