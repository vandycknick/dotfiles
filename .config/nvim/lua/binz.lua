local function sha256(file)
  local handle = io.popen('shasum -a 256 ' .. vim.fn.shellescape(file) .. " | awk '{print $1}'")
  if not handle then
    return nil
  end
  local result = handle:read '*l'
  handle:close()
  return result
end

local function read_file(path)
  local fd = io.open(path, 'r')
  if not fd then
    return nil
  end
  local content = fd:read '*a'
  fd:close()
  return content
end

local function write_file(path, data)
  local fd = io.open(path, 'w')
  if not fd then
    return false
  end
  fd:write(data)
  fd:close()
  return true
end

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
    return function()
      return ''
    end
  end

  return function(tool)
    return parsed[tool]
  end
end

local M = {}

M.get_bin = packages_factory()

return M
