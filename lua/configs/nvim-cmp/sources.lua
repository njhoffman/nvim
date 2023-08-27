-- stylua: ignore
local setup_highlights = function()
  vim.api.nvim_set_hl(0, 'CmpSource',                      { default = true, link = 'Keyword' })
  vim.api.nvim_set_hl(0, 'CmpSourceCalc',                  { default = true, link = 'CmpSource' })
  vim.api.nvim_set_hl(0, 'CmpSourceDadbod',                { default = true, link = 'CmpSource' })
  vim.api.nvim_set_hl(0, 'CmpSourceVimWiki',               { default = true, link = 'CmpSource' })
  vim.api.nvim_set_hl(0, 'CmpSourceCmdline',               { default = true, link = 'CmpSource' })
  vim.api.nvim_set_hl(0, 'CmpSourceCmdlineHistory',        { default = true, link = 'CmpSource' })
  vim.api.nvim_set_hl(0, 'CmpSourceCmpGit',                { default = true, link = 'CmpSource' })
  vim.api.nvim_set_hl(0, 'CmpSourceCmpRg',                 { default = true, link = 'CmpSource' })
  vim.api.nvim_set_hl(0, 'CmpSourceCmpTabnine',            { default = true, link = 'CmpSource' })
  vim.api.nvim_set_hl(0, 'CmpSourceCopilot',               { default = true, link = 'CmpSource' })
  vim.api.nvim_set_hl(0, 'CmpSourceDictionary',            { default = true, link = 'CmpSource' })
  vim.api.nvim_set_hl(0, 'CmpSourceEmoji',                 { default = true, link = 'CmpSource' })
  vim.api.nvim_set_hl(0, 'CmpSourcePath',                  { default = true, link = 'CmpSource' })
  vim.api.nvim_set_hl(0, 'CmpSourceFuzzyBuffer',           { default = true, link = 'CmpSource' })
  vim.api.nvim_set_hl(0, 'CmpSourceFuzzyPath',             { default = true, link = 'CmpSource' })
  vim.api.nvim_set_hl(0, 'CmpSourceLook',                  { default = true, link = 'CmpSource' })
  vim.api.nvim_set_hl(0, 'CmpSourceLuasnip',               { default = true, link = 'CmpSource' })
  vim.api.nvim_set_hl(0, 'CmpSourceNpm',                   { default = true, link = 'CmpSource' })
  vim.api.nvim_set_hl(0, 'CmpSourceNvimLsp',               { default = true, link = 'CmpSource' })
  vim.api.nvim_set_hl(0, 'CmpSourceNvimLspDocumentSymbol', { default = true, link = 'CmpSource' })
  vim.api.nvim_set_hl(0, 'CmpSourceNvimLspSignatureHelp',  { default = true, link = 'CmpSource' })
  vim.api.nvim_set_hl(0, 'CmpSourceNvimLua',               { default = true, link = 'CmpSource' })
  vim.api.nvim_set_hl(0, 'CmpSourceOmni',                  { default = true, link = 'CmpSource' })
  vim.api.nvim_set_hl(0, 'CmpSourceSpell',                 { default = true, link = 'CmpSource' })
  vim.api.nvim_set_hl(0, 'CmpSourceTmux',                  { default = true, link = 'CmpSource' })
  vim.api.nvim_set_hl(0, 'CmpSourceTreesitter',            { default = true, link = 'CmpSource' })
end

setup_highlights()

-- vim.api.nvim_set_hl(0, "CmpSourceCopilot", {fg ="#6CC644"})


          -- buffer = ' ﬘',
          -- nvim_lsp = ' ',
          -- luasnip = ' 🐍',
          -- treesitter = ' ',
          -- nvim_lua = ' ',
          -- spell = ' 暈',
          -- emoji = 'ﲃ',
          -- -- copilot = "🤖",
          -- cmp_tabnine = '🤖',
          -- look = '﬜',
