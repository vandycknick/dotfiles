local M = {}

-- Wraps `target` so every function call merges `defaults` into its options
-- table, e.g. Snacks pickers that should all open in the same layout.
function M.create_proxy(target, defaults)
  return setmetatable({}, {
    __index = function(_, key)
      return function(_, ...)
        local fn = target[key]
        if type(fn) ~= 'function' then
          error("Target has no function named '" .. key .. "'")
        end

        local args = { ... }
        local opts = vim.tbl_deep_extend('force', defaults or {}, args[1] or {})
        return fn(opts)
      end
    end,
  })
end

return M
