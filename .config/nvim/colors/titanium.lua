-- Titanium, from omp's bundled theme (packages/tui/src/theme/defaults/titanium.json
-- in can1357/oh-my-pi). The editor background stays the terminal's.
vim.cmd.highlight 'clear'
vim.g.colors_name = 'titanium'
vim.o.background = 'dark'

local c = {
  dark = '#0f1216', -- darkTitanium
  brushed = '#151820', -- brushedTitanium
  line = '#1f252d', -- borderMuted
  gray = '#2a3038', -- subtleGray
  comment = '#6b7280',
  muted = '#9ca3b0', -- dimAluminum
  fg = '#e8ecf4', -- brightAluminum
  blue = '#00b4ff', -- electricBlue
  deep = '#0082b3', -- deepBlue
  green = '#00ff88', -- readoutGreen
  gold = '#d4c090', -- titaniumGold
  amber = '#ffb347', -- warningAmber
  red = '#ff4757', -- alertRed
}

---@type table<string, vim.api.keyset.highlight>
local groups = {
  -- Editor
  Normal = { fg = c.fg },
  NormalNC = { link = 'Normal' },
  NormalFloat = { fg = c.fg, bg = c.dark },
  FloatBorder = { fg = c.gray, bg = c.dark },
  FloatTitle = { fg = c.blue, bg = c.dark, bold = true },
  Cursor = { fg = c.dark, bg = c.fg },
  CursorLine = { bg = c.line },
  CursorColumn = { link = 'CursorLine' },
  ColorColumn = { bg = c.line },
  CursorLineNr = { fg = c.blue, bold = true },
  LineNr = { fg = c.comment },
  SignColumn = {},
  FoldColumn = { fg = c.comment },
  Folded = { fg = c.muted, bg = c.line },
  Visual = { bg = c.gray },
  Search = { fg = c.dark, bg = c.gold },
  IncSearch = { fg = c.dark, bg = c.amber },
  CurSearch = { link = 'IncSearch' },
  Substitute = { fg = c.dark, bg = c.red },
  MatchParen = { fg = c.amber, bold = true },
  NonText = { fg = c.gray },
  Whitespace = { fg = c.gray },
  SpecialKey = { fg = c.gray },
  EndOfBuffer = { fg = c.brushed },
  WinSeparator = { fg = c.gray },
  StatusLine = { fg = c.fg, bg = c.brushed },
  StatusLineNC = { fg = c.comment, bg = c.brushed },
  TabLine = { fg = c.muted, bg = c.brushed },
  TabLineFill = { bg = c.dark },
  TabLineSel = { fg = c.dark, bg = c.blue, bold = true },
  WinBar = { fg = c.muted },
  WinBarNC = { fg = c.comment },
  Pmenu = { fg = c.fg, bg = c.dark },
  PmenuSel = { bg = c.gray, bold = true },
  PmenuSbar = { bg = c.line },
  PmenuThumb = { bg = c.gray },
  PmenuMatch = { fg = c.blue, bold = true },
  Title = { fg = c.blue, bold = true },
  Directory = { fg = c.blue },
  Question = { fg = c.green },
  MoreMsg = { fg = c.green },
  ModeMsg = { fg = c.muted },
  ErrorMsg = { fg = c.red },
  WarningMsg = { fg = c.amber },
  QuickFixLine = { bg = c.gray },
  SpellBad = { sp = c.red, undercurl = true },
  SpellCap = { sp = c.amber, undercurl = true },
  SpellLocal = { sp = c.blue, undercurl = true },
  SpellRare = { sp = c.muted, undercurl = true },

  -- Syntax, as omp colours code: keywords/types/operators blue, functions
  -- green, strings gold, numbers amber.
  Comment = { fg = c.comment, italic = true },
  Constant = { fg = c.amber },
  String = { fg = c.gold },
  Character = { link = 'String' },
  Number = { fg = c.amber },
  Boolean = { link = 'Number' },
  Float = { link = 'Number' },
  Identifier = { fg = c.fg },
  Function = { fg = c.green },
  Statement = { fg = c.blue },
  Keyword = { fg = c.blue },
  Operator = { fg = c.blue },
  PreProc = { fg = c.blue },
  Type = { fg = c.blue },
  Special = { fg = c.deep },
  Delimiter = { fg = c.muted },
  Tag = { fg = c.blue },
  Underlined = { underline = true },
  Todo = { fg = c.dark, bg = c.amber, bold = true },
  Error = { fg = c.red },

  -- Treesitter
  ['@variable'] = { fg = c.fg },
  ['@variable.builtin'] = { fg = c.blue, italic = true },
  ['@variable.parameter'] = { fg = c.fg, italic = true },
  ['@variable.member'] = { fg = c.muted },
  ['@property'] = { fg = c.muted },
  ['@constant'] = { fg = c.amber },
  ['@constant.builtin'] = { fg = c.amber },
  ['@module'] = { fg = c.fg },
  ['@string.escape'] = { fg = c.amber },
  ['@string.special.url'] = { fg = c.deep, underline = true },
  ['@type.builtin'] = { fg = c.blue, italic = true },
  ['@constructor'] = { fg = c.blue },
  ['@punctuation'] = { fg = c.muted },
  ['@tag.attribute'] = { fg = c.muted },
  ['@tag.delimiter'] = { fg = c.muted },
  ['@markup.heading'] = { fg = c.blue, bold = true },
  ['@markup.strong'] = { bold = true },
  ['@markup.italic'] = { italic = true },
  ['@markup.strikethrough'] = { strikethrough = true },
  ['@markup.link'] = { fg = c.blue },
  ['@markup.link.url'] = { fg = c.deep, underline = true },
  ['@markup.raw'] = { fg = c.green },
  ['@markup.quote'] = { fg = c.muted, italic = true },
  ['@markup.list'] = { fg = c.blue },
  ['@diff.plus'] = { fg = c.green },
  ['@diff.minus'] = { fg = c.red },
  ['@diff.delta'] = { fg = c.amber },
  ['@lsp.type.parameter'] = { link = '@variable.parameter' },
  ['@lsp.type.property'] = { link = '@property' },

  -- Diagnostics and LSP
  DiagnosticError = { fg = c.red },
  DiagnosticWarn = { fg = c.amber },
  DiagnosticInfo = { fg = c.blue },
  DiagnosticHint = { fg = c.muted },
  DiagnosticOk = { fg = c.green },
  DiagnosticUnderlineError = { sp = c.red, undercurl = true },
  DiagnosticUnderlineWarn = { sp = c.amber, undercurl = true },
  DiagnosticUnderlineInfo = { sp = c.blue, undercurl = true },
  DiagnosticUnderlineHint = { sp = c.muted, undercurl = true },
  DiagnosticVirtualTextError = { fg = c.red, bg = c.dark },
  DiagnosticVirtualTextWarn = { fg = c.amber, bg = c.dark },
  DiagnosticVirtualTextInfo = { fg = c.blue, bg = c.dark },
  DiagnosticVirtualTextHint = { fg = c.muted, bg = c.dark },
  LspReferenceText = { bg = c.gray },
  LspReferenceRead = { bg = c.gray },
  LspReferenceWrite = { bg = c.gray, underline = true },
  LspInlayHint = { fg = c.comment, italic = true },
  LspSignatureActiveParameter = { fg = c.amber, bold = true },

  -- Diffs and Git
  DiffAdd = { bg = '#12301f' },
  DiffChange = { bg = '#1a2533' },
  DiffDelete = { fg = c.red, bg = '#2e1418' },
  DiffText = { bg = '#1f3a52' },
  Added = { fg = c.green },
  Changed = { fg = c.amber },
  Removed = { fg = c.red },
  GitSignsAdd = { fg = c.green },
  GitSignsChange = { fg = c.amber },
  GitSignsDelete = { fg = c.red },

  -- Plugins
  MiniStatuslineModeNormal = { fg = c.dark, bg = c.blue, bold = true },
  MiniStatuslineModeInsert = { fg = c.dark, bg = c.green, bold = true },
  MiniStatuslineModeVisual = { fg = c.dark, bg = c.gold, bold = true },
  MiniStatuslineModeReplace = { fg = c.dark, bg = c.red, bold = true },
  MiniStatuslineModeCommand = { fg = c.dark, bg = c.amber, bold = true },
  MiniStatuslineModeOther = { fg = c.dark, bg = c.muted, bold = true },
  MiniStatuslineDevinfo = { fg = c.fg, bg = c.gray },
  MiniStatuslineFilename = { fg = c.muted, bg = c.brushed },
  MiniStatuslineFileinfo = { fg = c.fg, bg = c.gray },
  MiniStatuslineInactive = { fg = c.comment, bg = c.brushed },
  MiniHipatternsTodo = { fg = c.dark, bg = c.blue, bold = true },
  MiniHipatternsFixme = { fg = c.dark, bg = c.red, bold = true },
  MiniHipatternsHack = { fg = c.dark, bg = c.amber, bold = true },
  MiniHipatternsNote = { fg = c.dark, bg = c.green, bold = true },
  MiniIconsAzure = { fg = c.blue },
  MiniIconsBlue = { fg = c.deep },
  MiniIconsCyan = { fg = c.blue },
  MiniIconsGreen = { fg = c.green },
  MiniIconsGrey = { fg = c.muted },
  MiniIconsOrange = { fg = c.amber },
  MiniIconsPurple = { fg = c.muted },
  MiniIconsRed = { fg = c.red },
  MiniIconsYellow = { fg = c.gold },
  SnacksPickerMatch = { fg = c.blue, bold = true },
  SnacksDashboardHeader = { fg = c.blue },
  BlinkCmpLabelMatch = { fg = c.blue, bold = true },
}

for name, spec in pairs(groups) do
  vim.api.nvim_set_hl(0, name, spec)
end

-- The terminal's 16 colours inside :terminal.
for i, color in ipairs {
  c.dark,
  c.red,
  c.green,
  c.gold,
  c.deep,
  c.muted,
  c.blue,
  c.fg,
  c.gray,
  c.red,
  c.green,
  c.amber,
  c.blue,
  c.muted,
  c.blue,
  c.fg,
} do
  vim.g['terminal_color_' .. (i - 1)] = color
end
