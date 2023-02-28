---@diagnostic disable
--luacheck: ignore

local lush = require("lush")
local hsl = lush.hsl

tokyoColors = {
  none = "NONE",
  bg_dark = "#1c1f24",
  bg = "#24283b",
  bg_highlight = "#292e42",
  terminal_black = "#414868",
  fg = "#c0caf5",
  fg_dark = "#a9b1d6",
  fg_gutter = "#3b4261",
  dark3 = "#545c7e",
  comment = "#565f89",
  dark5 = "#737aa2",
  blue0 = "#3d59a1",
  blue = "#7aa2f7",
  cyan = "#7dcfff",
  blue1 = "#2ac3de",
  blue2 = "#0db9d7",
  blue5 = "#89ddff",
  blue6 = "#B4F9F8",
  blue7 = "#394b70",
  magenta = "#bb9af7",
  magenta2 = "#ff007c",
  purple = "#9d7cd8",
  orange = "#ff9e64",
  yellow = "#e0af68",
  green = "#9ece6a",
  green1 = "#73daca",
  green2 = "#41a6b5",
  teal = "#1abc9c",
  red = "#f7768e",
  red1 = "#db4b4b",
  git = { change = "#6183bb", add = "#449dab", delete = "#914c54", conflict = "#bb7a61" },
  gitSigns = { add = "#164846", change = "#394b70", delete = "#823c41" },
}

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
  nord13 = hsl(20, 10, 55), -- #EBCA89
  -- nord14 = hsl(92, 28, 65), -- #A4BF8D
  nord14 = "#22BB99",
  -- nord15 = hsl(311, 20, 63), -- #B48EAD
  nord15 = "#646EAD",
  nord16 = "#56a9b3",
  none = "NONE",
  highlight = "#1F2233",
  disabled = "#464B5D",
  accent = "#84FFFF",
  error = "#aa3049",
}

local clr_over = {
  -- selection = "#2F3243",
  -- -selection = "#0f2a56",
  selection = "#1c1f40",
  orange_faded = "#80788a",
  orange = "#cc8877",
  yellow = "#bdb994",
  yellow_faded = "#7B6B3B",
  purple_faded = "#6A6CAB",
  red_faded = "#7F212A",
  green_faded = "#128A67",
  blue_faded = "#5171A1",
}

