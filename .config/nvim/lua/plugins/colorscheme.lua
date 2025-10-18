return {
  {
    'rebelot/kanagawa.nvim',
    lazy = false,
    priority = 1000, -- Ensure it loads first
    opts = {
      compile = false,
      theme = 'wave',
      undercurl = true,
      terminalColors = true,
      transparent = true,
      colors = {
        theme = {
          all = {
            ui = {
              bg_gutter = 'none',
            },
          },
        },
      },
      overrides = function(colors)
        local theme = colors.theme
        local makeDiagnosticColor = function(color)
          local c = require 'kanagawa.lib.color'
          return { fg = color, bg = c(color):blend(theme.ui.bg, 0.95):to_hex() }
        end
        return {
          NormalFloat = { bg = theme.ui.bg_dim },
          FloatBorder = { bg = theme.ui.bg_dim },
          -- Save an hlgroup with dark background and dimmed foreground
          -- so that you can use it where your still want darker windows.
          -- E.g.: autocmd TermOpen * setlocal winhighlight=Normal:NormalDark
          NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },

          -- Popular plugins that open floats will link to NormalFloat by default;
          -- set their background accordingly if you wish to keep them dark and borderless
          LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
          MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },

          NoiceCmdlinePopup = { bg = theme.ui.bg_dim },

          TabLine = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
          TabLineFill = { bg = theme.ui.bg_m1 },

          Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 },
          PmenuSel = { fg = 'NONE', bg = theme.ui.bg_p2 },
          PmenuSbar = { bg = theme.ui.bg_m1 },
          PmenuThumb = { bg = theme.ui.bg_p2 },

          DiagnosticVirtualTextHint = makeDiagnosticColor(theme.diag.hint),
          DiagnosticVirtualTextInfo = makeDiagnosticColor(theme.diag.info),
          DiagnosticVirtualTextWarn = makeDiagnosticColor(theme.diag.warning),
          DiagnosticVirtualTextError = makeDiagnosticColor(theme.diag.error),
        }
      end,
    },
    config = function(_, opts)
      require('kanagawa').setup(opts)
      -- Load the colorscheme here
      vim.cmd.colorscheme 'kanagawa'
    end,
  },
}
