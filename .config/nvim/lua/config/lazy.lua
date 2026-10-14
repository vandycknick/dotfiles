-- lazy.nvim, the plugins, and the Treesitter grammars come from Nix
-- (package.nix), which passes their store paths in vim.g.nix.
local nix = assert(vim.g.nix, 'start Neovim through the Nix wrapper (package.nix)')
vim.opt.rtp:prepend(nix.lazy)

require('lazy').setup {
  spec = {
    { import = 'plugins' },
  },
  -- Every spec loads from the Nix plugin directory. To try a plugin before
  -- adding it to package.nix, set `dev = false` on its spec and lazy clones it.
  dev = { path = nix.plugins, patterns = { '' }, fallback = false },
  install = { missing = false },
  rocks = { enabled = false },
  checker = { enabled = false },
  -- Versions live in flake.lock; this only records clones made with dev = false.
  lockfile = vim.fn.stdpath 'state' .. '/lazy-lock.json',
}

-- After setup, which resets the runtimepath. Ahead of $VIMRUNTIME, so the
-- nvim-treesitter parsers and queries replace the ones bundled with Neovim.
vim.opt.rtp:prepend(nix.grammars)
