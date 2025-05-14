-- IndentGuidesOdd
-- IndentGuidesEven
-- IndentBlanklineChar
-- IndentSpaceChar
-- IndentContextChar
-- IndentContextStart
-- IndentSpaceCharBlankline
-- vim.cmd([[highlight default IndentBlanklineIndent1 guifg=#E06C75 gui=nocombine]])
-- vim.cmd([[highlight default IndentBlanklineIndent2 guifg=#E5C07B gui=nocombine]])
-- vim.cmd([[highlight default IndentBlanklineIndent3 guifg=#98C379 gui=nocombine]])
-- vim.cmd([[highlight default IndentBlanklineIndent4 guifg=#56B6C2 gui=nocombine]])
-- vim.cmd([[highlight default IndentBlanklineIndent5 guifg=#61AFEF gui=nocombine]])
-- vim.cmd([[highlight default IndentBlanklineIndent6 guifg=#C678DD gui=nocombine]])

local ft_exclude = {
  "alpha",
  "dap.*",
  "dashboard",
  "guihua",
  "help",
  "lazy",
  "lspinfo",
  "mason",
  "navbuddy",
  "neo-tree",
  "noice",
  "null-ls-info",
  "qf",
  "sidekick",
  "NvimTree",
  "tablegen",
  "Trouble",
}
local bt_exclude = { "terminal", "prompt", "nofile", "quickfix", "markdown" }

-- require('indent_blankline').setup({
--   -- for example, context is off by default, use this to turn it on
--   char = '│',
--   buftype_exclude = bt_exclude,
--   filetype_exclude = ft_exclude,
--   show_trailing_blankline_indent = false,
--   show_current_context = false,
--   use_treesitter = false,
-- })

vim.g.indent_blankline_show_trailing_blankline_indent = false
vim.g.indent_blankline_use_treesitter = false
require("ibl").setup({
  debounce = 300,
  indent = { char = "│" },
  -- whitespace = { highlight = { 'Whitespace', 'NonText' } },
  scope = { enabled = false },
  exclude = { filetypes = ft_exclude, buftypes = bt_exclude },
})

-- rainbow-delimiters.nvim integration
-- local highlight = {
--     "RainbowRed",
--     "RainbowYellow",
--     "RainbowBlue",
--     "RainbowOrange",
--     "RainbowGreen",
--     "RainbowViolet",
--     "RainbowCyan",
-- }
-- local hooks = require "ibl.hooks"
-- -- create the highlight groups in the highlight setup hook, so they are reset
-- -- every time the colorscheme changes
-- hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
--     vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
--     vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
--     vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
--     vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
--     vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
--     vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
--     vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
-- end)
--
-- vim.g.rainbow_delimiters = { highlight = highlight }
-- require("ibl").setup { scope = { highlight = highlight } }
--
-- hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)

-- local common = {
--   bufname_exclude = { 'README.md' },
--   buftype_exclude = bt_exclude,
--   filetype_exclude = ft_exclude,
--   context_patterns = {
--     'class',
--     'return',
--     'function',
--     'method',
--     '^if',
--     'if',
--     '^while',
--     'jsx_element',
--     '^for',
--     'for',
--     '^object',
--     '^table',
--     'block',
--     'arguments',
--     'if_statement',
--     'else_clause',
--     'jsx_element',
--     'jsx_self_closing_element',
--     'try_statement',
--     'catch_clause',
--     'import_statement',
--     'operation_type',
--   },
--   show_current_context = true,
--   show_current_context_start = true,
--   show_first_indent_level = false,
--   max_indent_increase = 1,
--   show_trailing_blankline_indent = false,
--   use_treesitter = true,
--   strict_tabs = true,
-- }
--
-- local blankline1 = {
--   char = '',
--
--   context_char = '│',
-- }
--
-- local blankline2 = {
--   -- indent_blankline_char = { fg = "#0D0E19" },
--   -- char = "▏",
--   space_char = ' ',
--   space_char_blank_line = ' ',
--   char = ' ',
--   indent_soft_pattern = '\\s',
--   char_list = { '', '┊', '┆', '¦', '|', '¦', '┆', '┊', '' },
--   char_highlight_list = {
--     'IndentBlanklineIndent1',
--     'IndentBlanklineIndent2',
--   },
--   space_char_highlight_list = {
--     'IndentBlanklineIndent1',
--     'IndentBlanklineIndent2',
--   },
-- }
--
-- -- vim.cmd([[
-- --     highlight IndentBlanklineChar guifg=#102030 gui=none
-- --     highlight IndentBlanklineContextChar guifg=#384858 gui=none
-- --     highlight IndentBlanklineContextStart gui=none
-- --     ]])