return function(injected_functions)
  local sym = injected_functions.sym
  return {
    Visual({ fg = "none", bg = clr_over.selection }),
    Error({ fg = clrs.error, bg = "none" }),
    -- Error({ fg = "none", bg = "none" }),
    Underline({ gui = "underline" }),
    Normal({ fg = clrs.nord4.darken(30), bg = "none" }),
    -- ui components
    NormalWindow({ fg = Normal.fg, bg = "none" }),
    NormalFloat({ fg = "#8f93a2", bg = "none" }), -- normal text and background color for floating windows
    FloatBorder({ fg = "#3f5382", bg = "none" }), --
    FloatTitle({ fg = "#5f73c2", bg = "none" }), --
    Pmenu({ fg = "#618cc4", bg = "none" }),
    PmenuSel({ fg = "#44bfcf", bg = "#1a1f2f" }),
    PmenuSbar({ fg = "#313c84", bg = "#202331" }),
    PmenuThumb({ fg = "#4f5362", bg = "#446faf" }),
    WinBar({ fg = "#313c84", bg = "#202331" }),
    WinBarNC({ fg = "#4f5362", bg = "#446faf" }),
    WinBarLocation({ fg = "#888888", bg = "#202331", gui = "bold" }),
    WinBarModified({ fg = "#d7d787", bg = "#202331", gui = "bold" }),
    WinBarGitDirty({ fg = "#d7afd7", bg = "#202331", gui = "bold" }),
    WinBarIndicator({ fg = "#5fafd7", bg = "#202331", gui = "bold" }),
    WinBarInactive({ bg = "#3a3a3a", fg = "#777777", gui = "bold" }),
    SignColumn({ bg = "none" }),
    LineNr({ fg = clrs.nord3 }),
    Boolean({ fg = "#6370c5" }),
    CursorLine({ bg = "#101018", gui = "none" }),
    CursorLineNr({ fg = "#44aaff", bg = CursorLine.bg, gui = "italic" }),
    CursorColumn({ bg = "#7722ff" }),
    ColorColumn({ bg = CursorLine.bg }),
    -- base groups
    Conceal({ bg = "none" }),
    Conditional({ fg = clr_over.orange_faded }),
    Constant({ fg = clrs.nord16 }),
    Delimiter({ fg = "#5f6fa2" }),
    Directory({ fg = "#187298" }),
    -- FoldIcon({ fg = "#4B4BBB" }),
    FoldColumn({ fg = "#4D578A", bg = "#000000" }),
    FoldText({ fg = "#41b1ff", gui = "bold" }),
    Folded({ fg = "#6Db7ca", bg = "#111111", gui = "bold" }),
    -- Function({ fg = "#988088" }),
    Function({ fg = "#908088" }),
    Identifier({ fg = "#6e99c6" }),
    Include({ fg = "#4784a6" }),
    IncSearch({ fg = "#eceff4", bg = "#5d61ec" }),
    Label({ fg = "#6688ba" }),
    Keyword({ fg = "#6177b2" }),
    MatchParen({ fg = "#60a0a0", bg = "#000022" }),
    MatchParenCursor({ fg = "#a0c0b0" }),
    NonText({ bg = "none", fg = "#555555" }),
    Operator({ fg = "#4886bf" }),
    PreProc({ fg = "#4796bc" }),
    QuickFixLine({ bg = "#172238" }),
    Scrollbar({ bg = "#111111", fg = "#334863" }),
    Search({ fg = "#74efff", bg = "#0d314c", gui = "NONE" }),
    Special({ fg = "#487ac8" }),
    SpecialChar({ fg = "#b88698" }), -- For special punctutation that does not fall in the catagories before.
    Statement({ fg = "#5191C1" }),
    String({ fg = "#00a0a9" }),
    Structure({ fg = "#5D81AC" }),
    Type({ fg = "#418cc4" }),
    Variable({ Normal }),
    VertSplit({ fg = "#444464", bg = "#090909", gui = "bold" }),
    VisualNOS({ fg = "none", bg = clr_over.selection }),
    healthError({ fg = "#BE6069", bg = "none" }),
    healthSuccess({ fg = "#22BB99", bg = "none" }),
    healthWarning({ fg = "#EBCA89", bg = "none" }),
    qfFilename({ Directory }),
    -- qfLineNr { LineNr },
    -- qfError { Error },
    -- qfSeparator { },

    -- +--- Prompt/Status ---+
    EndOfBuffer({ fg = clrs.nord1 }),
    ErrorMsg({ Error }),
    WarningMsg({ fg = clrs.nord13 }),
    ModeMsg({ fg = clrs.nord10 }),
    MoreMsg({ fg = clrs.nord8, gui = "bold" }),
    DebugMsg({ fg = Comment.fg }),
    Question({ fg = clrs.nord4 }),
    -- +--- LSP ---+
    LspFloatWinBorder({ bg = "none", fg = "#333333" }),
    LspCodeLens({ fg = "#6272A4" }),
    LspCodeLensSeparator({ fg = "#7F8CB5" }),
    DiagnosticError({ fg = clrs.nord11.da(30) }),
    DiagnosticWarn({ fg = clrs.nord13.da(30) }),
    DiagnosticHint({ fg = clrs.nord8.da(50) }),
    DiagnosticInfo({ fg = clrs.nord10 }),
    DiagnosticVirtualTextError({ fg = DiagnosticError.fg.da(20), gui = "italic" }),
    DiagnosticVirtualTextWarn({ fg = DiagnosticWarn.fg, gui = "italic" }),
    DiagnosticVirtualTextHint({ fg = DiagnosticHint.fg, gui = "italic" }),
    DiagnosticVirtualTextInfo({ fg = DiagnosticInfo.fg, gui = "italic" }),
    LspDiagnosticsDefaultError({ DiagnosticError }),
    LspDiagnosticsDefaultWarn({ DiagnosticWarn }),
    LspDiagnosticsDefaultHint({ DiagnosticHint }),
    LspDiagnosticsDefaultInfo({ DiagnosticInfo }),
    LspDiagnosticsSignError({ fg = DiagnosticError.fg.da(20) }),
    LspDiagnosticsSignWarn({ fg = DiagnosticWarn.fg.da(20) }),
    LspDiagnosticsSignHint({ fg = DiagnosticHint.fg.da(20) }),
    LspDiagnosticsSignInfo({ fg = DiagnosticInfo.fg.da(20) }),
    LspReferenceRead({ fg = Search.fg, gui = "none" }), -- #22bb99, 628bff
    LspReferenceWrite({ fg = Search.fg, gui = "none" }), -- #22bb99
    LspReferenceText({ fg = Search.fg, gui = "none" }), -- #22bb99
    DiffAdd({ bg = "#00361f" }), -- #00361f #001000 #22bb99
    DiffChange({ bg = "#003050" }), -- #003050 #001030 #646ead
    DiffDelete({ bg = "#3E0009" }), -- #3e0009 #300000 #be6069
    DiffText({ gui = "italic", fg = "#464b5d" }), -- #464b5d #001030 #81a1c1
    diffAdded({ fg = clrs.nord14 }),
    diffRemoved({ fg = clrs.nord11 }),
    diffChanged({ fg = clrs.nord15 }),
    diffOldFile({ fg = clrs.nord9 }),
    diffNewFile({ fg = clrs.nord12 }),
    diffFile({ fg = clrs.nord7 }),
    diffLine({ fg = "#464B5D" }),
    diffIndexLine({ fg = clrs.nord9 }),
    --
    -- language groups
    --
    TreesitterContext({ bg = "#1a0606", gui = "italic" }),

    sym("@include")({ Include }),
    sym("@boolean")({ Boolean }),
    sym("@conditional")({ Conditional }),
    -- sym("@conditional")({ fg = "#80788a" }),
    sym("@exception")({ Special }),
    sym("@error")({ Normal }),
    sym("@function")({ Function }),
    sym("@function.call")({ Function }),
    sym("@keyword")({ Keyword }),
    sym("@keyword.operator")({ Operator }),
    sym("@keyword.return")({ Statement }),
    sym("@keywordFunction")({ Function }),
    sym("@label")({ Label }), -- For labels: `label:` in C and `:label:` in Lua.
    sym("@method")({ Function }),
    sym("@method.call")({ Function }),
    sym("@nameSpace")({ Statement }),
    sym("@operator")({ Operator }),
    sym("@property")({ Identifier }),
    sym("@punct.bracket")({ fg = "#888698" }),
    sym("@punct.special")({ fg = "#888698" }),
    sym("@tag")({ fg = clr_over.orange }),
    sym("@tag.delimiter")({ fg = clr_over.orange }),
    sym("@text.literal")({ gui = "none" }),
    -- sym("@type")({ fg = "#6595f8" }),
    -- sym("@type.builtin")({ fg = "#89DDFF" }),
    sym("@uri")({ fg = "#8eb9f6", gui = "none" }),
    sym("@variable")({ Variable }),
    sym("@variable.builtin")({ Identifier }),
    -- luaTSFunction({ TSMethod }),

    typescriptImport({ Include }),
    typescriptVariable({ Identifier }),
    -- typescriptAsyncFuncKeyword({ Keyword }),
    typescriptIdentifierName({ Variable }),
    typescriptTypeReference({ Operator }),
    typescriptTypeBrackets({ fg = "#3BaBcB", gui = "bold" }),

    cssTSType({ fg = "#486795" }),
    cssTSPunctDelimiter({ fg = "#4784a6" }),
    cssTSProperty({ fg = "none" }),
    cssTSNumber({ fg = "none" }),
    cssClassName({ fg = "#5780a6" }),
    cssIdentifier({ fg = "#4770a6" }),
    cssDefinition({ fg = "#6898c6" }),
    cssCommonAttr({ fg = "#6784d5" }),
    cssValueLength({ fg = "#0786bc" }),
    cssValueNumber({ cssValueLength }),
    cssColor({ cssValueLength }),
    cssUnitDecorators({ cssValueLength }),
    --
    manSectionHeading({ fg = "#6595f8" }),
    manReference({ fg = "#4796bc" }),
    -- manSubheading { Function  },
    -- manOptionDesc { Constant },
    --
    liquidExpression({ Type }),
    liquidDelimiter({ fg = clr_over.orange }),

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

    -- jsFunctionName({ fg = "#a78086" }),
    jsxTag({ fg = clr_over.orange }),
    -- jsxComponentName({ fg = clr_over.orange }),
    jsxTagName({ fg = clr_over.orange }),
    jsxOpenTag({ fg = clr_over.orange }),
    jsxCloseTag({ fg = "#7f90aa" }),
    -- jsxCloseString {fg = "#ff6600"},
    jsxAttrib({ fg = "#88bbdd" }),
    jsxEqual({ fg = "#6699bb" }),
    -- BufferInactiveIndex { bg = "#000000" },
    -- BufferInactive  { bg = "#000000" },
    jsonKeyword({ fg = "#446688" }),
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
    shBrackets({ fg = clr_over.orange }),
    shStatement({ Keyword }),
    shSubst({ fg = "#488aaf" }),
    shSubstDelim({ fg = "#5776bc" }),
    shParentheses({ fg = "#c78087" }),
    shFunction({ Function }),
    shDeref({ fg = "#488aaf" }),
    shDerefSimple({ fg = "#488aaf" }),
    shLoop({ fg = "#80788a" }),
    shRepeat({ fg = "#80788a" }),
    shConditional({ fg = "#80788a" }),
    shVariable({ Normal }),
    zshBrackets({ fg = clr_over.orange }),
    zshSubst({ fg = "#488aaf" }),
    zshSubstDelim({ fg = "#5776bc" }),
    zshParentheses({ fg = "#c78087" }),
    zshFunction({ fg = "#a78087" }),
    zshDeref({ fg = "#488aaf" }),
    zshRepeat({ fg = "#80788a" }),
    zshLoop({ fg = "#80788a" }),
    zshConditional({ fg = "#80788a" }),
    zshCommands({ fg = "#6180b2" }),
    ZinitForCommand({ fg = "#a78087" }),
    ZinitPlugin({ fg = "#5588fd", gui = "italic" }), -- Macro, Define
    ZinitSnippet({ fg = "#95b5ed" }), -- Macro, Define
    ZinitIce({ fg = "#87a9ff", gui = "bold" }), -- Type
    Zinitcommand({ fg = "#a78087" }),
    ZinitContinue({ fg = "#4878a8" }),
    ZinitIceDoubleQuoteParam({ fg = "#30b0d9" }), -- Special
    ZinitIceSingleQuoteParam({ fg = "#30c0e9" }),
    yamlTSField({ fg = "#717cb4" }),
    yamlBlockMappingKey({ yamlTSField }),
    -- html
    -- markdownH {},
    -- markdownTSTitle {},
    htmlH1({ fg = "#45a5f8" }),
    htmlH2({ fg = "#45a5e8" }),
    htmlH3({ fg = "#45a5d8" }),
    htmlH4({ fg = "#45a5c8" }),
    htmlH5({ fg = "#45a5b8" }),
    htmlH6({ fg = "#45a5a8" }),
    htmlEndTag({ fg = "#7f90aa" }),
    htmlTagN({ fg = clr_over.orange }),
    CSVColumnHeaderOdd({ String }),
    CSVColumnHeaderEven({ fg = Statement.fg, bg = "none" }),
    markdownH1({ fg = "#45a5f8" }),
    markdownH2({ fg = "#45a5e8" }),
    markdownH3({ fg = "#45a5d8" }),
    markdownH4({ fg = "#45a5c8" }),
    markdownH5({ fg = "#45a5b8" }),
    markdownH6({ fg = "#45a5a8" }),
    mkdHeading({ fg = "#557588" }),
    markdownLinkText({ fg = "#00ccff" }),
    pandocDelimitedCodeBlock({ gui = "none" }),
    pandocStrikeout({ gui = "strikethrough" }),
    pandocEmphasis({ gui = "italic", fg = "#bbbbcc" }),
    pandocStrong({ gui = "bold", fg = "#ddddee" }),
    -- pandocReferenceLabel { gui = "none", fg = clr_over.orange },
    pandocListItemBullet({ fg = "#66a8dc" }),
    pandocListItemBulletId({ fg = "#66a8dc" }),
    pandocOperator({ bg = "none", fg = "#aa6600" }),
    -- pandocListItem {},
    -- pandocUListItem { gui = "none", bg = "none", fg = "#aa6600" },
    -- pandocReferenceDefinition { fg = "#7788ff", bg = "none" },
    -- pandocAtxHeader { fg = "#4575b8" },
    pandocPipeTable({ fg = "#4789aa" }),
    pandocPipeTableDelims({ fg = "#555577" }),
    pandocNoFormatted({ bg = "none" }),
    pandocReferenceDefinition({ fg = "#4488cc", bg = "none" }),
    pandocAtxHeader({ fg = "#8595f8" }),
    pandocAtxHeaderMark({ fg = "#4575f8" }),
    pandocAtxStart({ fg = "#4575f8" }),
    helpHyperTextJump({ fg = "#6585b8" }),
    --
    InfoWindowFloat({ fg = "#2886bf", bg = "none" }),
    BqfPreviewFloat({ Normal }),
    BqfPreviewBorder({ Normal }),
    -- BqfPreviewCursor { Cursor },
    BqfPreviewRange({ IncSearch }),
    BqfSign({ fg = "cyan" }),
    -- zshVariableDef { Normal },
    -- zshDeref { fg = '#2886bf' },
    lsp_markdown1({ Normal }),
    DashboardHeader({ fg = "#8AFF80" }),
    DashboardKey({ fg = "#FF9580" }),
    DashboardDesc({ fg = "#87FEF8" }),
    DashboardIcon({ fg = "#FCFC7F" }),
    DashboardShortCut({ fg = TokyoColors.cyan }),
    DashboardFooter({ fg = "#5D5D65" }),
    -- DashboardHeader ({ fg = colors.blue }),
    -- DashboardCenter ({ fg = colors.purple }),
    -- DashboardFooter ({ fg = colors.green, gui = "italic" }),
    -- NavicIconsFile({}),
    -- NavicIconsModule({}),
    -- NavicIconsNamespace({}),
    -- NavicIconsPackage({}),
    -- NavicIconsClass({}),
    -- NavicIconsMethod({}),
    -- NavicIconsProperty({}),
    -- NavicIconsField({}),
    -- NavicIconsConstructor({}),
    -- NavicIconsEnum({}),
    -- NavicIconsInterface({}),
    -- NavicIconsFunction({}),
    -- NavicIconsVariable({}),
    -- NavicIconsConstant({}),
    -- NavicIconsString({}),
    -- NavicIconsNumber({}),
    -- NavicIconsBoolean({}),
    -- NavicIconsArray({}),
    -- NavicIconsObject({}),
    -- NavicIconsKey({}),
    -- NavicIconsNull({}),
    -- NavicIconsEnumMember({}),
    -- NavicIconsStruct({}),
    -- NavicIconsEvent({}),
    -- NavicIconsOperator({}),
    -- NavicIconsTypeParameter({}),
    -- NavicText({}),
    -- NavicSeparator({}),
    -- dashboardn.vim
    --DashboardHeader {Type},
    -- DashboardCenter({ fg = "#4499ff" }),
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
