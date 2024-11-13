---@diagnostic disable
--luacheck: ignore

local lush = require("lush")
local hsl = lush.hsl
local clrutil = require("utils.colors")
-- Title          xxx cterm=bold gui=bold guifg=#82aaff
-- Visual         xxx guibg=#2d3f76
-- VisualNC       xxx cleared
-- WildMenu       xxx guibg=#2d3f76
-- Folded         xxx guifg=#82aaff guibg=#3b4261
-- FoldColumn     xxx guifg=#636da6 guibg=#222436
-- DiffAdd        xxx guibg=#273849
-- DiffChange     xxx guibg=#252a3f
-- DiffDelete     xxx guibg=#3a273a
-- DiffText       xxx guibg=#394b70

local tokyoColors = {
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
  purple = "#7d7cf8",
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

local colors = {
  fg = "#A8C0E0",
  fg_light = "#E5E9F0",
  bg_dark = "#1c1f24",
  bg = "#2E3440",
  gray = "#646A76",
  light_gray = "#6C7A96",
  cyan = "#88C0D0",
  blue = "#81A1C1",
  dark_blue = "#5E81AC",
  green = "#A3BE8C",
  light_green = "#8FBCBB",
  dark_red = "#BF616A",
  red = "#D57780",
  light_red = "#DE878F",
  pink = "#E85B7A",
  dark_pink = "#E44675",
  orange = "#D08F70",
  yellow = "#EBCB8B",
  purple = "#B988B0",
  light_purple = "#B48EAD",
  none = "NONE",
  highlight = hsl("#101c39"),
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
  nord16 = "#3698b3",
  none = "NONE",
  highlight = "#1F2233",
  disabled = "#464B5D",
  accent = "#84FFFF",
  error = "#aa3049",
}

local clr_over = {
  selection = "#101840",
  orange_faded = "#80788a",
  orange = "#cc8877",
  yellow = "#bdb994",
  yellow_faded = "#7B6B3B",
  purple_faded = "#6A6CAB",
  red_faded = "#7F212A",
  green_faded = "#027A57",
  blue_faded = "#4161B1",
}

return function(injected_functions)
  local sym = injected_functions.sym
  return {
    -- CurSearch({ fg = '#cc2266', gui = 'bold' }), --  bg = '#110033'

    -- Search        xxx guifg=#d6deeb guibg=#38507a
    -- CurSearchxxx guifg=#011627 guibg=#f78c6c
    -- IncSearchxxx guifg=#011627 guibg=#ffcb8b
    -- Visual        xxx links to NightflyVisual
    -- VisualNOSxxx guifg=#c3ccdc guibg=#1d3b53
    -- Visual        xxx links to NightflyVisual
    -- VisualNOSxxx guifg=#c3ccdc guibg=#1d3b53
    -- NightflyVisualxxx guibg=#1d3b53
    -- WinBarxxx guifg=#c3ccdc guibg=#0e293f
    -- WinBarNCxxx guifg=#a1aab8 guibg=#0e293f

    Normal({ fg = "#667da9", bg = "none" }),
    NormalNC({ fg = "#465d89" }),
    SignColumn({ bg = "none" }),
    Search({ bg = "#0e1c36", fg = "#008fff", gui = "italic" }), -- bg = '#0d314c',
    IncSearch({ bg = "#23518b", fg = "#88aaff", gui = "italic" }),
    CurSearch({ bg = "#4e3ce6", fg = "#aaffff", gui = "bold" }), --  bg = '#110033'
    -- VisualNOS({ fg = 'none', bg = '#301840' }),
    -- Visual({ bg = '#171f47', fg = 'none', gui = 'italic' }),
    -- Visual({ bg = "#021626", gui = "bold,italic" }),
    Visual({ bg = "#08203f", gui = "bold,italic" }),
    VisualNOS({ bg = "#1d3b53" }),
    VisualAlt({ fg = "none", bg = "#10082f", gui = "italic" }),
    VisualRed({ fg = "none", bg = "#40112c", gui = "bold,italic" }),
    LineNr({ fg = "#2D476A" }),
    Error({ fg = clrs.error, bg = "none" }),
    -- Error({ fg = "none", bg = "none" }),
    -- ui components
    NormalWindow({ fg = Normal.fg, bg = "none" }),
    NormalFloat({ fg = Normal.fg, bg = "none" }), -- normal text and background color for floating windows
    Title({ fg = "#88aee9", gui = "NONE" }),
    FloatBorder({ fg = "#3f5382", bg = "none" }), --
    FloatTitle({ fg = "#5f73c2", bg = "none" }), --
    Pmenu({ fg = "#618cc4", bg = "none" }),
    PmenuSel({ fg = "#44bfcf", bg = "#1a1f2f" }),
    PmenuSbar({ fg = "#313c84", bg = "#202331" }),
    PmenuThumb({ fg = "#1f3352", bg = "#244f7f" }),
    -- TabLine({ fg = clrs.nord3, bg = clrs.nord1, gui = "NONE" }),
    -- TabLineFill({ fg = clrs.nord4, bg = clrs.nord1, gui = "NONE" }),
    -- TabLineSel({ fg = "#a6cfff", bg = "#213c64", gui = "bold" }),
    TabLine({ fg = "#616F89", bg = "#21242b", gui = "NONE" }),
    TabLineFill({ fg = "none", bg = "#1c1f24" }),
    TabLineSel({ fg = "#51afef", bg = "#282c34" }),
    WinSeparator({ fg = "#444464", bg = "#090909", gui = "bold" }),
    -- WinBar({ fg = "#313c84", bg = "#202331" }),
    -- WinBarNC({ fg = "#4f5362", bg = "#446faf" }),
    -- WinBarLocation({ fg = "#888888", bg = "#202331", gui = "bold" }),
    -- WinBarModified({ fg = "#d7d787", bg = "#202331", gui = "bold" }),
    -- WinBarGitDirty({ fg = "#d7afd7", bg = "#202331", gui = "bold" }),
    -- WinBarIndicator({ fg = "#5fafd7", bg = "#202331", gui = "bold" }),
    -- WinBarInactive({ bg = "#3a3a3a", fg = "#777777", gui = "bold" }),
    -- Cursor({ bg = '#3760bf' }), cursor = "0x5f36ff" text = "0xf1d1d1"
    Cursor({ bg = "#3f56ff" }),
    nCursor({ Cursor }),
    iCursor({ Cursor }),
    lCursor({ gui = "reverse" }), -- language mapping active
    -- Cursor({ bg = '#4B5Bff' }),
    -- NavbuddyCursor({ gui = 'bold' }),
    SpecsCursor({ bg = "#1f6385" }),
    SmoothCursor({ fg = "#0081ca", gui = "bold" }),
    -- NoiceCursor({ bg = '#4B6BfB' }),  #51e3ed
    NoiceCursor({ bg = "#003558", gui = "bold", fg = "#17a9b3" }),
    HopCursor({ Cursor }),
    ReactiveCursor({ Cursor }),
    -- ScrollViewCursorxxx links to WarningMsg
    -- MiniAnimateCursorxxx cterm=reverse,nocombine gui=reverse,nocombine
    -- CursorIMxxx cterm=reverse gui=reverse
    -- FlashCursor({Cursor})	-- cursor
    -- BqfPreviewCursor { Cursor },
    CursorColumn({ bg = "#061028" }),
    ColorColumn({ bg = "#061028" }),
    CursorLine({ bg = "#061028" }),
    CursorLineNr({ fg = "#44aaff", gui = "italic" }),
    -- CursorLine({ bg = '#0a1020' }),
    -- CursorLineNr({ fg = '#44aaff', bg = CursorLine.bg, gui = 'italic' }),
    -- CursorColumn({ bg = CursorLine.bg }),
    -- ColorColumn({ bg = CursorLine.bg }),
    StatusLine({ fg = "NONE", bg = "NONE" }),

    -- base groups
    -- FoldIcon({ fg = "#4B4BBB" }),
    -- MatchParenCursor({ fg = "#fb8b8b" }),
    Boolean({ fg = "#5370af" }),
    Number({ fg = "#4078c0" }),
    Character({ fg = "#10a4ca", gui = "bold" }),
    Comment({ fg = "#405f88", gui = "italic" }),
    Conceal({ bg = "none" }),
    Conditional({ fg = "#70688a" }),
    Constant({ fg = "#5599cc" }),
    ConstantBuiltin({ fg = "#0698b3" }),
    Delimiter({ fg = "#5f6fa2" }),
    Directory({ fg = "#187298" }),
    -- Field({ fg = '#4688B0' }),
    -- Field({ fg = '#467aB0' }),
    Field({ fg = "#467aB8" }),
    FoldColumn({ fg = "#4D578A", bg = "#000000" }),
    FoldText({ fg = "#41b1ff", gui = "bold" }),
    Folded({ fg = "#6Db7ca", bg = "#111111", gui = "bold" }),
    Function({ fg = "#2d79a7" }),
    FunctionCall({ fg = "#4d79c7" }),
    -- Function({ fg = '#8c788c' }),
    -- FunctionCall({ fg = '#7f788f' }),
    Identifier({ fg = "#4e73c6" }),
    Include({ fg = "#4774c6" }),
    Italic({ gui = "italic" }),
    Keyword({ fg = "#3167a2" }),
    KeywordFunction({ fg = "#2D88BF" }),
    KeywordReturn({ fg = "#2D81BC" }),
    Label({ fg = "#3377ba" }),
    NonText({ bg = "none", fg = "#556677" }),
    Operator({ fg = "#4866bf" }),
    -- Operator({ fg = '#28567f' }),
    -- PreProc({ fg = '#806a7f' }),
    PreProc({ fg = "#4796bc" }),
    QuickFixLine({ bg = "#172238" }),
    Repeat({ fg = "#806a7f" }),
    Scrollbar({ bg = "#111111", fg = "#224385" }),
    Special({ fg = "#487ac8" }),
    SpecialChar({ fg = "#b88698" }), -- For special punctutation that does not fall in the catagories before.
    SpecialComment({ fg = "#3698b3" }),
    Statement({ fg = "#5191D1" }),
    String({ fg = "#1684a4" }),
    Structure({ fg = "#3D71AC" }),
    Type({ fg = "#418cc4" }),
    -- Variable({ fg = '#5a8ab0' }),
    Variable({ fg = "#5a8ac0" }),
    healthError({ fg = "#BE6069", bg = "none" }),
    healthSuccess({ fg = "#22BB99", bg = "none" }),
    healthWarning({ fg = "#EBCA89", bg = "none" }),
    qfFileName({ Directory }),
    qfFileNameHead({ Keyword }),
    qfLineNr({ LineNr }),
    qfSeparator({ fg = "#322c2f" }), -- Delimiter
    qfSeparatorLeft({ qfSeparator }),
    qfSeparatorRight({ qfSeparator }),
    -- qfLineNr({ fg = clrs.highlight, bg = clrs.nord6, gui = 'reverse' }),
    -- qfError { Error },
    -- +--- Prompt/Status ---+
    EndOfBuffer({ fg = clrs.nord1 }),
    ErrorMsg({ Error }),
    ModeMsg({ fg = clrs.nord10 }),
    MoreMsg({ fg = clrs.nord8, gui = "bold" }),
    DebugMsg({ fg = Comment.fg }),
    Question({ fg = clrs.nord4 }),
    -- +--- LSP ---+
    LspInfoBorder({ FloatBorder }),
    NullLsInfoBorder({ FloatBorder }),
    DiagnosticOk({ fg = "#1abc9c" }),
    DiagnosticError({ fg = "#8d3a42" }),
    DiagnosticWarn({ fg = "#6d605a" }),
    DiagnosticHint({ fg = "#206b8b" }),
    DiagnosticInfo({ fg = "#0d81bc" }),
    DiagnosticFloatingError({ DiagnosticError }),
    DiagnosticFloatingWarn({ DiagnosticWarn }),
    DiagnosticFloatingHint({ DiagnosticHint }),
    DiagnosticFloatingInfo({ DiagnosticInfo }),
    DiagnosticFloatingErrorBorder({ fg = "#5a070f" }),
    DiagnosticFloatingWarnBorder({ fg = "#584b45" }),
    DiagnosticFloatingHintBorder({ fg = "#195474" }),
    DiagnosticFloatingInfoBorder({ fg = "#0067a2" }),
    DiagnosticSignError({ DiagnosticError }),
    DiagnosticSignWarn({ DiagnosticWarn }),
    DiagnosticSignHint({ DiagnosticHint }),
    DiagnosticSignInfo({ DiagnosticInfo }),
    LspDiagnosticsSignError({ fg = "#702e34" }),
    LspDiagnosticsSignWarn({ fg = "#574c47" }),
    LspDiagnosticsSignHint({ fg = "#206b8b" }),
    LspDiagnosticsSignInfo({ fg = "#0d81bc" }),
    DiagnosticUnderlineError({ fg = "none", gui = "none" }),
    DiagnosticUnderlineWarn({ fg = "none", gui = "none" }),
    DiagnosticUnderlineHint({ fg = "none", gui = "none" }),
    DiagnosticUnderlineInfo({ fg = "none", gui = "none" }),
    DiagnosticVirtualTextError({ fg = "#9a4c54", gui = "italic" }), -- #ffc777
    DiagnosticVirtualTextWarn({ fg = "#7c706a", gui = "italic" }), -- #c53b53
    DiagnosticVirtualTextHint({ fg = "#457d8c", gui = "italic" }), -- "#4fd6be"
    DiagnosticVirtualTextInfo({ fg = "#597597", gui = "italic" }), -- "#0db9d7"
    -- DiagnosticVirtualLinesError({ fg = '#c53b53', gui = 'italic' }),
    -- DiagnosticVirtualLinesWarn({ fg = '#ffc777', gui = 'italic' }),
    DiagnosticVirtualLinesHint({ fg = "#4fd6be", gui = "italic" }),
    DiagnosticVirtualLinesInfo({ fg = "#0db9d7", gui = "italic" }),
    LspCodeLens({ fg = "#6272A4" }),
    LspCodeLensSeparator({ fg = "#7F8CB5" }),
    LspReferenceRead({ fg = Search.fg, gui = "none" }), -- #22bb99, 628bff
    LspReferenceWrite({ fg = Search.fg, gui = "none" }), -- #22bb99
    LspReferenceText({ fg = Search.fg, gui = "none" }), -- #22bb99
    DiffAdd({ bg = "#003c42" }), -- #00361f #001000 #22bb99
    DiffChange({ bg = "#063054" }), -- #003050 #001030 #646ead
    DiffDelete({ fg = "#444466", bg = "#240000" }), -- #3e0009 #300000 #be6069
    DiffText({ gui = "italic", bg = "#0e2040" }), -- #464b5d #001030 #81a1c1
    diffAdded({ fg = clrs.nord14 }),
    diffRemoved({ fg = clrs.nord11 }),
    diffChanged({ fg = clrs.nord15 }),
    diffOldFile({ fg = clrs.nord9 }),
    diffNewFile({ fg = clrs.nord12 }),
    diffFile({ fg = clrs.nord7 }),
    diffLine({ fg = "#464B5D" }),
    diffIndexLine({ fg = clrs.nord9 }),
    Todo({ fg = "none", bg = "none", gui = "none" }),
    TodoMsg({ fg = "#2583cB", gui = "bold, italic" }),
    Warning({ bg = "none", fg = "#aB6F34", gui = "bold, italic" }),
    WarningMsg({ bg = "none", fg = clrs.nord13 }),
    -- language groups
    --
    TreesitterContext({ bg = "#1a0606", fg = "#143658" }),
    TreesitterContextLineNumber({
      fg = "#244668",
      bg = "#1a0606",
    }),
    TreesitterContextLineNumberBottom({
      fg = "#244668",
      -- gui = 'underline',
      guisp = "Grey",
    }),
    TreesitterContextBottom({
      fg = "#00a6f8",
      -- fg = '#102648',
      -- gui = 'underline',
      guisp = "Grey",
    }),

    -- @comment.error         ; error-type comments (e.g., `DEPRECATED:`)
    -- @comment.warning       ; warning-type comments (e.g., `WARNING:`, `FIX:`)
    -- @comment.hint          ; note-type comments (e.g., `NOTE:`)
    -- @comment.info          ; info-type comments
    -- @comment.todo          ; todo-type comments (e.g-, `TODO:`, `WIP:`)
    -- Markup
    -- Mainly for markup languages.
    --
    -- @markup.strong         ; bold text
    -- @markup.italic         ; text with emphasis
    -- @markup.strikethrough  ; strikethrough text
    -- @markup.underline      ; underlined text (only for literal underline markup!)
    --
    -- @markup.heading        ; headings, titles (including markers)
    --
    -- @markup.quote          ; block quotes
    -- @markup.math           ; math environments (e.g. `$ ... $` in LaTeX)
    -- @markup.environment    ; environments (e.g. in LaTeX)
    --
    -- @markup.link           ; text references, footnotes, citations, etc.
    -- @markup.link.label     ; link, reference descriptions
    -- @markup.link.url       ; URL-style links
    --
    -- @markup.raw            ; literal or verbatim text (e.g., inline code)
    -- @markup.raw.block      ; literal or verbatim text as a stand-alone block
    --                        ; (use priority 90 for blocks with injections)
    --
    -- @markup.list           ; list markers
    -- @markup.list.checked   ; checked todo-style list markers
    -- @markup.list.unchecked ; unchecked todo-style list markers
    -- @diff.plus       ; added text (for diff files)
    -- @diff.minus      ; deleted text (for diff files)
    -- @diff.delta      ; changed text (for diff files)
    -- @tag           ; XML tag names
    -- @tag.attribute ; XML tag attributes
    -- @tag.delimiter ; XML tag delimiters
    -- Non-highlighting captures
    -- @none    ; completely disable the highlight
    -- @conceal ; captures that are only meant to be concealed
    -- @spell   ; for defining regions to be spellchecked
    -- @nospell ; for defining regions that should NOT be spellchecked
    --

    -- sym("@keyword.conditional")({ fg = "#80788a" }),
    sym("@boolean")({ Boolean }),
    sym("@comment")({ Comment }),
    sym("@comment.note")({ fg = "#278d8b" }),
    sym("@comment.documentation")({ Comment }),
    sym("@constant")({ Constant }),
    sym("@constant.builtin")({ ConstantBuiltin }),
    sym("@comment.warning")({ Warning }),
    sym("@comment.danger")({ bg = "#db4b4b", fg = "#24283b" }),
    sym("@diff.add")({ DiffAdd }),
    sym("@diff.delete")({ DiffDelete }),
    sym("@error")({ Error }),
    sym("@exception")({ Special }),
    sym("@function")({ Function }),
    sym("@function.builtin")({ Special }),
    sym("@function.call")({ FunctionCall }),
    sym("@function.method")({ Function }),
    sym("@function.method.call")({ FunctionCall }),
    sym("@include")({ Include }),
    sym("@keyword")({ Keyword }),
    sym("@constant.luap")({ fg = "#2288cc", gui = "bold" }),
    sym("@keyword.luap")({ fg = "#5886ff" }),
    sym("@operator.luap")({ fg = "#08a4ea", gui = "bold" }),
    sym("@keyword.exception")({ Special }),
    sym("@keyword.operator")({ Operator }),
    sym("@keyword.return")({ KeywordReturn }),
    sym("@keyword.function")({ KeywordFunction }),
    sym("@keyword.luadoc")({ gui = "none" }),
    sym("@label")({ Label }), -- For labels: `label:` in C and `:label:` in Lua.
    sym("@method")({ Function }),
    sym("@method.call")({ FunctionCall }),
    sym("@module")({ Statement }),
    sym("@module.builtin")({ Keyword }),
    sym("@nospell")({ fg = "none", bg = "none", gui = "none" }),
    sym("@number")({ Number }),
    sym("@operator")({ Operator }),
    sym("@parameter")({ Statement }),
    sym("@property")({ Identifier }),
    sym("@punctuation.bracket")({ fg = "#7886a8" }), -- fg = "#a9b1d6"
    sym("@punctuation.bracket.luap")({ fg = "#8b8af7" }),
    sym("@punctuation.delimiter")({ fg = "#7886a8" }),
    sym("@punctuation.delimiter.luap")({ fg = "#4866d8", gui = "bold" }),
    sym("@punctuation.special")({ fg = "#888698" }), -- #89ddff
    sym("@punctuation.special.markdown")({ fg = "#645060" }), --  fg = '#89ddff'
    sym("@punctuation.strikethrough.markdown_inline")({ Normal }),
    sym("@string")({ String }),
    sym("@string.regexp")({ fg = "#1a84ba", gui = "none" }),
    sym("@string.special.url")({ gui = "italic" }),
    sym("@string.documentation")({ fg = "#406f88", gui = "italic" }),
    sym("@string.escape")({ fg = "#bb9af7" }),
    sym("@tag")({ fg = "#a78086" }),
    sym("@tag.attribute")({ fg = "#5599dd" }),
    sym("@tag.delimiter")({ sym("@tag") }),
    sym("@markup.raw.markdown_inline")({ fg = "#2779aa", gui = "none" }),
    sym("@markup.raw.block")({ gui = "none", fg = "#2779aa" }),
    sym("@markup.raw")({ fg = "#2779aa", gui = "none" }),
    sym("@markup.strikethrough")({ gui = "strikethrough" }),
    sym("@markup.strikethrough.markdown_inline")({ gui = "strikethrough", fg = Normal.fg }),
    sym("@markup.italic")({ gui = "italic" }),
    sym("@markup.italic.markdown_inline")({ gui = "italic", fg = "#839ac6" }),
    sym("@markup.strong.markdown")({ gui = "bold" }),
    sym("@markup.strong.markdown_inline")({ gui = "bold", fg = "#839ac6" }),
    sym("@markup.link")({ fg = "#2aa1ae", gui = "italic" }),
    sym("@markup.link.label.markdown")({ fg = "#5c71cf" }),
    -- sym('@markup.link.label.markdown_inline')({ fg = '#6c81ff', gui = 'italic' }),
    sym("@markup.link.label.markdown_inline")({ fg = "#0081aa", gui = "italic" }),
    sym("@markup.list")({ Special }),
    sym("@markup.list.checked")({ fg = "#73daca", gui = "bold" }),
    sym("@markup.list.unchecked")({ fg = "#7aa2f7" }),
    -- sym('@markup.list.checked.markdown')({ fg = '#53fafa', gui = 'bold' }),
    sym("@spell")({}),
    sym("@type")({ Type }),
    sym("@type.builtin")({ fg = "#487795" }),
    sym("@uri")({ fg = "#8eb9f6", gui = "none" }),
    sym("@variable")({ Variable }),
    sym("@variable.builtin")({ Identifier }),
    sym("@variable.member")({ Field }),
    sym("@variable.parameter")({ Identifier }),
    sym("@variable.parameter.vimdoc")({ sym("@parameter") }),
    -- sym('@markup')({ fg = '#0789aa' }), --  fg = '#89ddff'
    -- @markup.list.unchecked.markdown
    -- CodeBlock({ bg = '#090909' }),
    -- - @lsp.type.variable.javascript links to Variable priority: 125
    -- - @lsp.mod.defaultLibrary.javascript links to @lsp priority: 126
    -- - @lsp.typemod.variable.defaultLibrary.javascript links to Identifier priority: 127
    -- sym('@lsp')({ Keyword }),
    -- sym('@lsp.typemod.variable.readonly.javascript')({ Variable }),
    -- sym('@lsp.typemod.variable.declaration.javascript')({ Variable }),
    sym("@lsp.type.class.markdown")({ fg = "none", bg = "none" }), -- sym('@type') Structure
    -- sym('@lsp.type.class.javascript')({ sym('@variable') }),
    sym("@lsp.type.class.javascript")({ Special }),
    sym("@lsp.type.comment")({ sym("@comment") }),
    sym("@lsp.type.enum")({ sym("@type") }),
    sym("@lsp.type.enumMember")({ sym("@constant") }),
    sym("@lsp.type.interface")({ fg = "#6ad5e8" }),
    sym("@lsp.type.keyword")({ sym("@keyword") }),
    sym("@lsp.type.namespace")({ sym("@module") }),
    sym("@lsp.type.parameter")({ sym("@variable.parameter") }),
    sym("@lsp.type.property")({ sym("@property") }),
    sym("@lsp.type.variable")({ sym("@variable") }),
    sym("@lsp.typemod.function.defaultLibrary")({ sym("@function.builtin") }),
    sym("@lsp.typemod.macro.defaultLibrary")({ sym("@function.builtin") }),
    sym("@lsp.typemod.method.defaultLibrary")({ sym("@function.builtin") }),
    sym("@lsp.typemod.operator.injected")({ sym("@operator") }),
    sym("@lsp.typemod.string.injected")({ sym("@string") }),
    sym("@lsp.typemod.type.defaultLibrary")({ fg = "#29a4bd" }),
    sym("@lsp.typemod.variable.defaultLibrary")({ sym("@variable.builtin") }),
    sym("@lsp.typemod.variable.injected")({ sym("@variable") }),
    sym("@lsp.typemod.variable.typescriptreact")({ Type }),
    sym("@lsp.typemod.variable.readonly.typescriptreact")({ Type }),
    -- ["@text.reference"] = { fg = "#1abc9c" },
    -- ["@text.todo.checked"] = {fg = "#73daca" },
    -- ["@text.todo.unchecked"] = { fg = "#7aa2f7" },
    -- ["@text.warning"] = { bg = "#e0af68",fg = "#24283b" },
    -- ["@type.builtin"] = { fg = "#29a4bd" },
    -- luaTSFunction({ TSMethod }),
    -- sym("@constructor")({ fg = "#bb9af7" }),
    -- sym("@keyword")({fg = "#9d7cd8", style = {italic = true, }}),
    -- sym("@keyword.function")({fg = "#bb9af7", style = {}}),
    -- sym("@label")({fg = "#7aa2f7"}),
    -- sym("@namespace")({link = "Include"}),
    -- sym("@operator")({fg = "#89ddff"}),
    -- sym("@property")({fg = "#73daca"}),
    -- sym("@text.todo.checked")({fg = "#73daca"}),
    -- sym("@text.todo.unchecked")({ fg = "#7aa2f7", }),
    -- sym("@text.warning")({ bg = "#e0af68", fg = "#24283b", }),
    -- sym("@variable")({ fg = "#c0caf5", style = {}, }),
    -- sym("@variable.builtin")({ fg = "#f7768e", }),
    -- sym("@type.builtin")({ fg = "#29a4bd" }),
    -- ['@lsp.type.namespace'] = '@namespace',
    -- ['@lsp.type.type'] = '@type',
    -- ['@lsp.type.class'] = '@type',
    -- ['@lsp.type.enum'] = '@type',
    -- ['@lsp.type.interface'] = '@type',
    -- ['@lsp.type.struct'] = '@structure',
    -- ['@lsp.type.parameter'] = '@parameter',
    -- ['@lsp.type.variable'] = '@variable',
    -- ['@lsp.type.property'] = '@property',
    -- ['@lsp.type.enumMember'] = '@constant',
    -- ['@lsp.type.function'] = '@function',
    -- ['@lsp.type.method'] = '@method',
    -- ['@lsp.type.macro'] = '@macro',
    -- ['@lsp.type.decorator'] = '@function',
    -- sym('@constructor.tsx')({ fg = 'none', bg = 'none' }),
    sym("@constructor")({ fg = "none", bg = "none" }),
    sym("@constructor.tsx")({ fg = "none", bg = "none" }),
    sym("@tag.end.jsx")({ Statement }),
    sym("@tag.end.tsx")({ Statement }),
    sym("@tag.delimiter.end.jsx")({ Statement }),
    sym("@tag.delimiter.end.tsx")({ Statement }),
    sym("@tag.constructor.end.jsx")({ Statement }),
    sym("@tag.constructor.end.tsx")({ Statement }),
    -- sym('@tag.tsx')({ fg = 'none', bg = 'none' }),
    -- sym('@operator.tsx')({ fg = 'none', bg = 'none' }),
    -- sym('@tag.delimiter.tsx')({ fg = 'none', bg = 'none' }),
    -- sym('@tag.jsx')({ fg = 'none', bg = 'none' }),
    -- sym('@type.tsx')({ fg = 'none', bg = 'none' }),
    -- sym('@variable.tsx')({ fg = 'none', bg = 'none' }),
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
    manReference({ fg = "#2aa1ae" }),
    manUnderline({ gui = "italic", fg = "#2aa1ae" }),
    manBold({ fg = "#0575af", gui = "italic" }),
    manItalic({ gui = "italic", fg = "#2aa1ae" }),
    manSectionHeading({ fg = "#25a5ff", gui = "none,bold" }),
    -- manSubheading { Function  },
    -- manOptionDesc { Constant },
    -- manHeader         Title
    -- manSectionHeading Statement
    -- manOptionDesc     Constant
    -- manReference      PreProc
    -- manSubHeading     Function
    liquidExpression({ Type }),
    liquidDelimiter({ fg = clr_over.orange }),

    -- WFComment({ fg = "#2aa1ae"}),
    -- WFWhichRem({ fg = "#2aa1ae"}),
    -- WFFreeze({ fg = "#2aa1ae"}),
    -- WFSeparator({ fg = "#2aa1ae"}),
    -- WFTitleOutput({ fg = "#67b11d"}),
    -- WFTitleWhich({ fg = "#67b11d"}),
    -- WFTitleFuzzy({ fg = "#67b11d"}),
    -- WFNormal({ fg = "#4583a0"}),
    -- WFWhichDesc({fg = "#4583a0" }),
    -- WFFocus({fg = "#4583a0"}),
    -- WFWhichUnique({fg = "#ce537a"}),
    -- WFExpandable({fg = "#ce537a"}),
    -- WFFloatBorder({fg = "#2d9574"}),
    -- WFFloatBorderFocus({fg = "#2d9574"}),
    -- WFTitleFreeze({fg = "#2aa1ae"}),
    -- WFWhichOn({fg = "#4f97d7"}),
    -- WFFuzzy({fg = "#bc6ec5"}),
    -- WFGroup({fg = "#bc6ec5"}),
    -- WFWhichObjCounter({fg = "#44505c"}),
    -- WFFuzzyPrompt({fg = "#f2241f"}),

    --  WFNormal({Normal}),
    --  WFFloatBorder({FloatBorder}),
    --  WFFloatBorderFocus({FloatBorder}),
    --  WFComment({Comment}),
    --  WFWhichRem({Comment}),
    --  WFWhichOn({Keyword}),
    --  WFFuzzy({String}),
    --  WFFuzzyPrompt({Error}),
    --  WFFocus({WFNormal}),
    --  WFFreeze({Comment}),
    --  WFWhichObjCounter({NonText}),
    --  WFWhichDesc({Normal}),
    --  WFSeparator({Comment}),
    --  WFGroup({Function}),
    --  WFWhichUnique({Type}),
    --  WFExpandable({Type}),
    --  WFTitleOutput({Title}),
    --  WFTitleWhich({Title}),
    --  WFTitleFuzzy({Title}),
    --  WFTitleFreeze({WFFreeze}),

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
    -- markdownTSTitle {},
    htmlEndTag({ fg = "#7f90aa" }),
    htmlTagN({ fg = clr_over.orange }),
    CSVColumnHeaderOdd({ String }),
    CSVColumnHeaderEven({ fg = Statement.fg, bg = "none" }),
    -- markdownLinkText({ fg = '#702cff' }),
    pandocAutomaticLink({ gui = "italic" }),
    pandocReferenceURL({ gui = "italic" }),
    pandocReferenceDefinitionAddress({ gui = "italic" }),
    pandocDelimitedCodeBlock({ gui = "none" }),
    pandocStrikeout({ gui = "strikethrough" }),
    -- pandocEllipses({}),
    -- pandocEmphasis({ gui = 'italic', fg = '#bbbbcc' }),
    -- pandocStrong({ gui = 'none' }),
    -- pandocReferenceLabel { gui = "none", fg = clr_over.orange },
    pandocListItemBullet({ fg = "#66a8dc" }),
    pandocListItemBulletId({ fg = "#66a8dc" }),
    pandocOperator({ bg = "none", fg = "#aa6600" }),
    pandocListItem({}),
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
    mkdListItemLine({ pandocListItem }),
    helpHyperTextJump({ fg = "#6585b8", gui = "none" }),
    Dash({ bg = "#341710", fg = "#341710" }),
    --
    -- Indent Blankline
    -- IblScope, IblIndent, IblWhitespace
    -- IndentBlanklineChar({ fg = '#102030', gui = 'nocombine' }),
    -- IndentBlanklineContextChar({ fg = colors.purple, gui = 'nocombine' }),
    IblIndent({ fg = "#102030", gui = "nocombine" }),
    -- IblScope({ fg = colors.purple, gui = 'nocombine' }),
    -- IndentBlanklineIndent1({ bg = '#262626', gui = 'nocombine' }),
    -- IndentBlanklineIndent2({ bg = '#1f1f1f', gui = 'nocombine' }),

    IndentGuidesEven({ bg = clrs.nord1 }),
    IndentGuidesOdd({ bg = clrs.nord2 }),
    MiniIndentscopeSymbol({ fg = "#003460", bg = "#000f18" }),
    MiniIndentscopeSymbolOff({ fg = "#162f58" }),
    ---   indent is multiple of 'shiftwidth'.
    --
    -- [[hi default link MiniIndentscopeSymbol Delimiter
    --   hi default link MiniIndentscopeSymbolOff MiniIndentscopeSymbol]],
    -- false
    -- highlight IndentBlanklineChar guifg=#303030
    -- highlight IndentBlanklineContextChar guifg=#585858
    -- #0D0E19
    -- IndentBlanklineIndent1 guifg=#E06C75
    -- IndentBlanklineIndent2 guifg=#E5C07B
    -- IndentBlanklineIndent3 guifg=#98C379
    -- IndentBlanklineIndent4 guifg=#56B6C2
    -- IndentBlanklineIndent5 guifg=#61AFEF
    -- IndentBlanklineIndent6 guifg=#C678DD
    InfoWindowFloat({ fg = "#2886bf", bg = "none" }),
    BqfPreviewFloat({ Normal }),
    BqfPreviewBorder({ Normal }),
    BqfPreviewRange({ IncSearch }),
    BqfSign({ fg = "cyan" }),
    -- zshVariableDef { Normal },
    -- zshDeref { fg = '#2886bf' },
    lsp_markdown1({ Normal }),
    DashboardHeader({ fg = "#8AFF80" }),
    DashboardKey({ fg = "#FF9580" }),
    DashboardCenter({ fg = clrs.nord8 }),
    DashboardDesc({ fg = "#87FEF8" }),
    DashboardIcon({ fg = "#FCFC7F" }),
    DashboardShortCut({ fg = TokyoColors.cyan }),
    DashboardFooter({ fg = "#5D5D65" }),
    -- DashboardHeader ({ fg = colors.blue }),
    -- DashboardCenter ({ fg = colors.purple }),
    -- DashboardFooter ({ fg = colors.green, gui = "italic" }),
    NotifyBackground({ bg = "#000000" }),
    NotifyRepeatCount({ Comment }),
    NotifySTATUSBorder({ fg = "#3a3286", bg = "none" }),
    NotifySTATUSTitle({ fg = "#3a3286" }),
    NotifySTATUSIcon({ fg = "#2a76b7" }),
    NotifyINSPECTBorder({ fg = "#2A70fF", bg = "none" }),
    NotifyINSPECTIcon({ fg = "#67b0f7" }),
    NotifyINSPECTTitle({ fg = "#2760f7" }),
    NotifyINFOBorder({ fg = "#008Fa8", bg = "none" }),
    NotifyINFOIcon({ fg = "#19aFc8" }),
    NotifyINFOTitle({ fg = "#19aFc8" }),
    NotifyDEBUGBorder({ fg = "#4B6BBB" }),
    NotifyDEBUGIcon({ fg = "#6B8BFF" }),
    NotifyDEBUGTitle({ fg = "#6B8BFF" }),
    NotifyTRACEBorder({ fg = "#637699", bg = "none" }),
    -- NotifyTRACEBorder { fg = "#7B7BCC" },
    -- NotifyTRACEBorder { Normal },
    NotifyTRACEIcon({ fg = "#637699" }),
    NotifyTRACEBody({ fg = "#637699" }),
    -- NotifyTRACEIcon { fg = "#7BABFF" },
    NotifyTRACETitle({ fg = "#7BABFF" }),
    NotifyERRORBorder({ fg = "#8A1F1F", bg = "none" }),
    NotifyERRORIcon({ fg = "#F74047" }),
    NotifyERRORTitle({ fg = "#F74047" }),
    NotifyWARNBorder({ fg = "#79491D", bg = "none" }),
    NotifyWARNIcon({ fg = "#C77700" }),
    NotifyWARNTitle({ fg = "#C77000" }),

    NotifyRUNBorder({ fg = "#1f87c2", bg = "none" }),
    NotifyRUNTitle({ fg = "#06c0f6" }),
    NotifyRUNIcon({ fg = "#c6b087" }),
    -- NotifyRunSuccessCommand({ fg = '#4fa7f2' }),
    NotifyRunSuccessOutput({ fg = Comment.fg }),

    WhichKeyKey({ fg = "#07c0f7", gui = "none" }), --Function
    WhichKeyOperator({ fg = "#917ccf", gui = "none" }), -- Keyword
    WhichKeyGroup({ fg = "#418cf4", gui = "none" }), -- Keyword
    -- WhichKeyDesc({ fg = "#5d79a1", gui = "italic" }), -- Identifier
    WhichKeyDesc({ fg = "#5d79a1", gui = "italic" }), -- Identifier
    WhichKeySeperator({ fg = "#334664", gui = "bold" }), -- DiffAdded
    WhichKeyFloat({ bg = NormalFloat.bg }), -- NormalFloat
    WhichKeyCursorLine({ bg = "#0a2446", gui = "bold" }),
    --     WhichKeyGroup = { fg = clrs.text },
    --     WhichKeyDesc = { fg = clrs.nord7, gui = "italic" },
    --     WhichKeySeperator = { fg = clrs.fg },
    -- WhichKeyValue { bg = clrs.float }, -- Comment
    -- WhichKey = { fg = colors.purple, gui = "bold" },
    -- WhichKeyGroup = { fg = colors.cyan },
    -- WhichKeyDesc = { fg = colors.blue, gui = "italic" },
    -- WhichKeySeperator = { fg = colors.green },
    -- WhichKeyFloat = { bg = colors.active },

    -- NvimTreesitterPairsSelf({ MatchParen }),
    -- NvimTreesitterPairsPartner({ MatchParen }),
    NvimTreesitterPairsSelf({ fg = "#f35050" }),
    NvimTreesitterPairsPartner({ fg = "#f79000" }),
    -- gui
    -- TSRainbowRed({ fg = "#cc241d" }),
    -- TSRainbowYellow({ fg = "#d79921" }),
    -- TSRainbowBlue({ fg = "#458588" }),
    -- TSRainbowOrange({ fg = "#d65d0e" }),
    -- TSRainbowGreen({ fg = "#689d6a" }),
    -- TSRainbowViolet({ fg = "#b16286" }),
    -- TSRainbowCyan({ fg = "#a89984" }),
    TSRainbowRed({ fg = clrutil.shade_color("#cc241d", -30) }),
    TSRainbowYellow({ fg = clrutil.shade_color("#d79921", -30) }),
    TSRainbowBlue({ fg = clrutil.shade_color("#458588", -30) }),
    TSRainbowOrange({ fg = clrutil.shade_color("#d65d0e", -30) }),
    TSRainbowGreen({ fg = clrutil.shade_color("#689d6a", -30) }),
    TSRainbowViolet({ fg = clrutil.shade_color("#b16286", -30) }),
    TSRainbowCyan({ fg = clrutil.shade_color("#a89984", -30) }),
    CmpCursorLine({ bg = "#142446", gui = "bold" }),
    CmpNormal({ fg = "#667da9", bg = "#06061a" }),
    CmpFloatBorder({ fg = "#3f5382", bg = "#000a1a" }), --
    CmpGhostLight({ fg = "#1f4f94" }),
    CmpGhostDark({ fg = "#27476c" }),
    CmpGhostText({ CmpGhostLight }),
    -- CmpPmenu({ bg = '#142a30' }),
    CmpPmenu({ bg = "#001020" }),
    CmpPmenuBorder({ bg = "#242a30" }),
    -- CmpDocumentation({ fg = tokyoColors.fg, bg = tokyoColors.bg_float }),
    -- CmpDocumentationBorder({ fg = tokyoColors.border_highlight, bg = tokyoColors.bg_float }),
    CmpItemMenu({ fg = "#6C7A96" }),
    CmpItemAbbr({ fg = "#4c74a4" }),
    CmpItemAbbrDeprecated({ fg = "#3c6494", gui = "strikethrough" }),
    CmpItemAbbrMatch({ fg = "#208Ff8", gui = "italic" }),
    CmpItemAbbrMatchFuzzy({ fg = "#008Fb8", gui = "italic" }),
    CmpItemKindArray({ fg = tokyoColors.blue }),
    CmpItemKindBoolean({ fg = tokyoColors.orange }),
    CmpItemKindClass({ fg = colors.yellow }),
    CmpItemKindConstant({ fg = colors.orange }),
    CmpItemKindConstructor({ fg = colors.yellow }),
    CmpItemKindCodeium({ fg = "#6460ff" }),
    CmpItemKindCopilot({ fg = tokyoColors.green2 }),
    CmpItemKindDefault({ fg = tokyoColors.fg }),
    CmpItemKindEnum({ fg = colors.yellow }),
    CmpItemKindEnumMember({ fg = colors.cyan }),
    CmpItemKindEvent({ fg = tokyoColors.orange }),
    CmpItemKindField({ fg = colors.blue }),
    CmpItemKindFile({ fg = colors.blue }),
    CmpItemKindKey({ fg = colors.fg }),
    CmpItemKindFunction({ fg = colors.purple }),
    CmpItemKindInterface({ fg = colors.yellow }),
    CmpItemKindKeyword({ fg = tokyoColors.cyan }),
    CmpItemKindMethod({ fg = colors.purple }),
    CmpItemKindModule({ fg = colors.blue }),
    CmpItemKindNamespace({ fg = tokyoColors.purple }),
    CmpItemKindNumber({ fg = tokyoColors.orange }),
    CmpItemKindNull({ fg = tokyoColors.orange }),
    CmpItemKindObject({ fg = tokyoColors.blue }),
    CmpItemKindOperator({ fg = tokyoColors.green1 }),
    CmpItemKindPackage({ fg = tokyoColors.orange }),
    CmpItemKindProperty({ fg = colors.blue }),
    CmpItemKindReference({ fg = tokyoColors.magenta }),
    CmpItemKindSnippet({ fg = colors.green2 }),
    CmpItemKindString({ fg = tokyoColors.green2 }),
    CmpItemKindStruct({ fg = colors.yellow }),
    CmpItemKindText({ fg = "#489aac" }),
    CmpItemKindTypeParameter({ fg = colors.yellow }),
    CmpItemKindUnit({ fg = colors.orange }),
    CmpItemKindValue({ fg = colors.orange }),
    CmpItemKindVariable({ fg = tokyoColors.blue2 }),

    CmpSourceNvimLsp({ fg = "#0ca6ff" }), -- '#8fa080'
    CmpSourceLuasnip({ fg = "#8fa080" }), --
    CmpSourceTreesitter({ fg = "#4C86a4" }),
    CmpSourceCodeium({ CmpItemKindCodeium }),
    CmpSourceCopilot({ CmpItemKindCopilot }),
    CmpSourceAsyncPath({ fg = "#6F65f0" }),
    CmpSourcePath({ fg = "#6F65f0" }),
    CmpSourceFuzzyPath({ fg = "#6F65f0" }),
    CmpSourceCmdline({ fg = "#8F65a0" }),
    CmpSourceCmdlineHistory({ fg = "#4482fc" }),
    CmpSourceQuickData({ fg = "#6462cc" }),
    CmpSourceYanky({ fg = "#24a2ac" }),

    -- -- nvim-navic
    NavicSeparator({ fg = tokyoColors.fg }),
    NavicText({ fg = tokyoColors.fg }),
    NavicIconsArray({ CmpItemKindArray }),
    NavicIconsBoolean({ CmpItemKindBoolean }),
    NavicIconsClass({ CmpItemKindClass }),
    NavicIconsConstant({ CmpItemKindConstant }),
    NavicIconsConstructor({ CmpItemKindConstructor }),
    NavicIconsEnum({ CmpItemKindEnum }),
    NavicIconsEnumMember({ CmpItemKindEnumMember }),
    NavicIconsEvent({ CmpItemKindEvent }),
    NavicIconsField({ CmpItemKindField }),
    NavicIconsFile({ CmpItemKindFile }),
    NavicIconsFunction({ CmpItemKindFunction }),
    NavicIconsInterface({ CmpItemKindInterface }),
    NavicIconsKey({ CmpItemKindKey }),
    NavicIconsMethod({ CmpItemKindMethod }),
    NavicIconsModule({ CmpItemKindModule }),
    NavicIconsNamespace({ CmpItemKindNamespace }),
    NavicIconsNull({ CmpItemKindNull }),
    NavicIconsNumber({ CmpItemKindNumber }),
    NavicIconsOperator({ CmpItemKindOperator }),
    NavicIconsObject({ CmpItemKindObject }),
    NavicIconsPackage({ CmpItemKindPackage }),
    NavicIconsProperty({ CmpItemKindProperty }),
    NavicIconsString({ CmpItemKindString }),
    NavicIconsStruct({ CmpItemKindStruct }),
    NavicIconsTypeParameter({ CmpItemKindTypeParameter }),
    NavicIconsVariable({ CmpItemKindVariable }),
    -- -- aerial
    -- AerialDefault({ fg = Normal.fg.darken(30) }),
    -- AerialDefault({ bg = "none", fg = "none" }),
    AerialGuide({ fg = "#182838" }),
    AerialLine({ fg = "#00aacc", bg = "#002233", gui = "bold" }),
    -- AerialLine({ QuickFixLine }),
    AerialLineNC({ fg = "#00ff88", bg = "blue" }),
    -- AerialLineNC({ AerialLine }),
    AerialArrayIcon({ CmpItemKindArray }),
    -- AerialArrayIcon({ Identifier }),
    AerialBooleanIcon({ CmpItemKindBoolean }),
    -- AerialBooleanIcon({ Identifier }),
    AerialClassIcon({ CmpItemKindClass }),
    -- AerialClassIcon({ Type }),
    AerialConstantIcon({ CmpItemKindConstant }),
    -- AerialConstantIcon({ Constant }),
    AerialConstructorIcon({ CmpItemKindConstructor }),
    -- AerialConstructorIcon({ Special }),
    AerialEnumIcon({ CmpItemKindEnum }),
    -- AerialEnumIcon({ Type }),
    AerialEnumMemberIcon({ CmpItemKindEnumMember }),
    -- AerialEnumMemberIcon({ Identifier }),
    AerialEventIcon({ CmpItemKindEvent }),
    -- AerialEventIcon({ Identifier }),
    AerialFieldIcon({ CmpItemKindField }),
    -- AerialFieldIcon({ Identifier }),
    AerialFileIcon({ CmpItemKindFile }),
    -- AerialFileIcon({ Identifier }),
    AerialFunctionIcon({ CmpItemKindFunction }),
    -- AerialFunctionIcon({ Function }),
    AerialInterfaceIcon({ CmpItemKindInterface }),
    -- AerialInterfaceIcon({ Type }),
    AerialKeyIcon({ CmpItemKindKey }),
    -- AerialKeyIcon({ Identifier }),
    AerialMethodIcon({ CmpItemKindMethod }),
    -- AerialMethodIcon({ Function }),
    AerialModuleIcon({ CmpItemKindModule }),
    -- AerialModuleIcon({ Include }),
    AerialNamespaceIcon({ CmpItemKindNamespace }),
    -- AerialNamespaceIcon({ Include }),
    AerialNullIcon({ CmpItemKindNull }),
    -- AerialNullIcon({ Identifier }),
    AerialNumberIcon({ CmpItemKindNumber }),
    -- AerialNumberIcon({ Identifier }),
    AerialObjectIcon({ CmpItemKindObject }),
    -- AerialObjectIcon({ Identifier }),
    AerialOperatorIcon({ CmpItemKindOperator }),
    -- AerialOperatorIcon({ Identifier }),
    AerialPackageIcon({ CmpItemKindPackage }),
    -- AerialPackageIcon({ Include }),
    AerialPropertyIcon({ CmpItemKindProperty }),
    -- AerialPropertyIcon({ Identifier }),
    AerialStringIcon({ CmpItemKindString }),
    -- AerialStringIcon({ Identifier }),
    AerialStructIcon({ CmpItemKindStruct }),
    -- AerialStructIcon({ Type }),
    AerialTypeParameterIcon({ CmpItemKindTypeParameter }),
    -- AerialTypeParameterIcon({ Identifier }),
    AerialVariableIcon({ CmpItemKindVariable }),
    -- AerialVariableIcon({ Identifier }),
    -- +--- Telescope ---+
    TelescopeNormal({ fg = "#4f6f9f", bg = "none", gui = "none" }), -- #6d779a
    TelescopeComment({ Comment }),
    TelescopeBorder({ bg = "none", fg = "#2299cc" }),
    TelescopePrompt({ bg = "none" }),
    TelescopePromptTitle({ fg = "#07a0ff", bg = "none" }),
    TelescopePromptCounter({ fg = "#4d577a", bg = "none" }),
    TelescopePromptNormal({ fg = "#2299cc", bg = "none" }),
    TelescopePromptBorder({ fg = "#416191", bg = "none" }),
    TelescopePromptPrefix({ fg = "#2977FF", bg = "none" }),
    TelescopePreviewBorder({ fg = "#416191", bg = "none" }),
    TelescopeResults({ bg = "none" }),
    TelescopeResultsBorder({ fg = "#416191", bg = "none" }),
    TelescopeSelectionCaret({ fg = "#04c9fc" }),
    TelescopeSelection({ fg = "#008acf", gui = "bold", bg = CursorLine.bg }), -- bg = "#202324"
    TelescopeMatching({ fg = "#4070cc", bg = "none" }),
    TelescopeFrecencyScores({ fg = "#34799c" }),
    TelescopeBufferLoaded({ fg = "#47a0f0" }),
    TelescopeMultiIcon({ fg = "#20a0ff", gui = "bold" }),
    TelescopeMultiSelection({ fg = "#2080cf", bg = "none", gui = "italic" }),
    TelescopeTitle({ fg = "#2299ff", gui = "bold " }),
    TelescopePreviewTitle({ fg = "#47a0f0", bg = "none" }),
    TelescopeResultsTitle({ fg = "#64a9ec", bg = "none" }),
    TelescopeResultsIdentifier({ fg = "#6476ce" }),
    TelescopeResultsSpecialComment({ fg = "#4488cc" }),
    TelescopeResultsField({ fg = "#4090ff" }),
    -- TelescopeWhichKeyMode({ TelescopeResultsConstant }),
    TelescopeResultsSeparator({ fg = "#1f3f5f", bg = "none" }),
    TelescopeWhichKeyBind({ fg = WhichKey.fg }),
    TelescopeWhichKeyBindCustom({ fg = WhichKey.fg, gui = "bold" }),
    TelescopeWhichKeyName({ WhichKeyDesc }),
    TelescopeWhichKeyNameCustom({ fg = "#88aee9", gui = "bold" }),
    TelescopeWhichKeyBorder({ WhichKeyDesc }),
    vimAugroup({ fg = "#2080cf" }),
    vimAutoEvent({ TelescopeResultsField }),
    -- { entry.value.pattern, "vimAutoCmdSfxList" },
    -- "TelescopeResultsDiffAdd" },
    -- "TelescopeResultsDiffAdd" },
    -- "TelescopeResultsDiffChange" },
    -- "TelescopeResultsDiffChange" },
    -- "TelescopeResultsDiffChange" },
    -- "TelescopeResultsDiffDelete" },
    -- = "TelescopeResultsDiffUntracked" },
    --
    -- ["Class"] = "TelescopeResultsClass",
    -- ["Constant"] = "TelescopeResultsConstant",
    -- ["Field"] = "TelescopeResultsField",
    -- ["Function"] = "TelescopeResultsFunction",
    -- ["Method"] = "TelescopeResultsMethod",
    -- ["Property"] = "TelescopeResultsOperator",
    -- ["Struct"] = "TelescopeResultsStruct",
    -- ["Variable"] = "TelescopeResultsVariable",
    --     WhichKeyGroup = { fg = clrs.text },
    --     WhichKeyDesc = { fg = clrs.nord7, gui = "italic" },
    --     WhichKeySeperator = { fg = clrs.fg },
    -- NavbuddyName({ fg = '#eceff4', bg = '#5d61ec' }),
    NavbuddyName({ bg = "#40112f", gui = "bold" }),
    NavbuddyTitleBorder({ fg = "#222222" }),
    NavbuddyScope({ bg = "#061026", gui = "italic" }),
    -- NavbuddyCursor({ gui = 'bold' }),
    -- NavbuddyCursorLine({}),
    -- NavbuddyNormalTitle({ fg = "#222222" }),

    -- TelescopePromptCounter { NonText },
    -- TelescopePathSeparator { fg = '#667788' },
    -- TelescopeQueryFilter { fg = '#4466FF'},
    -- TelescopeResultsComment = {},
    -- TelescopeMultiSelection guifg=#928374          " Multisections

    IlluminatedWordRead({ bg = "#101c39", gui = "" }),
    IlluminatedWordText({ bg = "#101c39", gui = "" }),
    IlluminatedWordWrite({ bg = "#101c39", gui = "" }),

    -- git-conflict-nvim
    GitConflictCurrent({ bg = "#203d5e" }),
    GitConflictIncoming({ bg = "#003723" }),
    GitConflictAncestor({ bg = "#28218A" }),

    -- dim.lua
    sym("@functionDimmed")({ fg = "#6c6066", gui = "italic" }),
    sym("@variableDimmed")({ fg = "#62718b", gui = "italic" }),
    sym("@parameterDimmed")({ fg = "#537396", gui = "italic" }),
    sym("@keyword.functionDimmed")({ fg = "#495986", gui = "italic" }),

    -- +--- GitSigns ---+
    GitSignsAddFaded({ fg = clr_over.green_faded }),
    GitSignsAddNrFaded({ fg = clr_over.green_faded }),
    GitSignsAddLnFaded({ fg = clr_over.green_faded }),
    GitSignsChangeFaded({ fg = clr_over.blue_faded }),
    GitSignsChangeNrFaded({ fg = clr_over.blue_faded }),
    GitSignsChangeLnFaded({ fg = clr_over.blue_faded }),
    GitSignsChangeDeleteFaded({ fg = clr_over.purple_faded }),
    GitSignsChangeDeleteNrFaded({ fg = clr_over.purple_faded }),
    GitSignsChangeDeleteLnFaded({ fg = clr_over.purple_faded }),
    GitSignsDeleteFaded({ fg = clr_over.red_faded }),
    GitSignsDeleteNrFaded({ fg = clr_over.red_faded }),
    GitSignsDeleteLnFaded({ fg = clr_over.red_faded }),
    GitSignsAdd({ fg = clrs.nord14 }), -- diff mode: Added line |diff.txt|
    GitSignsAddNr({ fg = clrs.nord14 }), -- diff mode: Added line |diff.txt|
    GitSignsAddLn({ fg = clrs.nord14 }), -- diff mode: Added line |diff.txt|
    GitSignsChange({ fg = clrs.nord15 }), -- diff mode: Changed line |diff.txt|
    GitSignsChangeNr({ fg = clrs.nord15 }), -- diff mode: Changed line |diff.txt|
    GitSignsChangeLn({ fg = clrs.nord15 }), -- diff mode: Changed line |diff.txt|
    GitSignsDelete({ fg = clrs.nord11 }), -- diff mode: Deleted line |diff.txt|
    GitSignsDeleteNr({ fg = clrs.nord11 }), -- diff mode: Deleted line |diff.txt|
    GitSignsDeleteLn({ fg = clrs.nord11 }), -- diff mode: Deleted line |diff.txt|

    -- CybuFocus guifg=#8396b9 guibg=#101840 Operator
    -- CybuAdjacent guifg=#4a647b
    -- CybuBackgrou links to Normal
    -- CybuBorder links to FloatBorder
    -- CybuInfobar links to StatusLine
    FlashBackdrop({ fg = "#405560" }), -- #1a1f2a
    FlashLabel({ fg = "#cc0044", bg = "#000000", gui = "bold,italic" }), -- #0d314c

    -- Dressing
    TaskFloat({ fg = "#2a8ccb" }),
    TaskFloatBorder({ fg = "#2151a1" }),

    -- MiniClue
    -- MiniClueBorder({ FloatBorder }),
    MiniClueNextKey({ fg = "#07c0f7" }), -- MiniClueNextKey({DiagnosticFloatingHint})
    MiniClueDescSingle({ gui = "italic" }), -- MiniClueDescSingle({NormalFloat}),
    -- MiniClueDescGroup({DiagnosticFloatingWarn}),
    -- MiniClueNextKeyWithPostkeys({DiagnosticFloatingError}),
    MiniClueSeparator({ fg = "#333344" }), -- MiniClueSeparator({DiagnosticFloatingInfo})
    MiniClueTitle({ fg = "#f38080" }), -- MiniClueTitle({Title})

    -- symbol-usage
    SymbolInlay({ fg = "#004466", gui = "italic" }),
    --- nvim-hlslens
    -- HlSearchNear({ fg = '#00ffdd', bg = 'none' }), -- IncSearch
    -- HlSearchLens({ fg = '#ff2266', bg = '#003333' }), -- WildMenu
    -- HlSearchLensNear({ fg = '#00ddff', bg = 'none' }), -- IncSearch

    HighlightUndo({ fg = "#b7001e", bg = "#0f2139" }),
    HighlightRedo({ fg = "#00ffdd", bg = "#003149" }),
    BackseatText({ DiagnosticFloatingHint, gui = "italic" }),
    FlashCharMatch({ fg = "#33c78a", bg = "#0a331a" }),
    FlashCharLabel({ fg = "#33aaff", bg = "#001122", gui = "bold,italic" }),
    -- FlashCharLabel({ fg = '#ff00ff', bg = '#000000', gui = 'bold,italic' }),
    -- FlashBackdrop = { fg = '#545c7e', },
    -- FlashLabel = { bg = '#ff007c', bold = true, fg = '#c0caf5', },
    -- FloatBorder = { bg = '#1f2335', fg = '#29a4bd' },
    -- FloatTitle = { bg = '#1f2335', fg = '#29a4bd' },
    -- highlight MatchParen gui=BOLD guifg=#ffaf00 guibg=#444444
    -- hi FlashCurrent guifg=#ffaf00 gui=Bold
    -- hi FlashBackdrop guifg=#666666
    -- hi FlashMatch guifg=#EEEEEE
    -- hi FlashLabel guifg=#ff5555 guibg=#000000 gui=Bold
    -- hi Search guibg=#444444 gui=Bold
    -- FlashBackdrop({	Comment	}), -- backdrop
    -- FlashMatch({	Search	}), -- search matches
    -- FlashCurrent({	IncSearch	}), -- current match
    -- FlashLabel({	Substitute	}), -- jump label
    -- FlashPrompt({	MsgArea	}), -- prompt
    -- FlashPromptIcon({	Special	}), -- prompt icon
    -- FlashBackdropRemote
    -- FlashRemoteLine
    -- RenamerNormal Normal
    RenamerBorder({ fg = "#4466ff" }),
    -- RenamerTitle Identifier
    MatchParen({ fg = "#fb8b8b", gui = "bold," }),
    MatchParenCur({ fg = "#ff9f9f", gui = "bold" }), -- matchparen
    MatchWord({ fg = "#7f6686", gui = "italic" }),
    MatchBackground({ gui = "italic", bg = "#0f2139" }), -- colorcolumn
    RegistersPreview({ fg = "#009ac8", bg = "none", gui = "none" }), -- IncSearch
    LeapMatch({ fg = "#00ffdd", bg = "none" }), -- IncSearch
    -- LeapLabelPrimary
    -- LeapLabelSelected
    -- GlancePreviewNormal
    -- GlancePreviewMatch
    -- GlancePreviewCursorLine
    -- GlancePreviewSignColumn
    -- GlancePreviewEndOfBuffer
    -- GlancePreviewLineNr
    -- GlancePreviewBorderBottom
    -- GlanceWinBarFilename
    -- GlanceWinBarFilepath
    -- GlanceinBarTitle
    -- GlanceListNormal
    -- GlanceListFilename
    -- GlanceListFilepath
    -- GlanceListCount
    -- GlanceListMatch
    -- GlanceListCursorLine
    -- GlanceListEndOfBuffer
    -- GlanceListBorderBottom
    -- GlanceFoldIcon
    -- GlanceIndent
    -- GlanceBorderTop

    -- barbar
    -- ('BufferTabpages',       #51afef,   #3E4556, 'bold')
    BufferTabpages({ fg = "#51afef", bg = "#3e4556", gui = "bold" }),
    -- ('BufferTabpageFill',    '#3f444a', #1c1f24, 'bold')
    BufferTabpagesFill({ fg = "#3f444a", bg = "#1c1f24", gui = "bold" }),
    -- ('BufferCurrent',        #e6e6e6,   #282c34, 'none')
    -- ('BufferCurrentIndex',   #73797e,   #282c34, 'none')
    -- ('BufferCurrentMod',     #ECBE7B,   #282c34, 'none')
    -- ('BufferCurrentSign',    #51afef,   #282c34, 'none')
    -- ('BufferCurrentTarget',  #ff6c6b,   #282c34, 'bold')
    BufferCurrent({ fg = "#a8c0f0", bg = "#003d79", gui = "bold" }),
    BufferCurrentError({ bg = "#003d79" }),
    -- BufferCurrentIndex({ fg = colors.fg, bg = "NONE" }),
    BufferCurrentMod({ fg = colors.yellow, bg = "#003d79", gui = "bold" }),
    BufferCurrentSign({ fg = "#51afff", bg = "#003d79" }),
    -- BufferCurrentSignRight({ bg = colors.red }),
    -- BufferCurrentTarget({ fg = colors.red, bg = "NONE", gui = "bold" }),
    -- BufferVisible({ fg = colors.fg, bg = "none" }),
    -- BufferVisibleIndex({ fg = colors.fg, bg = "none" }),
    -- BufferVisibleMod({ fg = colors.yellow, bg = "none", gui = "bold" }),
    -- BufferVisibleSign({ bg = colors.light_gray }),
    -- BufferVisibleTarget({ fg = colors.red, bg = "none", gui = "bold" }),
    -- BufferInactive({ fg = colors.light_gray, bg = "#1C1F24" }),
    -- BufferInactiveIndex({ fg = colors.light_gray, bg = "#1C1F24" }),
    -- BufferInactiveMod({ fg = colors.yellow, bg = "#1C1F24" }),
    -- BufferInactiveSign({ fg = colors.light_gray, bg = "#1C1F24" }),
    -- BufferInactiveTarget({ fg = colors.red, bg = "#1C1F24", gui = "bold" }),
    -- BufferDefaultAlternate({ bg = "#0c2333" }), -- guifg=#4d576a guibg=#3c4353
    BufferAlternate({ bg = "#162343" }), -- guifg=#4d576a guibg=#3c4353
    -- BufferAlternateADDED({ bg = "#0c2333" }),
    -- BufferAlternateARN({ bg = "#0c2333" }),
    -- BufferAlternateCHANGED({ bg = "#0c2333" }),
    -- BufferAlternateDELETED({ bg = "#0c2333" }),
    -- BufferAlternateERROR({ bg = "#0c2333" }),
    -- BufferAlternateHINT({ bg = "#0c2333" }),
    -- BufferAlternateINFO({ bg = "#0c2333" }),
    -- BufferAlternateIndex({ bg = "#0c2333" }),
    BufferAlternateMod({ bg = "#162343", fg = "#988881" }),
    BufferAlternateIcon({ bg = "#162343", fg = "#3a5677" }),
    -- BufferAlternateNumber({ bg = "#0c2333" }),
    -- BufferAlternateSign({ bg = "#0c2333" }),
    -- BufferAlternateSignRight({ bg = "#0c2333" }),
    -- BufferAlternateTarget({ bg = "#0c2333" }),

    -- ('BufferVisible',        #9ca0a4,   #282c34, 'none')
    -- ('BufferVisibleIndex',   #e6e6e6,   #282c34, 'none')
    -- ('BufferVisibleMod',     #ECBE7B,   #282c34, 'none')
    -- ('BufferVisibleSign',    '#3f444a', #282c34, 'none')
    -- ('BufferVisibleTarget',  #ff6c6b,   #282c34, 'bold')
    -- ('BufferInactive',       #73797e,   #1c1f24, 'none')
    -- ('BufferInactiveIndex',  #73797e,   #1c1f24, 'none')
    -- ('BufferInactiveMod',    #ECBE7B,   #1c1f24, 'none')
    -- ('BufferInactiveSign',   '#3f444a', #1c1f24, 'none')
    -- ('BufferInactiveTarget', #ff6c6b,   #1c1f24, 'bold')
    -- ('BufferOffset',         #73797e,   #282c34, 'bold')
    -- ('BufferScrollArrow',    #b1b1b1,   #1c1f24, 'bold')
    -- ('BufferPart',           #51afef,   #D8EEFD, 'bold')

    -- noice.nvim
    NoiceCmdlinePopupTitle({ bold = true, fg = "#82b4ff" }),
    NoiceCmdlinePopupBorderFilter({ fg = "#643e5d" }),
    NoiceCmdlineIconFilter({ fg = "#643e5d" }),
    NeoTreeTitleBar({ bg = "#1f2342" }),
    NeoTreeFileNameOpened({ gui = "bold" }),
    -- NeoTreeNormal guibg=#010409"
    -- NeoTreeNormalNC guibg=#010409"
    -- NoiceCmdlinePopup guibg=#0a0e12"
    -- NoiceCmdlineIconCmdline guifg=#d2a8ff"
    -- NoiceCmdlineIcon({ fg = '#00aacc' }),
    -- NoiceCmdlineIconCalculator({ fg = '#6F65f0' }),
    -- NoiceCmdlineIconCmdline({ fg = '#88c0d0' }),
    -- NoiceCmdlineIconFilter({ fg = '#b48ead' }),
    -- NoiceCmdlineIconHelp({ fg = '#24a2ac' }),
    -- NoiceCmdlineIconIncRename({ fg = '#b48ead' }),
    -- NoiceCmdlineIconInput({ fg = '#88c0d0' }),
    -- NoiceCmdlineIconLua({ fg = '#2a76b7' }),
    -- NoiceCmdlineIconSearch({ fg = '#b48ead' }),
    -- NoiceCmdlinePopup({ fg = '#00aacc' }),
    -- NoiceCmdlinePopupBorder({ fg = '#4466ff' }),
    -- NoiceCmdlinePopupBorderCalculator({ fg = '#81A1C1' }),
    -- NoiceCmdlinePopupBorderCmdline({ fg = '#88c0d0' }),
    -- NoiceCmdlinePopupBorderFilter({ fg = '#b16286' }),
    -- NoiceCmdlinePopupBorderHelp({ fg = '#2d78c4' }),
    -- NoiceCmdlinePopupBorderIncRename({ fg = '#b48ead' }),
    -- NoiceCmdlinePopupBorderInput({ fg = '#88c0d0' }),
    -- NoiceCmdlinePopupBorderLua({ fg = '#2a76b7' }),
    -- NoiceCmdlinePopupBorderLuaExpr({ fg = '#44aaff' }),
    -- NoiceCmdlinePopupBorderNumb({ fg = '#8888ff' }),
    -- NoiceCmdlinePopupBorderSearch({ fg = '#b48ead'  }),
    -- NoiceCmdlinePopupSubs({ fg = '#6B8BFF' }),
    -- NoiceCmdlinePrompt({ fg = '#68e0f5" ' }),
    --	NoiceConfirm                      = { fg = C.frost.turquoise, bg = C.bg },           --normal for the confirm view
    -- NoiceConfirmBorder                = { fg = C.frost.turquoise, bg = C.bg },           --Border for the confirm view
    -- NoiceCursor                       = { fg = C.blend.blue, bg = C.blend.bluec1 },      --fake Cursor
    -- NoiceFormatConfirm                = { fg = C.frost.turquoise, bg = C.blend.turquoise }, --
    -- NoiceFormatConfirmDefault         = { fg = C.frost.turquoise, bg = C.blend.turquoise }, --
    -- NoiceFormatLevelDebug             = { fg = C.aurora.green, bg = C.none },            --
    -- NoiceFormatLevelDebug             = { fg = C.aurora.green, bg = C.none },            --
    -- NoiceFormatLevelError             = { fg = C.aurora.red, bg = C.none },              --
    -- NoiceFormatLevelInfo              = { fg = C.frost.turquoise, bg = C.none },         --
    -- NoiceFormatLevelOff               = { fg = C.night.c3, bg = C.none },                --
    -- NoiceFormatLevelTrace             = { fg = C.aurora.green, bg = C.none },            --
    -- NoiceFormatLevelWarn              = { fg = C.aurora.yellow, bg = C.none },           --
    -- NoiceFormatProgressDone           = { fg = C.frost.turquoise, bg = C.none },         --progress bar done
    -- NoiceFormatProgressTodo           = { fg = C.aurora.yellow, bg = C.none },           --progress bar todo
    -- NoiceFormatTitle                  = { fg = C.fg, bg = C.none },                      --
    -- NoiceFormatEvent                  = { fg = C.frost.turquoise, bg = C.bg },           --
    -- NoiceLspProgressClient            = { fg = C.frost.turquoise, bg = C.bg, blend = 5 }, --lsp progress client name
    -- NoiceLspProgressSpinner           = { fg = C.aurora.green, bg = C.bg, blend = 5 },   --lsp progress spinner
    -- NoiceLspProgressTitle             = { fg = C.fg, bg = C.bg },                        --lsp progress title
    -- NoiceMini                         = { fg = C.fg, bg = C.bg, blend = 0 },             --normal for mini view
    -- NoicePopup                        = { fg = C.frost.turquoise, bg = C.bg },           --Normal for popup views
    -- NoicePopupBorder                  = { fg = C.frost.turquoise, bg = C.bg },           --Border for popup views
    -- NoicePopupmenu                    = { fg = C.frost.turquoise, bg = C.blend.blue },   --normal for the popupmenu
    -- NoicePopupmenuBorder              = { fg = C.frost.turquoise, bg = C.bg },           --Popupmenu border
    -- NoicePopupmenuMatch               = { fg = C.frost.turquoise, bg = C.blend.turquoise }, --part of the item that matches the input
    -- NoicePopupmenuSelected            = { fg = C.frost.turquoise, bg = C.blend.turquoise }, --selected item in the popupmenu
    -- NoiceScrollbar                    = { fg = C.night.c2, bg = C.none },                --Normal for scrollbar
    -- NoiceScrollbarThumb               = { fg = C.night.c2, bg = C.none },                --Scrollbar thumb
    -- NoiceSplit                        = { fg = C.fg, bg = C.bg },                        --Normal for split views
    -- NoiceSplitBorder                  = { fg = C.night.c1, bg = C.bg },                  --Border for split views
    -- 	-hi(0, "NoiceCmdlineIconIncRename", { fg = "#68e0f5" })
    -- hi(0, "NoiceCmdlineIconInput", { fg = "#68e0f5" })
    -- hi(0, "NoiceCmdlineIconLua", { fg = "#68e0f5" })
    -- hi(0, "NoiceCmdlineIconSearch", { fg = "#fee19f" })
    -- hi(0, "NoiceCmdlinePopup", { bg = "#10121e" })
    -- hi(0, "NoiceCmdlinePopupBorder", { fg = "#68e0f5" })
    -- hi(0, "NoiceCmdlinePopupBorderCalculator", { fg = "#68e0f5" })
    -- hi(0, "NoiceCmdlinePopupBorderCmdline", { fg = "#68e0f5" })
    -- hi(0, "NoiceCmdlinePopupBorderFilter", { fg = "#68e0f5" })
    -- hi(0, "NoiceCmdlinePopupBorderHelp", { fg = "#68e0f5" })
    -- hi(0, "NoiceCmdlinePopupBorderIncRename", { fg = "#68e0f5" })
    -- hi(0, "NoiceCmdlinePopupBorderInput", { fg = "#68e0f5" })
    -- hi(0, "NoiceCmdlinePopupBorderLua", { fg = "#68e0f5" })
    -- hi(0, "NoiceCmdlinePopupBorderSearch", { fg = "#fee19f" })
    -- hi(0, "NoiceCmdlinePopupTitle", { fg = "#68e0f5" })
    -- hi(0, "NoiceCmdlinePrompt", { bold = true, fg = "#82b4ff" })
    -- hi(0, "NoiceCompletionItemKindC- NoiceVirtualText                  = { fg = C.frost.turquoise, bg = C.blend.turquoise }, --Default hl group for virtualtext viewsNoiceConfirm                      = { fg = C.frost.turquoise, bg = C.bg },           --normal for the confirm view

    -- #97b4ba, #7f9ba0, #29313e, #92a5cc, #332d39, #aa8ba5
    -- color1_bg = "#f265b5"
    -- color2_bg = "#37f499"
    -- color3_bg = "#04d1f9"
    -- color4_bg = "#a48cf2"
    -- color5_bg = "#f1fc79"
    -- color6_bg = "#f7c67f"
    --
    -- heading colors
    -- #435580  #131829  { bg = #1e2718, fg = #98C379, gui = "bold" }) { fg = c.bright_yellow, bold = true }
    -- #997b52  #191c1d  { bg = #21262d, fg = #61AFEF, gui = "bold" }) { fg = c.bright_cyan, bold = true }
    -- #5f794a  #171a1b  { bg = #2c1517, fg = #E06C75, gui = "bold" }) { fg = c.bright_green, bold = true }
    -- #1b5b55  #0d171f  { bg = #27182C, fg = #C678DD, gui = "bold" }) { fg = c.yellow }
    -- #544773  #0d171f  { bg = #3e2e1e, fg = #E5C07B, gui = "bold" }) { fg = c.cyan }
    CodeBlock({ bg = "#101018" }),
    RenderMarkdownH1({ fg = "#4385c0" }),
    RenderMarkdownH2({ fg = "#917A66" }),
    RenderMarkdownH3({ fg = "#406ff2" }),
    RenderMarkdownH4({ fg = "#1b8b95" }),
    RenderMarkdownH5({ fg = "#725591" }),
    RenderMarkdownH6({ fg = "#725591" }),
    RenderMarkdownH1Bg({ bg = "#0f162a" }),
    RenderMarkdownH2Bg({ bg = "#141413" }),
    RenderMarkdownH3Bg({ bg = "#12102f" }),
    RenderMarkdownH4Bg({ bg = "#0d1f26" }),
    RenderMarkdownH5Bg({ bg = "#181416" }),
    RenderMarkdownH6Bg({ bg = "#0a0608" }),
    sym("@markup.heading.1.markdown")({ fg = RenderMarkdownH1.fg, bg = RenderMarkdownH1Bg.bg }),
    sym("@markup.heading.2.markdown")({ fg = RenderMarkdownH2.fg, bg = RenderMarkdownH2Bg.bg }),
    sym("@markup.heading.3.markdown")({ fg = RenderMarkdownH3.fg, bg = RenderMarkdownH3Bg.bg }),
    sym("@markup.heading.4.markdown")({ fg = RenderMarkdownH4.fg, bg = RenderMarkdownH4Bg.bg }),
    sym("@markup.heading.5.markdown")({ fg = RenderMarkdownH5.fg, bg = RenderMarkdownH5Bg.bg }),
    sym("@markup.heading.6.markdown")({ fg = RenderMarkdownH6.fg, bg = RenderMarkdownH6Bg.bg }),
    RenderMarkdownBullet({ fg = "#846d59" }),
    RenderMarkdownTableRow({ fg = "#804c65" }),
    RenderMarkdownTableHead({ fg = "#804c65" }),
    RenderMarkdownTablFill({ fg = "#804c65" }),
    RenderMarkdownDash({ fg = "#624b17" }),
    RenderMarkdownInfo({ fg = "#0078a4" }),
    RenderMarkdownSuccess({ fg = "#079c7e" }),
    RenderMarkdownHint({ fg = "#276cce" }),
    RenderMarkdownWarn({ fg = "#83601f" }),
    RenderMarkdownError({ fg = "#991a1a" }),
    -- RenderMarkdownCodeInline({}),
    RenderMarkdownCode({ CodeBlock }),

    HelpviewTitle({ fg = "#c19A96", bg = "#141000", gui = "bold" }),
    HelpviewHeading1({ fg = "#1b8b95", bg = "#001808", gui = "bold" }),
    HelpviewHeading2({ fg = "#826591", bg = "#080406", gui = "bold" }),
    HelpviewHeading3({ fg = "#688cce", bg = "#182c4e", gui = "bold" }),
    HelpviewHeading4({ fg = "#448c8e", bg = "#08162b", gui = "bold" }),

    HelpviewCode({ CodeBlock }),
    HelpviewInlineCode({ CodeBlock }),
    HelpviewCodeLanguage({ fg = "#5f798a", bg = "none", italic = true }),

    HelpviewTaglink({ fg = "#01aab5", bg = "none", gui = "bold" }),
    HelpviewOptionlink({ fg = "#7755aa", bg = "none" }),
    HelpviewMentionlink({ fg = "#3388cc", bg = "none", gui = "italic" }),

    RecallMark({ fg = "#00baca" }),
    MiniJump({ fg = "#ff00a0" }),

    -- Eyeliner
    EyelinerPrimary({ fg = "#e06c75", gui = "bold" }),
    EyelinerSecondary({ fg = "#d19a66", gui = "bold" }),
    EyelinerDimmed({ fg = "#4e5769" }),

    -- ScrolllView
    ScrollView({ bg = "#224385" }),
    ScrollViewCursor({ fg = "#334365" }),
    ScrollViewSearch({ fg = "#3373c5" }),
  }
end
