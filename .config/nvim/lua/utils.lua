local M = {}

local function escape_wildcards(path)
  return path:gsub('([%[%]%?%*])', '\\%1')
end

function M.tbl_flatten(t)
  return vim.iter(t):flatten(math.huge):totable()
end

-- For zipfile: or tarfile: virtual paths, returns the path to the archive.
-- Other paths are returned unaltered.
function M.strip_archive_subpath(path)
  -- Matches regex from zip.vim / tar.vim
  path = vim.fn.substitute(path, 'zipfile://\\(.\\{-}\\)::[^\\\\].*$', '\\1', '')
  path = vim.fn.substitute(path, 'tarfile:\\(.\\{-}\\)::.*$', '\\1', '')
  return path
end

function M.root_pattern(...)
  vim.print 'hello'
  local patterns = M.tbl_flatten { ... }
  return function(startpath)
    vim.validate('startpath', startpath, 'string')
    vim.print('startpath', vim.inspect(startpath))
    startpath = M.strip_archive_subpath(startpath)
    vim.print('startpath2', startpath)
    for _, pattern in ipairs(patterns) do
      vim.print(pattern)
      local match = M.search_ancestors(startpath, function(path)
        for _, p in ipairs(vim.fn.glob(table.concat({ escape_wildcards(path), pattern }, '/'), true, true)) do
          vim.print('for', path)
          if vim.uv.fs_stat(p) then
            vim.print('fs_stat', path)
            return path
          end
        end
      end)
      vim.print('match', match)

      if match ~= nil then
        return match
      end
    end
  end
end

function M.search_ancestors(startpath, func)
  vim.validate('func', func, 'function')
  if func(startpath) then
    return startpath
  end
  local guard = 100
  for path in vim.fs.parents(startpath) do
    -- Prevent infinite recursion if our algorithm breaks
    guard = guard - 1
    if guard == 0 then
      return
    end

    if func(path) then
      return path
    end
  end
end

function M.create_proxy(target, defaults)
  return setmetatable({}, {
    __index = function(_, key)
      -- Return a callable function for any key accessed
      return function(_, ...)
        local fn = target[key]
        if type(fn) ~= 'function' then
          error("Target has no function named '" .. key .. "'")
        end

        -- You can merge default args, override them, etc.
        local args = { ... }
        local opts = vim.tbl_deep_extend('force', defaults or {}, args[1] or {})
        return fn(opts)
      end
    end,
  })
end

return M
