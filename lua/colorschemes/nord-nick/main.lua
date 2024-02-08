---@diagnostic disable
--luacheck: ignore

local lush = require('lush')
local hsl = lush.hsl
local clrutil = require('utils.colors')
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
  none = 'NONE',
  bg_dark = '#1c1f24',
  bg = '#24283b',
  bg_highlight = '#292e42',
  terminal_black = '#414868',
  fg = '#c0caf5',
  fg_dark = '#a9b1d6',
  fg_gutter = '#3b4261',
  dark3 = '#545c7e',
  comment = '#565f89',
  dark5 = '#737aa2',
  blue0 = '#3d59a1',
  blue = '#7aa2f7',
  cyan = '#7dcfff',
  blue1 = '#2ac3de',
  blue2 = '#0db9d7',
  blue5 = '#89ddff',
  blue6 = '#B4F9F8',
  blue7 = '#394b70',
  magenta = '#bb9af7',
  magenta2 = '#ff007c',
  purple = '#7d7cf8',
  orange = '#ff9e64',
  yellow = '#e0af68',
  green = '#9ece6a',
  green1 = '#73daca',
  green2 = '#41a6b5',
  teal = '#1abc9c',
  red = '#f7768e',
  red1 = '#db4b4b',
  git = { change = '#6183bb', add = '#449dab', delete = '#914c54', conflict = '#bb7a61' },
  gitSigns = { add = '#164846', change = '#394b70', delete = '#823c41' },
}

local colors = {
  fg = '#A8C0E0',
  fg_light = '#E5E9F0',
  bg_dark = '#1c1f24',
  bg = '#2E3440',
  gray = '#646A76',
  light_gray = '#6C7A96',
  cyan = '#88C0D0',
  blue = '#81A1C1',
  dark_blue = '#5E81AC',
  green = '#A3BE8C',
  light_green = '#8FBCBB',
  dark_red = '#BF616A',
  red = '#D57780',
  light_red = '#DE878F',
  pink = '#E85B7A',
  dark_pink = '#E44675',
  orange = '#D08F70',
  yellow = '#EBCB8B',
  purple = '#B988B0',
  light_purple = '#B48EAD',
  none = 'NONE',
  highlight = hsl('#101c39'),
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
  nord7 = '#6f9cbb',
  nord8 = hsl(193, 43, 67), -- #87BFCF
  nord9 = hsl(210, 34, 63), -- #81A1C1
  nord10 = hsl(213, 32, 52), -- #5D81AC
  nord11 = hsl(354, 42, 56), -- #BE6069
  nord12 = hsl(14, 51, 63), -- #D18771
  nord13 = hsl(20, 10, 55), -- #EBCA89
  -- nord14 = hsl(92, 28, 65), -- #A4BF8D
  nord14 = '#22BB99',
  -- nord15 = hsl(311, 20, 63), -- #B48EAD
  nord15 = '#646EAD',
  nord16 = '#3698b3',
  none = 'NONE',
  highlight = '#1F2233',
  disabled = '#464B5D',
  accent = '#84FFFF',
  error = '#aa3049',
}

local clr_over = {
  selection = '#101840',
  orange_faded = '#80788a',
  orange = '#cc8877',
  yellow = '#bdb994',
  yellow_faded = '#7B6B3B',
  purple_faded = '#6A6CAB',
  red_faded = '#7F212A',
  green_faded = '#027A57',
  blue_faded = '#4161B1',
}

