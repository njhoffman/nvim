---@diagnostic disable: undefined-global

local ok, lush = pcall(require, "lush")
if not ok then
  return
end

local hsl = lush.hsl

local clrs = {
  nord0 = hsl(220, 16, 22), -- #2F3541
  nord1 = hsl(222, 16, 28), -- #3C4353
  nord2 = hsl(220, 17, 32), -- #444D5F
  nord3 = hsl(220, 16, 36), -- #4D576A
  nord3_bright = hsl(220, 17, 46), -- #616F89
  nord4 = hsl(219, 28, 88), -- #D8DEE9
  nord5 = hsl(218, 27, 92), -- #E5E9F0
  nord6 = hsl(218, 27, 94), -- #ECEFF4
  -- nord7 = hsl(179, 25, 65), -- #8FBCBB
  nord7 = "#6f9cbb",
  nord8 = hsl(193, 43, 67), -- #87BFCF
  nord9 = hsl(210, 34, 63), -- #81A1C1
  nord10 = hsl(213, 32, 52), -- #5D81AC
  nord11 = hsl(354, 42, 56), -- #BE6069
  nord12 = hsl(14, 51, 63), -- #D18771
  nord13 = hsl(40, 71, 73), -- #EBCA89
  -- nord14 = hsl(92, 28, 65), -- #A4BF8D
  nord14 = "#22BB99",
  -- nord15 = hsl(311, 20, 63), -- #B48EAD
  nord15 = "#646EAD",
  nord16 = "#56a9b3",
  none = "NONE",
  highlight = "#1F2233",
  disabled = "#464B5D",
  accent = "#84FFFF",
  error = "#BE6069"
}

local clr_over = {
  -- select ion = "#2F3243",
  -- -selection = "#0f2a56",
  selection = "#122244",
  orange = "#cc8877",
  yellow = "#bdb994",
  yellow_faded = "#7B6B3B",
  purple_faded = "#6A6CAB",
  red_faded = "#7F212A",
  green_faded = "#128A67",
  blue_faded = "#5171A1"
}

