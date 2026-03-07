---@diagnostic disable undefined-globalcolor/nick
-- *bold*      *inverse*   *italic*      *standout*    *strikethrough* *altfont* *nocombine*
-- *underline* *undercurl* *underdouble* *underdotted* *underdashed*

local lush = require("lush")
local hsl = lush.hsl
local clrutil = require("utils.colors")

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
  nord9 = hsl(210, 34, 63), -- #81A1C1
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
  red_faded = "#430000",
  green_faded = "#004a47",
  blue_faded = "#173787",
}

return function(injected_functions)
  local sym = injected_functions.sym
  return {
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
    Normal({ fg = "#4f7aaf", bg = "#000000" }),
    NormalNC({ fg = "#4C84b8", bg = "#000000" }),

    Todo({ fg = "none", bg = "none", gui = "none" }),
    TodoMsg({ fg = "#2583cB", gui = "italic" }),
    Warning({ bg = "none", fg = "#aB6F34", gui = "italic" }),
    WarningMsg({ bg = "none", fg = clrs.nord13 }),
    DebugMsg({ fg = "#565f89" }),
    EndOfBuffer({ fg = clrs.nord1 }),
    Error({ fg = "#aa3049", bg = "none" }),
    ErrorMsg({ Error }),
    ModeMsg({ fg = "#5D81AC" }),
    MoreMsg({ fg = "#87BFCF" }),
    Question({ fg = clrs.nord4 }),
    healthError({ fg = "#BE6069", bg = "none" }),
    healthSuccess({ fg = "#22BB99", bg = "none" }),
    healthWarning({ fg = "#EBCA89", bg = "none" }),

    Search({ bg = "#0e1c36", fg = "#008fff", gui = "italic" }), -- bg = '#0d314c',
    IncSearch({ bg = "#23518b", fg = "#88aaff", gui = "italic" }),
    CurSearch({ bg = "#4e3ce6", fg = "#aaffff" }), --  bg = '#110033'
    -- CurSearch({ fg = '#cc2266', gui = 'bold' }), --  bg = '#110033'

    -- bg - #171f47, bg = #021626, gui = bold,italic
    Visual({ bg = "#08204f", gui = "italic,bold" }),
    VisualNOS({ bg = "#1d3b53" }), -- bg = '#301840'
    VisualAlt({ fg = "none", bg = "#10083f", gui = "italic" }),
    VisualRed({ fg = "none", bg = "#40112c", gui = "italic" }),

    DiffAdd({ bg = "#001c26" }), -- #00361f #001000 #22bb99
    DiffTextAdd({ bg = "#000f20", fg = "#00aabb" }), -- #464b5d #001030 #81a1c1

    -- DiffText guibg=#000f20 guifg=#22ccff
    DiffChange({ bg = "#000f20", fg = "#00ccff", gui = "italic,bold" }), -- #003050 #001030 #646ead
    DiffDelete({ bg = "#200000", fg = "#aa4444", gui = "italic,bold" }), -- #3e0009 #300000 #be6069
    DiffText({ bg = "#000f20", gui = "italic, bold" }), -- #464b5d #001030 #81a1c1
    -- DiffAdd DiffChan DiffText DiffTextAdd DiffDele
    diffAdded({ DiffAdd }),
    diffRemoved({ DiffDelete }),
    diffChanged({ DiffChange }),
    diffOldFile({ fg = clrs.nord9 }),
    diffNewFile({ fg = clrs.nord12 }),
    diffFile({ fg = clrs.nord7 }),
    diffLine({ fg = "#464B5D" }),
    diffIndexLine({ fg = clrs.nord9 }),
    -- DiffAdd        xxx guibg=#273849
    -- DiffChange     xxx guibg=#252a3f
    -- DiffDelete     xxx guibg=#3a273a
    -- DiffText       xxx guibg=#394b70

    MiniDiffSignAdd({ fg = "#064044" }),
    MiniDiffSignChange({ fg = "#063054" }),
    MiniDiffSignDelete({ fg = "#3a273a" }),
    MiniDiffOverAdd({ bg = "#003040", fg = "#1180a0" }),
    MiniDiffOverChange({ bg = "#063064", fg = "#1170b0" }),
    MiniDiffOverChangeBuf({ bg = "#063064", fg = "#1170b0" }),
    MiniDiffOverContext({ bg = "#003884" }),
    -- MiniDiffOverContext({ bg = "#005894" }),
    MiniDiffOverDelete({ bg = "#240000", fg = "#444466" }),

    -- ui components
    SignColumn({ bg = "none" }),
    LineNr({ fg = "#2D476A" }),
    StatusLine({ fg = "NONE", bg = "NONE" }),
    ColorColumn({ bg = "#061028" }),
    CursorColumn({ bg = "#061028" }), --  bg = '#0a1020'
    CursorLine({ bg = "#061028" }),
    CursorLineNr({ fg = "#44aaff", gui = "italic" }), -- bg = CursorLine.bg
    FloatBorder({ fg = "#3f5382", bg = "none" }), -- { bg = '#1f2335', fg = '#29a4bd' },
    FloatTitle({ fg = "#5f73c2", bg = "none" }), -- { bg = '#1f2335', fg = '#29a4bd' },
    FoldColumn({ fg = "#4D578A", bg = "#000000" }),
    FoldIcon({ fg = "#4B4BBB" }),
    FoldText({ fg = "#41b1ff" }),
    Folded({ fg = "#6Db7ca", bg = "#111111" }),
    NormalFloat({ fg = Normal.fg, bg = "none" }),
    NormalWindow({ fg = Normal.fg, bg = "none" }),
    Pmenu({ fg = "#618cc4", bg = "none" }),
    PmenuSbar({ fg = "#313c84", bg = "#202331" }),
    PmenuSel({ fg = "#44bfcf", bg = "#1a1f2f" }),
    PmenuThumb({ fg = "#1f3352", bg = "#244f7f" }),
    Scrollbar({ bg = "#111111", fg = "#224385" }),
    TabLine({ fg = "#616F89", bg = "#21242b", gui = "NONE" }), -- fg = clrs.nord3, bg = clrs.nord1, gui = "NONE"
    TabLineFill({ fg = "none", bg = "#1c1f24" }), -- fg = clrs.nord4, bg = clrs.nord1, gui = "NONE"
    TabLineSel({ fg = "#51afef", bg = "#282c34" }), -- fg = "#a6cfff", bg = "#213c64", gui = "bold"
    Title({ fg = "#88aee9", gui = "NONE" }),
    WinSeparator({ fg = "#444464", bg = "#090919", gui = "bold" }),
    -- CodeBlock({ bg = '#090909' }),
    CodeBlock({ bg = "#040812" }), -- bg = "#101018"
    CodeBlockInline({ bg = "#040814" }), -- bg = "#101018"

    Cursor({ bg = "#3f56ff" }), -- bg = '#4B5Bff'
    nCursor({ Cursor }),
    iCursor({ Cursor }),
    lCursor({ gui = "reverse" }), -- language mapping active
    SpecsCursor({ bg = "#1f6385" }),
    SmoothCursor({ fg = "#0081ca", gui = "italic" }),
    NoiceCursor({ bg = "#003558", gui = "italic", fg = "#17a9b3" }),
    HopCursor({ Cursor }),
    ReactiveCursor({ Cursor }),
    -- NavbuddyCursor({ gui = 'bold' }),
    -- NoiceCursor({ bg = '#4B6BfB' }),  #51e3ed
    -- ScrollViewCursorxxx links to WarningMsg
    -- MiniAnimateCursorxxx cterm=reverse,nocombine gui=reverse,nocombine
    -- CursorIMxxx cterm=reverse gui=reverse
    -- FlashCursor({Cursor})	-- cursor
    -- BqfPreviewCursor { Cursor },

    -- base groups
    Boolean({ fg = "#83709f" }),
    Number({ fg = "#2074c0" }),
    Character({ fg = "#10a4ca" }),
    Comment({ fg = "#405f88", gui = "italic" }),
    Conceal({ bg = "none" }),
    Conditional({ fg = "#70688a" }),
    Constant({ fg = "#66aae2" }),
    ConstantBuiltin({ fg = "#0698b3" }),
    Delimiter({ fg = "#5f6fa2" }),
    Directory({ fg = "#187298" }),
    Field({ fg = "#467aB8" }), -- fg = '#467aB0', fg = '#4688B0'
    Function({ fg = "#8c788c" }), -- fg = "#2d79a7", fg = "#a78087"
    FunctionCall({ fg = "#4d79c7" }), --fg = '#7f788f'
    Identifier({ fg = "#406faf" }),
    Include({ fg = "#4774c6", gui = "italic" }),
    Italic({ gui = "italic" }),
    Keyword({ fg = "#3167a2" }),
    KeywordFunction({ fg = "#2D88BF" }),
    KeywordReturn({ fg = "#2D61aC" }),
    Label({ fg = "#3377ba" }),
    NonText({ bg = "none", fg = "#556677" }),
    Operator({ fg = "#4866bf" }), -- fg = '#28567f'
    -- PreProc({ fg = "#00769c" }), -- fg = '#806a7f'
    PreProc({ fg = Keyword.fg, gui = "italic" }), -- fg = '#806a7f'
    QuickFixLine({ bg = "#172238" }),
    Repeat({ fg = "#806a7f" }),
    Special({ fg = "#487ac8" }),
    SpecialChar({ fg = "#b88698" }), -- For special punctutation that does not fall in the catagories before.
    SpecialComment({ fg = "#3698b3" }),
    Statement({ fg = "#5191D1" }),
    String({ fg = "#1684a4" }),
    Structure({ fg = "#3D71AC" }),
    Tag({ fg = "#7c688c" }),
    Type({ fg = "#418cc4" }),
    TSCurrentScope({ bg = "none", fg = "none" }), --   ReactiveCursorLine@preset.cursorline.@mode.normal, CursorLine
    Variable({ fg = "#5a8ac0" }), -- fg = '#5a8ab0'

    -- +--- Quickfix Styles ---+
    qfFileName({ Directory }),
    qfFileNameHead({ Keyword }),
    qfLineNr({ LineNr }),
    qfSeparator({ fg = "#322c2f" }), -- Delimiter
    qfSeparatorLeft({ qfSeparator }),
    qfSeparatorRight({ qfSeparator }),
    -- qfLineNr({ fg = clrs.highlight, bg = clrs.nord6, gui = 'reverse' }),
    -- qfError { Error },

    -- @comment.error         ; error-type comments (e.g., `DEPRECATED:`)
    -- @comment.warning       ; warning-type comments (e.g., `WARNING:`, `FIX:`)
    -- @comment.hint          ; note-type comments (e.g., `NOTE:`)
    -- @comment.info          ; info-type comments
    -- @comment.todo          ; todo-type comments (e.g-, `TODO:`, `WIP:`)
    -- @markup.strong         ; bold text
    -- @markup.italic         ; text with emphasis
    -- @markup.strikethrough  ; strikethrough text
    -- @markup.underline      ; underlined text (only for literal underline markup!)
    -- @markup.heading        ; headings, titles (including markers)
    -- @markup.quote          ; block quotes
    -- @markup.math           ; math environments (e.g. `$ ... $` in LaTeX)
    -- @markup.environment    ; environments (e.g. in LaTeX)
    -- @markup.link           ; text references, footnotes, citations, etc.
    -- @markup.link.label     ; link, reference descriptions
    -- @markup.link.url       ; URL-style links
    -- @markup.raw            ; literal or verbatim text (e.g., inline code)
    -- @markup.raw.block      ; literal or verbatim text as a stand-alone block
    --                        ; (use priority 90 for blocks with injections)
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
    -- sym('@constructor')({ fg = "#bb9af7" }),
    -- sym('@constructor.tsx')({ fg = 'none', bg = 'none' }),
    -- sym('@keyword')({fg = "#9d7cd8", style = {italic = true, }}),
    -- sym('@keyword.function')({fg = "#bb9af7", style = {}}),
    -- sym('@label')({fg = "#7aa2f7"}),
    -- sym('@namespace')({link = "Include"}),
    -- sym('@operator')({fg = "#89ddff"}),
    -- sym('@operator.tsx')({ fg = 'none', bg = 'none' }),
    -- sym('@property')({fg = "#73daca"}),
    -- sym('@tag.delimiter.tsx')({ fg = 'none', bg = 'none' }),
    -- sym('@tag.jsx')({ fg = 'none', bg = 'none' }),
    -- sym('@tag.tsx')({ fg = 'none', bg = 'none' }),
    -- sym('@text.todo.checked')({fg = "#73daca"}),
    -- sym('@text.todo.unchecked')({ fg = "#7aa2f7", }),
    -- sym('@text.warning')({ bg = "#e0af68", fg = "#24283b", }),
    -- sym('@type.builtin')({ fg = "#29a4bd" }),
    -- sym('@type.tsx')({ fg = 'none', bg = 'none' }),
    -- sym('@variable')({ fg = "#c0caf5", style = {}, }),
    -- sym('@variable.builtin')({ fg = "#f7768e", }),
    -- sym('@variable.tsx')({ fg = 'none', bg = 'none' }),
    sym("@boolean")({ Boolean }),
    sym("@comment")({ Comment }),
    sym("@comment.danger")({ bg = "#db4b4b", fg = "#24283b" }),
    sym("@comment.documentation")({ Comment }),
    sym("@comment.note")({ fg = "#278d8b" }),
    sym("@comment.warning")({ Warning }),
    sym("@conditional")({ Conditional }),
    sym("@constant")({ Constant }),
    sym("@constant.builtin")({ ConstantBuiltin }),
    sym("@constant.luap")({ fg = "#2288cc" }),
    sym("@constructor")({ fg = "none", bg = "none" }),
    sym("@constructor.tsx")({ fg = "none", bg = "none" }),
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
    sym("@keyword.exception")({ Special }),
    sym("@keyword.function")({ KeywordFunction }),
    sym("@keyword.luadoc")({ gui = "none" }),
    sym("@keyword.luap")({ fg = "#5886ff" }),
    sym("@keyword.operator")({ Operator }),
    sym("@keyword.return")({ KeywordReturn }),
    sym("@keyword.directive.define.c")({ fg = "#5886ff", gui = "italic" }),
    sym("@keyword.import.c")({ fg = "#5886ff", gui = "italic" }),
    sym("@label")({ Label }), -- For labels: `label:` in C and `:label:` in Lua.
    sym("@method")({ Function }),
    sym("@method.call")({ FunctionCall }),
    sym("@module")({ PreProc }),
    sym("@module.c")({ fg = "#2288cc", gui = "italic" }),
    sym("@module.builtin")({ Keyword }),
    sym("@nospell")({ fg = "none", bg = "none", gui = "none" }),
    sym("@number")({ Number }),
    sym("@operator")({ Operator }),
    sym("@operator.luap")({ fg = "#08a4ea" }),
    sym("@parameter")({ Statement }),
    sym("@property")({ Identifier }),
    sym("@punctuation.bracket")({ fg = "#7886a8" }), -- fg = "#a9b1d6"
    sym("@punctuation.bracket.luap")({ fg = "#8b8af7" }),
    sym("@punctuation.delimiter")({ fg = "#7886a8" }),
    sym("@punctuation.delimiter.luap")({ fg = "#4866d8" }),
    sym("@punctuation.special")({ fg = "#888698" }), -- #89ddff
    sym("@punctuation.special.markdown")({ fg = "#645060" }), --  fg = '#89ddff'
    sym("@punctuation.strikethrough.markdown_inline")({ Normal }),
    sym("@spell")({}),
    sym("@string")({ String }),
    sym("@string.documentation")({ fg = "#406f88", gui = "italic" }),
    sym("@string.escape")({ fg = "#bb9af7" }),
    sym("@string.regexp")({ fg = "#1a84ba", gui = "none" }),
    sym("@string.special.url")({ gui = "italic" }),
    sym("@tag")({ fg = "#a78086" }),
    sym("@tag.attribute")({ fg = "#5599dd" }),
    sym("@tag.constructor.end.jsx")({ Statement }),
    sym("@tag.constructor.end.tsx")({ Statement }),
    sym("@tag.delimiter")({ sym("@tag") }),
    sym("@tag.delimiter.end.jsx")({ Statement }),
    sym("@tag.delimiter.end.tsx")({ Statement }),
    sym("@tag.end.jsx")({ Statement }),
    sym("@tag.end.tsx")({ Statement }),
    sym("@type")({ Type }),
    sym("@type.builtin")({ fg = "#487795" }),
    sym("@type.builtin.c")({ Type }),
    sym("@lsp.typemod.type.defaultLibrary")({ Type }),
    sym("@uri")({ fg = "#8eb9f6", gui = "none" }),
    sym("@variable")({ Variable }),
    sym("@variable.builtin")({ Identifier }),
    sym("@variable.member")({ Field }),
    sym("@variable.parameter")({ Identifier }),
    sym("@label.vimdoc")({ fg = "#0099cc", gui = "bold" }),
    sym("@variable.parameter.vimdoc")({ fg = "#2288a9" }),
    -- #81c2e1
    -- #253245
    -- +--- LSP ---+
    LspDiagnosticsSignError({ fg = "#702e34" }),
    LspDiagnosticsSignWarn({ fg = "#574c47" }),
    LspDiagnosticsSignHint({ fg = "#206b8b" }),
    LspDiagnosticsSignInfo({ fg = "#0d81bc" }),
    LspCodeLens({ fg = "#6272A4" }),
    LspCodeLensSeparator({ fg = "#7F8CB5" }),
    LspReferenceRead({ fg = Search.fg, gui = "none" }), -- #22bb99, 628bff
    LspReferenceWrite({ fg = Search.fg, gui = "none" }), -- #22bb99
    LspReferenceText({ fg = Search.fg, gui = "none" }), -- #22bb99
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
    DiagnosticUnderulineError({ sp = DiagnosticError.fg, gui = "undercurl" }),
    DiagnosticUnderlineWarn({ sp = DiagnosticWarn.fg, gui = "undercurl" }),
    DiagnosticUnderlineHint({ sp = DiagnosticHint.fg, gui = "undercurl" }),
    DiagnosticUnderlineInfo({ sp = DiagnosticInfo.fg, gui = "undercurl" }),
    DiagnosticVirtualTextError({ fg = "#9a4c54", gui = "italic" }), -- #ffc777
    DiagnosticVirtualTextWarn({ fg = "#7c706a", gui = "italic" }), -- #c53b53
    DiagnosticVirtualTextHint({ fg = "#457d8c", gui = "italic" }), -- "#4fd6be"
    DiagnosticVirtualTextInfo({ fg = "#597597", gui = "italic" }), -- "#0db9d7"
    DiagnosticVirtualLinesError({ fg = "#c53b53", gui = "italic" }),
    DiagnosticVirtualLinesWarn({ fg = "#ffc777", gui = "italic" }),
    DiagnosticVirtualLinesHint({ fg = "#4fd6be", gui = "italic" }),
    DiagnosticVirtualLinesInfo({ fg = "#0db9d7", gui = "italic" }),
    LspInfoBorder({ FloatBorder }),
    NullLsInfoBorder({ FloatBorder }),

    -- sym('@lsp.type.class.javascript')({ sym('@variable') }),
    -- sym('@lsp')({ Keyword })
    -- sym('@lsp.typemod.variable.readonly.javascript')({ Variable })
    -- sym('@lsp.typemod.variable.declaration.javascript')({ Variable })
    sym("@lsp.type.class.javascript")({ Special }),
    sym("@lsp.type.class.markdown")({ fg = "none", bg = "none" }), -- sym('@type') Structure
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

    -- language groups
    --
    TreesitterContext({ bg = "#1a0606", fg = "#143658" }),
    TreesitterContextLineNumber({ fg = "#244668", bg = "#1a0606" }),
    TreesitterContextLineNumberBottom({ fg = "#244668", gui = "underline", guisp = "Grey" }),
    TreesitterContextBottom({ fg = "#00a6f8", guisp = "Grey" }),

    -- sym('@markup.list.checked.markdown')({ fg = '#53fafa', gui = 'bold' }),
    -- sym('@markup')({ fg = '#0789aa' }), --  fg = '#89ddff'
    -- sym('@markup.link.label.markdown_inline')({ fg = '#6c81ff', gui = 'italic' }),
    sym("@markup.raw.markdown_inline")({ fg = "#2779aa", gui = "none" }),
    sym("@markup.raw.block")({ gui = "none", fg = "#2779aa" }),
    sym("@markup.raw")({ fg = "#2779aa", gui = "none" }),
    sym("@markup.strikethrough")({ gui = "strikethrough" }),
    sym("@markup.strikethrough.markdown_inline")({ gui = "strikethrough", fg = Normal.fg }),
    sym("@markup.italic")({ gui = "italic" }),
    sym("@markup.italic.markdown_inline")({ gui = "italic", fg = "#839ac6" }),
    sym("@markup.strong.markdown")({ gui = "" }),
    sym("@markup.strong.markdown_inline")({ gui = "bold", fg = "#839ac6" }),
    sym("@markup.link")({ fg = "#2aa1ae", gui = "italic" }),
    sym("@markup.link.label.markdown")({ fg = "#5c71cf" }),
    sym("@markup.link.label.markdown_inline")({ fg = "#0081aa", gui = "italic" }),
    sym("@markup.list")({ Special }),
    sym("@markup.list.checked")({ fg = "#33cafa", gui = "bold" }),
    sym("@markup.list.unchecked")({ fg = "#7aa2f7" }),
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
    -- markdownTSTitle {},
    mkdListItemLine({ pandocListItem }),

    Dash({ bg = "#341710", fg = "#341710" }),

    helpHyperTextJump({ fg = "#6585b8", gui = "none" }),

    -- typescript
    typescriptImport({ Include }),
    typescriptVariable({ Identifier }),
    -- typescriptAsyncFuncKeyword({ Keyword }),
    typescriptIdentifierName({ Variable }),
    typescriptTypeReference({ Operator }),
    typescriptTypeBrackets({ fg = "#3BaBcB" }),

    -- css
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

    -- man
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
    liquidDelimiter({ fg = "#cc8877" }),

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

    --
    -- Bash/Sh/Zsh/Zinit
    --
    sym("@bash.argumentFlag")({ Identifier }),
    sym("@bash.specialKeyword")({ fg = "#a67860" }), -- yarn, next, node, etc...

    shBrackets({ fg = clr_over.orange }),
    -- shStatement({ Keyword }),
    shSubst({ fg = "#488aaf" }),
    shSubstDelim({ fg = "#5776bc" }),
    shParentheses({ fg = "#c78087" }),
    shFunction({ sym("@keyword.function") }),
    shDeref({ fg = "#488aaf" }),
    shDerefSimple({ fg = "#488aaf" }),
    shLoop({ fg = "#80788a" }),
    shRepeat({ fg = "#80788a" }),
    shConditional({ sym("@conditional") }),
    shVariable({ Normal }),

    zshBrackets({ fg = clr_over.orange }),
    -- sym("@punctuation.special")({ fg = "#888698" }), -- #89ddff

    zshSubst({ fg = "#888698" }),
    zshSubstDelim({ fg = "#5776bc" }),
    zshParentheses({ fg = "#c78087" }),
    zshConditional({ sym("@keyword") }),

    -- zshFunction({ sym("@function") }),
    zshDeref({ fg = "#488aaf" }),
    zshPreProc({ PreProc }),
    zshFunction({ sym("@function") }),
    zshRepeat({ sym("@keyword") }),
    -- zshRepeat({ fg = "#80788a" }),
    -- zshLoop({ fg = "#80788a" }),
    zshCommands({ sym("@function.call") }),
    zshTypes({ sym("@keyword") }),
    -- zshCommands({ fg = "#6180b2" }),
    -- zshVariableDef { Normal },
    -- zshDeref { fg = '#2886bf' },

    ZinitForCommand({ fg = "#a78087" }),
    ZinitPlugin({ fg = "#5588fd", gui = "italic" }), -- Macro, Define
    ZinitSnippet({ fg = "#95b5ed" }), -- Macro, Define
    ZinitIce({ fg = "#87a9ff", gui = "bold" }), -- Type
    Zinitcommand({ fg = "#a78087" }),
    ZinitContinue({ fg = "#4878a8" }),
    ZinitIceDoubleQuoteParam({ fg = "#30b0d9" }), -- Special
    ZinitIceSingleQuoteParam({ fg = "#30c0e9" }),

    -- yaml
    yamlTSField({ fg = "#717cb4" }),
    yamlBlockMappingKey({ yamlTSField }),

    -- html
    htmlEndTag({ fg = "#7f90aa" }),
    htmlTagN({ fg = clr_over.orange }),
    CSVColumnHeaderOdd({ String }),
    CSVColumnHeaderEven({ fg = Statement.fg, bg = "none" }),

    -- plugins --
    MatchWord({ fg = "#aa6699", gui = "italic" }),
    MatchWordCur({ fg = "#aa6699", gui = "italic" }),
    -- MatchParen({ fg = "#fb8b8b", gui = "bold" }),
    MatchParen({ fg = "#f35050", gui = "bold" }),
    MatchParenCur({ fg = "#ff66ff", gui = "bold" }),
    MatchParenCursor({ MatchParenCur }), -- matchparen
    -- Indent Blankline / MiniIndent
    -- IblScope, IblIndent, IblWhitespace
    -- IndentBlanklineChar({ fg = '#102030', gui = 'nocombine' }),
    -- IndentBlanklineContextChar({ fg = colors.purple, gui = 'nocombine' }),
    IblIndent({ fg = "#102030", gui = "nocombine" }),
    -- IblScope({ fg = colors.purple, gui = 'nocombine' }),
    -- IndentBlanklineIndent1({ bg = '#262626', gui = 'nocombine' }),
    -- IndentBlanklineIndent2({ bg = '#1f1f1f', gui = 'nocombine' }),
    IndentGuidesEven({ bg = clrs.nord1 }),
    IndentGuidesOdd({ bg = clrs.nord2 }),
    MiniIndentscopeSymbol({ fg = "#162a3a", bg = "#000000" }),
    -- MiniIndentscopeSymbol({ fg = "#003460", bg = "#000000" }),
    MiniIndentscopeSymbolOff({ fg = "#000000" }),
    -- [[hi default link MiniIndentscopeSymbol Delimiter
    --   hi default link MiniIndentscopeSymbolOff MiniIndentscopeSymbol]],
    -- highlight IndentBlanklineChar guifg=#303030
    -- highlight IndentBlanklineContextChar guifg=#585858
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

    DashboardHeader({ fg = "#8AFF80" }),
    DashboardKey({ fg = "#FF9580" }),
    DashboardCenter({ fg = "#87BFCF" }),
    DashboardDesc({ fg = "#87FEF8" }),
    DashboardIcon({ fg = "#FCFC7F" }),
    DashboardShortCut({ fg = TokyoColors.cyan }),
    DashboardFooter({ fg = "#5D5D65" }),
    -- DashboardHeader ({ fg = colors.blue }),
    -- DashboardCenter ({ fg = colors.purple }),
    -- DashboardFooter ({ fg = colors.green, gui = "italic" }),

    --  nvim-ntoify
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

    -- whatkey
    WhatKeyKey({ fg = "#07c0f7", gui = "none" }), --Function
    WhatKeyOperator({ fg = "#917ccf", gui = "none" }), -- Keyword
    WhatKeyGroup({ fg = "#418cf4", gui = "none" }), -- Keyword
    -- WhatKeyDesc({ fg = "#5d79a1", gui = "italic" }), -- Identifier
    WhatKeyDesc({ fg = "#5d79a1", gui = "italic" }), -- Identifier
    WhatKeySeperator({ fg = "#334664", gui = "bold" }), -- DiffAdded
    WhatKeyFloat({ bg = NormalFloat.bg }), -- NormalFloat
    WhatKeyCursorLine({ bg = "#0a2446", gui = "bold" }),
    -- WhatKeyGroup = { fg = clrs.text },
    -- WhatKeyDesc = { fg = clrs.nord7, gui = "italic" },
    -- WhatKeySeperator = { fg = clrs.fg },
    -- WhatKeyValue { bg = clrs.float }, -- Comment
    -- WhatKey = { fg = colors.purple, gui = "bold" },
    -- WhatKeyGroup = { fg = colors.cyan },
    -- WhatKeyDesc = { fg = colors.blue, gui = "italic" },
    -- WhatKeySeperator = { fg = colors.green },
    -- WhatKeyFloat = { bg = colors.active },
    -- WhatKeyGroup = { fg = clrs.text },
    -- WhatKeyDesc = { fg = clrs.nord7, gui = "italic" },
    -- WhatKeySeperator = { fg = clrs.fg },

    -- whatkey
    WhichKeyKey({ fg = "#07c0f7", gui = "none" }), --Function
    WhichKeyOperator({ fg = "#917ccf", gui = "none" }), -- Keyword
    WhichKeyGroup({ fg = "#418cf4", gui = "none" }), -- Keyword
    -- WhichKeyDesc({ fg = "#5d79a1", gui = "italic" }), -- Identifier
    WhichKeyDesc({ fg = "#5d79a1", gui = "italic" }), -- Identifier
    WhichKeySeperator({ fg = "#334664", gui = "bold" }), -- DiffAdded
    WhichKeyFloat({ bg = NormalFloat.bg }), -- NormalFloat
    WhichKeyCursorLine({ bg = "#0a2446", gui = "bold" }),

    -- WhichKey({ fg = "#0db9d7" }),
    -- WhichKeyGroup({ fg = c.blue }),
    -- WhichKeyDesc({ fg = c.magenta }),
    -- WhichKeySeparator({ fg = c.comment }),
    -- WhichKeyNormal({ bg = c.bg_sidebar }),
    -- WhichKeyValue({ fg = c.dark5 }),
    -- WhichKeyGroup = { fg = clrs.text },
    -- WhichKeyDesc = { fg = clrs.nord7, gui = "italic" },
    -- WhichKeySeperator = { fg = clrs.fg },
    -- WhichKeyValue { bg = clrs.float }, -- Comment
    -- WhichKey = { fg = colors.purple, gui = "bold" },
    -- WhichKeyGroup = { fg = colors.cyan },
    -- WhichKeyDesc = { fg = colors.blue, gui = "italic" },
    -- WhichKeySeperator = { fg = colors.green },
    -- WhichKeyFloat = { bg = colors.active },
    -- WhichKeyGroup = { fg = clrs.text },
    -- WhichKeyDesc = { fg = clrs.nord7, gui = "italic" },
    -- WhichKeySeperator = { fg = clrs.fg },

    -- NvimTreesitterPairsSelf({ MatchParen }),
    -- NvimTreesitterPairsPartner({ MatchParen }),
    NvimTreesitterPairsSelf({ fg = "#f35050" }),
    NvimTreesitterPairsPartner({ fg = "#f79000" }),

    -- treesitter
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

    -- nvim-cmp
    CmpCursorLine({ bg = "#142446" }),
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
    AerialDefault({ bg = "none", fg = "none" }), -- fg = Normal.fg.darken(30)
    AerialGuide({ fg = "#182838" }),
    AerialLine({ fg = "#00aacc", bg = "#002233", gui = "bold" }),
    AerialLineNC({ fg = "#00ff88", bg = "blue" }), -- AerialLine
    AerialArrayIcon({ CmpItemKindArray }), -- Identifier,
    AerialBooleanIcon({ CmpItemKindBoolean }), -- Identifier
    AerialClassIcon({ CmpItemKindClass }), -- -Type
    AerialConstantIcon({ CmpItemKindConstant }), --Constant
    -- AerialFieldIcon({ Identifier }),
    AerialFileIcon({ CmpItemKindFile }), -- -Identifier
    AerialFunctionIcon({ CmpItemKindFunction }), -- -Function
    AerialInterfaceIcon({ CmpItemKindInterface }), -- -Type
    AerialKeyIcon({ CmpItemKindKey }), -- -Identifier
    AerialMethodIcon({ CmpItemKindMethod }), -- Function
    AerialModuleIcon({ CmpItemKindModule }), -- Include
    AerialNamespaceIcon({ CmpItemKindNamespace }), -- Include
    AerialNullIcon({ CmpItemKindNull }), -- Identifier
    AerialNumberIcon({ CmpItemKindNumber }), -- Identifier
    AerialObjectIcon({ CmpItemKindObject }), -- Identifier
    AerialOperatorIcon({ CmpItemKindOperator }), -- Identifier
    AerialPackageIcon({ CmpItemKindPackage }), -- Include
    AerialPropertyIcon({ CmpItemKindProperty }), -- Identifier
    AerialStringIcon({ CmpItemKindString }), -- -Identifier
    AerialStructIcon({ CmpItemKindStruct }), -- -Type
    AerialTypeParameterIcon({ CmpItemKindTypeParameter }), -- -Identifier
    AerialVariableIcon({ CmpItemKindVariable }), -- Identifier

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
    TelescopeMatching({ fg = "#4070cc", bg = "none" }),
    TelescopeFrecencyScores({ fg = "#34799c" }),
    TelescopeBufferLoaded({ fg = "#47a0f0" }),
    TelescopeSelectionCaret({ fg = "#04f9cc" }),
    TelescopeSelection({ fg = "#008acf", gui = "bold", bg = CursorLine.bg }), -- bg = "#202324"
    TelescopeMultiIcon({ fg = "#0028ff", bg = "#10003c", gui = "bold" }),
    TelescopeMultiSelection({ fg = "#2080cf", bg = "#001024", gui = "italic" }),
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

    -- TelescopeResultsDiffAdd
    -- TelescopeResultsDiffChange
    -- TelescopeResultsDiffDelete
    -- TelescopeResultsDiffUntracked
    -- TelescopePromptCounter { NonText },
    -- TelescopePathSeparator { fg = '#667788' },
    -- TelescopeQueryFilter { fg = '#4466FF'},
    -- TelescopeResultsComment = {},
    -- TelescopeMultiSelection guifg=#928374          " Multisections
    vimAugroup({ fg = "#2080cf" }),
    vimAutoEvent({ TelescopeResultsField }),

    -- navbuddy
    NavbuddyName({ bg = "#40112f", gui = "bold" }), -- fg = '#eceff4', bg = '#5d61ec'
    NavbuddyTitleBorder({ fg = "#222222" }),
    NavbuddyScope({ bg = "#061026", gui = "italic" }),
    -- NavbuddyCursor({ gui = 'bold' }),
    -- NavbuddyCursorLine({}),
    -- NavbuddyNormalTitle({ fg = "#222222" }),

    IlluminatedWordRead({ bg = "#101c39", gui = "" }),
    IlluminatedWordText({ bg = "#101c39", gui = "" }),
    IlluminatedWordWrite({ bg = "#101c39", gui = "" }),

    -- highlight-undo
    HighlightUndo({ fg = "#b7001e", bg = "#0f2139" }),
    HighlightRedo({ fg = "#00ffdd", bg = "#003149" }),

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
    -- GitSignsAdd                   `GitGutterAdd`, `SignifySignAdd`, `DiffAddedGutter`, `Added`, `DiffAdd`
    -- GitSignsAddCul                `GitSignsAdd`
    -- GitSignsAddInline             `TermCursor`
    -- GitSignsAddLn                 `GitGutterAddLine`, `SignifyLineAdd`, `DiffAdd`
    -- GitSignsAddLnInline           `GitSignsAddInline`
    -- GitSignsAddNr                 `GitGutterAddLineNr`, `GitSignsAdd`
    -- GitSignsAddPreview            `GitGutterAddLine`, `SignifyLineAdd`, `DiffAdd`
    -- GitSignsChange                `GitGutterChange`, `SignifySignChange`, `DiffModifiedGutter`, `Changed`, `DiffChange`
    -- GitSignsChangeCul             `GitSignsChange`
    -- GitSignsChangeInline          `TermCursor`
    -- GitSignsChangeLn              `GitGutterChangeLine`, `SignifyLineChange`, `DiffChange`
    -- GitSignsChangeLnInline        `GitSignsChangeInline`
    -- GitSignsChangeNr              `GitGutterChangeLineNr`, `GitSignsChange`
    -- GitSignsChangedelete          `GitSignsChange`
    -- GitSignsChangedeleteCul       `GitSignsChangeCul`
    -- GitSignsChangedeleteLn        `GitSignsChangeLn`
    -- GitSignsChangedeleteNr        `GitSignsChangeNr`
    -- GitSignsCurrentLineBlame      `NonText`
    -- GitSignsDelete                `GitGutterDelete`, `SignifySignDelete`, `DiffRemovedGutter`, `Removed`, `DiffDelete`
    -- GitSignsDeleteCul             `GitSignsDelete`
    -- GitSignsDeleteInline          `TermCursor`
    -- GitSignsDeleteLnInline        `GitSignsDeleteInline`
    -- GitSignsDeleteNr              `GitGutterDeleteLineNr`, `GitSignsDelete`
    -- GitSignsDeletePreview         `GitGutterDeleteLine`, `SignifyLineDelete`, `DiffDelete`
    -- GitSignsDeleteVirtLn          `GitGutterDeleteLine`, `SignifyLineDelete`, `DiffDelete`
    -- GitSignsDeleteVirtLnInLine    `GitSignsDeleteLnInline`
    -- GitSignsStagedAdd             `GitSignsAdd` (fg=50%)
    -- GitSignsStagedAddCul          `GitSignsAddCul` (fg=50%)
    -- GitSignsStagedAddLn           `GitSignsAddLn` (fg=50%)
    -- GitSignsStagedAddNr           `GitSignsAddNr` (fg=50%)
    -- GitSignsStagedChange          `GitSignsChange` (fg=50%)
    -- GitSignsStagedChangeCul       `GitSignsChangeCul` (fg=50%)
    -- GitSignsStagedChangeLn        `GitSignsChangeLn` (fg=50%)
    -- GitSignsStagedChangeNr        `GitSignsChangeNr` (fg=50%)
    -- GitSignsStagedChangedelete    `GitSignsChangedelete` (fg=50%)
    -- GitSignsStagedChangedeleteCul `GitSignsChangedeleteCul` (fg=50%)
    -- GitSignsStagedChangedeleteLn  `GitSignsChangedeleteLn` (fg=50%)
    -- GitSignsStagedChangedeleteNr  `GitSignsChangedeleteNr` (fg=50%)
    -- GitSignsStagedDelete          `GitSignsDelete` (fg=50%)
    -- GitSignsStagedDeleteCul       `GitSignsDeleteCul` (fg=50%)
    -- GitSignsStagedDeleteNr        `GitSignsDeleteNr` (fg=50%)
    -- GitSignsStagedTopdelete       `GitSignsTopdelete` (fg=50%)
    -- GitSignsStagedTopdeleteCul    `GitSignsTopdeleteCul` (fg=50%)
    -- GitSignsStagedTopdeleteLn     `GitSignsTopdeleteLn` (fg=50%)
    -- GitSignsStagedTopdeleteNr     `GitSignsTopdeleteNr` (fg=50%)
    -- GitSignsStagedUntracked       `GitSignsUntracked` (fg=50%)
    -- GitSignsStagedUntrackedCul    `GitSignsUntrackedCul` (fg=50%)
    -- GitSignsStagedUntrackedLn     `GitSignsUntrackedLn` (fg=50%)
    -- GitSignsStagedUntrackedNr     `GitSignsUntrackedNr` (fg=50%)
    -- GitSignsTopdelete             `GitSignsDelete`
    -- GitSignsTopdeleteCul          `GitSignsDeleteCul`
    -- GitSignsTopdeleteLn           `GitSignsDeleteLn`
    -- GitSignsTopdeleteNr           `GitSignsDeleteNr`
    -- GitSignsUntracked             `GitSignsAdd`
    -- GitSignsUntrackedCul          `GitSignsAddCul`
    -- GitSignsUntrackedLn           `GitSignsAddLn`
    -- GitSignsUntrackedNr           `GitSignsAddNr`
    -- GitSignsVirtLnum              `GitSignsDeleteVirtLn`

    -- CybuFocus guifg=#8396b9 guibg=#101840 Operator
    -- CybuAdjacent guifg=#4a647b
    -- CybuBackgrou links to Normal
    -- CybuBorder links to FloatBorder
    -- CybuInfobar links to StatusLine

    -- flash.nvim
    FlashBackdrop({ fg = "#405560" }), -- #1a1f2a
    FlashLabel({ fg = "#cc0044", bg = "none", gui = "bold,italic" }), -- #0d314c
    FlashCharMatch({ fg = "#33c78a", bg = "#0a331a" }),
    FlashCharLabel({ fg = "#33aaff", bg = "none", gui = "bold,italic" }),
    -- FlashCharLabel({ fg = '#ff00ff', bg = '#000000', gui = 'bold,italic' }),
    -- FlashBackdrop({	Comment	}), -- backdrop -- fg=#666666
    -- FlashMatch({	Search	}), -- search matches -- fg=#EEEEEE
    -- FlashCurrent({	IncSearch	}), -- current match -- fg=#ffaf00 gui=Bold
    -- FlashLabel({	Substitute	}), -- jump label
    -- FlashLabel = { bg = '#ff007c', bold = true, fg = '#c0caf5', },
    --   guifg=#ff5555 guibg=#000000 gui=Bold, bg = '#ff007c', bold = true, fg = '#c0caf5',
    -- FlashPrompt({	MsgArea	}), -- prompt
    -- FlashPromptIcon({	Special	}), -- prompt icon
    -- FlashBackdropRemote
    -- FlashRemoteLine

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

    BackseatText({ DiagnosticFloatingHint, gui = "italic" }),

    -- RenamerNormal Normal
    RenamerBorder({ fg = "#4466ff" }),
    -- RenamerTitle Identifier

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
    -- ('BufferCurrentSign',    ,   #282c34, 'none')
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
    -- NoiceCmdlinePopupTitleCmdline({ fg = "" }),
    -- NoiceCmdlinePopupBorderCmdline({ fg = "" }),

    NoiceCmdlinePopupTitleFilter({ fg = "#b48ead" }),
    NoiceCmdlinePopupBorderFilter({ fg = "#845e6d" }),
    NoiceCmdlineIconFilter({ fg = "#845e6d", gui = "bold" }),

    NoiceCmdlinePopupTitleEval_lua({ fg = "#44a0ff", bg = "none" }),
    NoiceCmdlinePopupBorderEval_lua({ fg = "#2080ff", bg = "none" }),
    NoiceCmdlineIconEval_lua({ fg = "#2080ff", bg = "none", gui = "bold" }),

    NoiceCmdlinePopupTitleLua({ fg = "#22aafF", bg = "none" }),
    NoiceCmdlinePopupBorderLua({ fg = "#0099fF", bg = "none" }),
    NoiceCmdlineIconLua({ fg = "#0099fF", bg = "none", gui = "bold" }),

    NoiceCmdlinePopupTitleHelp({ fg = "#8898FF" }),
    NoiceCmdlinePopupBorderHelp({ fg = "#6B7BFF" }),
    NoiceCmdlineIconHelp({ fg = "#6B7BFF", gui = "bold" }),

    NoiceCmdlinePopupTitleGlobal({ fg = "#60afff" }),
    NoiceCmdlinePopupBorderGlobal({ fg = "#00afef" }),
    NoiceCmdlineIconGlobal({ fg = "#00afef", gui = "bold" }),
    -- NoiceCmdlinePopupTitleHelp({ fg = "#aa00aa" }),
    -- NoiceCmdlinePopupBorderHelp({ fg = "#aa00aa" }),
    -- NoiceCmdlineIconHelp({ fg = "#aa00aa" }),
    -- NoiceCmdlinePopupTitleInput({ fg = "" }),
    -- NoiceCmdlinePopupBorderInput({ fg = "" }),
    -- NoiceCmdlinePopupBorderSubs({ fg = "" }),
    -- NoiceCmdlinePopupTitleSubs({ fg = "" }),
    -- NoiceCmdlinePopupTitleSearch({ fg = "" }),
    -- NoiceCmdlinePopupBorderSearch({ fg = "" }),
    -- NoiceCmdlinePopupTitlePreview({ fg = "" }),
    -- NoiceCmdlinePopupBorderPreview({ fg = "" }),
    -- NoiceCmdlinePopupTitleCalculator({ fg = "" }),
    -- NoiceCmdlinePopupBorderCalculator({ fg = "" }),
    -- NoiceCmdlinePopupBorderIncRename({ fg = "" }),
    -- NoiceCmdlinePopupTitleIncRename({ fg = "" }),
    -- NoiceCmdlinePopupTitleInc_rename({ fg = "" }),
    -- NoiceCmdlinePopupBorderInc_rename({ fg = "" }),
    -- NoiceCmdlinePopup guibg=#0a0e12"
    -- NoiceCmdlineIconCmdline guifg=#d2a8ff"
    -- NoiceCmdlinePopup({ fg = '#00aacc' }),
    -- NoiceCmdlinePopupBorder({ fg = '#4466ff' }),
    -- NoiceCmdlinePopupBorderCalculator({ fg = '#81A1C1' }),
    -- NoiceCmdlinePopupBorderCmdline({ fg = '#88c0d0' }),
    -- NoiceCmdlinePopupBorderFilter({ fg = '#b16286' }),
    -- NoiceCmdlinePopupBorderHelp({ fg = '#2d78c4' }),
    -- NoiceCmdlinePopupBorderLua({ fg = '#2a76b7' }),
    -- NoiceCmdlinePopupBorderLuaExpr({ fg = '#44aaff' }),
    -- NoiceCmdlinePopupBorderNumb({ fg = '#8888ff' }),
    -- NoiceCmdlinePopupBorderSearch({ fg = '#6B8BFF'  }),
    -- NoiceCmdlinePopupSubs({ fg = '#6B8BFF' }),
    -- NoiceCmdlinePrompt({ fg = '#68e0f5" ' }),
    -- NoiceConfirm                      = { fg = C.frost.turquoise, bg = C.bg },           --normal for the confirm view
    -- NoiceConfirmBorder                = { fg = C.frost.turquoise, bg = C.bg },           --Border for the confirm view
    -- NoiceCursor                       = { fg = C.blend.blue, bg = C.blend.bluec1 },      --fake Cursor
    -- NoiceFormatConfirm                = { fg = C.frost.turquoise, bg = C.blend.turquoise }, --
    -- NoiceFormatConfirmDefault         = { fg = C.frost.turquoise, bg = C.blend.turquoise }, --
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

    RenderMarkdownH1({ fg = "#23a5f0" }),
    RenderMarkdownH2({ fg = "#917A66" }),
    RenderMarkdownH3({ fg = "#406ff2" }),
    RenderMarkdownH4({ fg = "#1b8b95" }),
    RenderMarkdownH5({ fg = "#725591" }),
    RenderMarkdownH6({ fg = "#725591" }),
    RenderMarkdownH1Bg({ bg = "#0f162f" }),
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
    --     RenderMarkdownBullet({ fg = "#846d59" }),
    RenderMarkdownBullet({ fg = "#0098cf" }),

    RenderMarkdownTableRow({ fg = "#502c25" }),
    RenderMarkdownTableHead({ fg = "#502c25" }),
    RenderMarkdownTableFill({ fg = "#502c25" }),
    RenderMarkdownDash({ fg = "#624b17" }),
    RenderMarkdownInfo({ fg = "#0078a4" }),
    RenderMarkdownSuccess({ fg = "#079c7e" }),
    RenderMarkdownHint({ fg = "#276cce" }),
    RenderMarkdownWarn({ fg = "#83601f" }),
    RenderMarkdownError({ fg = "#991a1a" }),

    RenderMarkdownCode({ CodeBlock }),
    RenderMarkdownCodeNoFile({ CodeBlock }),
    RenderMarkdownCodeInline({ sym("@markup.raw.markdown_inline") }),
    mkdCode({ CodeBlock }),
    -- mkdCodeEnd({ mkdCode }),

    HelpviewTitle({ fg = "#a5707B", bg = "#100606", gui = "italic" }),
    HelpviewHeading1({ fg = "#1b8b95", bg = "#001808", gui = "" }),
    HelpviewHeading2({ fg = "#826591", bg = "#080406", gui = "" }),
    HelpviewHeading3({ fg = "#688cce", bg = "#182c4e", gui = "" }),
    HelpviewHeading4({ fg = "#448c8e", bg = "#08162b", gui = "" }),

    HelpviewCode({ CodeBlock }),
    HelpviewInlineCode({ CodeBlockInline }),
    HelpviewCodeLanguage({ fg = "#5f798a", bg = "none", gui = "italic" }),

    HelpviewKeycode({ fg = "#836681" }),
    HelpviewTaglink({ fg = "#01aab5", bg = "none", gui = "italic,nocombine" }),
    HelpviewOptionlink({ fg = "#3388cc", bg = "none", gui = "nocombine" }),
    HelpviewMentionlink({ fg = "#3388cc", bg = "none", gui = "italic" }),

    RecallMark({ fg = "#00baca" }),
    MiniJump({ fg = "#ff00a0" }),

    CodeiumSuggestion({ fg = "#e06c75", gui = "italic" }),

    NeoTreeTitleBar({ bg = "#1f2342" }),
    NeoTreeFileNameOpened({ gui = "bold" }),
    NeoTreeGitUntracked({ fg = "#705466", gui = "italic" }),
    NeoTreeAdded({ fg = "#008888" }),
    NeoTreeGitStaged({ fg = "#4c68a0" }),
    NeoTreeGitUnstaged({ fg = "#00aa88" }),
    -- NeoTreeNormal guibg=#010409"
    -- NeoTreeNormalNC guibg=#010409"

    -- Eyeliner
    EyelinerPrimary({ fg = "#e06c75", gui = "bold" }),
    EyelinerSecondary({ fg = "#d19a66", gui = "bold" }),
    EyelinerDimmed({ fg = "#4e5769" }),

    -- SatelliteBar
    -- SatelliteCursor
    -- SatelliteDiagnosticError
    -- SatelliteDiagnosticHint
    -- SatelliteDiagnosticInfo
    -- SatelliteDiagnosticWarn
    -- SatelliteGitSignsAdd
    -- SatelliteGitSignsChange
    -- SatelliteGitSignsDelete
    -- SatelliteMark
    -- SatelliteQuickfix
    -- SatelliteSearch
    -- PmenuSbar({ fg = "#313c84", bg = "#202331" }),
    -- PmenuSel({ fg = "#44bfcf", bg = "#1a1f2f" }),
    -- PmenuThumb({ fg = "#1f3352", bg = "#244f7f" }),

    SatelliteBar({ bg = "#203361" }),
    -- SatelliteBarInactive({ fg = "#405f88" }),
    SatelliteBarInactive({ bg = "#203361" }),
    SatelliteBarScrolling({ bg = "#224385" }),
    SatelliteCursor({ fg = "#313c84", bg = "#224385" }),

    -- ScrolllView
    ScrollView({ bg = "#224385" }),
    ScrollViewCursor({ fg = "#334365" }),
    ScrollViewSearch({ fg = "#3373c5" }),

    -- TinyGlimmer({ bg = "#1f2342" }),

    TinyGlimmerFrom({ VisualAlt }),
    TinyGlimmerTo({ bg = Normal.bg }),

    TinyGlimmerDelete({ bg = "#583042" }),
    TinyGlimmerAdd({ bg = "#065C6C" }),

    TinyGlimmerYankFrom({ bg = "#032568" }),
    TinyGlimmerYankTo({ TinyGlimmerTo }),

    TinyGlimmerSubFrom({ bg = "#3303a5" }),
    TinyGlimmerSubTo({ TinyGlimmerTo }),

    TinyGlimmerPasteFrom({ bg = DiffAdd.bg }),
    TinyGlimmerPasteTo({ TinyGlimmerTo }),

    TinyGlimmerSearchFrom({ bg = "#3373c5" }),
    TinyGlimmerSearchTo({ TinyGlimmerTo }),

    TinyGlimmerPulsarFrom({ bg = "#123448" }),
    TinyGlimmerPulsarTo({ TinyGlimmerTo }),

    -- substitute.nvim / vim-abolish
    SubstituteExchange({ VisualRed }),
    SubstituteRange({ VisualRed }),

    -- multicursor.nvim
    MultiCursorCursor({ bg = "#40112c", gui = "italic,underline,bold" }),
    MultiCursorVisual({ Visual }),
    MultiCursorSign({ fg = Cursor.bg }),
    MultiCursorMatchPreview({ Search }),
    MultiCursorDisabledCursor({ reverse = true }),
    MultiCursorDisabledVisual({ Visual }),
    MultiCursorDisabledSign({ SignColumn }),

    -- leepfrog spidermonkey and psl

    sym("@lsp.type.enum")({ sym("@type") }),
    spidercodeTag({ fg = "#990000" }),
    sym("@keyword.directive.spidercode")({ spidercodeTag }),
    pslDirective({ spidercodeTag }),
    pslNegative({ fg = "#804A67" }),
    pslPositive({ fg = "#00aAa7" }),
    pslImport({ fg = "#c86040" }),
    pslMultiline({ fg = "#a7a7a7" }),
    pslVariable({ fg = "#008AF7" }),
    tcfAttrName({ fg = "#7F93E2" }),
    tcfAttrValue({ fg = "#C8C8C8" }),
    tcfAttrDiv({ fg = "#AACCFF", gui = "bold" }),
    tcfAttrRev({ fg = "#888888", gui = "italic" }),
    tcfAttrRevNum({ fg = "#888888", gui = "italic" }),
    tcfAttrRevName({ fg = "#888888", gui = "italic" }),
    tcfAttrRevDiv({ fg = "#888888", gui = "italic" }),
    tcfAttrRevValue({ fg = "#888888", gui = "italic" }),
    NeoCodeiumSingleLineLabel({ fg = "#c86040", gui = "bold,italic", bg = "none" }),
    NeoCodeiumLabel({ fg = "#aa4488", gui = "bold,italic", bg = "none" }),
    NeoCodeiumSuggestion({ fg = "#008866", gui = "italic", bg = "none" }),
    -- NeoCodeiumSuggestion({ fg = "#804243", gui = "italic" }),
  }
end
