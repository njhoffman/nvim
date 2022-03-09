local lush = require("lush")
local hsl = lush.hsl

vim.g.vim_jsx_pretty_colorful_config = 1
vim.g.vim_jsx_pretty_highlight_close_tag = 1

vim.g.javascript_sql_dialect = "pgsql"
vim.o.background = "dark" -- or "light" for light mode

local nord = require("colorschemes.lush-themes.nord-nvim")

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
  error = "#BE6069",
}

local clr_over = {
  -- select ion = "#2F3243",
  -- -selection = "#0f2a56",
  selection = "#0f2a46",
  orange = "#cc8877",
  yellow = "#bdb994",
  yellow_faded = "#7B6B3B",
  purple_faded = "#6A6CAB",
  red_faded = "#7F212A",
  green_faded = "#128A67",
  blue_faded = "#5171A1",
}

local spec = lush.extends({ nord }).with(function()
  return {
    Visual { fg = "none", bg = clr_over.selection },
    Error { fg = "#bF211A", bg = 'none' },
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
    CursorLineNr { fg = '#44aaff', bg = CursorLine.bg, gui= "italic" },
    CursorColumn { bg = "#7722ff"},
    -- base groups
    Statement { fg = "#5191C1" },
    Comment { fg = "#495a74", gui = "italic" },
    Conceal { bg = "none" },
    Constant { fg = clrs.nord16},
    Delimiter { fg = "#5f6fa2" },
    Directory { fg = "#187298" },
    FoldColumn { fg = "#4D576A", bg = "#121212" },
    Folded { fg = "#6D778a", bg = "#121212", gui = "bold" },
    Function { fg = "#988088" },
    Identifier { fg = "#6e99c6" },
    IncSearch { fg = "#eceff4", bg = "#5d61ec" },
    Search {fg = '#74efff', bg = '#0d314c', gui = "NONE"},
    Keyword { fg = "#6177b2" },

    MatchParen { fg = "#60a0a0", bg = "000022" },
    MatchParenCursor { fg = "#a0c0b0" },
    NonText { bg = "#000000", fg = "#555555" },
    Normal { fg = nord.Normal.fg.darken(30), bg = "none" },
    NormalWindow { fg = Normal.fg, bg = "#000000" },
    Operator { fg = "#4886bf" },
    PreProc { fg = "#4796bc" },
    QuickFixLine { bg = "#172238" },
    Scrollbar { bg = "#111111", fg = "#334863" },
    SpecialChar { fg = "#b88698" }, -- For special punctutation that does not fall in the catagories before.
    String { fg = "#00a0a9" },
    Type { fg = "#718cb4" },
    VertSplit { fg = "#646Dcf", bg = "none", gui = "NONE" },-- bg = "#2C2343",
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
    LspFloatWinBorder = { bg = 'none' },
    LSPDiagnosticsSignWarning { fg = "#675023" },
    LspDiagnosticsWarning { fg = clrs.nord13 },
    LspDiagnosticsError { fg = clrs.nord11 },
    LspDiagnosticsHint { fg = clrs.nord8  },
    LspDiagnosticsInformation { fg = clrs.nord10 },
    LspDiagnosticsDefaultWarning { LspDiagnosticsWarning },
    LspDiagnosticsDefaultError { LspDiagnosticsError },
    LspDiagnosticsDefaultHint { LspDiagnosticsHint },
    LspDiagnosticsDefaultInformation { LspDiagnosticsInformation },

    DiffAdd { bg = '#00361f' }, -- #00361f #001000 #22bb99
    DiffChange { bg = '#003050' }, -- #003050 #001030 #646ead
    DiffDelete { bg = '#3E0009' }, -- #3e0009 #300000 #be6069
    DiffText { gui = 'italic', fg = '#464b5d' }, -- #464b5d #001030 #81a1c1

    diffAdded  { fg = clrs.nord14 },
    diffRemoved  { fg = clrs.nord11 },
    diffChanged  { fg = clrs.nord15 },
    diffOldFile  { fg = clrs.nord9 },
    diffNewFile  { fg = clrs.nord12 },
    diffFile  { fg = clrs.nord7 },
    diffLine  { fg = '#464B5D' },
    diffIndexLine  { fg = clrs.nord9 },
    --
    -- language groups
    --
    TSInclude {fg = '#4784a6' },
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
    cssTSType { fg = '#486795' },
    cssTSPunctDelimiter { fg = "#4784a6" },
    cssTSProperty { fg = 'none' },
    cssTSNumber { fg = 'none' },
    cssClassName { fg = '#5780a6' },
    cssIdentifier { fg = "#4770a6" },
    cssDefinition { fg = '#6898c6' },
    cssCommonAttr { fg = "#6784d5" },
    cssValueLength { fg = "#0786bc" },
    cssValueNumber { cssValueLength },
    cssColor { cssValueLength  },
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
    ZinitForCommand { fg = '#a78087' },
    ZinitPlugin {fg = "#95b5ed", gui= "italic"}, -- Macro, Define
    ZinitSnippet {fg = "#95b5ed" }, -- Macro, Define
    ZinitIce { fg = '#7799ee'}, -- Type
    ZinitContinue { fg = '#4878a8'},
    ZinitIceDoubleQuoteParam { fg = "#30b0d9" }, -- Special
    ZinitIceSingleQuoteParam {fg = "#30c0e9"},
    yamlTSField { fg = "#717cb4" },
    yamlBlockMappingKey { yamlTSField },
    -- html
    -- markdownH {},
    -- markdownTSTitle {},
    Special { fg = "#487a98" },
    htmlH1 { fg = "#45a5f8" },
    htmlH2 { fg = "#45a5e8" },
    htmlH3 { fg = "#45a5d8" },
    htmlH4 { fg = "#45a5c8" },
    htmlH5 { fg = "#45a5b8" },
    htmlH6 { fg = "#45a5a8" },
    htmlEndTag { fg = "#7f90aa" },
    htmlTagN { fg = clr_over.orange },
    CSVColumnHeaderOdd {String},
    CSVColumnHeaderEven { fg = Statement.fg, bg='none'},

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
    WhichKeyFloat  { bg = NormalFloat.bg }, -- NormalFloat
    -- WhichKeyValue { bg = clrs.float }, -- Comment
    InfoWindowFloat { fg = "#2886bf", bg = "none" },
    BqfPreviewFloat { Normal },
    BqfPreviewBorder { Normal },
    -- BqfPreviewCursor { Cursor },
    BqfPreviewRange { IncSearch },
    BqfSign { fg = "cyan" },
    -- zshVariableDef { Normal },
    -- zshDeref { fg = '#2886bf' },
    -- Notify
    NotifyERRORBorder { fg = "#8A1F1F"},
    NotifyWARNBorder { fg = "#79491D"},
    NotifyINFOBorder { fg = "#4Fa792"},
    NotifyDEBUGBorder { fg = "#4B4BBB"},
    NotifyTRACEBorder { fg = "#7B7BCC"},
    NotifyERRORIcon { fg = "#F74047"},
    NotifyWARNIcon { fg = "#F79000"},
    NotifyINFOIcon { fg = "#29cFa8"},
    NotifyDEBUGIcon { fg = "#6B6BFF"},
    NotifyTRACEIcon { fg = "#7BABFF"},
    NotifyERRORTitle  { fg = "#F74047"},
    NotifyWARNTitle { fg = "#F79000"},
    NotifyINFOTitle { fg = "#29cFa8"},
    NotifyDEBUGTitle  { fg = "#6B6BFF"},
    NotifyTRACETitle  { fg = "#7BABFF"},
    NotifyERRORBody { Normal },
    NotifyWARNBody { Normal },
    NotifyINFOBody { Normal },
    NotifyDEBUGBody { Normal },
    NotifyTRACEBody { Normal },
    --- nvim-hlslens
    HlSearchLensCur { fg = "#ff2266", bg = "#003333" },
    HlSearchLens { fg = "#00ddff", bg = "none" },
    HlSearchCur { fg = "#00ffdd", bg = "none" },
    -- dashboardn.vim
    --DashboardHeader {Type},
    DashboardCenter {fg = '#4499ff'},
    --DashboardShortcut {Boolean},
    --DashboardFooter {Keyword},
    -- Telescope
    TelescopeNormal { fg = '#6D778a', bg = 'none' },
    TelescopeResultsBorder { fg = "#476F9F" },
    TelescopePromptNormal { bg = 'black'},
    TelescopePromptBorder { fg = "#2299cc" },
    TelescopeMultiIcon { fg = '#0066ff' },
    TelescopePreviewBorder { fg = "#416191" },
    TelescopeSelectionCaret { fg = "#44c9fc" },
    TelescopeSelection { fg = "#28ddff", gui = "bold", bg = "#202324" },
    TelescopePromptPrefix { fg = '#2977FF', bg = 'black'},
    TelescopeMatching { fg = '#7997FF', bg = 'black'},
    TelescopeFrecencyScores { fg = "#34799c" },
    TelescopeBufferLoaded { fg = '#47a0f0'},
    TelescopeMultiSelection { fg = '#4060ff', gui = 'italic' },
    -- TelescopePromptCounter { NonText },
    -- TelescopePathSeparator { fg = '#667788' },
    -- TelescopeQueryFilter { fg = '#4466FF'},
    -- TelescopeResultsIdentifier = {},
    -- TelescopeResultsComment = {},
    -- TelescopeMultiSelection guifg=#928374          " Multisections

--    " Sets the highlight for selected items within the picker.
--    highlight default link TelescopeSelection Visual
--    highlight default link TelescopeSelectionCaret TelescopeSelection
--    highlight default link TelescopeMultiSelection Type
--
--    " "Normal" in the floating windows created by telescope.
--    highlight default link TelescopeNormal Normal
--    highlight default link TelescopePreviewNormal TelescopeNormal
--    highlight default link TelescopePromptNormal TelescopeNormal
--    highlight default link TelescopeResultsNormal TelescopeNormal
--
--    " Border highlight groups.
--    "   Use TelescopeBorder to override the default.
--    "   Otherwise set them specifically
--    highlight default link TelescopeBorder TelescopeNormal
--    highlight default link TelescopePromptBorder TelescopeBorder
--    highlight default link TelescopeResultsBorder TelescopeBorder
--    highlight default link TelescopePreviewBorder TelescopeBorder
--
--    " Title highlight groups.
--    "   Use TelescopeTitle to override the default.
--    "   Otherwise set them specifically
--    highlight default link TelescopeTitle TelescopeBorder
--    highlight default link TelescopePromptTitle TelescopeTitle
--    highlight default link TelescopeResultsTitle TelescopeTitle
--    highlight default link TelescopePreviewTitle TelescopeTitle
--
--    highlight default link TelescopePromptCounter NonText
--
--    " Used for highlighting characters that you match.
--    highlight default link TelescopeMatching Special
--
--    " Used for the prompt prefix
--    highlight default link TelescopePromptPrefix Identifier
--
--    " Used for highlighting the matched line inside Previewer. Works only for (vim_buffer_ previewer)
--    highlight default link TelescopePreviewLine Visual
--    highlight default link TelescopePreviewMatch Search
--
--    highlight default link TelescopePreviewPipe Constant
--    highlight default link TelescopePreviewCharDev Constant
--    highlight default link TelescopePreviewDirectory Directory
--    highlight default link TelescopePreviewBlock Constant
--    highlight default link TelescopePreviewLink Special
--    highlight default link TelescopePreviewSocket Statement
--    highlight default link TelescopePreviewNormal Normal
--    highlight default link TelescopePreviewRead Constant
--    highlight default link TelescopePreviewWrite Statement
--    highlight default link TelescopePreviewExecute String
--    highlight default link TelescopePreviewHyphen NonText
--    highlight default link TelescopePreviewSticky Keyword
--    highlight default link TelescopePreviewSize String
--    highlight default link TelescopePreviewUser Constant
--    highlight default link TelescopePreviewGroup Constant
--    highlight default link TelescopePreviewDate Directory
--    highlight default link TelescopePreviewMessage TelescopePreviewNormal
--    highlight default link TelescopePreviewMessageFillchar TelescopePreviewMessage
--
--    " Used for Picker specific Results highlighting
--    highlight default link TelescopeResultsClass Function
--    highlight default link TelescopeResultsConstant Constant
--    highlight default link TelescopeResultsField Function
--    highlight default link TelescopeResultsFunction Function
--    highlight default link TelescopeResultsMethod Method
--    highlight default link TelescopeResultsOperator Operator
--    highlight default link TelescopeResultsStruct Struct
--    highlight default link TelescopeResultsVariable SpecialChar
--
--    highlight default link TelescopeResultsLineNr LineNr
--    highlight default link TelescopeResultsIdentifier Identifier
--    highlight default link TelescopeResultsNumber Number
--    highlight default link TelescopeResultsComment Comment
--    highlight default link TelescopeResultsSpecialComment SpecialComment
--
--    " Used for git status Results highlighting
--    highlight default link TelescopeResultsDiffChange DiffChange
--    highlight default link TelescopeResultsDiffAdd DiffAdd
--    highlight default link TelescopeResultsDiffDelete DiffDelete
--    highlight default link TelescopeResultsDiffUntracked NonText

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
--    index          = 'TelescopeAreciboNumber',
--    url            = 'TelescopeAreciboUrl',
--    prompt_default = 'TelescopePromptPrefix',
--    prompt_query   = 'TelescopeAreciboPrompt',
--   OctoDirty	ErrorMsg
--   OctoIssueTitle	PreProc
--   OctoIssueId	Question
--   OctoEmpty	Comment
--   OctoFloat	NormalNC
--   OctoDate	Comment
--   OctoSymbol	Comment
--   OctoTimelineItemHeading	Comment
--   OctoDetailsLabel	Title
--   OctoMissingDetails	Comment
--   OctoDetailsValue	Identifier
--   OctoDiffHunkPosition	NormalFloat
--   OctoCommentLine	TabLineSel
--   OctoEditable	NormalFloat
--   OctoViewer	GitHub color
--   OctoBubble	NormalFloat
--   OctoBubbleGreen	GitHub color
--   OctoBubbleRed	GitHub color
--   OctoUser	OctoBubble
--   OctoUserViewer	OctoViewer
--   OctoReaction	OctoBubble
--   OctoReactionViewer	OctoViewer
--   OctoPassingTest	GitHub color
--   OctoFailingTest	GitHub color
--   OctoPullAdditions	GitHub color
--   OctoPullDeletions	GitHub color
--   OctoPullModifications	GitHub color
--   OctoStateOpen	GitHub color
--   OctoStateClosed	GitHub color
--   OctoStateMerge	GitHub color
--   OctoStatePending	GitHub color
--   OctoStateApproved	OctoStateOpen
--   OctoStateChangesRequested	OctoStateClosed
--   OctoStateCommented	Normal
--   OctoStateDismissed	OctoStateClosed
  }
end)
return spec

