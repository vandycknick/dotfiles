local ivy_split = { layout = { preset = 'ivy_split', layout = { position = 'bottom' } } }

return {
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    opts = {
      bigfile = {
        enabled = true,
        notify = true, -- show notification when big file detected
        size = 1.5 * 1024 * 1024, -- 1.5MB
      },

      picker = {
        prompt = ' ',
        ----@class snacks.picker.layout.Config
        layout = {
          preset = 'default',
        },
      },

      -- https://github.com/folke/snacks.nvim/blob/main/docs/dashboard.md
      dashboard = {
        enabled = true,
        preset = {
          pick = 'telescope.nvim',
          header = [[
  ███╗   ██╗██╗   ██╗██████╗
    ████╗  ██║██║   ██║██╔══██╗
    ██╔██╗ ██║██║   ██║██║  ██║
    ██║╚██╗██║╚██╗ ██╔╝██║  ██║
    ██║ ╚████║ ╚████╔╝ ██████╔╝
  ╚═╝  ╚═══╝  ╚═══╝  ╚═════╝
            ]],
        },
      },

      lazygit = {
        enabled = true,
        configure = true,
      },
    },
    keys = {
      -- stylua: ignore start

      -- Pickers & Explorer
      { '<leader><space>', function() Snacks.picker.smart(ivy_split)  end, desc = 'Smart Find Files', },

      -- search
      { '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers" },
      { '<leader>s/', function() Snacks.picker.search_history() end, desc = "Search History" },
      { "<leader>sa", function() Snacks.picker.autocmds() end, desc = "Autocmds" },
      { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
      { "<leader>sc", function() Snacks.picker.command_history() end, desc = "Command History" },
      { "<leader>sC", function() Snacks.picker.commands() end, desc = "Commands" },
      { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
      { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
      { '<leader>sf', function() Snacks.picker.files { hidden = true, layout = { preset = 'ivy_split', layout = { position = 'bottom' } } } end, desc = '[S]earch [F]iles' },
      { "<leader>sh", function() Snacks.picker.help() end, desc = "Help Pages" },
      { '<leader>sg', function() Snacks.picker.grep { hidden = true, layout = { preset = 'ivy_split', layout = { position = 'bottom' } } } end, desc = '[S]earch by [G]rep' },
      { "<leader>sH", function() Snacks.picker.highlights() end, desc = "Highlights" },
      { "<leader>si", function() Snacks.picker.icons() end, desc = "Icons" },
      { "<leader>sj", function() Snacks.picker.jumps() end, desc = "Jumps" },
      { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
      { "<leader>sl", function() Snacks.picker.loclist() end, desc = "Location List" },
      { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
      { "<leader>sM", function() Snacks.picker.man() end, desc = "Man Pages" },
      { '<leader>sn', function() Snacks.picker.notifications() end, desc = 'Notification History' },
      { "<leader>sp", function() Snacks.picker.lazy() end, desc = "Search for Plugin Spec" },
      { "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
      { "<leader>sr", function() Snacks.picker.resume() end, desc = "Resume" },
      { "<leader>su", function() Snacks.picker.undo() end, desc = "Undo History" },
      { "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },

      -- git
      { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
      { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git Log" },
      { "<leader>gL", function() Snacks.picker.git_log_line() end, desc = "Git Log Line" },
      { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },
      { "<leader>gS", function() Snacks.picker.git_stash() end, desc = "Git Stash" },
      { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git Diff (Hunks)" },
      { "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git Log File" },
      -- stylua: ignore end
    },
  },
}
