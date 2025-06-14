
-- AI calc cmdline cmdline_history cmp_yanky codeium copilot
-- diag-codes dictionary emoji fuzzy_buffer fuzzy_path fzf-lua
-- git lazydev luasnip nerdfont npm
-- nvim_lsp_document_symbol nvim_lsp_signature_help nvim_lua
-- pandoc_references plugins render-markdown rg spell tags
-- tmux treesitter vimwiki-tags zsh

-- stylua: ignore
local setup_highlights = function()
  vim.api.nvim_set_hl(0, 'CmpSource',                      { default = true, link = 'Keyword' })
  vim.api.nvim_set_hl(0, 'CmpSourceAsyncPath',             { default = true, link = 'CmpSource' })
  vim.api.nvim_set_hl(0, 'CmpSourceCalc',                  { default = true, link = 'CmpSource' })
  vim.api.nvim_set_hl(0, 'CmpSourceCmdline',               { default = true, link = 'CmpSource' })
  vim.api.nvim_set_hl(0, 'CmpSourceCmdlineHistory',        { default = true, link = 'CmpSource' })
  vim.api.nvim_set_hl(0, 'CmpSourceCodeium',               { default = true, link = 'CmpSource' })
  vim.api.nvim_set_hl(0, 'CmpSourceCopilot',               { default = true, link = 'CmpSource' })
  vim.api.nvim_set_hl(0, 'CmpSourceDadbod',                { default = true, link = 'CmpSource' })
  vim.api.nvim_set_hl(0, 'CmpSourceDiagCodes',             { default = true, link = 'CmpSource' })
  vim.api.nvim_set_hl(0, 'CmpSourceDictionary',            { default = true, link = 'CmpSource' })
  vim.api.nvim_set_hl(0, 'CmpSourceEmoji',                 { default = true, link = 'CmpSource' })
  vim.api.nvim_set_hl(0, 'CmpSourceFuzzyBuffer',           { default = true, link = 'CmpSource' })
  vim.api.nvim_set_hl(0, 'CmpSourceFuzzyPath',             { default = true, link = 'CmpSource' })
  vim.api.nvim_set_hl(0, 'CmpSourceFzfLua',                { default = true, link = 'CmpSource' })
  vim.api.nvim_set_hl(0, 'CmpSourceGit',                   { default = true, link = 'CmpSource' })
  vim.api.nvim_set_hl(0, 'CmpSourceLazyDev',               { default = true, link = 'CmpSource' })
  vim.api.nvim_set_hl(0, 'CmpSourceLook',                  { default = true, link = 'CmpSource' })
  vim.api.nvim_set_hl(0, 'CmpSourceLuasnip',               { default = true, link = 'CmpSource' })
  vim.api.nvim_set_hl(0, 'CmpSourceNerdfont',              { default = true, link = 'CmpSource' })
  vim.api.nvim_set_hl(0, 'CmpSourceNpm',                   { default = true, link = 'CmpSource' })
  vim.api.nvim_set_hl(0, 'CmpSourceNvimLsp',               { default = true, link = 'CmpSource' })
  vim.api.nvim_set_hl(0, 'CmpSourceNvimLspDocumentSymbol', { default = true, link = 'CmpSource' })
  vim.api.nvim_set_hl(0, 'CmpSourceNvimLspSignatureHelp',  { default = true, link = 'CmpSource' })
  vim.api.nvim_set_hl(0, 'CmpSourceNvimLua',               { default = true, link = 'CmpSource' })
  vim.api.nvim_set_hl(0, 'CmpSourceOmni',                  { default = true, link = 'CmpSource' })
  vim.api.nvim_set_hl(0, 'CmpSourcePath',                  { default = true, link = 'CmpSource' })
  vim.api.nvim_set_hl(0, 'CmpSourcePlugin',                { default = true, link = 'CmpSource' })
  vim.api.nvim_set_hl(0, 'CmpSourceQuickData',             { default = true, link = 'CmpSource' })
  vim.api.nvim_set_hl(0, 'CmpSourceRenderMarkdown',        { default = true, link = 'CmpSource' })
  vim.api.nvim_set_hl(0, 'CmpSourceRg',                    { default = true, link = 'CmpSource' })
  vim.api.nvim_set_hl(0, 'CmpSourceSpell',                 { default = true, link = 'CmpSource' })
  vim.api.nvim_set_hl(0, 'CmpSourceTabnine',               { default = true, link = 'CmpSource' })
  vim.api.nvim_set_hl(0, 'CmpSourceTags',                  { default = true, link = 'CmpSource' })
  vim.api.nvim_set_hl(0, 'CmpSourceTmux',                  { default = true, link = 'CmpSource' })
  vim.api.nvim_set_hl(0, 'CmpSourceTreesitter',            { default = true, link = 'CmpSource' })
  vim.api.nvim_set_hl(0, 'CmpSourceVimWiki',               { default = true, link = 'CmpSource' })
  vim.api.nvim_set_hl(0, 'CmpSourceYanky',                 { default = true, link = 'CmpSource' })
  vim.api.nvim_set_hl(0, 'CmpSourceZsh',                   { default = true, link = 'CmpSource' })