-- -- +----------------------+
-- -- + Treesitter
-- -- +----------------------+
-- TSStrike  {},
-- TSUnderline  {},
-- TSAnnotation = { fg = clrs.nord12 }, -- For C++/Dart attributes, annotations thatcan be attached to the code to denote some kind of meta information.
-- TSCharacter = { fg = clrs.nord14 }, -- For characters.
-- TSConstructor = { fg = clrs.nord9 }, -- For constructor calls and definitions: `= { }` in Lua, and Java constructors.
-- TSConstant = { fg = clrs.nord13 }, -- For constants
-- TSFloat = { fg = clrs.nord15 }, -- For floats
-- TSNumber = { fg = clrs.nord15 }, -- For all number
-- TSString = { fg = clrs.nord14 }, -- For strings.
-- -- TSAnnotation =              { fg = clrs.nord11 },    -- For C++/Dart attributes, annotations that can be attached to the code to denote some kind of meta information.
-- TSAttribute = { fg = clrs.nord15 }, -- (unstable) TODO: docs
-- TSBoolean = { fg = clrs.nord9 }, -- For booleans.
-- -- TSCharacter=                { fg = clrs.nord12 },    -- For characters.
-- -- TSConstructor =             { fg = clrs.nord9 }, -- For constructor calls and definitions: `= { }` in Lua, and Java constructors.
-- -- TSConstant =                { fg = clrs.nord15 },    -- For constants
-- TSConstBuiltin = { fg = clrs.nord7 }, -- For constant that are built in the language: `nil` in Lua.
-- TSConstMacro = { fg = clrs.nord7 }, -- For constants that are defined by macros: `NULL` in C.
-- TSError = { fg = clrs.error }, -- For syntax/parser errors.
-- TSException = { fg = clrs.nord15 }, -- For exception related keywords.
-- TSField = { fg = clrs.gray }, -- For fields.
-- -- TSFloat =                   { fg = clrs.nord11 },    -- For floats.
-- TSFuncMacro = { fg = clrs.nord7 }, -- For macro defined fuctions (calls and definitions): each `macro_rules` in Rust.
-- TSInclude = { fg = clrs.nord9 }, -- For includes: `#include` in C, `use` or `extern crate` in Rust, or `require` in Lua.
-- TSLabel = { fg = clrs.nord15 }, -- For labels: `label:` in C and `:label:` in Lua.
-- TSNamespace = { fg = clrs.nord4 }, -- For identifiers referring to modules and namespaces.
-- -- TSNone =                    { },    -- TODO: docs
-- -- TSNumber =                  { fg = clrs.nord12 },    -- For all numbers
-- TSOperator = { fg = clrs.nord9 }, -- For any operator: `+`, but also `->` and `*` in C.
-- TSParameter = { fg = clrs.nord10 }, -- For parameters of a function.
-- TSParameterReference = { fg = clrs.nord10 }, -- For references to parameters of a function.
-- TSProperty = { fg = clrs.nord10 }, -- Same as `TSField`.
-- TSPunctDelimiter = { fg = clrs.nord8 }, -- For delimiters ie: `.`
-- TSPunctBracket = { fg = clrs.nord8 }, -- For brackets and parens.
-- TSPunctSpecial = { fg = clrs.nord8 }, -- For special punctutation that does not fall in the catagories before.
-- -- TSString =                  { fg = clrs.nord14 },    -- For strings.
-- TSStringRegex = { fg = clrs.nord7 }, -- For regexes.
-- TSStringEscape = { fg = clrs.disabled }, -- For escape characters within a string.
-- TSSymbol = { fg = clrs.nord15 }, -- For identifiers referring to symbols or atoms.
-- TSType = { fg = clrs.nord9 }, -- For types.
-- TSTypeBuiltin = { fg = clrs.nord9 }, -- For builtin types.
-- TSTag = { fg = clrs.nord4 }, -- Tags like html tag names.
-- TSTagDelimiter = { fg = clrs.nord15 }, -- Tag delimiter like `<` `>` `/`
-- TSText = { fg = clrs.text }, -- For strings considenord11 text in a markup language.
-- TSTextReference = { fg = clrs.nord15 }, -- TODO: fixme
-- TSEmphasis = { fg = clrs.nord10 }, -- For text to be represented with emphasis.
-- TSUnderline = { fg = clrs.fg, bg = clrs.none }, -- For text to be represented with an underline.
-- TSStrike = {}, -- For strikethrough text.
-- TSTitle = { fg = clrs.nord10, bg = clrs.none, style = "bold" }, -- Text that is part of a title.
-- TSLiteral = { fg = clrs.fg }, -- Literal text.
-- TSURI = { fg = clrs.link }, -- Any URI like a link or email.
-- TSComment = { fg = clrs.nord3_bright },
-- TSConditional = { fg = clrs.nord9 }, -- For keywords related to conditionnals.
-- TSKeyword = { fg = clrs.nord9 }, -- For keywords that don't fall in previous categories.
-- TSRepeat = { fg = clrs.nord9 }, -- For keywords related to loops.
-- TSKeywordFunction = { fg = clrs.nord8 },
-- TSFunction = { fg = clrs.nord8 }, -- For fuction (calls and definitions).
-- TSMethod = { fg = clrs.nord7 }, -- For method calls and definitions.
-- TSFuncBuiltin = { fg = clrs.nord8 },
-- TSVariable = { fg = clrs.accent },
-- -- Any variable name that does not have another highlight.
-- TSVariableBuiltin = { fg = clrs.accent },


