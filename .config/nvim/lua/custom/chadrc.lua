---@type ChadrcConfig 
local M = {}

M.ui = {
  theme = 'onedark',
  telescope = { style = "bordered" }, -- borderless / bordered

  nvdash = {
    load_on_startup = true, -- Doesn't seem to work at the moment??
  },
}

M.plugins = 'custom.plugins'

return M
