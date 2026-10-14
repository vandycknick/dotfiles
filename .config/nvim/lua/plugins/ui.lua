local theme = {
  fill = 'TabLineFill', -- tabline background
  head = 'TabLine', -- head element highlight
  current_tab = 'TabLineSel', -- current tab label highlight
  tab = 'TabLine', -- other tab label highlight
  win = 'TabLine', -- window highlight
  tail = 'TabLine', -- tail element highlight
}

local check_macro_recording = function()
  if vim.fn.reg_recording() ~= '' then
    return 'Recording @' .. vim.fn.reg_recording()
  else
    return ''
  end
end

return {
  -- Icons for everything, including plugins that ask for nvim-web-devicons.
  {
    'nvim-mini/mini.icons',
    lazy = true,
    opts = {},
    init = function()
      package.preload['nvim-web-devicons'] = function()
        require('mini.icons').mock_nvim_web_devicons()
        return package.loaded['nvim-web-devicons']
      end
    end,
  },

  {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
      keymaps = {
        ['q'] = { 'actions.close', mode = 'n' },
      },
      view_options = {
        -- Show files and directories that start with "."
        show_hidden = true,
      },
    },
    dependencies = { 'nvim-mini/mini.icons' },
    -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
    lazy = false,
    keys = {
      { '<C-n>', '<CMD>Oil<CR>', desc = 'Open parent directory' },
    },
  },

  { 'shortcuts/no-neck-pain.nvim' },

  -- Which Key
  {
    'folke/which-key.nvim',
    event = 'VimEnter',
    opts = {
      spec = {
        { '<leader>c', group = '[C]ode', mode = { 'n', 'x' } },
        { '<leader>d', group = '[D]iff and [D]atabase' },
        { '<leader>g', group = '[G]it' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
        { '<leader>m', group = '[M]arkdown' },
        { '<leader>r', group = '[R]ename' },
        { '<leader>s', group = '[S]earch' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>u', group = '[U]I' },
      },
    },
  },

  -- Tabline
  {
    'nanozuki/tabby.nvim',
    event = 'VimEnter',
    dependencies = 'nvim-mini/mini.icons',
    opts = {
      line = function(line)
        return {
          {
            { '  ', hl = theme.head },
            line.sep('', theme.head, theme.fill),
          },
          line.tabs().foreach(function(tab)
            local hl = tab.is_current() and theme.current_tab or theme.tab
            return {
              line.sep('', hl, theme.fill),
              tab.is_current() and '' or '󰆣',
              tab.number(),
              tab.name(),
              tab.close_btn '',
              line.sep('', hl, theme.fill),
              hl = hl,
              margin = ' ',
            }
          end),
          line.spacer(),
          -- NOTE: I don't need this, but leaving it as it is a nice example
          -- line.wins_in_tab(line.api.get_current_tab()).foreach(function(win)
          --   return {
          --     line.sep('', theme.win, theme.fill),
          --     win.is_current() and '' or '',
          --     win.buf_name(),
          --     line.sep('', theme.win, theme.fill),
          --     hl = theme.win,
          --     margin = ' ',
          --   }
          -- end),
          {
            line.sep('', theme.tail, theme.fill),
            { '  ', hl = theme.tail },
          },
          hl = theme.fill,
        }
      end,
      option = {
        theme = theme,
        nerdfont = true,
        lualine_theme = nil,
        buf_name = {
          mode = 'unique', -- or 'relative', 'tail', 'shorten'
        },
      },
    },
  },

  -- Statusline
  {
    'echasnovski/mini.statusline',
    config = function()
      local statusline = require 'mini.statusline'
      statusline.setup {
        use_icons = true,
        content = {
          -- Default active content: https://github.com/echasnovski/mini.nvim/blob/a8185957febe7dae31556dbd7326cfa597b812f1/lua/mini/statusline.lua#L606
          active = function()
            local mode, mode_hl = statusline.section_mode { trunc_width = 120 }
            local git = statusline.section_git { trunc_width = 40 }
            local diff = statusline.section_diff { trunc_width = 75 }
            local diagnostics = statusline.section_diagnostics { trunc_width = 75 }
            local lsp = statusline.section_lsp { trunc_width = 75 }
            local filename = statusline.section_filename { trunc_width = 140 }
            local fileinfo = statusline.section_fileinfo { trunc_width = 120 }
            local location = statusline.section_location()
            local search = statusline.section_searchcount { trunc_width = 75 }
            local macro = check_macro_recording()

            return statusline.combine_groups {
              { hl = mode_hl, strings = { mode } },
              { hl = 'MiniStatuslineDevinfo', strings = { git, diff, diagnostics, lsp } },
              '%<', -- Mark general truncate point
              { hl = 'MiniStatuslineFilename', strings = { filename } },
              '%=', -- End left alignment
              { hl = 'MiniStatuslineFilename', strings = { macro } },
              { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
              { hl = mode_hl, strings = { search, location } },
            }
          end,
        },
      }

      -- You can configure sections in the statusline by overriding their
      -- default behavior. For example, here we set the section for
      -- cursor location to LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end
    end,
  },

  -- Diffview
  {
    'sindrets/diffview.nvim',
    event = 'VeryLazy',
    keys = {
      { '<leader>do', '<cmd>DiffviewOpen<cr>', desc = 'Diffview open' },
      { '<leader>dc', '<cmd>DiffviewClose<cr>', desc = 'Diffview close' },
      { '<leader>dh', '<cmd>DiffviewFileHistory %<cr>', desc = 'Diffview file history current file.' },
      { '<leader>dh', [[:'<,'>DiffviewFileHistory<cr>]], desc = 'Diffview file history current selection.', mode = 'v' },
    },
  },

  {
    'tpope/vim-fugitive',
    cmd = { 'G' },
  },

  -- SQL editor integration
  {
    'kristijanhusak/vim-dadbod-ui',
    dependencies = {
      { 'tpope/vim-dadbod', lazy = true },
      { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true }, -- Optional
    },
    cmd = {
      'DBUI',
      'DBUIToggle',
      'DBUIAddConnection',
      'DBUIFindBuffer',
    },
    init = function()
      -- Your DBUI configuration
      vim.g.db_ui_use_nerd_fonts = 1

      vim.g.db_adapter_bigquery_region = 'region-europe-west1'

      vim.g.dbs = {
        ['Conveo BigQuery'] = 'bigquery:?project_id=conveo-data',
      }
    end,
    keys = {
      { '<leader>db', '<cmd>tabnew<cr><cmd>DBUI<cr>', desc = 'DBUI open' },
    },
  },

  {
    'sphamba/smear-cursor.nvim',
    opts = {
      smear_between_buffers = false,
      stiffness = 0.5,
      trailing_stiffness = 0.49,
      -- JetBrains Mono Nerd Font lacks the U+1FB8x "Legacy Computing" blocks; Tern draws them as "?"
      legacy_computing_symbols_support = false,
    },
  },
}
