local M = {}

M.terminal = {
  tabs = {},
  buf = nil,
  height = 10,
}

M.toggle = function()
  local terminal = M.terminal
  local current_tab = vim.api.nvim_get_current_tabpage()

  if terminal.tabs[current_tab] == nil then
    vim.cmd.split()
    local current_win = vim.api.nvim_get_current_win()

    if terminal.buf == nil then
      vim.cmd.terminal()
      terminal.buf = vim.api.nvim_get_current_buf()
    else
      vim.api.nvim_win_set_buf(current_win, terminal.buf)
    end

    -- vim.wo.winbar = id .. ': %{b:term_title}'
    terminal.tabs[current_tab] = {
      visible = true,
      win = current_win,
    }
    return
  end

  local terminal_tab = terminal.tabs[current_tab]

  -- CTRL-W_c closes a window, I could attach a listener for this
  -- but I thought this was less lines of code. I just check if the window handle
  -- that I have is still valid. If it isn't I just clear it and create a new window later.
  if terminal_tab.win ~= nil and vim.api.nvim_win_is_valid(terminal_tab.win) == false then
    terminal_tab.win = nil
  end

  if terminal_tab.win ~= nil then
    terminal_tab.height = vim.api.nvim_win_get_height(terminal_tab.win)
    vim.api.nvim_win_close(terminal_tab.win, false)
    terminal_tab.win = nil
  else
    vim.cmd.split()
    terminal_tab.win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_height(terminal_tab.win, terminal_tab.height)
    vim.api.nvim_win_set_buf(terminal_tab.win, terminal.buf)
  end
end

M.close = function()
  M.terminal.tabs = {}
  M.terminal.buf = nil
end

return {
  name = 'terminal',
  dir = '.',
  lazy = false,
  config = function()
    vim.keymap.set({ 'n' }, '<M-;>', M.toggle, { desc = 'Toggle Terminal Window.' })

    vim.api.nvim_create_autocmd('TermOpen', {
      desc = 'remove line numbers in terminal',
      group = vim.api.nvim_create_augroup('nvd-term-open', { clear = true }),
      callback = function()
        vim.wo.number = false
        vim.wo.relativenumber = false
        vim.wo.statuscolumn = ''
      end,
    })

    vim.api.nvim_create_autocmd('TermClose', {
      desc = 'Close window when terminal job ends',
      group = vim.api.nvim_create_augroup('nvd-term-close', { clear = true }),
      callback = M.close,
    })
  end,
}
