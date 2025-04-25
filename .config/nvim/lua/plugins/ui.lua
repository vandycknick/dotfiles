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
  -- file managing , picker etc
  {
    'nvim-tree/nvim-tree.lua',
    cmd = { 'NvimTreeToggle', 'NvimTreeFocus' },
    init = function()
      vim.api.nvim_set_keymap('n', '<C-n>', ':NvimTreeToggle<cr>', { silent = true, noremap = true })
    end,
    opts = {
      filters = {
        dotfiles = false,
        exclude = { vim.fn.stdpath 'config' .. '/lua/custom' },
      },
      disable_netrw = true,
      hijack_netrw = true,
      hijack_cursor = true,
      hijack_unnamed_buffer_when_opening = false,
      sync_root_with_cwd = true,
      update_focused_file = {
        enable = true,
        update_root = false,
      },
      view = {
        adaptive_size = false,
        side = 'left',
        width = 35,
        preserve_window_proportions = true,
      },
      git = {
        enable = false,
        ignore = true,
      },
      filesystem_watchers = {
        enable = true,
      },
      actions = {
        open_file = {
          resize_window = true,
        },
      },
      renderer = {
        root_folder_label = false,
        highlight_git = false,
        highlight_opened_files = 'none',

        indent_markers = {
          enable = true,
        },

        icons = {
          show = {
            file = true,
            folder = true,
            folder_arrow = true,
            git = false,
          },

          glyphs = {
            default = '󰈚',
            symlink = '',
            folder = {
              default = '',
              empty = '',
              empty_open = '',
              open = '',
              symlink = '',
              symlink_open = '',
              arrow_open = '',
              arrow_closed = '',
            },
            git = {
              unstaged = '✗',
              staged = '✓',
              unmerged = '',
              renamed = '➜',
              untracked = '★',
              deleted = '',
              ignored = '◌',
            },
          },
        },
      },
    },
  },

  -- Which Key
  {
    'folke/which-key.nvim',
    event = 'VimEnter',
    spec = {
      { '<leader>c', group = '[C]ode', mode = { 'n', 'x' } },
      { '<leader>d', group = '[D]ocument' },
      { '<leader>r', group = '[R]ename' },
      { '<leader>s', group = '[S]earch' },
      { '<leader>w', group = '[W]orkspace' },
      { '<leader>t', group = '[T]oggle' },
      { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
    },
  },

  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    opts = {
      cmdline = {
        enabled = true,
        view = 'cmdline_popup',
      },
    },
    -- INFO: Not using nvim-notify here, this makes noice fallback to mini. I prefer the mini style notifications, they are less intrusive.
    dependencies = {
      'MunifTanjim/nui.nvim',
    },
    keys = {
      {
        '<leader>nl',
        function()
          require('noice').cmd 'last'
        end,
        desc = 'shows the last message in a popup',
      },
      {
        '<leader>nh',
        function()
          require('noice').cmd 'history'
        end,
        desc = 'shows the message history',
      },
    },
  },

  -- Tabline
  {
    'nanozuki/tabby.nvim',
    event = 'VimEnter',
    dependencies = 'nvim-tree/nvim-web-devicons',
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
    version = '*',
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
    enabled = true,
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
    end,
    keys = {
      { '<leader>db', '<cmd>tabnew<cr><cmd>DBUI<cr>', desc = 'DBUI open' },
    },
  },
}