return function()
  return {
    Visual { fg = "none", bg = clr_over.selection },
    Error { fg = "#bF211A", bg = "none" },
    Underline = { gui = "none" },
    Underlined = { gui = "none" },
    -- ui components
    NormalFloat { fg = "#8f93a2", bg = "#0c101f" }, -- normal text and background color for floating windows
    FloatBorder { fg = "#4f73a2", bg = NormalFloat.bg }, --
    Pmenu { fg = "#618cc4", bg = "#090918" },
    PmenuSel { fg = "#74efff", bg = "#1a1f2f" },
    PmenuSbar { fg = "#717cb4", bg = "#202331" },
    PmenuThumb { fg = "#8f93a2", bg = "#84ffff" },
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
    MatchParen { fg = "#60a0a0", bg = "000022" },
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
    VertSplit { fg = "#646Dcf", bg = "none", gui = "NONE" },
    -- bg = "#2C2343",
    VisualNOS { fg = "none", bg = clr_over.selection },
    healthError { fg = "#BE6069", bg = "#none" },
    healthSuccess { fg = "#22BB99", bg = "#none" },
    healthWarning { fg = "#EBCA89", bg = "#none" },
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
    Question { fg = clrs.nord4 },
    --
    DiagnosticWarn { fg = clrs.nord13.da(40) },
    DiagnosticVirtualTextWarn { fg = clrs.nord13.da(60), gui = 'italic' },
    DiagnosticHint { fg = "#447Ddf" },
    DiagnosticVirtualTextHint { fg = "#246Daf", gui = 'italic' },
    LspFloatWinBorder = { bg = "none" },
    LspDiagnosticsError { fg = clrs.nord11 },
    LspDiagnosticsHint { fg = clrs.nord8 },
    LspDiagnosticsInformation { fg = clrs.nord10 },
    LspDiagnosticsDefaultError { LspDiagnosticsError },
    LspDiagnosticsDefaultHint { LspDiagnosticsHint },
    LspDiagnosticsDefaultInformation { LspDiagnosticsInformation },
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
    -- FoldColumn { fg = clrs.nord3, bg = clrs.nord0 },
    -- SignColumn { fg = clrs.nord1.li(2), bg = clrs.nord0 },
    -- Underline {},
    -- Underlined {},
    -- htmlLink  {},
    -- htmlUnderline  {},
    -- htmlUnderLineItalic  {}
    -- Underlined, CursorLine, TSUnderline, htmlUnderline, htmlUnderlineItalic, htmlUnderLineItalic,
    ---
    -- GitSigns Faded
    GitSignsAddFaded { fg = clr_over.green_faded },
    GitSignsAddNrFaded { fg = clr_over.green_faded },
    GitSignsAddLnFaded { fg = clr_over.green_faded },
    GitSignsChangeFaded { fg = clr_over.yellow_faded },
    GitSignsChangeNrFaded { fg = clr_over.yellow_faded },
    GitSignsChangeLnFaded { fg = clr_over.yellow_faded },
    GitSignsChangeDeleteFaded { fg = clr_over.purple_faded },
    GitSignsChangeDeleteNrFaded { fg = clr_over.purple_faded },
    GitSignsChangeDeleteLnFaded { fg = clr_over.purple_faded },
    GitSignsDeleteFaded { fg = clr_over.red_faded },
    GitSignsDeleteNrFaded { fg = clr_over.red_faded },
    GitSignsDeleteLnFaded { fg = clr_over.red_faded },
    DAPLogPointSign { fg = "#00f1f5" },
    DAPBreakpointSign { fg = "#4790ff" },
    DAPStopSign { fg = "#07ffc0" },
    DAPStopSignText { bg = "#280000" },
    DapUIScope { fg = "#00F1F5" },
    DapUIType { fg = "#74b4cF" },
    DapUIDecoration { fg = "#00F1F5" },
    DapUIThread { fg = "#A9FF68" },
    DapUIStoppedThread { fg = "#00f1f5" },
    DapUISource { fg = "#8484FF" },
    DapUILineNumber { fg = "#00f1f5" },
    DapUIFloatBorder { fg = "#00F1F5" },
    DapUIWatchesHeader { fg = "#00F1F5" },
    DapUIWatchesEmpty { fg = "#F70067" },
    DapUIWatchesValue { fg = "#A9FF68" },
    DapUIWatchesError { fg = "#F70067" },
    DapUIBreakpointsPath { fg = "#00F1F5" },
    DapUIBreakpointsInfo { fg = "#A9FF68" },
    DapUIBreakpointsCurrentLine { fg = "#A9FF68", gui = "bold" },
    DapUIVariable { fg = "#6484cF" },
    -- DapUIFrameName { Normal },
    -- DapUIBreakpointsLive { DapUILineNumber },
    -- DapVariableTreeType { Comment },
    -- DapVariableTreeOperator { Operator },
    -- DapVariableTreeString { String },
    -- DapVariableTreeNumber { Number },
    --
    PackageInfoOutdatedVersion { fg = "#d19a66" },
    PackageInfoUpToDateVersion { fg = "#3C4048" },
    SpecsCursor { bg = "#274087" },
    -- -- WhichKey
    --     WhichKey = { fg = clrs.accent, style = "bold" },
    --     WhichKeyGroup = { fg = clrs.text },
    --     WhichKeyDesc = { fg = clrs.nord7, style = "italic" },
    --     WhichKeySeperator = { fg = clrs.fg },
    --     WhichKeyFloating = { bg = clrs.float },
    --     WhichKeyFloat = { bg = clrs.float },
    WhichKey { fg = "#f78077", style = "bold" }, --Function
    WhichKeyGroup { fg = "#619cf4" }, -- Keyword
    -- WhichKeyDesc  { fg = clrs.nord7, style = "italic" }, -- Identifier
    -- WhichKeySeperator  { fg = clrs.fg }, -- DiffAdded
    WhichKeyFloat { bg = NormalFloat.bg }, -- NormalFloat
    -- WhichKeyValue { bg = clrs.float }, -- Comment
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
    DashboardCenter { fg = "#4499ff" },
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


-- local function remove_background(group)
--   group["bg"] = colors.none
-- end

-- local function load_syntax()
--   -- Syntax highlight groups

--   local syntax = {
--     -- int, long, char, etc.
--     Type = { fg = colors.yellow },
--     -- static, register, volatile, etc.
--     StorageClass = { fg = colors.purple },
--     -- struct, union, enum, etc.
--     Structure = { fg = colors.purple },
--     -- any constant
--     Constant = { fg = colors.blue },
--     -- any character constant: 'c', '\n'
--     Character = { fg = colors.green },
--     -- a number constant: 5
--     Number = { fg = colors.orange },
--     -- a boolean constant: TRUE, false
--     Boolean = { fg = colors.orange },
--     -- a floating point constant: 2.3e10
--     Float = { fg = colors.orange },
--     -- any statement
--     Statement = { fg = colors.purple },
--     -- case, default, etc.
--     Label = { fg = colors.purple },
--     -- sizeof", "+", "*", etc.
--     Operator = { fg = colors.purple },
--     -- try, catch, throw
--     Exception = { fg = colors.purple },
--     -- generic Preprocessor
--     PreProc = { fg = colors.purple },
--     -- preprocessor #include
--     Include = { fg = colors.blue },
--     -- preprocessor #define
--     Define = { fg = colors.red },
--     -- same as Define
--     Macro = { fg = colors.red },
--     -- A typedef
--     Typedef = { fg = colors.purple },
--     -- preprocessor #if, #else, #endif, etc.
--     PreCondit = { fg = colors.purple },
--     -- any special symbol
--     Special = { fg = colors.light_red },
--     -- special character in a constant
--     SpecialChar = { fg = colors.light_red },
--     -- you can use CTRL-] on this
--     Tag = { fg = colors.green },
--     -- character that needs attention like , or .
--     Delimiter = { fg = colors.dark_blue },
--     -- special things inside a comment
--     SpecialComment = { fg = colors.light_gray },
--     -- debugging statements
--     Debug = { fg = colors.yellow },
--     -- text that stands out, HTML links
--     Underlined = { fg = colors.green, style = "underline" },
--     -- left blank, hidden
--     Ignore = { fg = colors.cyan, bg = colors.bg, style = "bold" },
--     -- any erroneous construct
--     Error = { fg = colors.error, bg = colors.none, style = "bold,underline" },
--     -- anything that needs extra attention; mostly the keywords TODO FIXME and XXX
--     Todo = { fg = colors.yellow, bg = colors.none, style = "bold,italic" },
--     Comment = { fg = colors.light_gray, style = config.styles.comments }, -- normal comments
--     -- normal if, then, else, endif, switch, etc.
--     Conditional = { fg = colors.purple, style = config.styles.keywords },
--     -- normal for, do, while, etc.
--     Keyword = { fg = colors.purple, style = config.styles.keywords },
--     -- normal any other keyword
--     Repeat = { fg = colors.purple, style = config.styles.keywords },
--     -- normal function names
--     Function = { fg = colors.blue, style = config.styles.functions },
--     -- any variable name
--     Identifier = { fg = colors.fg, style = config.styles.variables },
--     -- any string
--     String = { fg = colors.green, config.styles.strings },

--     htmlLink = { fg = colors.green, style = "underline" },
--     htmlH1 = { fg = colors.cyan, style = "bold" },
--     htmlH2 = { fg = colors.red, style = "bold" },
--     htmlH3 = { fg = colors.green, style = "bold" },
--     htmlH4 = { fg = colors.yellow, style = "bold" },
--     htmlH5 = { fg = colors.purple, style = "bold" },

--     markdownBlockquote = { fg = colors.light_gray },
--     markdownBold = { fg = colors.purple, style = "bold" },
--     markdownCode = { fg = colors.green },
--     markdownCodeBlock = { fg = colors.green },
--     markdownCodeDelimiter = { fg = colors.green },
--     markdownH1 = { fg = colors.dark_blue, style = "bold" },
--     markdownH2 = { fg = colors.blue, style = "bold" },
--     markdownH3 = { fg = colors.cyan, style = "bold" },
--     markdownH4 = { fg = colors.light_green },
--     markdownH5 = { fg = colors.light_green },
--     markdownH6 = { fg = colors.light_green },
--     markdownH1Delimiter = { fg = colors.dark_blue },
--     markdownH2Delimiter = { fg = colors.blue },
--     markdownH3Delimiter = { fg = colors.cyan },
--     markdownH4Delimiter = { fg = colors.light_green },
--     markdownH5Delimiter = { fg = colors.light_green },
--     markdownH6Delimiter = { fg = colors.light_green },
--     markdownId = { fg = colors.yellow },
--     markdownIdDeclaration = { fg = colors.purple },
--     markdownIdDelimiter = { fg = colors.light_gray },
--     markdownLinkDelimiter = { fg = colors.light_gray },
--     markdownItalic = { fg = colors.yellow, style = "italic" },
--     markdownLinkText = { fg = colors.purple },
--     markdownListMarker = { fg = colors.red },
--     markdownOrderedListMarker = { fg = colors.red },
--     markdownRule = { fg = colors.purple },
--     markdownUrl = { fg = colors.cyan, style = "underline" },
--   }

