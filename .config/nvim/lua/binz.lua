local function packages_factory()
  local path = (vim.fn.stdpath 'config') .. '/tools.json'
  local ok, parsed = pcall(function()
    local f = assert(io.open(path, 'r'))
    local data = f:read '*a'
    f:close()
    return vim.fn.json_decode(data)
  end)
  if not ok then
    vim.notify('Failed to load neovim-tools.json', vim.log.levels.ERROR)
    return {}
  end

  return function(tool)
    return parsed[tool]
  end
end

local M = {}

M.get_bin = packages_factory()

return M
