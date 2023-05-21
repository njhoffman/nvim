-- stylua: ignore
local source_names          = {
  ['vim-dadbod-completion'] = 'sql',
  ['vimwiki-tags']          = 'vimwiki',
  calc                      = '󰃬 ',
  cmdline                   = ' ',
  cmdline_history           = ' ',
  cmp_git                   = ' ',
  cmp_rg                    = '󰉸 ',
  cmp_tabnine               = '󰘳 ',
  copilot                   = ' ',
  dictionary                = ' ',
  emoji                     = ' ',
  fuzzy_buffer              = ' ',
  fuzzy_path                = ' ',
  look                      = ' ',
  luasnip                   = ' ',
  npm                       = ' ',
  nvim_lsp                  = ' ',
  nvim_lsp_document_symbol  = ' ',
  nvim_lsp_signature_help   = '󰊕 ',
  nvim_lua                  = ' ',
  omni                      = ' ',
  spell                     = ' ',
  tmux                      = ' ',
  treesitter                = ' ',
}

  -- local statusline_hl = vim.api.nvim_get_hl_by_name("StatusLine", true)
  --         local cursorline_hl = vim.api.nvim_get_hl_by_name("CursorLine", true)
  --         local normal_hl = vim.api.nvim_get_hl_by_name("Normal", true)
  --         vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })
  --         vim.api.nvim_set_hl(0, "CmpItemKindTabnine", { fg = "#CA42F0" })
  --         vim.api.nvim_set_hl(0, "CmpItemKindCrate", { fg = "#F64D00" })
  --         vim.api.nvim_set_hl(0, "CmpItemKindEmoji", { fg = "#FDE030" })
  --         vim.api.nvim_set_hl(0, "SLCopilot", { fg = "#6CC644", bg = statusline_hl.background })
  --         vim.api.nvim_set_hl(0, "SLGitIcon", { fg = "#E8AB53", bg = cursorline_hl.background })
  --         vim.api.nvim_set_hl(0, "SLBranchName", { fg = normal_hl.foreground, bg = cursorline_hl.background })
  --         vim.api.nvim_set_hl(0, "SLSeparator", { fg = cursorline_hl.background, bg = statusline_hl.background })

--  local after_line = string.sub(line, cursor + 1, -1)
-- stylua: ignore
local lsp_symbols = {
  Boolean         = "◩ ",
  Class           = '󰌗 ', --   Class       = "󰠱 ",
  Color           = '󰏘 ',
  Comment         = " ",
  ConstantBuiltin = "󰏿 ",
  Conditional     = 'נּ ',
  Constant        = '󰞂 ', --   Constant    = "󰐀 ",
  Constructor     = ' ', --   Constructor = "⌘ ",
  Copilot         = ' ',
  Enum            = '󰕘 ', --   Enum        = " ",
  EnumMember      = ' ',
  Error           = ' ',
  Event           = ' ',
  Field           = '󰜢 ', --   Field       = "󰜢 ",
  File            = '󰈔 ', --   File        = "󰈙 ",
  Folder          = '󰉋 ',
  Function        = '󰊕 ',
  Interface       = '󰜰 ', --   Interface   = " ",
  Keyword         = '󰌋 ', --   Keyword     = "󰔌 ",
  KeywordOperator = ' ',
  KeywordFunction = ' ' , --   Keyword    = "󰔌 ",
  KeywordReturn   = ' ', --   Keyword     = "󰔌 ",
  Method          = '󰆧 ',
  Module          = '󰅩 ', --   Module      = "󰏓 ",
  Number          = "󰎠 ",
  Operator        = '󰃬 ', --   Operator    = "󰆕 ",
  Property        = '󰖷 ', --   Property    = "󰜢",
  Reference       = '󰈝 ', --   Reference   = "󰈇 ",
  Repeat          = ' ',
  Snippet         = ' ', --   Snippet     = "󰅱 ",
  String          = " ",
  Struct          = '󰟦 ', --   Struct      = "󰙅 ",
  Text            = ' ', --   Text        = " ",
  TypeParameter   = '󰊄 ',
  Unit            = ' ', --   Unit        = "󰑭 ",
  Value           = '󰎠 ',
  Variable        = ' ', --   Variable    = "󰈜 ",
}

local sources = {
  -- nvim_lua, vim-dadbod-completion, cmp_tabnine
  { name = 'nvim_lsp_signature_help', priority = 100 },
  { name = 'nvim_lsp', priority = 100, group_index = 1 },
  { name = 'fuzzy_path', priority = 10, group_index = 1, max_item_count = 5 },
  -- { name = "path", priority = 10, group_index = 1, max_item_count = 5 },
  -- { name = "fuzzy_buffer", priority = 1, group_index = 2, max_item_count = 3 },
  { name = 'calc', priority = 3 },
  { name = 'spell', priority = 3 },
  { name = 'git', priority = 3 },
  { name = 'pandoc_references', priority = 3 },
  { name = 'emoji', priority = 2 },
  { name = 'vimwiki-tags', priority = 1 },
  { name = 'omni', priority = 1 },
  { name = 'luasnip', priority = 1, group_index = 1 },
  { name = 'npm', keyword_length = 1 },
  { name = 'copilot', group_index = 2 },
  -- {
  --   name = "tmux",
  --   max_item_count = 5,
  --   keyword_length = 5,
  --   priority = 1,
  --   option = {
  --     all_panes = false,
  --     label = "tmux",
  --     -- trigger_characters = { "." },
  --     -- trigger_characters_ft = {markdown = {}}
  --   },
  -- },
}

return {
  definitions = sources,
  names = source_names,
  symbols = lsp_symbols,
}