-- -- LspTrouble
-- LspTroubleText = { fg = clrs.text },
-- LspTroubleCount = { fg = clrs.nord9, bg = clrs.active },
-- LspTroubleNormal = { fg = clrs.fg, bg = clrs.sidebar },
-- -- Diff

-- diffAdded = { DiffAdd },
-- diffChanged = { DiffChange },
-- diffRemoved = { DiffDelete },
-- diffLine = { DiffText },
-- diffFile = { DiffText },
-- " call s:X("DiffAdd","","001000","","","DarkGreen")
-- call s:X("DiffAdd","","00361f","","","DarkGreen")
-- " call s:X("DiffDelete","","300000","","","DarkRed")
-- " call s:X("DiffChange","","001030","","","DarkBlue")
-- " call s:X("DiffText","","001030","italic","","")

-- DiffAdd {
--   fg = clrs.nord14,
--   bg = cfg.nord_uniform_diff_background == 0 and clrs.nord0 or clrs.nord1,
--   gui = spec.inverse,
-- },
-- DiffChange {
--   fg = clrs.nord13,
--   bg = cfg.nord_uniform_diff_background == 0 and clrs.nord0 or clrs.nord1,
--   gui = spec.inverse,
-- },
-- DiffDelete {
--   fg = clrs.nord11,
--   bg = cfg.nord_uniform_diff_background == 0 and clrs.nord0 or clrs.nord1,
--   gui = spec.inverse,
-- },
-- DiffText {
--   fg = clrs.nord9,
--   bg = cfg.nord_uniform_diff_background == 0 and clrs.nord0 or clrs.nord1,
--   gui = spec.inverse,
-- },


