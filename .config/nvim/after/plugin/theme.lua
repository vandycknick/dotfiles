require("onedarkpro").setup({ })

local helpers = require("onedarkpro.helpers")
local colors = helpers.get_colors()

vim.api.nvim_set_hl(0, "VertSplit", { bg = "none", fg = colors.gray })
vim.api.nvim_set_hl(0, "Folded", { bg = "none", fg = colors.gray })
vim.api.nvim_set_hl(0, "FoldedNC", { bg = "none", fg = colors.gray })
vim.api.nvim_set_hl(0, "FoldColumn", { bg = "none", fg = colors.gray })
vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
vim.api.nvim_set_hl(0, "SignColumnNC", { bg = "none", fg = colors.gray })
vim.api.nvim_set_hl(0, "NonText", { bg = "none", fg = colors.gray })
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none", fg = colors.gray })
vim.api.nvim_set_hl(0, "LineNr", { bg = "none", fg = colors.gray })
vim.api.nvim_set_hl(0, "LineNrNC", { bg = "none", fg = colors.gray })
vim.api.nvim_set_hl(0, "Question", { bg = "none", fg = colors.gray })
vim.api.nvim_set_hl(0, "WinBar", { bg = "none", fg = colors.gray })
vim.api.nvim_set_hl(0, "WinBar", { bg = "none", fg = colors.gray })
vim.api.nvim_set_hl(0, "WinBarNC", { bg = "none", fg = colors.gray })
vim.api.nvim_set_hl(0, "WinSeparator", { bg = "none", fg = colors.gray })
