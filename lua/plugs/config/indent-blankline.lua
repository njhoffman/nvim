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

local common = {
  bufname_exclude = { "README.md" },
  buftype_exclude = { "terminal", "prompt", "nofile" },
  filetype_exclude = {
    "help",
    "dashboard",
    "Trouble",
    "dap.*",
    "NeoTree",
    "NvimTree",
    "packer",
    "guihua",
    "sidekick",
  },
  context_patterns = {
    "class",
    "return",
    "function",
    "method",
    "^if",
    "if",
    "^while",
    "jsx_element",
    "^for",
    "for",
    "^object",
    "^table",
    "block",
    "arguments",
    "if_statement",
    "else_clause",
    "jsx_element",
    "jsx_self_closing_element",
    "try_statement",
    "catch_clause",
    "import_statement",
    "operation_type",
  },
  show_current_context = true,
  show_current_context_start = true,
  show_first_indent_level = false,
  max_indent_increase = 1,
  show_trailing_blankline_indent = false,
  use_treesitter = true,
  strict_tabs = true,
}

local blankline1 = {
  char = "",

  context_char = "│",
}

local blankline2 = {
  -- indent_blankline_char = { fg = "#0D0E19" },
  -- char = "▏",
  space_char = " ",
  space_char_blank_line = " ",
  char = " ",
  indent_soft_pattern = "\\s",
  char_list = { "", "┊", "┆", "¦", "|", "¦", "┆", "┊", "" },
  char_highlight_list = {
    "IndentBlanklineIndent1",
    "IndentBlanklineIndent2",
  },
  space_char_highlight_list = {
    "IndentBlanklineIndent1",
    "IndentBlanklineIndent2",
  },
}

vim.cmd([[
    highlight IndentBlanklineChar guifg=#102030 gui=none
    highlight IndentBlanklineContextChar guifg=#384858 gui=none
    highlight IndentBlanklineContextStart gui=none
    ]])