-- gitDiff, gitcommitDiff, gitDiffMerge, gitDiffRemoved
-- DiffAdd        xxx ctermbg=4 guibg=#00361f
-- DiffviewDiffAddAsDelete xxx guibg=#3E0009
--
-- DiffviewDim1   xxx guifg=#495a74
-- DiffviewPrimary xxx guifg=#6e99c6
-- DiffviewNormal xxx links to Normal
-- DiffviewSecondary xxx guifg=#5679b3
-- DiffviewNonText xxx links to NonText
-- DiffviewSignColumn xxx links to Normal
-- DiffviewDiffDelete xxx links to Comment
-- DiffviewFolderSign xxx links to PreProc
-- DiffviewVertSplit xxx links to VertSplit
-- DiffviewDiffAddAsDelete xxx guibg=#3E0009
-- DiffviewFolderName xxx links to Directory
-- DiffviewCursorLine xxx links to CursorLine
-- DiffviewStatusLine xxx links to StatusLine
-- DiffviewStatusAdded xxx links to diffAdded
-- DiffviewFilePanelPath xxx links to Comment
-- DiffviewStatusIgnored xxx links to Comment
-- DiffviewFilePanelFileName xxx guifg=#8396B9
-- DiffviewEndOfBuffer xxx links to EndOfBuffer
-- DiffviewStatusCopied xxx links to diffChanged
-- DiffviewStatusBroken xxx links to diffRemoved
-- DiffviewStatusRenamed xxx links to diffChanged
-- DiffviewStatusLineNC xxx links to StatusLineNC
-- DiffviewStatusUntracked xxx links to diffAdded
-- DiffviewStatusDeleted xxx links to diffRemoved
-- DiffviewStatusUnknown xxx links to diffRemoved
-- DiffviewStatusModified xxx links to diffChanged
-- DiffviewStatusUnmerged xxx links to diffChanged
-- DiffviewFilePanelTitle xxx gui=bold guifg=#187298
-- DiffviewStatusTypeChange xxx links to diffChanged
-- DiffviewFilePanelInsertions xxx links to diffAdded
-- DiffviewFilePanelCounter xxx gui=bold guifg=#6e99c6
-- DiffviewFilePanelDeletions xxx links to diffRemoved
-- DiffviewFilePanelRootPath xxx links to
-- DiffviewFilePanelTitle
-- DiffviewDim1   xxx guifg=#495a74 DiffviewPrimary xxx guifg=#6e99c6 DiffviewNormal xxx links to Normal DiffviewSecondary xxx guifg=#5679b3 DiffviewNonText xxx links to NonText DiffviewSignColumn xxx links to Normal DiffviewDiffDelete xxx links to Comment DiffviewFolderSign xxx links to PreProc DiffviewVertSplit xxx links to VertSplit DiffviewDiffAddAsDelete xxx guibg=#3E0009 DiffviewFolderName xxx links to Directory DiffviewCursorLine xxx links to CursorLine DiffviewStatusLine xxx links to StatusLine DiffviewStatusAdded xxx links to diffAdded DiffviewFilePanelPath xxx links to Comment DiffviewStatusIgnored xxx links to Comment DiffviewFilePanelFileName xxx guifg=#8396B9 DiffviewEndOfBuffer xxx links to EndOfBuffer gitDiff        xxx cleared gitDiffMerge   xxx cleared gitcommitDiff  xxx cleared

