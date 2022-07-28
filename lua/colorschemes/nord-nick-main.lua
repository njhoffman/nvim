---@diagnostic disable
--luacheck: ignore

local ok, lush = pcall(require, "lush")
if not ok then
  return
end

local hsl = lush.hsl

local clrs = {
  nord0        = hsl(220, 16, 22), -- #2F3541
  nord1        = hsl(222, 16, 28), -- #3C4353
  nord2        = hsl(220, 17, 32), -- #444D5F
  nord3        = hsl(220, 16, 36), -- #4D576A
  nord3_bright = hsl(220, 17, 46), -- #616F89
  nord4        = hsl(219, 28, 88), -- #D8DEE9
  nord5        = hsl(218, 27, 92), -- #E5E9F0
  nord6        = hsl(218, 27, 94), -- #ECEFF4
  -- nord7 = hsl(179, 25, 65), -- #8FBCBB
  nord7        = "#6f9cbb",
  nord8        = hsl(193, 43, 67), -- #87BFCF
  nord9        = hsl(210, 34, 63), -- #81A1C1
  nord10       = hsl(213, 32, 52), -- #5D81AC
  nord11       = hsl(354, 42, 56), -- #BE6069
  nord12       = hsl(14, 51, 63), -- #D18771
  nord13       = hsl(40, 71, 73), -- #EBCA89
  -- nord14 = hsl(92, 28, 65), -- #A4BF8D
  nord14       = "#22BB99",
  -- nord15 = hsl(311, 20, 63), -- #B48EAD
  nord15       = "#646EAD",
  nord16       = "#56a9b3",
  none         = "NONE",
  highlight    = "#1F2233",
  disabled     = "#464B5D",
  accent       = "#84FFFF",
  error        = "#BE6069"
}

local clr_over = {
  -- select ion = "#2F3243",
  -- -selection = "#0f2a56",
  selection    = "#122244",
  orange       = "#cc8877",
  yellow       = "#bdb994",
  yellow_faded = "#7B6B3B",
  purple_faded = "#6A6CAB",
  red_faded    = "#7F212A",
  green_faded  = "#128A67",
  blue_faded   = "#5171A1"
}

