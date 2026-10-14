-- Render the current file in a new Tern tab. Only inside Tern, and only where
-- the tern CLI exists (not on a remote host over SSH).
if vim.env.TERM_PROGRAM ~= 'tern' or vim.fn.executable 'tern' == 0 then
  return
end

vim.keymap.set('n', '<leader>mp', function()
  local file = vim.api.nvim_buf_get_name(0)
  if file == '' then
    return vim.notify('Buffer has no file', vim.log.levels.WARN)
  end
  if vim.bo.modified then
    vim.cmd.write()
  end
  vim.system({ 'tern', 'open', '--tab', file }, {}, function(open)
    if open.code ~= 0 then
      return vim.schedule(function()
        vim.notify('tern open failed: ' .. open.stderr, vim.log.levels.ERROR)
      end)
    end
    vim.system { 'tern', 'ctl', 'file', 'mode', 'rendered' }
  end)
end, { buffer = true, desc = '[M]arkdown [P]review in Tern tab' })