-- -- Neogit
-- NeogitBranch = { fg = clrs.nord10 },
-- NeogitRemote = { fg = clrs.nord9 },
-- NeogitHunkHeader = { fg = clrs.fg, bg = clrs.highlight },
-- NeogitHunkHeaderHighlight = { fg = clrs.nord7, bg = clrs.contrast },
-- NeogitDiffContextHighlight = { fg = clrs.bg_alt, bg = clrs.contrast },
-- NeogitDiffDeleteHighlight = { fg = clrs.nord11 },
-- NeogitDiffAddHighlight = { fg = clrs.nord14 },
-- -- GitGutter
-- GitGutterAdd = { fg = clrs.nord14 }, -- diff mode: Added line |diff.txt|
-- GitGutterChange = { fg = clrs.nord15 }, -- diff mode: Changed line |diff.txt|
-- GitGutterDelete = { fg = clrs.nord11 }, -- diff mode: Deleted line |diff.txt|
-- -- GitSigns
-- GitSignsAdd = { fg = clrs.nord14 }, -- diff mode: Added line |diff.txt|
-- GitSignsAddNr = { fg = clrs.nord14 }, -- diff mode: Added line |diff.txt|
-- GitSignsAddLn = { fg = clrs.nord14 }, -- diff mode: Added line |diff.txt|
-- GitSignsChange = { fg = clrs.nord15 }, -- diff mode: Changed line |diff.txt|
-- GitSignsChangeNr = { fg = clrs.nord15 }, -- diff mode: Changed line |diff.txt|
-- GitSignsChangeLn = { fg = clrs.nord15 }, -- diff mode: Changed line |diff.txt|
-- GitSignsDelete = { fg = clrs.nord11 }, -- diff mode: Deleted line |diff.txt|
-- GitSignsDeleteNr = { fg = clrs.nord11 }, -- diff mode: Deleted line |diff.txt|
-- GitSignsDeleteLn = { fg = clrs.nord11 }, -- diff mode: Deleted line |diff.txt|
-- -- Telescope
-- TelescopePromptBorder = { fg = clrs.nord8 },
-- TelescopeResultsBorder = { fg = clrs.nord9 },
-- TelescopePreviewBorder = { fg = clrs.nord14 },
-- TelescopeSelectionCaret = { fg = clrs.nord9 },
-- TelescopeSelection = { fg = clrs.nord9 },
-- TelescopeMatching = { fg = clrs.nord8 },
-- TelescopeNormal = { fg = clrs.fg, bg = clrs.float },
-- -- NvimTree
-- NvimTreeRootFolder = { fg = clrs.nord7, style = "bold" },
-- NvimTreeGitDirty = { fg = clrs.nord15 },
-- NvimTreeGitNew = { fg = clrs.nord14 },
-- NvimTreeImageFile = { fg = clrs.nord15 },
-- NvimTreeExecFile = { fg = clrs.nord14 },
-- NvimTreeSpecialFile = { fg = clrs.nord9, style = spec.underline },
-- NvimTreeFolderName = { fg = clrs.nord10 },
-- NvimTreeEmptyFolderName = { fg = clrs.disabled },
-- NvimTreeFolderIcon = { fg = clrs.accent },
-- NvimTreeIndentMarker = { fg = clrs.disabled },
-- -- WhichKey
-- WhichKey = { fg = clrs.accent, style = "bold" },
-- WhichKeyGroup = { fg = clrs.text },
-- WhichKeyDesc = { fg = clrs.nord7, style = "italic" },
-- WhichKeySeperator = { fg = clrs.fg },
-- WhichKeyFloating = { bg = clrs.float },
-- WhichKeyFloat = { bg = clrs.float },
-- -- LspSaga
-- DiagnosticError = { fg = clrs.error },
-- DiagnosticWarning = { fg = clrs.nord15 },
-- DiagnosticInformation = { fg = clrs.nord10 },
-- DiagnosticHint = { fg = clrs.nord9 },
-- DiagnosticTruncateLine = { fg = clrs.fg },
-- LspFloatWinNormal = { bg = clrs.contrast },
-- LspFloatWinBorder = { fg = clrs.nord9 },
-- LspSagaBorderTitle = { fg = clrs.nord8 },
-- LspSagaHoverBorder = { fg = clrs.nord10 },
-- LspSagaRenameBorder = { fg = clrs.nord14 },
-- LspSagaDefPreviewBorder = { fg = clrs.nord14 },
-- LspSagaCodeActionBorder = { fg = clrs.nord7 },
-- LspSagaFinderSelection = { fg = clrs.nord14 },
-- LspSagaCodeActionTitle = { fg = clrs.nord10 },
-- LspSagaCodeActionContent = { fg = clrs.nord9 },
-- LspSagaSignatureHelpBorder = { fg = clrs.nord13 },
-- ReferencesCount = { fg = clrs.nord9 },
-- DefinitionCount = { fg = clrs.nord9 },
-- DefinitionIcon = { fg = clrs.nord7 },
-- ReferencesIcon = { fg = clrs.nord7 },
-- TargetWord = { fg = clrs.nord8 },