return function(injected_functions)
  local sym = injected_functions.sym
  return {
    Visual({ fg = 'none', bg = '#101840', gui = 'bold,italic' }),
    VisualAlt({ fg = 'none', bg = '#141436', gui = 'bold,italic' }),
    VisualRed({ fg = 'none', bg = '#40112c', gui = 'bold,italic' }),
    Error({ fg = clrs.error, bg = 'none' }),
    -- Error({ fg = "none", bg = "none" }),
    Underline({ gui = 'none' }),
    Underlined({ gui = 'none' }),
    Normal({ fg = clrs.nord4.darken(40), bg = 'none' }),
    -- ui components
    NormalWindow({ fg = Normal.fg, bg = 'none' }),
    NormalFloat({ fg = Normal.fg, bg = 'none' }), -- normal text and background color for floating windows
    Title({ fg = '#88aee9', gui = 'NONE' }),
    FloatBorder({ fg = '#3f5382', bg = 'none' }), --
    FloatTitle({ fg = '#5f73c2', bg = 'none' }), --
    Pmenu({ fg = '#618cc4', bg = 'none' }),
    PmenuSel({ fg = '#44bfcf', bg = '#1a1f2f' }),
    PmenuSbar({ fg = '#313c84', bg = '#202331' }),
    PmenuThumb({ fg = '#1f3352', bg = '#446faf' }),
    -- TabLine({ fg = clrs.nord4, bg = clrs.nord1, gui = "NONE" }),
    -- TabLineFill({ fg = clrs.nord4, bg = clrs.nord1, gui = "NONE" }),
    TabLine({ fg = clrs.nord3, bg = clrs.nord1, gui = 'NONE' }),
    TabLineSel({ fg = '#a6cfff', bg = '#213c64', gui = 'bold' }),
    WinSeparator({ fg = '#444464', bg = '#090909', gui = 'bold' }),
    VisualNOS({ fg = 'none', bg = clr_over.selection }),
    -- TabLineFill({ fg = clrs.nord4, bg = clrs.nord1, gui = "NONE" }),
    -- WinBar({ fg = "#313c84", bg = "#202331" }),
    -- WinBarNC({ fg = "#4f5362", bg = "#446faf" }),
    -- WinBarLocation({ fg = "#888888", bg = "#202331", gui = "bold" }),
    -- WinBarModified({ fg = "#d7d787", bg = "#202331", gui = "bold" }),
    -- WinBarGitDirty({ fg = "#d7afd7", bg = "#202331", gui = "bold" }),
    -- WinBarIndicator({ fg = "#5fafd7", bg = "#202331", gui = "bold" }),
    -- WinBarInactive({ bg = "#3a3a3a", fg = "#777777", gui = "bold" }),
    SignColumn({ bg = 'none' }),
    LineNr({ fg = clrs.nord3 }),
    Boolean({ fg = '#5370af' }),
    Number({ fg = '#4078c0' }),
    -- CursorLine({ bg = '#0a1020' }),
    CursorLine({ bg = '#061028' }),
    CursorLineNr({ fg = '#44aaff', bg = CursorLine.bg, gui = 'italic' }),
    Cursor({ bg = '#4B5Bff' }),
    CursorColumn({ bg = CursorLine.bg }),
    ColorColumn({ bg = CursorLine.bg }),
    -- base groups
    -- FoldIcon({ fg = "#4B4BBB" }),
    -- MatchParenCursor({ fg = "#fb8b8b" }),
    Character({ fg = '#10a4ca', gui = 'bold' }),
    Comment({ fg = '#4a647b', gui = 'italic' }),
    Conceal({ bg = 'none' }),
    Conditional({ fg = '#70688a' }),
    Constant({ fg = '#3698b3' }),
    ConstantBuiltin({ fg = '#0698b3' }),
    Delimiter({ fg = '#5f6fa2' }),
    Directory({ fg = '#187298' }),
    -- Field({ fg = '#4688B0' }),
    -- Field({ fg = '#467aB0' }),
    Field({ fg = '#467aB8' }),
    FoldColumn({ fg = '#4D578A', bg = '#000000' }),
    FoldText({ fg = '#41b1ff', gui = 'bold' }),
    Folded({ fg = '#6Db7ca', bg = '#111111', gui = 'bold' }),
    Function({ fg = '#2d79a7' }),
    FunctionCall({ fg = '#4d79c7' }),
    -- Function({ fg = '#8c788c' }),
    -- FunctionCall({ fg = '#7f788f' }),
    Identifier({ fg = '#5e88b6' }),
    IncSearch({ fg = '#eceff4', bg = '#5d61ec' }),
    Include({ fg = '#4774c6' }),
    Keyword({ fg = '#4177b2' }),
    KeywordFunction({ fg = '#2D88BF' }),
    KeywordReturn({ fg = '#2D81BC' }),
    Label({ fg = '#3377ba' }),
    NonText({ bg = 'none', fg = '#556677' }),
    Operator({ fg = '#4866bf' }),
    -- Operator({ fg = '#28567f' }),
    -- PreProc({ fg = '#806a7f' }),
    PreProc({ fg = '#4796bc' }),
    QuickFixLine({ bg = '#172238' }),
    Repeat({ fg = '#806a7f' }),
    Scrollbar({ bg = '#111111', fg = '#334863' }),
    Search({ fg = '#74efff', bg = '#0d314c', gui = 'NONE' }),
    Special({ fg = '#487ac8' }),
    SpecialChar({ fg = '#b88698' }), -- For special punctutation that does not fall in the catagories before.
    SpecialComment({ fg = '#3698b3' }),
    Statement({ fg = '#5191D1' }),
    String({ fg = '#1094aa' }),
    Structure({ fg = '#3D71AC' }),
    Type({ fg = '#418cc4' }),
    -- Variable({ fg = '#5a8ab0' }),
    Variable({ fg = '#5a8ac0' }),
    healthError({ fg = '#BE6069', bg = 'none' }),
    healthSuccess({ fg = '#22BB99', bg = 'none' }),
    healthWarning({ fg = '#EBCA89', bg = 'none' }),
    qfFileName({ Directory }),
    qfFileNameHead({ Keyword }),
    qfLineNr({ LineNr }),
    qfSeparator({ fg = '#322c2f' }), -- Delimiter
    qfSeparatorLeft({ qfSeparator }),
    qfSeparatorRight({ qfSeparator }),
    -- qfLineNr({ fg = clrs.highlight, bg = clrs.nord6, gui = 'reverse' }),
    -- qfError { Error },
    -- +--- Prompt/Status ---+
    EndOfBuffer({ fg = clrs.nord1 }),
    ErrorMsg({ Error }),
    ModeMsg({ fg = clrs.nord10 }),
    MoreMsg({ fg = clrs.nord8, gui = 'bold' }),
    DebugMsg({ fg = Comment.fg }),
    Question({ fg = clrs.nord4 }),
    -- +--- LSP ---+
    LspInfoBorder({ FloatBorder }),
    NullLsInfoBorder({ FloatBorder }),
    DiagnosticOk({ fg = '#1abc9c' }),
    DiagnosticError({ fg = '#8d3a42' }),
    DiagnosticWarn({ fg = '#6d605a' }),
    DiagnosticHint({ fg = '#206b8b' }),
    DiagnosticInfo({ fg = '#0d81bc' }),
    DiagnosticFloatingError({ DiagnosticError }),
    DiagnosticFloatingWarn({ DiagnosticWarn }),
    DiagnosticFloatingHint({ DiagnosticHint }),
    DiagnosticFloatingInfo({ DiagnosticInfo }),
    DiagnosticFloatingErrorBorder({ fg = '#5a070f' }),
    DiagnosticFloatingWarnBorder({ fg = '#584b45' }),
    DiagnosticFloatingHintBorder({ fg = '#195474' }),
    DiagnosticFloatingInfoBorder({ fg = '#0067a2' }),
    DiagnosticSignError({ DiagnosticError }),
    DiagnosticSignWarn({ DiagnosticWarn }),
    DiagnosticSignHint({ DiagnosticHint }),
    DiagnosticSignInfo({ DiagnosticInfo }),
    LspDiagnosticsSignError({ fg = '#702e34' }),
    LspDiagnosticsSignWarn({ fg = '#574c47' }),
    LspDiagnosticsSignHint({ fg = '#206b8b' }),
    LspDiagnosticsSignInfo({ fg = '#0d81bc' }),
    DiagnosticUnderlineError({ fg = 'none', gui = 'none' }),
    DiagnosticUnderlineWarn({ fg = 'none', gui = 'none' }),
    DiagnosticUnderlineHint({ fg = 'none', gui = 'none' }),
    DiagnosticUnderlineInfo({ fg = 'none', gui = 'none' }),
    DiagnosticVirtualTextError({ fg = '#9a4c54', gui = 'italic' }), -- #ffc777
    DiagnosticVirtualTextWarn({ fg = '#7c706a', gui = 'italic' }), -- #c53b53
    DiagnosticVirtualTextHint({ fg = '#457d8c', gui = 'italic' }), -- "#4fd6be"
    DiagnosticVirtualTextInfo({ fg = '#597597', gui = 'italic' }), -- "#0db9d7"
    -- DiagnosticVirtualLinesError({ fg = '#c53b53', gui = 'italic' }),
    -- DiagnosticVirtualLinesWarn({ fg = '#ffc777', gui = 'italic' }),
    DiagnosticVirtualLinesHint({ fg = '#4fd6be', gui = 'italic' }),
    DiagnosticVirtualLinesInfo({ fg = '#0db9d7', gui = 'italic' }),
    LspCodeLens({ fg = '#6272A4' }),
    LspCodeLensSeparator({ fg = '#7F8CB5' }),
    LspReferenceRead({ fg = Search.fg, gui = 'none' }), -- #22bb99, 628bff
    LspReferenceWrite({ fg = Search.fg, gui = 'none' }), -- #22bb99
    LspReferenceText({ fg = Search.fg, gui = 'none' }), -- #22bb99
    DiffAdd({ bg = '#001822' }), -- #00361f #001000 #22bb99
    DiffChange({ bg = '#061024' }), -- #003050 #001030 #646ead
    DiffDelete({ fg = '#444466', bg = '#0E0009' }), -- #3e0009 #300000 #be6069
    DiffText({ gui = 'italic', bg = '#0e2040' }), -- #464b5d #001030 #81a1c1
    diffAdded({ fg = clrs.nord14 }),
    diffRemoved({ fg = clrs.nord11 }),
    diffChanged({ fg = clrs.nord15 }),
    diffOldFile({ fg = clrs.nord9 }),
    diffNewFile({ fg = clrs.nord12 }),
    diffFile({ fg = clrs.nord7 }),
    diffLine({ fg = '#464B5D' }),
    diffIndexLine({ fg = clrs.nord9 }),
    Todo({ fg = 'none', bg = 'none', gui = 'none' }),
    TodoMsg({ fg = '#2583cB', gui = 'bold, italic' }),
    Warning({ bg = 'none', fg = '#aB6F34', gui = 'bold, italic' }),
    WarningMsg({ bg = 'none', fg = clrs.nord13 }),
    -- language groups
    --
    TreesitterContext({ bg = '#1a0606', gui = 'italic' }),
    -- @variable            ; various variable names
    -- @variable.builtin    ; built-in variable names (e.g. `this`)
    -- @variable.parameter  ; parameters of a function
    -- @variable.member     ; object and struct fields
    --
    -- @constant          ; constant identifiers
    -- @constant.builtin  ; built-in constant values
    -- @constant.macro    ; constants defined by the preprocessor
    --
    -- @module            ; modules or namespaces
    -- @module.builtin    ; built-in modules or namespaces
    -- @label             ; GOTO and other labels (e.g. `label:` in C), including heredoc labels
    -- Literals
    -- @string                 ; string literals
    -- @string.documentation   ; string documenting code (e.g. Python docstrings)
    -- @string.regexp          ; regular expressions
    -- @string.escape          ; escape sequences
    -- @string.special         ; other special strings (e.g. dates)
    -- @string.special.symbol  ; symbols or atoms
    -- @string.special.url     ; URIs (e.g. hyperlinks)
    -- @string.special.path    ; filenames
    --
    -- @character              ; character literals
    -- @character.special      ; special characters (e.g. wildcards)
    --
    -- @boolean                ; boolean literals
    -- @number                 ; numeric literals
    -- @number.float           ; floating-point number literals
    -- Types
    -- @type             ; type or class definitions and annotations
    -- @type.builtin     ; built-in types
    -- @type.definition  ; identifiers in type definitions (e.g. `typedef <type> <identifier>` in C)
    -- @type.qualifier   ; type qualifiers (e.g. `const`)
    --
    -- @attribute        ; attribute annotations (e.g. Python decorators)
    -- @property         ; the key in key/value pairs
    -- Functions
    -- @function             ; function definitions
    -- @function.builtin     ; built-in functions
    -- @function.call        ; function calls
    -- @function.macro       ; preprocessor macros
    --
    -- @function.method      ; method definitions
    -- @function.method.call ; method calls
    --
    -- @constructor          ; constructor calls and definitions
    -- @operator             ; symbolic operators (e.g. `+` / `*`)
    -- Keywords
    -- @keyword                   ; keywords not fitting into specific categories
    -- @keyword.coroutine         ; keywords related to coroutines (e.g. `go` in Go, `async/await` in Python)
    -- @keyword.function          ; keywords that define a function (e.g. `func` in Go, `def` in Python)
    -- @keyword.operator          ; operators that are English words (e.g. `and` / `or`)
    -- @keyword.import            ; keywords for including modules (e.g. `import` / `from` in Python)
    -- @keyword.storage           ; modifiers that affect storage in memory or life-time
    -- @keyword.repeat            ; keywords related to loops (e.g. `for` / `while`)
    -- @keyword.return            ; keywords like `return` and `yield`
    -- @keyword.debug             ; keywords related to debugging
    -- @keyword.exception         ; keywords related to exceptions (e.g. `throw` / `catch`)
    --
    -- @keyword.conditional         ; keywords related to conditionals (e.g. `if` / `else`)
    -- @keyword.conditional.ternary ; ternary operator (e.g. `?` / `:`)
    --
    -- @keyword.directive         ; various preprocessor directives & shebangs
    -- @keyword.directive.define  ; preprocessor definition directives
    -- Punctuation
    -- @punctuation.delimiter ; delimiters (e.g. `;` / `.` / `,`)
    -- @punctuation.bracket   ; brackets (e.g. `()` / `{}` / `[]`)
    -- @punctuation.special   ; special symbols (e.g. `{}` in string interpolation)
    -- Comments
    -- @comment               ; line and block comments
    -- @comment.documentation ; comments documenting code
    --
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
    sym('@markup.raw.markdown_inline')({ fg = '#2779aa', gui = 'none' }),
    sym('@markup.raw.block')({ gui = 'none', fg = '#2779aa' }),
    sym('@markup.raw')({ fg = '#2779aa', gui = 'none' }),
    sym('@boolean')({ Boolean }),
    sym('@comment')({ Comment }),
    sym('@comment.documentation')({ Comment }),
    sym('@constant')({ Constant }),
    sym('@constant.builtin')({ ConstantBuiltin }),
    sym('@comment.warning')({ Warning }),
    sym('@comment.danger')({ bg = '#db4b4b', fg = '#24283b' }),
    sym('@diff.add')({ DiffAdd }),
    sym('@diff.delete')({ DiffDelete }),
    sym('@error')({ Error }),
    sym('@exception')({ Special }),
    sym('@function')({ Function }),
    sym('@function.builtin')({ Special }),
    sym('@function.call')({ FunctionCall }),
    sym('@function.method')({ Function }),
    sym('@function.method.call')({ FunctionCall }),
    sym('@include')({ Include }),
    sym('@keyword')({ Keyword }),
    sym('@constant.luap')({ fg = '#2288cc', gui = 'bold' }),
    sym('@keyword.luap')({ fg = '#5886ff' }),
    sym('@operator.luap')({ fg = '#08a4ea', gui = 'bold' }),
    sym('@punctuation.delimiter.luap')({ fg = '#4866d8', gui = 'bold' }),
    sym('@punctuation.bracket.luap')({ fg = '#8b8af7' }),
    sym('@string.regexp')({ fg = '#1a84ba', gui = 'none' }),

    sym('@keyword.exception')({ Special }),
    sym('@keyword.operator')({ Operator }),
    sym('@keyword.return')({ KeywordReturn }),
    sym('@keyword.function')({ KeywordFunction }),
    sym('@keyword.luadoc')({ gui = 'none' }),
    sym('@label')({ Label }), -- For labels: `label:` in C and `:label:` in Lua.
    sym('@method')({ Function }),
    sym('@method.call')({ FunctionCall }),
    sym('@module')({ Statement }),
    sym('@module.builtin')({ Keyword }),
    sym('@nospell')({ fg = 'none', bg = 'none', gui = 'none' }),
    sym('@number')({ Number }),
    sym('@operator')({ Operator }),
    sym('@parameter')({ fg = '#41a6b5' }),
    sym('@property')({ Identifier }),
    sym('@punctuation.bracket')({ fg = '#7886a8' }), -- fg = "#a9b1d6"
    sym('@punct.bracket')({ sym('@punctuation.bracket') }),
    sym('@punctuation.delimiter')({ fg = '#7886a8' }),
    sym('@punctuation.special')({ fg = '#888698' }), -- #89ddff
    sym('@punct.special')({ sym('@punctuation.special') }),
    sym('@punctuation.special.markdown')({ fg = '#645060' }), --  fg = '#89ddff'
    sym('@string')({ String }),
    sym('@string.documentation')({ fg = '#406f88', gui = 'italic' }),
    sym('@string.escape')({ fg = '#bb9af7' }),
    sym('@tag')({ fg = '#a78086' }),
    sym('@tag.attribute')({ fg = '#5599dd' }),
    sym('@tag.delimiter')({ sym('@tag') }),
    sym('@markup.strikethrough')({ gui = 'strikeout' }),
    sym('@markup.italic')({ gui = 'italic' }),
    sym('@markup.strong.markdown')({ gui = 'bold' }),
    sym('@markup.strong.markdown_inline')({ gui = 'bold' }),
    sym('@markup.link.label.markdown')({ fg = '#6c81df' }),
    sym('@markup.link.label.markdown_inline')({ fg = '#6c81df' }),
    sym('@markup.link')({ fg = '#2aa1ae', gui = 'italic' }),
    sym('@markup.heading')({ fg = Title.fg }),
    sym('@markup.heading.1.markdown')({ fg = '#4f86e6' }),
    sym('@markup.heading.2.markdown')({ fg = '#347ad6' }),
    sym('@markup.heading.3.markdown')({ fg = '#2d78c4' }),
    sym('@markup.heading.4.markdown')({ fg = '#1a84ba' }),
    sym('@markup.heading.5.markdown')({ fg = '#1080a0' }),
    sym('@markup.heading.6.markdown')({ fg = '#0a8098' }),
    sym('@markup.list')({ Special }),
    sym('@markup.list.checked')({ fg = '#73daca', gui = 'bold' }),
    sym('@markup.list.unchecked')({ fg = '#7aa2f7' }),
    -- sym('@markup.list.checked.markdown')({ fg = '#53fafa', gui = 'bold' }),
    sym('@spell')({}),
    sym('@type')({ Type }),
    sym('@type.builtin')({ fg = '#487795' }),
    sym('@uri')({ fg = '#8eb9f6', gui = 'none' }),
    sym('@variable')({ Variable }),
    sym('@variable.builtin')({ Identifier }),
    sym('@variable.member')({ Field }),
    sym('@variable.parameter')({ Identifier }),
    sym('@variable.parameter.vimdoc')({ sym('@parameter') }),
    -- sym('@markup')({ fg = '#0789aa' }), --  fg = '#89ddff'
    -- @markup.list.unchecked.markdown
    -- h1 = 'iris', h2 = 'foam', h3 = 'rose', h4 = 'gold', h5 = 'pine', h6 = 'foam',
    -- #3dbcff  #f38ba8  #21c7a8  #7aa2f7 #272b40  #1e2718
    -- #3ab4e8  #fab387  #82aaff  #e0af68 #2d2c39  #21262d
    -- #37b0d8  #f9e2af  #7fdbca  #9ece68 #2a2a3a  #1d2229
    -- #34a4c8  #a6e3a1  #f78c6c  #1abc9c #242d3d  #13181f
    -- #3098b2  #74c7ec  #87bcff  #bb9af7 #2a2a40  #0c1118
    -- #3092ae  #b4befe  #ae81ff  #9d7cd8 #2d2b3f  #0c0b12
    Headline1({ bg = '#081228', fg = sym('@markup.heading.1.markdown').fg }),
    Headline2({ bg = '#020814', fg = sym('@markup.heading.2.markdown').fg }),
    Headline3({ bg = '#000408', fg = sym('@markup.heading.3.markdown').fg }),
    Headline4({ bg = '#040608', fg = sym('@markup.heading.4.markdown').fg }),
    Headline5({ bg = '#020408', fg = sym('@markup.heading.5.markdown').fg }),
    Headline6({ bg = '#000204', fg = sym('@markup.heading.6.markdown').fg }),
    markdownH1({ fg = sym('@markup.heading.1.markdown').fg }),
    markdownH2({ fg = sym('@markup.heading.2.markdown').fg }),
    markdownH3({ fg = sym('@markup.heading.3.markdown').fg }),
    markdownH4({ fg = sym('@markup.heading.4.markdown').fg }),
    markdownH5({ fg = sym('@markup.heading.5.markdown').fg }),
    markdownH6({ fg = sym('@markup.heading.6.markdown').fg }),

    -- CodeBlock({ bg = '#090909' }),
    CodeBlock({ bg = '#101018' }),
    -- - @lsp.type.variable.javascript links to Variable priority: 125
    -- - @lsp.mod.defaultLibrary.javascript links to @lsp priority: 126
    -- - @lsp.typemod.variable.defaultLibrary.javascript links to Identifier priority: 127
    -- sym('@lsp')({ Keyword }),
    -- sym('@lsp.typemod.variable.readonly.javascript')({ Variable }),
    -- sym('@lsp.typemod.variable.declaration.javascript')({ Variable }),
    sym('@lsp.type.class.markdown')({ fg = 'none', bg = 'none' }), -- sym('@type') Structure
    -- sym('@lsp.type.class.javascript')({ sym('@variable') }),
    sym('@lsp.type.class.javascript')({ Special }),
    sym('@lsp.type.comment')({ sym('@comment') }),
    sym('@lsp.type.enum')({ sym('@type') }),
    sym('@lsp.type.enumMember')({ sym('@constant') }),
    sym('@lsp.type.interface')({ fg = '#6ad5e8' }),
    sym('@lsp.type.keyword')({ sym('@keyword') }),
    sym('@lsp.type.namespace')({ sym('@module') }),
    sym('@lsp.type.parameter')({ sym('@variable.parameter') }),
    sym('@lsp.type.property')({ sym('@property') }),
    sym('@lsp.type.variable')({ sym('@variable') }),
    sym('@lsp.typemod.function.defaultLibrary')({ sym('@function.builtin') }),
    sym('@lsp.typemod.macro.defaultLibrary')({ sym('@function.builtin') }),
    sym('@lsp.typemod.method.defaultLibrary')({ sym('@function.builtin') }),
    sym('@lsp.typemod.operator.injected')({ sym('@operator') }),
    sym('@lsp.typemod.string.injected')({ sym('@string') }),
    sym('@lsp.typemod.type.defaultLibrary')({ fg = '#29a4bd' }),
    sym('@lsp.typemod.variable.defaultLibrary')({ sym('@variable.builtin') }),
    sym('@lsp.typemod.variable.injected')({ sym('@variable') }),
    sym('@lsp.typemod.variable.typescriptreact')({ Type }),
    sym('@lsp.typemod.variable.readonly.typescriptreact')({ Type }),
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
    sym('@constructor')({ fg = 'none', bg = 'none' }),
    sym('@constructor.tsx')({ fg = 'none', bg = 'none' }),
    sym('@tag.end.jsx')({ Statement }),
    sym('@tag.end.tsx')({ Statement }),
    sym('@tag.delimiter.end.jsx')({ Statement }),
    sym('@tag.delimiter.end.tsx')({ Statement }),
    sym('@tag.constructor.end.jsx')({ Statement }),
    sym('@tag.constructor.end.tsx')({ Statement }),
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
    typescriptTypeBrackets({ fg = '#3BaBcB', gui = 'bold' }),

    cssTSType({ fg = '#486795' }),
    cssTSPunctDelimiter({ fg = '#4784a6' }),
    cssTSProperty({ fg = 'none' }),
    cssTSNumber({ fg = 'none' }),
    cssClassName({ fg = '#5780a6' }),
    cssIdentifier({ fg = '#4770a6' }),
    cssDefinition({ fg = '#6898c6' }),
    cssCommonAttr({ fg = '#6784d5' }),
    cssValueLength({ fg = '#0786bc' }),
    cssValueNumber({ cssValueLength }),
    cssColor({ cssValueLength }),
    cssUnitDecorators({ cssValueLength }),
    --
    manReference({ fg = '#2aa1ae' }),
    manUnderline({ gui = 'italic', fg = '#2aa1ae' }),
    manBold({ fg = '#0575af', gui = 'italic' }),
    manItalic({ gui = 'italic', fg = '#2aa1ae' }),
    manSectionHeading({ fg = '#25a5ff', gui = 'none,bold' }),
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
    jsxCloseTag({ fg = '#7f90aa' }),
    -- jsxCloseString {fg = "#ff6600"},
    jsxAttrib({ fg = '#88bbdd' }),
    jsxEqual({ fg = '#6699bb' }),
    -- BufferInactiveIndex { bg = "#000000" },
    -- BufferInactive  { bg = "#000000" },
    jsonKeyword({ fg = '#446688' }),
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
    shSubst({ fg = '#488aaf' }),
    shSubstDelim({ fg = '#5776bc' }),
    shParentheses({ fg = '#c78087' }),
    shFunction({ Function }),
    shDeref({ fg = '#488aaf' }),
    shDerefSimple({ fg = '#488aaf' }),
    shLoop({ fg = '#80788a' }),
    shRepeat({ fg = '#80788a' }),
    shConditional({ fg = '#80788a' }),
    shVariable({ Normal }),
    zshBrackets({ fg = clr_over.orange }),
    zshSubst({ fg = '#488aaf' }),
    zshSubstDelim({ fg = '#5776bc' }),
    zshParentheses({ fg = '#c78087' }),
    zshFunction({ fg = '#a78087' }),
    zshDeref({ fg = '#488aaf' }),
    zshRepeat({ fg = '#80788a' }),
    zshLoop({ fg = '#80788a' }),
    zshConditional({ fg = '#80788a' }),
    zshCommands({ fg = '#6180b2' }),
    ZinitForCommand({ fg = '#a78087' }),
    ZinitPlugin({ fg = '#5588fd', gui = 'italic' }), -- Macro, Define
    ZinitSnippet({ fg = '#95b5ed' }), -- Macro, Define
    ZinitIce({ fg = '#87a9ff', gui = 'bold' }), -- Type
    Zinitcommand({ fg = '#a78087' }),
    ZinitContinue({ fg = '#4878a8' }),
    ZinitIceDoubleQuoteParam({ fg = '#30b0d9' }), -- Special
    ZinitIceSingleQuoteParam({ fg = '#30c0e9' }),
    yamlTSField({ fg = '#717cb4' }),
    yamlBlockMappingKey({ yamlTSField }),
    -- html
    -- markdownTSTitle {},
    htmlEndTag({ fg = '#7f90aa' }),
    htmlTagN({ fg = clr_over.orange }),
    CSVColumnHeaderOdd({ String }),
    CSVColumnHeaderEven({ fg = Statement.fg, bg = 'none' }),
    markdownLinkText({ fg = '#00ccff' }),
    pandocDelimitedCodeBlock({ gui = 'none' }),
    -- pandocStrikeout({ gui = 'none' }),
    -- pandocEmphasis({ gui = 'italic', fg = '#bbbbcc' }),
    -- pandocStrong({ gui = 'none' }),
    -- pandocReferenceLabel { gui = "none", fg = clr_over.orange },
    pandocListItemBullet({ fg = '#66a8dc' }),
    pandocListItemBulletId({ fg = '#66a8dc' }),
    pandocOperator({ bg = 'none', fg = '#aa6600' }),
    -- pandocListItem {},
    -- pandocUListItem { gui = "none", bg = "none", fg = "#aa6600" },
    -- pandocReferenceDefinition { fg = "#7788ff", bg = "none" },
    -- pandocAtxHeader { fg = "#4575b8" },
    pandocPipeTable({ fg = '#4789aa' }),
    pandocPipeTableDelims({ fg = '#555577' }),
    pandocNoFormatted({ bg = 'none' }),
    pandocReferenceDefinition({ fg = '#4488cc', bg = 'none' }),
    pandocAtxHeader({ fg = '#8595f8' }),
    pandocAtxHeaderMark({ fg = '#4575f8' }),
    pandocAtxStart({ fg = '#4575f8' }),
    helpHyperTextJump({ fg = '#6585b8', gui = 'none' }),
    Dash({ bg = '#341710', fg = '#341710' }),
    --
    -- Indent Blankline
    -- IblScope, IblIndent, IblWhitespace
    -- IndentBlanklineChar({ fg = '#102030', gui = 'nocombine' }),
    -- IndentBlanklineContextChar({ fg = colors.purple, gui = 'nocombine' }),
    IblIndent({ fg = '#102030', gui = 'nocombine' }),
    -- IblScope({ fg = colors.purple, gui = 'nocombine' }),
    -- IndentBlanklineIndent1({ bg = '#262626', gui = 'nocombine' }),
    -- IndentBlanklineIndent2({ bg = '#1f1f1f', gui = 'nocombine' }),

    IndentGuidesEven({ bg = clrs.nord1 }),
    IndentGuidesOdd({ bg = clrs.nord2 }),
    MiniIndentscopeSymbol({ fg = '#003460', bg = '#000f18' }),
    MiniIndentscopeSymbolOff({ fg = '#162f58' }),
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
    InfoWindowFloat({ fg = '#2886bf', bg = 'none' }),
    BqfPreviewFloat({ Normal }),
    BqfPreviewBorder({ Normal }),
    -- BqfPreviewCursor { Cursor },
    BqfPreviewRange({ IncSearch }),
    BqfSign({ fg = 'cyan' }),
    -- zshVariableDef { Normal },
    -- zshDeref { fg = '#2886bf' },
    lsp_markdown1({ Normal }),
    DashboardHeader({ fg = '#8AFF80' }),
    DashboardKey({ fg = '#FF9580' }),
    DashboardCenter({ fg = clrs.nord8 }),
    DashboardDesc({ fg = '#87FEF8' }),
    DashboardIcon({ fg = '#FCFC7F' }),
    DashboardShortCut({ fg = TokyoColors.cyan }),
    DashboardFooter({ fg = '#5D5D65' }),
    -- DashboardHeader ({ fg = colors.blue }),
    -- DashboardCenter ({ fg = colors.purple }),
    -- DashboardFooter ({ fg = colors.green, gui = "italic" }),
    NotifyBackground({ bg = '#000000' }),
    NotifyRepeatCount({ Comment }),
    NotifySTATUSBorder({ fg = '#3a3286', bg = 'none' }),
    NotifySTATUSTitle({ fg = '#3a3286' }),
    NotifySTATUSIcon({ fg = '#2a76b7' }),
    NotifyINSPECTBorder({ fg = '#2A70fF', bg = 'none' }),
    NotifyINSPECTIcon({ fg = '#67b0f7' }),
    NotifyINSPECTTitle({ fg = '#2760f7' }),
    NotifyINFOBorder({ fg = '#008Fa8', bg = 'none' }),
    NotifyINFOIcon({ fg = '#19aFc8' }),
    NotifyINFOTitle({ fg = '#19aFc8' }),
    NotifyDEBUGBorder({ fg = '#4B6BBB' }),
    NotifyDEBUGIcon({ fg = '#6B8BFF' }),
    NotifyDEBUGTitle({ fg = '#6B8BFF' }),
    NotifyTRACEBorder({ fg = '#637699', bg = 'none' }),
    -- NotifyTRACEBorder { fg = "#7B7BCC" },
    -- NotifyTRACEBorder { Normal },
    NotifyTRACEIcon({ fg = '#637699' }),
    NotifyTRACEBody({ fg = '#637699' }),
    -- NotifyTRACEIcon { fg = "#7BABFF" },
    NotifyTRACETitle({ fg = '#7BABFF' }),
    NotifyERRORBorder({ fg = '#8A1F1F', bg = 'none' }),
    NotifyERRORIcon({ fg = '#F74047' }),
    NotifyERRORTitle({ fg = '#F74047' }),
    NotifyWARNBorder({ fg = '#79491D', bg = 'none' }),
    NotifyWARNIcon({ fg = '#C77700' }),
    NotifyWARNTitle({ fg = '#C77000' }),

    NotifyRUNBorder({ fg = '#1f87c2', bg = 'none' }),
    NotifyRUNTitle({ fg = '#06c0f6' }),
    NotifyRUNIcon({ fg = '#c6b087' }),
    -- NotifyRunSuccessCommand({ fg = '#4fa7f2' }),
    NotifyRunSuccessOutput({ fg = Comment.fg }),

    WhichKey({ fg = '#07c0f7', gui = 'bold' }), --Function
    WhichKeyGroup({ fg = '#619cf4' }), -- Keyword
    -- WhichKeyDesc({ fg = "#5d79a1", gui = "italic" }), -- Identifier
    WhichKeyDesc({ fg = '#5d79a1', gui = 'italic' }), -- Identifier
    WhichKeySeperator({ fg = '#334664', gui = 'bold' }), -- DiffAdded
    WhichKeyFloat({ bg = NormalFloat.bg }), -- NormalFloat
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
    NvimTreesitterPairsSelf({ fg = '#f35050' }),
    NvimTreesitterPairsPartner({ fg = '#f79000' }),
    -- gui
    -- TSRainbowRed({ fg = "#cc241d" }),
    -- TSRainbowYellow({ fg = "#d79921" }),
    -- TSRainbowBlue({ fg = "#458588" }),
    -- TSRainbowOrange({ fg = "#d65d0e" }),
    -- TSRainbowGreen({ fg = "#689d6a" }),
    -- TSRainbowViolet({ fg = "#b16286" }),
    -- TSRainbowCyan({ fg = "#a89984" }),
    TSRainbowRed({ fg = clrutil.shade_color('#cc241d', -30) }),
    TSRainbowYellow({ fg = clrutil.shade_color('#d79921', -30) }),
    TSRainbowBlue({ fg = clrutil.shade_color('#458588', -30) }),
    TSRainbowOrange({ fg = clrutil.shade_color('#d65d0e', -30) }),
    TSRainbowGreen({ fg = clrutil.shade_color('#689d6a', -30) }),
    TSRainbowViolet({ fg = clrutil.shade_color('#b16286', -30) }),
    TSRainbowCyan({ fg = clrutil.shade_color('#a89984', -30) }),
    CmpGhostLight({ fg = '#1f4f94' }),
    CmpGhostDark({ fg = '#27476c' }),
    CmpGhostText({ CmpGhostLight }),
    -- CmpPmenu({ bg = '#142a30' }),

    CmpPmenu({ bg = '#001020' }),
    CmpPmenuBorder({ bg = '#242a30' }),
    -- CmpDocumentation({ fg = tokyoColors.fg, bg = tokyoColors.bg_float }),
    -- CmpDocumentationBorder({ fg = tokyoColors.border_highlight, bg = tokyoColors.bg_float }),
    CmpItemMenu({ fg = colors.light_gray }),
    CmpItemAbbr({ fg = '#4c74a4' }),
    CmpItemAbbrDeprecated({ fg = colors.fg, gui = 'strikethrough' }),
    CmpItemAbbrMatch({ fg = '#208Ff8', gui = 'italic' }),
    CmpItemAbbrMatchFuzzy({ fg = '#008Fb8', gui = 'italic' }),
    CmpItemKindArray({ fg = tokyoColors.blue }),
    CmpItemKindBoolean({ fg = tokyoColors.orange }),
    CmpItemKindClass({ fg = colors.yellow }),
    CmpItemKindConstant({ fg = colors.orange }),
    CmpItemKindConstructor({ fg = colors.yellow }),
    CmpItemKindCodeium({ fg = '#6460ff' }),
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
    CmpItemKindText({ fg = '#489aac' }),
    CmpItemKindTypeParameter({ fg = colors.yellow }),
    CmpItemKindUnit({ fg = colors.orange }),
    CmpItemKindValue({ fg = colors.orange }),
    CmpItemKindVariable({ fg = tokyoColors.blue2 }),

    CmpSourceNvimLsp({ fg = '#0ca6ff' }), -- '#8fa080'
    CmpSourceLuasnip({ fg = '#8fa080' }), --
    CmpSourceTreesitter({ fg = '#4C86a4' }),
    CmpSourceCodeium({ CmpItemKindCodeium }),
    CmpSourceCopilot({ CmpItemKindCopilot }),
    CmpSourceAsyncPath({ fg = '#6F65f0' }),
    CmpSourcePath({ fg = '#6F65f0' }),
    CmpSourceFuzzyPath({ fg = '#6F65f0' }),
    CmpSourceCmdline({ fg = '#8F65a0' }),
    CmpSourceCmdlineHistory({ fg = '#4482fc' }),
    CmpSourceQuickData({ fg = '#6462cc' }),
    CmpSourceYanky({ fg = '#24a2ac' }),

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
    AerialGuide({ fg = '#182838' }),
    AerialLine({ fg = '#00aacc', bg = '#002233', gui = 'bold' }),
    -- AerialLine({ QuickFixLine }),
    AerialLineNC({ fg = '#00ff88', bg = 'blue' }),
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
    TelescopeNormal({ fg = '#6D779a', bg = 'none', gui = 'none' }),
    TelescopeComment({ Comment }),
    TelescopeBorder({ bg = 'none', fg = '#2299cc' }),
    TelescopePrompt({ bg = 'none' }),
    TelescopePromptTitle({ fg = '#07a0ff', bg = 'none' }),
    TelescopePromptCounter({ fg = '#4d577a', bg = 'none' }),
    TelescopePromptNormal({ fg = '#2299cc', bg = 'none' }),
    TelescopePromptBorder({ fg = '#416191', bg = 'none' }),
    TelescopePromptPrefix({ fg = '#2977FF', bg = 'none' }),
    TelescopeMultiIcon({ fg = '#0066ff' }),
    TelescopePreviewBorder({ fg = '#416191', bg = 'none' }),
    TelescopeResults({ bg = 'none' }),
    TelescopeResultsBorder({ fg = '#416191', bg = 'none' }),
    TelescopeSelectionCaret({ fg = '#04c9fc' }),
    TelescopeSelection({ fg = '#38aaee', gui = 'bold', bg = CursorLine.bg }), -- bg = "#202324"
    TelescopeMatching({ fg = '#7997FF', bg = 'none' }),
    TelescopeFrecencyScores({ fg = '#34799c' }),
    TelescopeBufferLoaded({ fg = '#47a0f0' }),
    TelescopeMultiSelection({ fg = '#4060ff', gui = 'italic' }),
    TelescopeTitle({ fg = '#2299ff', gui = 'bold ' }),
    TelescopePreviewTitle({ fg = '#47a0f0', bg = 'none' }),
    TelescopeResultsTitle({ fg = '#64a9ec', bg = 'none' }),
    TelescopeResultsIdentifier({ fg = '#6476ce' }),
    TelescopeResultsSpecialComment({ fg = '#4488cc' }),
    TelescopeResultsField({ fg = '#4090ff' }),
    -- TelescopeWhichKeyMode({ TelescopeResultsConstant }),
    TelescopeResultsSeparator({ fg = '#1f3f5f', bg = 'none' }),
    TelescopeWhichKeyBind({ fg = WhichKey.fg }),
    TelescopeWhichKeyBindCustom({ fg = WhichKey.fg, gui = 'bold' }),
    TelescopeWhichKeyName({ WhichKeyDesc }),
    TelescopeWhichKeyNameCustom({ fg = '#88aee9', gui = 'bold' }),
    TelescopeWhichKeyBorder({ WhichKeyDesc }),
    -- { entry.value.event, "vimAutoEvent" },
    -- { entry.value.group_name, "vimAugroup" },
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
    NavbuddyName({ bg = '#40112c' }),
    NavbuddyTitleBorder({ fg = '#222222' }),
    -- NavbuddyNormalTitle({ fg = "#222222" }),

    -- TelescopePromptCounter { NonText },
    -- TelescopePathSeparator { fg = '#667788' },
    -- TelescopeQueryFilter { fg = '#4466FF'},
    -- TelescopeResultsComment = {},
    -- TelescopeMultiSelection guifg=#928374          " Multisections

    IlluminatedWordRead({ bg = '#101c39', gui = '' }),
    IlluminatedWordText({ bg = '#101c39', gui = '' }),
    IlluminatedWordWrite({ bg = '#101c39', gui = '' }),
    -- noice.nvim

    NoiceCursor({ bg = '#4B6BfB' }),
    NoiceCmdlinePopupBorderHelp({ fg = '#8888ff' }),
    NoiceCmdlinePopupBorderLua({ fg = '#44aaff' }),
    NoiceCmdlinePopupBorder({ fg = '#4466ff' }),
    NoiceCmdline({ fg = '#88aaff' }),
    -- git-conflict-nvim
    GitConflictCurrent({ bg = '#203d5e' }),
    GitConflictIncoming({ bg = '#003723' }),
    GitConflictAncestor({ bg = '#28218A' }),

    -- dim.lua
    sym('@functionDimmed')({ fg = '#6c6066', gui = 'italic' }),
    sym('@variableDimmed')({ fg = '#62718b', gui = 'italic' }),
    sym('@parameterDimmed')({ fg = '#537396', gui = 'italic' }),
    sym('@keyword.functionDimmed')({ fg = '#495986', gui = 'italic' }),

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
    FlashBackdrop({ fg = '#405560' }), -- #1a1f2a
    FlashLabel({ fg = '#cc0044', bg = '#000000', gui = 'bold,italic' }), -- #0d314c

    -- Dressing
    TaskFloat({ fg = '#2a8ccb' }),
    TaskFloatBorder({ fg = '#2151a1' }),

    -- MiniClue
    -- MiniClueBorder({ FloatBorder }),
    MiniClueNextKey({ fg = '#07c0f7' }), -- MiniClueNextKey({DiagnosticFloatingHint})
    MiniClueDescSingle({ gui = 'italic' }), -- MiniClueDescSingle({NormalFloat}),
    -- MiniClueDescGroup({DiagnosticFloatingWarn}),
    -- MiniClueNextKeyWithPostkeys({DiagnosticFloatingError}),
    MiniClueSeparator({ fg = '#333344' }), -- MiniClueSeparator({DiagnosticFloatingInfo})
    MiniClueTitle({ fg = '#f38080' }), -- MiniClueTitle({Title})

    -- symbol-usage
    SymbolInlay({ fg = '#004466', gui = 'italic' }),
    --- nvim-hlslens
    -- HlSearchNear({ fg = '#00ffdd', bg = 'none' }), -- IncSearch
    -- HlSearchLens({ fg = '#ff2266', bg = '#003333' }), -- WildMenu
    -- HlSearchLensNear({ fg = '#00ddff', bg = 'none' }), -- IncSearch

    SpecsCursor({ bg = '#1f6385' }),
    HighlightUndo({ fg = '#b7001e', bg = '#0f2139' }),
    BackseatText({ DiagnosticFloatingHint, gui = 'italic' }),

    MatchParen({ fg = '#fb8b8b', gui = 'bold,' }),
    MatchParenCur({
      fg = '#ff9f9f',
      gui = 'bold',
    }), -- matchparen
    MatchWord({
      fg = '#7f6686',
      gui = 'italic',
    }),
    MatchBackground({
      gui = 'italic',
      bg = '#0f2139',
    }), -- colorcolumn

    RegistersPreview({ fg = '#009ac8', bg = 'none', gui = 'none' }), -- IncSearch

    SmoothCursor({ fg = '#0081ca', gui = 'bold' }),
    LeapMatch({ fg = '#00ffdd', bg = 'none' }), -- IncSearch
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
    -- GlanceWinBarTitle
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
    BufferCurrent({ fg = colors.fg, bg = 'NONE' }),
    BufferCurrentIndex({ fg = colors.fg, bg = 'NONE' }),
    BufferCurrentMod({ fg = colors.yellow, bg = 'NONE', gui = 'bold' }),
    BufferCurrentSign({ fg = colors.cyan, bg = 'NONE' }),
    BufferCurrentTarget({ fg = colors.red, bg = 'NONE', gui = 'bold' }),
    BufferVisible({ fg = colors.fg, bg = 'none' }),
    BufferVisibleIndex({ fg = colors.fg, bg = 'none' }),
    BufferVisibleMod({ fg = colors.yellow, bg = 'none', gui = 'bold' }),
    BufferVisibleSign({ fg = colors.light_gray, bg = 'none' }),
    BufferVisibleTarget({ fg = colors.red, bg = 'none', gui = 'bold' }),
    BufferInactive({ fg = colors.light_gray, bg = '#1C1F24' }),
    BufferInactiveIndex({ fg = colors.light_gray, bg = '#1C1F24' }),
    BufferInactiveMod({ fg = colors.yellow, bg = '#1C1F24' }),
    BufferInactiveSign({ fg = colors.light_gray, bg = '#1C1F24' }),
    BufferInactiveTarget({ fg = colors.red, bg = '#1C1F24', gui = 'bold' }),
    BufferDefaultAlternate({ bg = '#0c2333' }), -- guifg=#4d576a guibg=#3c4353
    BufferCurrentError({ bg = '#0c2333' }),
    BufferAlternate({ bg = '#0c2333' }), -- guifg=#4d576a guibg=#3c4353
    BufferAlternateHINT({ bg = '#0c2333' }),
    BufferAlternateINFO({ bg = '#0c2333' }),
    BufferAlternateMod({ bg = '#0c2333', fg = colors.yellow }),
    BufferAlternateSign({ bg = '#0c2333' }),
    BufferAlternateWARN({ bg = '#0c2333' }),
    BufferAlternateADDED({ bg = '#0c2333' }),
    BufferAlternateERROR({ bg = '#0c2333' }),
    BufferAlternateIndex({ bg = '#0c2333' }),
    BufferAlternateNumber({ bg = '#0c2333' }),
    BufferAlternateTarget({ bg = '#0c2333' }),
    BufferAlternateCHANGED({ bg = '#0c2333' }),
    BufferAlternateDELETED({ bg = '#0c2333' }),
    BufferAlternateSignRight({ bg = '#0c2333' }),
  }
end