-- stylua: ignore
local source_names = {
  calc =                      { '󰃬', 'CmpSourceCalc' },
  cmdline =                   { '', 'CmpSourceCmdline' },
  cmdline_history =           { '', 'CmpSourceCmdlineHistory' },
  cmp_git =                   { '', 'CmpSourceCmpGit' },
  cmp_rg =                    { '󰉸', 'CmpSourceCmpRg' },
  cmp_tabnine =               { '󰘳', 'CmpSourceCmpTabnine' },
  copilot =                   { '', 'CmpSourceCopilot' }, -- 
  dictionary =                { '', 'CmpSourceDictionary' },
  emoji =                     { '', 'CmpSourceEmoji' },
  fuzzy_buffer =              { '', 'CmpSourceFuzzyBuffer' },
  fuzzy_path =                { '', 'CmpSourceFuzzyPath' },
  look =                      { '', 'CmpSourceLook' },
  luasnip =                   { '', 'CmpSourceLuasnip' },
  npm =                       { '', 'CmpSourceNpm' },
  nvim_lsp =                  { '', 'CmpSourceNvimLsp' },
  nvim_lsp_document_symbol =  { '', 'CmpSourceNvimLspDocumentSymbol' },
  nvim_lsp_signature_help =   { '󰊕', 'CmpSourceNvimLspSignatureHelp' },
  nvim_lua =                  { '', 'CmpSourceNvimLua' },
  omni =                      { '', 'CmpSourceOmni' },
  path =                      { '', 'CmpSourcePath' },
  spell =                     { '', 'CmpSourceSpell' },
  tmux =                      { '', 'CmpSourceTmux' },
  treesitter =                { '', 'CmpSourceTreesitter' },
  ['vim-dadbod-completion'] = { '', 'CmpSourceDadbod' },
  ['vimwiki-tags'] =          { '', 'CmpSourceVimWiki' },
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
  Boolean         = "◩",
  Class           = '󰌗', --   Class       = "󰠱 ",
  Color           = '󰏘',
  Comment         = "",
  ConstantBuiltin = "󰏿",
  Conditional     = 'נּ',
  Constant        = '󰞂', --   Constant    = "󰐀 ",
  Constructor     = '', --   Constructor = "⌘ ",
  Copilot         = '',
  Enum            = '󰕘', --   Enum        = " ",
  EnumMember      = '',
  Error           = '',
  Event           = '',
  Field           = '󰜢', --   Field       = "󰜢 ",
  File            = '󰈔', --   File        = "󰈙 ",
  Folder          = '󰉋',
  Function        = '󰊕',
  FunctionCall    = '󰊕',
  Interface       = '󰜰', --   Interface   = " ",
  Keyword         = '󰌋', --   Keyword     = "󰔌 ",
  KeywordOperator = '',
  KeywordFunction = '' , --   Keyword    = "󰔌 ",
  KeywordReturn   = '', --   Keyword     = "󰔌 ",
  Label           = '󰜢',
  Method          = '󰆧',
  Module          = '󰅩', --   Module      = "󰏓 ",
  None            = 'ﳠ',
  Namespace       = "󰌗",
  Number          = "󰎠",
  Operator        = '󰃬', --   Operator    = "󰆕 ",
  Parameter       = ' ',
  Preproc         = '', --   Property    = "󰜢",
  Property        = '󰖷', --   Property    = "󰜢",
  Reference       = '󰈝', --   Reference   = "󰈇 ",
  Repeat          = '',
  Snippet         = '', --   Snippet     = "󰅱 ",
  Spell           = "",
  String          = "",
  StringRegex     = "縷",
  Struct          = '󰟦', --   Struct      = "󰙅 ",
  Text            = '', --   Text        = " ",
  TextReference   = '󰈇', --   Text        = " ",
  TextLiteral     = '', --   Text        = " ",
  TextLiteralBlock = '󰅪', --   Text        = " ",
  TextUri         = '', --   Text        = " ",
  TextQuote       = '', --   Text        = " ",
  TextTitle1      = '', --   Text        = " ",
  TextTitle2      = '', --   Text        = " ",
  TextTitle3      = '', --   Text        = " ",
  TextTitle4      = '', --   Text        = " ",
  TextTitle5      = '', --   Text        = " ",
  TextTitle6      = '', --   Text        = " ",
  Type            = '󰊄',
  TypeParameter   = '󰊄',
  Unit            = '', --   Unit        = "󰑭 ",
  Value           = '󰎠',
  Variable        = '', --   Variable    = "󰈜 ",
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