return function()
  return {
    Visual { fg = "none", bg = clr_over.selection },
    Error { fg = "#bF211A", bg = "none" },
    Underline { gui = "none" },
    Underlined { gui = "none" },
    -- ui components
    NormalFloat { fg = "#8f93a2", bg = "none" }, -- normal text and background color for floating windows
    FloatBorder { fg = "#3f5382", bg = "none" }, --
    ColorColumn { bg = "none" },

    Pmenu { fg = "#618cc4", bg = "#090918" },
    PmenuSel { fg = "#44bfcf", bg = "#1a1f2f" },
    PmenuSbar { fg = "#313c84", bg = "#202331" },
    PmenuThumb { fg = "#4f5362", bg = "#446faf" },
    SignColumn { bg = "none" },
    LineNr { fg = clrs.nord3 },
    CursorLine { bg = "#101018", gui = "none" },
    CursorLineNr { fg = "#44aaff", bg = CursorLine.bg, gui = "italic" },
    CursorColumn { bg = "#7722ff" },
    -- base groups
    Statement { fg = "#5191C1" },
    Comment { fg = "#495a74", gui = "italic" },
    Conceal { bg = "none" },
    Constant { fg = clrs.nord16 },
    Delimiter { fg = "#5f6fa2" },
    Directory { fg = "#187298" },
    FoldColumn { fg = "#4D576A", bg = "#121212" },
    Folded { fg = "#6D778a", bg = "#121212", gui = "bold" },
    Function { fg = "#988088" },
    Identifier { fg = "#6e99c6" },
    IncSearch { fg = "#eceff4", bg = "#5d61ec" },
    Search { fg = "#74efff", bg = "#0d314c", gui = "NONE" },
    Keyword { fg = "#6177b2" },
    MatchParen { fg = "#60a0a0", bg = "#000022" },
    MatchParenCursor { fg = "#a0c0b0" },
    NonText { bg = "none", fg = "#555555" },
    Normal { fg = clrs.nord4.darken(30), bg = "none" },
    NormalWindow { fg = Normal.fg, bg = "none" },
    Operator { fg = "#4886bf" },
    PreProc { fg = "#4796bc" },
    QuickFixLine { bg = "#172238" },
    Scrollbar { bg = "#111111", fg = "#334863" },
    SpecialChar { fg = "#b88698" }, -- For special punctutation that does not fall in the catagories before.
    String { fg = "#00a0a9" },
    Type { fg = "#718cb4" },
    Special { fg = "#487a98" },
    VertSplit { fg = "#444464", bg = "#090909", gui = "bold" },
    VisualNOS { fg = "none", bg = clr_over.selection },
    healthError { fg = "#BE6069", bg = "none" },
    healthSuccess { fg = "#22BB99", bg = "none" },
    healthWarning { fg = "#EBCA89", bg = "none" },
    qfFilename { Directory },
    -- qfLineNr { LineNr },
    -- qfError { Error },
    -- qfSeparator { },

    -- +--- Prompt/Status ---+
    EndOfBuffer { fg = clrs.nord1 },
    ErrorMsg { Error },
    -- ErrorMsg { fg = clrs.nord11 },
    WarningMsg { fg = clrs.nord13 },
    ModeMsg { fg = clrs.nord10 },
    MoreMsg { fg = clrs.nord8 },
    DebugMsg { fg = Comment.fg },
    Question { fg = clrs.nord4 },
    -- +--- LSP ---+
    DiagnosticWarn { fg = clrs.nord13.da(40) },
    DiagnosticVirtualTextWarn { fg = clrs.nord13.da(60), gui = "italic" },
    DiagnosticHint { fg = "#447Ddf" },
    DiagnosticVirtualTextHint { fg = "#246Daf", gui = "italic" },
    LspFloatWinBorder { bg = "none" },
    LspDiagnosticsError { fg = clrs.nord11 },
    LspDiagnosticsHint { fg = clrs.nord8 },
    LspDiagnosticsInformation { fg = clrs.nord10 },
    LspDiagnosticsDefaultError { LspDiagnosticsError },
    LspDiagnosticsDefaultHint { LspDiagnosticsHint },
    LspDiagnosticsDefaultInformation { LspDiagnosticsInformation },
    LspDiagnosticsSignWarn { fg = clrs.nord13.da(70) },
    LspDiagnosticsSignError { fg = LspDiagnosticsError.fg.da(40) },
    LspDiagnosticsSignHint { fg = LspDiagnosticsHint.fg.da(40) },
    LspDiagnosticsSignInfo { fg = LspDiagnosticsInformation.fg.da(40) },
    -- LspDiagnosticsError = { fg = colors.error },
    -- LspDiagnosticsWarning = { fg = colors.warn },
    -- LspDiagnosticsInformation = { fg = colors.info },
    -- LspDiagnosticsHint = { fg = colors.hint },
    DiffAdd { bg = "#00361f" }, -- #00361f #001000 #22bb99
    DiffChange { bg = "#003050" }, -- #003050 #001030 #646ead
    DiffDelete { bg = "#3E0009" }, -- #3e0009 #300000 #be6069
    DiffText { gui = "italic", fg = "#464b5d" }, -- #464b5d #001030 #81a1c1
    diffAdded { fg = clrs.nord14 },
    diffRemoved { fg = clrs.nord11 },
    diffChanged { fg = clrs.nord15 },
    diffOldFile { fg = clrs.nord9 },
    diffNewFile { fg = clrs.nord12 },
    diffFile { fg = clrs.nord7 },
    diffLine { fg = "#464B5D" },
    diffIndexLine { fg = clrs.nord9 },
    --
    -- language groups
    --
    TreesitterContext { bg = '#1a0606', gui = 'italic' },
    TSInclude { fg = "#4784a6" },
    TSBoolean { fg = "#4d6f9c" },
    TSConditional { fg = "#897785" },
    TSException { fg = "#867f88" },
    TSFunction { fg = "#988088" },
    TSKeyword { fg = "#6177a8" },
    TSLabel { fg = "#6688ba" }, -- For labels: `label:` in C and `:label:` in Lua.
    TSMethod { fg = "#6e99c6" },
    TSPunctBracket { fg = "#888698" }, -- For special punctutation that does not fall in the catagories before.
    TSPunctSpecial { fg = "#888698" }, -- For special punctutation that does not fall in the catagories before.
    TSTag { fg = clr_over.orange },
    TSTagDelimiter { fg = clr_over.orange },
    TSURI { fg = "#8eb9f6", gui = "none" },
    TSVariable { Normal },
    TSVariableBuiltin { PreProc },
    --
    cssTSType { fg = "#486795" },
    cssTSPunctDelimiter { fg = "#4784a6" },
    cssTSProperty { fg = "none" },
    cssTSNumber { fg = "none" },
    cssClassName { fg = "#5780a6" },
    cssIdentifier { fg = "#4770a6" },
    cssDefinition { fg = "#6898c6" },
    cssCommonAttr { fg = "#6784d5" },
    cssValueLength { fg = "#0786bc" },
    cssValueNumber { cssValueLength },
    cssColor { cssValueLength },
    cssUnitDecorators { cssValueLength },
    --
    manSectionHeading { fg = "#6595f8" },
    manReference { fg = "#4796bc" },
    -- manSubheading { Function  },
    -- manOptionDesc { Constant },
    --
    liquidExpression { Type },
    liquidDelimiter { fg = clr_over.orange },
    luaTSFunction { TSMethod },
    -- betterlua
    -- set g:lua_subversion to change the highlighting of the standard library
    -- set g:BetterLua_enable_emmylua to 0 to turn off EmmyLua comment highlighting
    -- luaAttrib
    -- luaFuncCall
    -- luaEmmyKeyword The @ directives like @param, @type
    -- luaEmmyClassName
    -- luaEmmyAliasName
    -- luaEmmyParamName
    -- luaEmmyFieldName
    -- luaEmmyFieldExposure: public, protected, or private after a @field directive
    -- luaEmmyGenericName
    -- luaEmmyGenericParentName
    -- luaEmmyFieldName
    -- luaEmmyLang
    -- luaEmmyType:  Type names the string in @param foo string or @type string for var annotations
    -- luaSelf - Self, while not a keyword, has a highlight group
    -- luaSymbol - Operator symbols are now highlighted
    -- Varargs has a separate highlight group to not get highlighted as a partial concatenation operator
    -- luaVarargs

    -- jsx-pretty
    -- jsxElement {fg = "#ff6600"},
    -- jsFunctionCall {fg = jsFuncCall.fg},
    -- jsFuncCall { fg = "#6e99c6" },

    jsFunctionName { fg = "#a78086" },
    jsxTag { fg = clr_over.orange },
    jsxComponentName { fg = clr_over.orange },
    jsxTagName { fg = clr_over.orange },
    jsxOpenTag { fg = clr_over.orange },
    jsxCloseTag { fg = "#7f90aa" },
    -- jsxCloseString {fg = "#ff6600"},
    jsxAttrib { fg = "#88bbdd" },
    jsxEqual { fg = "#6699bb" },
    -- BufferInactiveIndex { bg = "#000000" },
    -- BufferInactive  { bg = "#000000" },
    jsonKeyword { fg = "#446688" },
    -- js-other
    -- jsVariableType {fg = jsStorageClass.fg},
    -- jsIf {fg = jsConditional.fg},
    -- jsIdentifier {fg = jsDestructuringBlock.fg},
    -- jsModuleDefault {fg = jsExportDefault.fg},
    -- jsSwitch {fg = jsConditional.fg},
    -- jsSwitchCase {fg = jsLabel.fg},
    -- jsRegexpString {javascriptRegExpString},
    -- jsTemplateVar {javascriptTemplateVar},
    -- jsTemplateDelim {javascriptTemplateDelim},
    -- jsTemplateString {javascriptTemplateString},
    -- jsStorageClass {StorageClass},
    -- jsReturn {Statement},
    -- jsConditional {Conditional},
    -- jsExportDefault {fg = StorageClass.fg},
    -- jsExportDefaultGroup {jsExportDefault},
    -- jsLabel {Label},
    shBrackets { fg = clr_over.orange },
    shStatement { Keyword },
    shSubst { fg = "#488aaf" },
    shSubstDelim { fg = "#5776bc" },
    shParentheses { fg = "#c78087" },
    shFunction { fg = "#a78087" },
    shDeref { fg = "#488aaf" },
    shDerefSimple { fg = "#488aaf" },
    shLoop { fg = "#80788a" },
    shRepeat { fg = "#80788a" },
    shConditional { fg = "#80788a" },
    shVariable { Normal },
    zshBrackets { fg = clr_over.orange },
    zshSubst { fg = "#488aaf" },
    zshSubstDelim { fg = "#5776bc" },
    zshParentheses { fg = "#c78087" },
    zshFunction { fg = "#a78087" },
    zshDeref { fg = "#488aaf" },
    zshRepeat { fg = "#80788a" },
    zshLoop { fg = "#80788a" },
    zshConditional { fg = "#80788a" },
    zshCommands { fg = "#6180b2" },
    ZinitForCommand { fg = "#a78087" },
    ZinitPlugin { fg = "#95b5ed", gui = "italic" }, -- Macro, Define
    ZinitSnippet { fg = "#95b5ed" }, -- Macro, Define
    ZinitIce { fg = "#7799ee" }, -- Type
    ZinitContinue { fg = "#4878a8" },
    ZinitIceDoubleQuoteParam { fg = "#30b0d9" }, -- Special
    ZinitIceSingleQuoteParam { fg = "#30c0e9" },
    yamlTSField { fg = "#717cb4" },
    yamlBlockMappingKey { yamlTSField },
    -- html
    -- markdownH {},
    -- markdownTSTitle {},
    htmlH1 { fg = "#45a5f8" },
    htmlH2 { fg = "#45a5e8" },
    htmlH3 { fg = "#45a5d8" },
    htmlH4 { fg = "#45a5c8" },
    htmlH5 { fg = "#45a5b8" },
    htmlH6 { fg = "#45a5a8" },
    htmlEndTag { fg = "#7f90aa" },
    htmlTagN { fg = clr_over.orange },
    CSVColumnHeaderOdd { String },
    CSVColumnHeaderEven { fg = Statement.fg, bg = "none" },
    markdownH1 { fg = "#45a5f8" },
    markdownH2 { fg = "#45a5e8" },
    markdownH3 { fg = "#45a5d8" },
    markdownH4 { fg = "#45a5c8" },
    markdownH5 { fg = "#45a5b8" },
    markdownH6 { fg = "#45a5a8" },
    mkdHeading { fg = "#557588" },
    markdownLinkText { fg = "#00ccff" },
    pandocStrikeout { gui = "strikethrough" },
    pandocEmphasis { gui = "italic", fg = "#bbbbcc" },
    pandocStrong { gui = "bold", fg = "#ddddee" },
    -- pandocReferenceLabel { gui = "none", fg = clr_over.orange },
    pandocListItemBullet { fg = "#66a8dc" },
    pandocListItemBulletId { fg = "#66a8dc" },
    pandocOperator { bg = "none", fg = "#aa6600" },
    -- pandocListItem {},
    -- pandocUListItem { gui = "none", bg = "none", fg = "#aa6600" },
    -- pandocReferenceDefinition { fg = "#7788ff", bg = "none" },
    -- pandocAtxHeader { fg = "#4575b8" },
    pandocPipeTable { fg = "#4789aa" },
    pandocPipeTableDelims { fg = "#555577" },
    pandocNoFormatted { bg = "none" },
    pandocReferenceDefinition { fg = "#4488cc", bg = "none" },
    pandocAtxHeader { fg = "#8595f8" },
    pandocAtxHeaderMark { fg = "#4575f8" },
    pandocAtxStart { fg = "#4575f8" },
    helpHyperTextJump { fg = "#6585b8" },
    --
    InfoWindowFloat { fg = "#2886bf", bg = "none" },
    BqfPreviewFloat { Normal },
    BqfPreviewBorder { Normal },
    -- BqfPreviewCursor { Cursor },
    BqfPreviewRange { IncSearch },
    BqfSign { fg = "cyan" },
    -- zshVariableDef { Normal },
    -- zshDeref { fg = '#2886bf' },

    --- nvim-hlslens
    HlSearchLensCur { fg = "#ff2266", bg = "#003333" },
    HlSearchLens { fg = "#00ddff", bg = "none" },
    HlSearchCur { fg = "#00ffdd", bg = "none" },
    -- dashboardn.vim
    --DashboardHeader {Type},
    DashboardCenter { fg = "#4499ff" }
    --DashboardShortcut {Boolean},
    --DashboardFooter {Keyword},

    -- -- Disable nvim-tree background
    -- if config.disable.background then
    --   remove_background(plugins.NvimTreeNormal)
    -- end

    -- call s:X("VNormalimWikiLink","00ccff","","","Green","")
    -- hi htmlH1 ctermfg=109  guifg=#45a5f8 ctermbg=None gui=bold term=bold cterm=bold
    -- hi htmlH2 ctermfg=109  guifg=#45a5e8 ctermbg=None gui=bold
    -- hi htmlH3 ctermfg=109  guifg=#45a5d8 ctermbg=None gui=bold
    -- hi htmlH4 ctermfg=109  guifg=#45a5c8 ctermbg=None gui=bold
    -- hi htmlH5 ctermfg=109  guifg=#45a5b8 ctermbg=None gui=bold
    -- hi htmlH6 ctermfg=109  guifg=#45a5a8 ctermbg=None gui=bold
    -- hi mkdHeading ctermfg=109  guifg=#557588 ctermbg=None
    -- " hi htmlH1 ctermfg=88   guifg=#9d0006 ctermbg=None gui=bold  term=bold cterm=bold
    -- " hi htmlH2 ctermfg=106  guifg=#fb4934 ctermbg=None gui=bold
    -- " hi htmlH3 ctermfg=166  guifg=#98971a ctermbg=None gui=bold
    -- " hi htmlH4 ctermfg=109  guifg=#458588 ctermbg=None gui=bold
    -- " hi htmlH5 ctermfg=124  guifg=#b16286 ctermbg=None gui=bold
    -- " hi mkdCodeStart ctermfg=239 guifg=#9E9E9E ctermbg=None gui=bold
    -- " hi mkdCodeEnd ctermfg=239 guifg=#9E9E9E ctermbg=None gui=bold
    -- " hi mkdCode ctermfg=88  guifg=#427b58 ctermbg=None cterm=bold
  }
end