--   return syntax
-- end

-- local function load_editor()
--   -- Editor highlight groups

--   local editor = {
--     -- normal text and background color for floating windows
--     NormalFloat = { fg = colors.fg, bg = colors.active },
--     -- floating window border
--     FloatBorder = { fg = colors.blue, bg = colors.active },
--     -- used for the columns set with 'colorcolumn'
--     ColorColumn = { fg = colors.none, bg = colors.float },
--     -- placeholder characters substituted for concealed text (see 'conceallevel')
--     Conceal = { bg = colors.bg },
--     -- the character under the cursor
--     Cursor = { fg = colors.fg, bg = colors.none, style = "reverse" },
--     -- like Cursor, but used when in IME mode
--     CursorIM = { fg = colors.fg, bg = colors.none, style = "reverse" },
--     -- directory names (and other special names in listings)
--     Directory = { fg = colors.blue, bg = colors.none },
--     -- diff mode: Added line
--     DiffAdd = { fg = colors.none, bg = colors.diff_add_bg },
--     -- diff mode: Changed line
--     DiffChange = { fg = colors.none, bg = colors.diff_change_bg },
--     -- diff mode: Deleted line
--     DiffDelete = { fg = colors.none, bg = colors.diff_remove_bg },
--     -- diff mode: Changed text within a changed line
--     DiffText = { fg = colors.none, bg = colors.diff_text_bg },
--     -- error messages
--     ErrorMsg = { fg = colors.error },
--     -- line used for closed folds
--     Folded = { fg = colors.dark_blue, bg = colors.none, style = "italic" },
--     -- 'foldcolumn'
--     FoldColumn = { fg = colors.light_gray },
--     -- 'incsearch' highlighting; also used for the text replaced with ":s///c"
--     IncSearch = { fg = colors.yellow, bg = colors.selection, style = "bold,underline" },
--     -- Line number for ":number" and ":#" commands, and when 'number' or 'relativenumber' option is set.
--     LineNr = { fg = colors.light_gray },
--     -- Like LineNr when 'cursorline' or 'relativenumber' is set for the cursor line.
--     CursorLineNr = { fg = colors.fg },
--     -- The character under the cursor or just before it, if it is a paired bracket, and its match. |pi_paren.txt|
--     MatchParen = { fg = colors.yellow, bg = colors.none, style = "bold" },
--     -- 'showmode' message (e.g., "-- INSERT -- ")
--     ModeMsg = { fg = colors.blue, style = "bold" },
--     -- |more-prompt|
--     MoreMsg = { fg = colors.blue, style = "bold" },
--     -- '@' at the end of the window, characters from 'showbreak' and other characters that do not really exist
--     -- in the text (e.g., ">" displayed when a double-wide character doesn't fit at the end of the line).
--     -- See also |hl-EndOfBuffer|.
--     NonText = { fg = colors.gray },
--     -- normal item |hl-Pmenu|
--     Pmenu = { fg = colors.fg, bg = colors.float },
--     -- selected item |hl-PmenuSel|
--     PmenuSel = { bg = colors.selection },
--     -- scrollbar |hl-PmenuSbar|
--     PmenuSbar = { bg = colors.float },
--     -- thumb of the scrollbar  |hl-PmenuThumb|
--     PmenuThumb = { bg = colors.fg },
--     -- |hit-enter| prompt and yes/no questions
--     Question = { fg = colors.green },
--     -- Current |quickfix| item in the quickfix window. Combined with |hl-CursorLine| when the cursor is there.
--     QuickFixLine = { bg = colors.float, style = "bold,italic" },
--     -- Line numbers for quickfix lists
--     qfLineNr = { fg = colors.purple },
--     -- Last search pattern highlighting (see 'hlsearch').  Also used for similar items that need to stand out.
--     Search = { fg = colors.blue, bg = colors.selection, style = "bold" },
--     -- Unprintable characters: text displayed differently from what it really is.
--     -- But not 'listchars' whitespace. |hl-Whitespace|
--     SpecialKey = { fg = colors.dark_blue },
--     -- Word that is not recognized by the spellchecker. |spell| Combined with the highlighting used otherwise.
--     SpellBad = { fg = colors.red, bg = colors.none, style = "italic,underline", sp = colors.red },
--     -- Word that should start with a capital. |spell| Combined with the highlighting used otherwise.
--     SpellCap = { fg = colors.yellow, bg = colors.none, style = "italic,underline", sp = colors.yellow },
--     -- Word that is recognized by the spellchecker as one that is used in another region.
--     -- |spell| Combined with the highlighting used otherwise.
--     SpellLocal = { fg = colors.cyan, bg = colors.none, style = "italic,underline", sp = colors.cyan },
--     -- Word that is recognized by the spellchecker as one that is hardly ever used.
--     -- |spell| Combined with the highlighting used otherwise.
--     SpellRare = { fg = colors.purple, bg = colors.none, style = "italic,underline", sp = colors.purple },
--     -- status line of current window
--     StatusLine = { fg = colors.fg, bg = colors.active },
--     -- status lines of not-current windows Note: if this is equal to "StatusLine"
--     -- Vim will use "^^^" in the status line of the current window.
--     StatusLineNC = { fg = colors.light_gray, bg = colors.active },
--     -- status line of current terminal window
--     StatusLineTerm = { fg = colors.fg, bg = colors.active },
--     -- status lines of not-current terminal windows Note: if this is equal to "StatusLine"
--     -- Vim will use "^^^" in the status line of the current window.
--     StatusLineTermNC = { fg = colors.light_gray, bg = colors.active },
--     -- tab pages line, where there are no labels
--     TabLineFill = { fg = colors.light_gray, bg = colors.active },
--     -- tab pages line, active tab page label
--     TablineSel = { fg = colors.cyan, bg = colors.bg },
--     Tabline = { fg = colors.light_gray, bg = colors.active },
--     -- titles for output from ":set all", ":autocmd" etc.
--     Title = { fg = colors.green, bg = colors.none, style = "bold" },
--     -- Visual mode selection
--     Visual = { fg = colors.none, bg = colors.highlight },
--     -- Visual mode selection when vim is "Not Owning the Selection".
--     VisualNOS = { fg = colors.none, bg = colors.highlight },
--     -- warning messages
--     WarningMsg = { fg = colors.warn },
--     -- "nbsp", "space", "tab" and "trail" in 'listchars'
--     Whitespace = { fg = colors.gray },
--     -- current match in 'wildmenu' completion
--     WildMenu = { fg = colors.yellow, bg = colors.none, style = "bold" },
--     -- Screen-column at the cursor, when 'cursorcolumn' is set.
--     CursorColumn = { fg = colors.none, bg = colors.float },
--     -- Screen-line at the cursor, when 'cursorline' is set. Low-priority if foreground (ctermfg OR guifg) is not set.
--     CursorLine = { fg = colors.none, bg = colors.active },
--     -- Normal mode message in the cmdline
--     NormalMode = { fg = colors.cyan, bg = colors.none, style = "reverse" },
--     -- Insert mode message in the cmdline
--     InsertMode = { fg = colors.green, bg = colors.none, style = "reverse" },
--     -- Replace mode message in the cmdline
--     ReplacelMode = { fg = colors.red, bg = colors.none, style = "reverse" },
--     -- Visual mode message in the cmdline
--     VisualMode = { fg = colors.purple, bg = colors.none, style = "reverse" },
--     -- Command mode message in the cmdline
--     CommandMode = { fg = colors.yellow, bg = colors.none, style = "reverse" },
--     Warnings = { fg = colors.warn },

--     healthError = { fg = colors.error },
--     healthSuccess = { fg = colors.green },
--     healthWarning = { fg = colors.warn },

--     -- Dashboard
--     DashboardShortCut = { fg = colors.cyan },
--     DashboardHeader = { fg = colors.blue },
--     DashboardCenter = { fg = colors.purple },
--     DashboardFooter = { fg = colors.green, style = "italic" },

--     -- normal text and background color
--     Normal = { fg = colors.fg, bg = colors.bg },
--     NormalNC = { bg = colors.bg },
--     SignColumn = { fg = colors.fg, bg = colors.none },

--     -- the column separating vertically split windows
--     VertSplit = { fg = colors.bg },

--     EndOfBuffer = { fg = colors.gray },
--   }

--   -- Options:

--   -- Set non-current background
--   if config.fade_nc then
--     editor.NormalNC["bg"] = colors.active
--     editor.NormalFloat["bg"] = colors.bg
--     editor.FloatBorder["bg"] = colors.bg
--   end

--   -- Set transparent background
--   if config.disable.background then
--     remove_background(editor.Normal)
--     remove_background(editor.NormalNC)
--     remove_background(editor.SignColumn)
--   end

--   -- Set transparent cursorline
--   if config.disable.cursorline then
--     remove_background(editor.CursorLine)
--   end

--   -- Set transparent eob lines
--   if config.disable.eob_lines then
--     editor.EndOfBuffer["fg"] = colors.bg
--   end

--   -- Add window split borders
--   if config.borders then
--     editor.VertSplit["fg"] = colors.selection
--   end

--   return editor
-- end

-- local function load_treesitter()
--   -- TreeSitter highlight groups

--   local treesitter = {
--     -- Annotations that can be attached to the code to denote some kind of meta information. e.g. C++/Dart attributes.
--     TSAttribute = { fg = colors.purple },
--     -- Boolean literals: `True` and `False` in Python.
--     TSBoolean = { fg = colors.orange },
--     -- Character literals: `'a'` in C.
--     TSCharacter = { fg = colors.green },
--     -- Line comments and block comments.
--     TSComment = { fg = colors.light_gray, style = config.styles.comments },
--     -- Keywords related to conditionals: `if`, `when`, `cond`, etc.
--     TSConditional = { fg = colors.purple, style = config.styles.keywords },
--     -- Constants identifiers. These might not be semantically constant. E.g. uppercase variables in Python.
--     TSConstant = { fg = colors.cyan },
--     -- Built-in constant values: `nil` in Lua.
--     TSConstBuiltin = { fg = colors.orange },
--     -- Constants defined by macros: `NULL` in C.
--     TSConstMacro = { fg = colors.red },
--     -- Constructor calls and definitions: `{}` in Lua, and Java constructors.
--     TSConstructor = { fg = colors.yellow },
--     -- Syntax/parser errors. This might highlight large sections of code while the user is typing
--     -- still incomplete code, use a sensible highlight.
--     TSError = { fg = colors.error },
--     -- Exception related keywords: `try`, `except`, `finally` in Python.
--     TSException = { fg = colors.purple },
--     -- Object and struct fields.
--     TSField = { fg = colors.blue },
--     -- Floating-point number literals.
--     TSFloat = { fg = colors.orange },
--     -- Function calls and definitions.
--     TSFunction = { fg = colors.blue, style = config.styles.functions },
--     -- Built-in functions: `print` in Lua.
--     TSFuncBuiltin = { fg = colors.cyan, style = config.styles.functions },
--     -- Macro defined functions (calls and definitions): each `macro_rules` in Rust.
--     TSFuncMacro = { fg = colors.blue },
--     -- File or module inclusion keywords: `#include` in C, `use` or `extern crate` in Rust.
--     TSInclude = { fg = colors.blue },
--     -- Keywords that don't fit into other categories.
--     TSKeyword = { fg = colors.purple, style = config.styles.keywords },
--     -- Keywords used to define a function: `function` in Lua, `def` and `lambda` in Python.
--     TSKeywordFunction = { fg = colors.purple, style = config.styles.keywords },
--     -- Unary and binary operators that are English words: `and`, `or` in Python; `sizeof` in C.
--     TSKeywordOperator = { fg = colors.purple },
--     -- Keywords like `return` and `yield`.
--     TSKeywordReturn = { fg = colors.purple },
--     -- GOTO labels: `label:` in C, and `::label::` in Lua.
--     TSLabel = { fg = colors.purple },
--     -- Method calls and definitions.
--     TSMethod = { fg = colors.blue, style = config.styles.functions },
--     -- Identifiers referring to modules and namespaces.
--     TSNamespace = { fg = colors.yellow },
--     -- Numeric literals that don't fit into other categories.
--     TSNumber = { fg = colors.orange },
--     -- Binary or unary operators: `+`, and also `->` and `*` in C.
--     TSOperator = { fg = colors.purple },
--     -- Parameters of a function.
--     TSParameter = { fg = colors.red },
--     -- References to parameters of a function.
--     TSParameterReference = { fg = colors.red },
--     -- Same as `TSField`.
--     TSProperty = { fg = colors.blue },
--     -- Punctuation delimiters: Periods, commas, semicolons, etc.
--     TSPunctDelimiter = { fg = colors.dark_blue },
--     -- Brackets, braces, parentheses, etc.
--     TSPunctBracket = { fg = colors.dark_blue },
--     -- Special punctuation that doesn't fit into the previous categories.
--     TSPunctSpecial = { fg = colors.dark_blue },
--     -- Keywords related to loops: `for`, `while`, etc.
--     TSRepeat = { fg = colors.purple, style = config.styles.keywords },
--     -- String literals.
--     TSString = { fg = colors.green, style = config.styles.strings },
--     -- Regular expression literals.
--     TSStringRegex = { fg = colors.orange },
--     -- Escape characters within a string: `\n`, `\t`, etc.
--     TSStringEscape = { fg = colors.orange },
--     -- Identifiers referring to symbols or atoms.
--     TSSymbol = { fg = colors.cyan },
--     -- Tags like HTML tag names.
--     TSTag = { fg = colors.yellow },
--     -- HTML tag attributes.
--     TSTagAttribute = { fg = colors.blue },
--     -- Tag delimiters like `<` `>` `/`.
--     TSTagDelimiter = { fg = colors.dark_blue },
--     -- Non-structured text. Like text in a markup language.
--     TSText = { fg = colors.fg },
--     -- Text to be represented in bold.
--     TSStrong = { fg = colors.purple, style = "bold" },
--     -- Text to be represented with emphasis.
--     TSEmphasis = { fg = colors.yellow, style = "italic" },
--     -- Text to be represented with an underline.
--     TSUnderline = { style = "underline" },
--     -- Text that is part of a title.
--     TSTitle = { fg = colors.blue, style = "bold" },
--     -- Literal or verbatim text.
--     TSLiteral = { fg = colors.green },
--     -- URIs like hyperlinks or email addresses.
--     TSURI = { fg = colors.cyan, style = "underline" },
--     -- Math environments like LaTeX's `$ ... $`
--     TSMath = { fg = colors.fg },
--     -- Footnotes, text references, citations, etc.
--     TSTextReference = { fg = colors.purple },
--     -- Text environments of markup languages.
--     TSEnvironment = { fg = colors.fg },
--     -- Text/string indicating the type of text environment. Like the name of a `\begin` block in LaTeX.
--     TSEnvironmentName = { fg = colors.fg },
--     -- Text representation of an informational note.
--     TSNote = { fg = colors.info, style = "bold" },
--     -- Text representation of a warning note.
--     TSWarning = { fg = colors.warn, style = "bold" },
--     -- Text representation of a danger note.
--     TSDanger = { fg = colors.error, style = "bold" },
--     -- Type (and class) definitions and annotations.
--     TSType = { fg = colors.yellow },
--     -- Built-in types: `i32` in Rust.
--     TSTypeBuiltin = { fg = colors.orange },
--     -- Variable names that don't fit into other categories.
--     TSVariable = { fg = colors.fg, style = config.styles.variables },
--     -- Variable names defined by the language: `this` or `self` in Javascript.
--     TSVariableBuiltin = { fg = colors.red, style = config.styles.variables },
--   }

--   return treesitter
-- end

-- local function load_lsp()
--   -- Lsp highlight groups

--   local lsp = {
--     -- used for "Error" diagnostic virtual text
--     LspDiagnosticsDefaultError = { fg = colors.error },
--     -- used for "Error" diagnostic signs in sign column
--     LspDiagnosticsSignError = { fg = colors.error },
--     -- used for "Error" diagnostic messages in the diagnostics float
--     LspDiagnosticsFloatingError = { fg = colors.error },
--     -- Virtual text "Error"
--     LspDiagnosticsVirtualTextError = { fg = colors.error },
--     -- used to underline "Error" diagnostics.
--     LspDiagnosticsUnderlineError = { style = config.styles.diagnostics, sp = colors.error },
--     -- used for "Warning" diagnostic signs in sign column
--     LspDiagnosticsDefaultWarning = { fg = colors.warn },
--     -- used for "Warning" diagnostic signs in sign column
--     LspDiagnosticsSignWarning = { fg = colors.warn },
--     -- used for "Warning" diagnostic messages in the diagnostics float
--     LspDiagnosticsFloatingWarning = { fg = colors.warn },
--     -- Virtual text "Warning"
--     LspDiagnosticsVirtualTextWarning = { fg = colors.warn },
--     -- used to underline "Warning" diagnostics.
--     LspDiagnosticsUnderlineWarning = { style = config.styles.diagnostics, sp = colors.warn },
--     -- used for "Information" diagnostic virtual text
--     LspDiagnosticsDefaultInformation = { fg = colors.info },
--     -- used for "Information" diagnostic signs in sign column
--     LspDiagnosticsSignInformation = { fg = colors.info },
--     -- used for "Information" diagnostic messages in the diagnostics float
--     LspDiagnosticsFloatingInformation = { fg = colors.info },
--     -- Virtual text "Information"
--     LspDiagnosticsVirtualTextInformation = { fg = colors.info },
--     -- used to underline "Information" diagnostics.
--     LspDiagnosticsUnderlineInformation = { style = config.styles.diagnostics, sp = colors.info },
--     -- used for "Hint" diagnostic virtual text
--     LspDiagnosticsDefaultHint = { fg = colors.hint },
--     -- used for "Hint" diagnostic signs in sign column
--     LspDiagnosticsSignHint = { fg = colors.hint },
--     -- used for "Hint" diagnostic messages in the diagnostics float
--     LspDiagnosticsFloatingHint = { fg = colors.hint },
--     -- Virtual text "Hint"
--     LspDiagnosticsVirtualTextHint = { fg = colors.hint },
--     -- used to underline "Hint" diagnostics.
--     LspDiagnosticsUnderlineHint = { style = config.styles.diagnostics, sp = colors.hint },
--     -- used for highlighting "text" references
--     LspReferenceText = { style = "underline", sp = colors.yellow },
--     -- used for highlighting "read" references
--     LspReferenceRead = { style = "underline", sp = colors.yellow },
--     -- used for highlighting "write" references
--     LspReferenceWrite = { style = "underline", sp = colors.yellow },

--     LspSignatureActiveParameter = { fg = colors.none, bg = colors.highlight_dark, style = "bold" },
--     LspCodeLens = { fg = colors.light_gray },

--     DiagnosticError = { link = "LspDiagnosticsDefaultError" },
--     DiagnosticWarn = { link = "LspDiagnosticsDefaultWarning" },
--     DiagnosticInfo = { link = "LspDiagnosticsDefaultInformation" },
--     DiagnosticHint = { link = "LspDiagnosticsDefaultHint" },
--     DiagnosticVirtualTextWarn = { link = "LspDiagnosticsVirtualTextWarning" },
--     DiagnosticUnderlineWarn = { link = "LspDiagnosticsUnderlineWarning" },
--     DiagnosticFloatingWarn = { link = "LspDiagnosticsFloatingWarning" },
--     DiagnosticSignWarn = { link = "LspDiagnosticsSignWarning" },
--     DiagnosticVirtualTextError = { link = "LspDiagnosticsVirtualTextError" },
--     DiagnosticUnderlineError = { link = "LspDiagnosticsUnderlineError" },
--     DiagnosticFloatingError = { link = "LspDiagnosticsFloatingError" },
--     DiagnosticSignError = { link = "LspDiagnosticsSignError" },
--     DiagnosticVirtualTextInfo = { link = "LspDiagnosticsVirtualTextInformation" },
--     DiagnosticUnderlineInfo = { link = "LspDiagnosticsUnderlineInformation" },
--     DiagnosticFloatingInfo = { link = "LspDiagnosticsFloatingInformation" },
--     DiagnosticSignInfo = { link = "LspDiagnosticsSignInformation" },
--     DiagnosticVirtualTextHint = { link = "LspDiagnosticsVirtualTextHint" },
--     DiagnosticUnderlineHint = { link = "LspDiagnosticsUnderlineHint" },
--     DiagnosticFloatingHint = { link = "LspDiagnosticsFloatingHint" },
--     DiagnosticSignHint = { link = "LspDiagnosticsSignHint" },
--   }
--   return lsp
-- end
