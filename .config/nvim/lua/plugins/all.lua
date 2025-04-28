return {
  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        'nvim-telescope/telescope-fzf-native.nvim',

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = 'make',

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },

      -- Useful for getting pretty icons, but requires a Nerd Font.
      { 'nvim-tree/nvim-web-devicons', enabled = true },
    },
    config = function()
      require('telescope').setup {
        pickers = {
          find_files = {
            find_command = { 'rg', '--files', '--hidden', '--glob', '!**/.git/*' },
          },
        },
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      -- See `:help telescope.builtin`
      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      -- vim.keymap.set('n', '<leader>sf', function()
      --   Snacks.picker.files()
      -- end, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      -- vim.keymap.set('n', '<leader>sg', Snacks.picker.grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sc', builtin.resume, { desc = '[S]earch [C]ontinue ' })
      vim.keymap.set('n', '<leader>sr', builtin.registers, { desc = '[S]earch [R]egisters' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      -- vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

      -- It's also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })
    end,
  },

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
      -- Pickers & Explorer
      {
        '<leader><space>',
        function()
          Snacks.picker.smart { layout = { preset = 'ivy_split', layout = { position = 'bottom' } } }
        end,
        desc = 'Smart Find Files',
      },

      -- search
      {
        '<leader>s"',
        function()
          Snacks.picker.registers()
        end,
        desc = 'Registers',
      },
      {
        '<leader>sf',
        function()
          Snacks.picker.files { hidden = true, layout = { preset = 'ivy_split', layout = { position = 'bottom' } } }
        end,
        desc = '[S]earch [F]iles',
      },
      {
        '<leader>sg',
        function()
          Snacks.picker.grep { hidden = true, layout = { preset = 'ivy_split', layout = { position = 'bottom' } } }
        end,
        desc = '[S]earch by [G]rep',
      },
      {
        '<leader>sn',
        function()
          Snacks.picker.notifications()
        end,
        desc = 'Notification History',
      },

      {
        '<leader>gb',
        function()
          Snacks.picker.git_branches { layout = 'default' }
        end,
        desc = 'Git Branches',
      },
      {
        '<leader>gl',
        function()
          Snacks.picker.git_log()
        end,
        desc = 'Git Log',
      },
      {
        '<leader>gf',
        function()
          Snacks.lazygit.log_file()
        end,
        desc = 'Lazygit Current File History',
      },
      {
        '<leader>gg',
        function()
          Snacks.lazygit()
        end,
        desc = 'Lazygit',
      },
      {
        '<leader>gl',
        function()
          Snacks.lazygit.log()
        end,
        desc = 'Lazygit Log (cwd)',
      },
    },
  },
}