end
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

--     󰜏       󰦄 󰦅 󰹓 󱦞 󱤇 󱤈 󰺄 󰺅 󱁴 󱁵 󰱼 󰱽 󱎰 󱎱 󱙓 󱙔 󱎸 󱩾 󰥖 󰥗 󰥡 󰥢 󰥷 󰥸 󱇒 󱇓 󱣒 󱣓 󰤏 󰥨 󰥩 󱈆 󱈇 󱈄 󰶚   󰀖 󰤵 󱝩 󱝪 󰨼 󰨽 󰩉 󰩊 󱑗 󱢃 󰥌 󰡦 󱘶 󰾄 󱩯 󰺮 󰺯 󰨭 󰱂 󱘞 󱘟 󱈅 󱊒 󱊓 󱙇 󱙈 󱘢 󱘣
local source_names = {
  async_path =                { ' ', 'CmpSourceAsyncPath' },
  calc =                      { '󰃬 ', 'CmpSourceCalc' },
  cmdline =                   { ' ', 'CmpSourceCmdline' },
  cmdline_history =           { ' ', 'CmpSourceCmdlineHistory' },
  cmp_git =                   { ' ', 'CmpSourceGit' },
  cmp_rg =                    { '󰉸 ', 'CmpSourceRg' },
  cmp_tabnine =               { '󰘳 ', 'CmpSourceTabnine' },
  cmp_yanky =                 { ' ', 'CmpSourceYanky' }, --    ﲇ  
  codeium =                   { ' ',  'CmpSourceCodeium' },
  copilot =                   { ' ', 'CmpSourceCopilot' }, -- " 
  ['diag-codes'] =            { ' ' , 'CmpSourceDiagCodes' },
  dictionary =                { ' ', 'CmpSourceDictionary' },
  emoji =                     { ' ', 'CmpSourceEmoji' },
  ['faker.quick_data'] =      { ' ', 'CmpSourceQuickData' }, --       
  fuzzy_buffer =              { ' ', 'CmpSourceFuzzyBuffer' },
  fuzzy_path =                { ' ', 'CmpSourceFuzzyPath' },
  ['fzf-lua'] =               { '󱈅 ', 'CmpSourceFzfLua' },
  lazydev =                   { '󰒲 ', 'CmpSourceLazyDev' },
  look =                      { ' ', 'CmpSourceLook' },
  luasnip =                   { ' ', 'CmpSourceLuasnip' },
  nerdfont =                  { ' ', 'CmpSourceNerdfont' },
  npm =                       { ' ', 'CmpSourceNpm' },
  nvim_lsp =                  { ' ', 'CmpSourceNvimLsp' },
  nvim_lsp_document_symbol =  { '󰒕 ', 'CmpSourceNvimLspDocumentSymbol' },
  nvim_lsp_signature_help =   { '󰊕 ', 'CmpSourceNvimLspSignatureHelp' },
  nvim_lua =                  { ' ', 'CmpSourceNvimLua' },
  omni =                      { ' ', 'CmpSourceOmni' },
  path =                      { ' ', 'CmpSourcePath' },
  plugins =                   { '鈴', 'CmpSourcePlugin' },
  ['render-markdown'] =       { ' ', 'CmpSourceRenderMarkdown' },
  rg =                        { '󱙔 ', 'CmpSourceRg' },
  spell =                     { ' ', 'CmpSourceSpell' },
  tags =                      { '󰜢 ', 'CmpSourceTags' },
  tmux =                      { ' ', 'CmpSourceTmux' },
  treesitter =                { '滑', 'CmpSourceTreesitter' }, --   滑
  ['vim-dadbod-completion'] = { ' ', 'CmpSourceDadbod' },
  ['vimwiki-tags'] =          { ' ', 'CmpSourceVimWiki' },
  zsh =                       { ' ', 'CmpSourceTmux' },
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

-- buffer = '', nvim_lsp = ' ', luasnip = ' 🐍', treesitter = ' ',
-- nvim_lua = ' ', spell = ' 暈', emoji = '󰞅', copilot = "🤖",
-- cmp_tabnine = '🤖', look = '',
-- 󰋺      󰈠  󰖋  󰬥  󰥝  󰶮  󱀯  󰾜  󰢖  󱘭  󱤭
-- stylua: ignore
local lsp_symbols = {
  _Parent              = "",
  Boolean              = "◩",
  CharacterSpecial     = "",
  Class                = '󰌗', --   Class       = "󰠱 ",
  Codeium              = '',
  Color                = '󰏘',
  Comment              = "",
  CommentError         = '',
  CommentNote          = '',
  CommentWarning       = '',
  Conditional          = 'נּ',
  Constant             = '󰞂', --   Constant    = "󰐀 ",
  ConstantBuiltin      = "󰏿",
  Constructor          = '', --   Constructor = "⌘ ",
  Copilot              = '',
  Enum                 = '󰕘', --   Enum        = " ",
  EnumMember           = '',
  Error                = '',
  Event                = '',
  Exception            = '',
  Field                = '󰜢', --   Field       = "󰜢 ",
  File                 = '󰈔', --   File        = "󰈙 ",
  Folder               = '󰉋',
  Function             = '󰊕',
  FunctionBuiltin      = '󰊕',
  FunctionCall         = '󰊕',
  FunctionMacro        = '󰊕',
  Include              = '󰜰', --   Interface   = " ",
  Interface            = '', --   Interface   = " ",
  Keyword              = '󰌋', --   Keyword     = "󰔌 ",
  KeywordConditional   = 'נּ',
  KeywordCoroutine     = '󰌋', --   Keyword     = "󰔌 ",
  KeywordFunction      = '' , --   Keyword    = "󰔌 ",
  KeywordImport        = '󰬥' , --   Keyword    = "󰔌 ",
  KeywordOperator      = '',
  KeywordRepeat        = '',
  KeywordReturn        = '', --   Keyword     = "󰔌 ",
  Label                = '󰜢',
  MarkupHeading1       = '',
  MarkupHeading2       = '',
  MarkupHeading3       = '',
  MarkupHeading4       = '',
  MarkupHeading5       = '',
  MarkupHeading6       = '',
  MarkupHeading1Marker = '',
  MarkupHeading2Marker = '',
  MarkupHeading3Marker = '',
  MarkupHeading4Marker = '',
  MarkupHeading5Marker = '',
  MarkupHeading6Marker = '',
  MarkupList           = '',
  MarkupLink           = '',
  MarkupRaw            = '',
  MarkupRawBlock       = '', -- ''
  MarkupRawDelimiter   = '' ,
  Method               = '󰆧',
  Module               = '󰅩', --   Module      = "󰏓 ",
  Namespace            = "󰌗",
  None                 = 'ﳠ',
  Number               = "󰎠",
  NumberFloat          = "󱂡",
  Operator             = '󰃬', --   Operator    = "󰆕 ",
  Parameter            = ' ',
  Parent               = "",
  Preproc              = '', --   Property    = "󰜢",
  Property             = '󰖷', --   Property    = "󰜢",
  PunctuationSpecial   = "",
  Reference            = '󰈝', --   Reference   = "󰈇 ",
  Repeat               = '',
  Snippet              = '', --   Snippet     = 󰅱 ,
  Spell                = "",
  String               = "",
  StringEscape         = '',
  StringRegex          = '縷',
  StringRegexp         = '縷',
  StringSpecial        = '',
  StringSpecialUrl     = '',
  Struct               = '󰟦', --   Struct      = "󰙅 ",
  Text                 = '', --   Text        = " ",
  TextLiteral          = '', --   Text        = " ",
  TextLiteralBlock     = '󰅪', --   Text        = " ",
  TextQuote            = '', --   Text        = " ",
  TextReference        = '󰈇', --   Text        = " ",
  TextTitle1           = '', --   Text        = " ",
  TextTitle2           = '', --   Text        = " ",
  TextTitle3           = '', --   Text        = " ",
  TextTitle4           = '', --   Text        = " ",
  TextTitle5           = '', --   Text        = " ",
  TextTitle6           = '', --   Text        = " ",
  TextUri              = '', --   Text        = " ",
  Type                 = '󰊄',
  TypeParameter        = '󰊄',
  Unit                 = '', --   Unit        = "󰑭 ",
  Value                = '󰎠',
  Variable             = '', --   Variable    = "󰈜 ",
  VariableBuiltin      = '', --   Variable    = "󰈜 ",
  VariableMember       = '', --   Variable    = "󰈜 ",
  VariableParameter    = '', --   Variable    = "󰈜 ",
  XX                   = ' ', --   Variable   = "󰈜 ",
}

return {
  names = source_names,
  symbols = lsp_symbols,
  setup_highlights = setup_highlights,
}
