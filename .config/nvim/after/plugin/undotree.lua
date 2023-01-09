vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

vim.keymap.set("n", "<C-n>", function() mark.nav_file(3) end)
