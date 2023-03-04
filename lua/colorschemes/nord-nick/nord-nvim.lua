---@diagnostic disable
--luacheck: ignore

-- https://github.com/kunzaatko/nord.nvim
-- https://github.com/shaunsingh/nord.nvim
local lush = require("lush")
local hsl = lush.hsl
local v = vim.g -- this must be done, because lush is executed in a bare environment

v.nord_uniform_diff_background = 0
v.nord_underline = 0
v.colors_name = "nord-nvim"

local clrs = {
  nord0 = hsl(220, 16, 22), -- #2F3541
  nord1 = hsl(222, 16, 28), -- #3C4353
  nord2 = hsl(220, 17, 32), -- #444D5F
  nord3 = hsl(220, 16, 36), -- #4D576A
  nord3_bright = hsl(220, 20, 60), -- #616F89
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

local nord3_brightened = {
  clrs.nord3,
  hsl(221, 17, 37), -- #4E586E
  hsl(219, 17, 38), -- #505C71
  hsl(220, 17, 39), -- #535E74
  hsl(220, 16, 40), -- #566176
  hsl(221, 16, 41), -- #586279
  hsl(221, 16, 42), -- #5A657C
  hsl(220, 17, 43), -- #5B6780
  hsl(221, 17, 44), -- #5D6983
  hsl(219, 17, 45), -- #5F6D86
  hsl(220, 17, 46), -- #616F89
  hsl(219, 17, 47), -- #63728C
  hsl(221, 16, 48), -- #67738E
  hsl(221, 16, 49), -- #697691
  hsl(220, 17, 50), -- #6A7895
  hsl(221, 16, 51), -- #6E7B96
  hsl(220, 17, 52), -- #707E99
  hsl(219, 17, 53), -- #73819C
  hsl(220, 16, 54), -- #77839C
  hsl(219, 16, 55), -- #7A879F
  hsl(219, 17, 56), -- #7C89A2
}

local cfg = {
  nord_bold = v.nord_bold or 1,
  nord_italic = v.nord_italic or 0, -- TODO: Add other conditions
  nord_underline = v.nord_underline or 0,
  nord_italic_comments = v.nord_italic_comments or 0,
  nord_uniform_status_lines = v.nord_uniform_status_lines or 0,
  nord_uniform_diff_background = v.nord_uniform_diff_background or 0,
  nord_cursor_line_number_background = v.nord_cursor_line_number_background or 0,
  nord_bold_vertical_split_line = v.nord_bold_vertical_split_line or 0,
}

local spec = {
  bold = cfg.nord_bold == 1 and "bold" or "",
  italic = cfg.nord_italic == 1 and "italic" or "",
  -- underline = cfg.nord_underline == 1 and "underline" or "",
  underline = cfg.nord_underline == 1 and "" or "",
  inverse = "inverse",
  undercurl = "undercurl",
}
spec["italicize_comments"] = cfg.nord_italic_comments == 1 and spec.italic or ""

local gui_combine = function(gui)
  for i = 1, #gui do
    if gui[i] == "" then
      table.remove(gui, i)
    end
  end
  return table.concat(gui, ",")
end

local theme = lush(function()
  return {
    -- +---------------+
    -- + UI Components +
    -- +---------------+
    -- +-- Attributes --+
    Bold({ gui = spec.bold }),
    Italic({ gui = spec.italic }),
    Underline({ gui = spec.underline }),
    -- +-- Editor --+
    ColorColumn({ bg = clrs.nord1 }),
    Cursor({ fg = clrs.nord0, bg = clrs.nord4 }),
    CursorLine({ bg = clrs.nord1 }),
    Error({ fg = clrs.nord4, bg = clrs.nord11 }),
    iCursor({ fg = clrs.nord0, bg = clrs.nord4 }),
    LineNr({ fg = clrs.nord3 }),
    MatchParen({ fg = clrs.nord8, bg = clrs.nord3 }),
    NonText({ fg = clrs.nord2 }),
    Normal({ fg = clrs.nord4.darken(30), bg = "none" }),
    -- Normal({ fg = clrs.nord4, bg = clrs.nord0 }),
    -- Pmenu { fg = clrs.nord4, bg = clrs.nord0 },
    -- PmenuSel { fg = clrs.nord8, bg = clrs.nord3 },
    -- PmenuSbar { fg = clrs.nord4, bg = clrs.nord2 },
    -- PmenuThumb { fg = clrs.nord8, bg = clrs.nord3 },
    SpecialKey({ fg = clrs.nord3 }),
    SpellBad({
      fg = clrs.nord11,
      bg = clrs.nord,
      gui = spec.undercurl,
      guisp = clrs.nord11,
    }),
    SpellCap({
      fg = clrs.nord13,
      bg = clrs.nord0,
      gui = spec.undercurl,
      guisp = clrs.nord13,
    }),
    SpellLocal({
      fg = clrs.nord5,
      bg = clrs.nord0,
      gui = spec.undercurl,
      guisp = clrs.nord5,
    }),
    SpellRare({
      fg = clrs.nord6,
      bg = clrs.nord0,
      gui = spec.undercurl,
      guisp = clrs.nord6,
    }),
    Visual({ bg = clrs.nord2 }),
    VisualNOS({ bg = clrs.nord2 }),
    -- +-- Gutter --+
    CursorColumn({ bg = clrs.nord1 }),
    CursorIM({ fg = clrs.cursor, bg = "NONE", gui = "reverse" }), -- like Cursor, but used when in IME mode
    CursorLineNr({
      fg = clrs.nord4,
      bg = cfg.nord_cursor_line_number_background == 1 and nil or clrs.nord1,
    }),
    Folded({ fg = clrs.nord3.li(7), bg = clrs.nord1, gui = spec.bold }),
    FoldColumn({ fg = clrs.nord3, bg = clrs.nord0 }),
    SignColumn({ fg = clrs.nord1.li(2), bg = clrs.nord0 }),
    -- +-- Navigation --+
    Directory({ fg = clrs.nord8 }),
    -- +--- Prompt/Status ---+
    EndOfBuffer({ fg = clrs.nord1 }),
    ErrorMsg({ fg = clrs.nord4, bg = clrs.nord11 }),
    ModeMsg({ fg = clrs.nord4 }),
    MoreMsg({ fg = clrs.nord8 }),
    Question({ fg = clrs.nord4 }),
    StatusLine({ fg = clrs.nord8, bg = clrs.nord3, gui = "NONE" }),
    StatusLineNC({
      fg = clrs.nord4,
      bg = cfg.nord_uniform_status_lines == 0 and clrs.nord1 or crls.nord3,
      gui = "NONE",
    }),
    StatusLineTerm({ fg = clrs.nord8, bg = clrs.nord3, gui = "NONE" }),
    StatusLineTermNC({
      fg = clrs.nord4,
      bg = cfg.nord_uniform_status_lines == 0 and clrs.nord1 or crls.nord3,
      gui = "NONE",
    }),
    WarningMsg({ fg = clrs.nord0, bg = clrs.nord13 }),
    WildMenu({ fg = clrs.nord8, bg = clrs.nord1 }),
    -- +--- Search ---+
    IncSearch({ fg = clrs.nord6, bg = clrs.nord10, gui = spec.underline }),
    Search({ fg = clrs.nord1, bg = clrs.nord8, gui = "NONE" }),
    -- +--- Tabs ---+
    -- TabLine({ fg = clrs.nord4, bg = clrs.nord1, gui = "NONE" }),
    TabLineFill({ fg = clrs.nord4, bg = clrs.nord1, gui = "NONE" }),
    -- TabLineSel({ fg = clrs.nord8, bg = clrs.nord3, gui = "NONE" }),
    -- +--- Window ---+
    Title({ fg = clrs.nord4, gui = "NONE" }),
    VertSplit({
      fg = clrs.nord2,
      bg = cfg.nord_bold_vertical_split_line == 0 and clrs.nord0 or clrs.nord1,
      gui = "NONE",
    }),
    -- -- +--- Other ---+
    CommandMode({ fg = clrs.gray, bg = "NONE", gui = "reverse" }),
    InsertMode({ fg = clrs.nord14, bg = "NONE", gui = "reverse" }),
    NormalMode({ fg = clrs.accent, bg = "NONE", gui = "reverse" }),
    ReplacelMode({ fg = clrs.nord11, bg = "NONE", gui = "reverse" }),
    VisualMode({ fg = clrs.nord9, bg = "NONE", gui = "reverse" }),
    Debug({ fg = clrs.nord11 }), -- debugging statements
    Ignore({ fg = clrs.disabled }), -- left blank, hidden
    QuickFixLine({ fg = clrs.highlight, bg = clrs.nord6, gui = "reverse" }),
    ToolbarButton({ bg = "NONE", gui = "bold" }),
    healthError({ fg = clrs.error }),
    healthSuccess({ fg = clrs.nord14 }),
    healthWarning({ fg = clrs.nord15 }),
    qfLineNr({ fg = clrs.highlight, bg = clrs.nord6, gui = "reverse" }),
    -- -- +----------------------+
    -- -- + Language Base Groups +
    -- -- +----------------------+
    Boolean({ fg = clrs.nord9 }),
    Character({ fg = clrs.nord14 }),
    -- Comment({ fg = clrs.nord3_bright, gui = spec.italicize_comments }),
    Comment({ fg = "#56667b", gui = "italic" }),
    Conditional({ fg = clrs.nord9 }),
    Constant({ fg = clrs.nord13 }),
    Define({ fg = clrs.nord9 }),
    Delimiter({ fg = clrs.nord6 }),
    Exception({ fg = clrs.nord9 }),
    Float({ fg = clrs.nord15 }),
    -- Function({ fg = clrs.nord8 }),
    Function({ fg = "#988088" }),
    -- Identifier({ fg = clrs.nord4, gui = "NONE" }),
    Identifier({ fg = "#6e99c6" }),
    Include({ fg = clrs.nord9 }),
    Keyword({ fg = clrs.nord9 }),
    Label({ fg = clrs.nord9 }),
    Number({ fg = clrs.nord15 }),
    Operator({ fg = clrs.nord9, gui = "NONE" }),
    PreProc({ fg = "#4796bc" }),
    -- PreProc({ fg = clrs.nord9, gui = "NONE" }),
    -- Repeat { fg = clrs.nord9 },
    Special({ fg = clrs.nord4 }),
    SpecialChar({ fg = clrs.nord13 }),
    SpecialComment({ fg = clrs.nord8, gui = spec.italicize_comments }),
    -- Statement({ fg = clrs.nord9 }),
    StorageClass({ fg = clrs.nord9 }),
    String({ fg = clrs.nord14 }),
    Structure({ fg = clrs.nord9 }),
    Tag({ fg = clrs.nord4 }),
    Todo({ fg = clrs.nord13, bg = nil, gui = "bold, italic" }),
    Type({ fg = clrs.nord9, gui = "NONE" }),
    Typedef({ fg = clrs.nord9 }),
    PreCondit({ PreProc }),
    Conceal({ bg = Normal.bg, fg = Normal.fg.ro(10) }),
    -- -- +----------------------+
    -- -- + Treesitter
    -- -- +----------------------+
    TSAnnotation({ fg = clrs.nord12 }), -- For C++/Dart attributes, annotations thatcan be attached to the code to denote some kind of meta information.
    TSCharacter({ fg = clrs.nord14 }), -- For characters.
    TSConstructor({ fg = clrs.nord9 }), -- For constructor calls and definitions: `= { }` in Lua, and Java constructors.
    TSFloat({ fg = clrs.nord15 }), -- For floats
    TSNumber({ fg = clrs.nord15 }), -- For all number
    -- TSString({ fg = clrs.nord14 }), -- For strings.
    -- TSAnnotation =              { fg = clrs.nord11 },    -- For C++/Dart attributes, annotations that can be attached to the code to denote some kind of meta information.
    TSAttribute({ fg = clrs.nord15 }), -- (unstable) TODO: docs
    TSBoolean({ fg = clrs.nord9 }), -- For booleans.
    -- TSCharacter=                { fg = clrs.nord12 },    -- For characters.
    -- TSConstructor =             { fg = clrs.nord9 }, -- For constructor calls and definitions: `{ }` in Lua, and Java constructors.
    -- TSConstant({ fg = clrs.nord13 }), -- For constants
    TSConstant(Constant), -- For constants
    -- TSConstBuiltin({ fg = clrs.nord7 }), -- For constant that are built in the language: `nil` in Lua.
    TSConstMacro({ fg = clrs.nord7 }), -- For constants that are defined by macros: `NULL` in C.
    TSError({ fg = clrs.error }), -- For syntax/parser errors.
    TSException({ fg = clrs.nord15 }), -- For exception related keywords.
    TSField({ fg = clrs.gray }), -- For fields.
    -- TSFloat =                   { fg = clrs.nord11 },    -- For floats.
    TSFuncMacro({ fg = clrs.nord7 }), -- For macro defined fuctions (calls and definitions): each `macro_rules` in Rust.
    TSInclude({ fg = clrs.nord9 }), -- For includes: `#include` in C, `use` or `extern crate` in Rust, or `require` in Lua.
    TSLabel({ fg = clrs.nord15 }), -- For labels: `label:` in C and `:label:` in Lua.
    -- TSNamespace({ fg = clrs.nord4 }), -- For identifiers referring to modules and namespaces.
    -- TSNone =                    { },    -- TODO: docs
    -- TSNumber =                  { fg = clrs.nord12 },    -- For all numbers
    TSOperator({ fg = clrs.nord9 }), -- For any operator: `+`, but also `->` and `*` in C.
    TSParameter({ fg = clrs.nord10 }), -- For parameters of a function.
    TSParameterReference({ fg = clrs.nord10 }), -- For references to parameters of a function.
    TSProperty({ fg = clrs.nord10 }), -- Same as `TSField`.
    TSPunctDelimiter({ fg = clrs.nord8 }), -- For delimiters ie: `.`
    TSPunctBracket({ fg = clrs.nord8 }), -- For brackets and parens.
    TSPunctSpecial({ fg = clrs.nord8 }), -- For special punctutation that does not fall in the catagories before.
    -- TSString =                  { fg = clrs.nord14 },    -- For strings.
    TSStringRegex({ fg = clrs.nord7 }), -- For regexes.
    TSStringEscape({ fg = clrs.disabled }), -- For escape characters within a string.
    TSSymbol({ fg = clrs.nord15 }), -- For identifiers referring to symbols or atoms.
    TSType({ fg = clrs.nord9 }), -- For types.
    -- TSTypeBuiltin({ fg = clrs.nord9 }), -- For builtin types.
    TSTag({ fg = clrs.nord4 }), -- Tags like html tag names.
    TSTagDelimiter({ fg = clrs.nord15 }), -- Tag delimiter like `<` `>` `/`
    TSText({ fg = clrs.text }), -- For strings considenord11 text in a markup language.
    TSTextReference({ fg = clrs.nord15 }), -- TODO: fixme
    TSEmphasis({ fg = clrs.nord10 }), -- For text to be represented with emphasis.
    TSUnderline({ bg = clrs.none }), -- For text to be represented with an underline.
    TSStrike({}), -- For strikethrough text.
    TSTitle({ fg = clrs.nord10, bg = clrs.none, gui = "bold" }), -- Text that is part of a title.
    -- TSLiteral({ fg = clrs.fg }), -- Literal text.
    TSURI({ fg = clrs.link }), -- Any URI like a link or email.
    -- TSComment({ fg = clrs.nord3_bright }),
    TSComment(Comment),
    TSConditional({ fg = clrs.nord9 }), -- For keywords related to conditionnals.
    TSKeyword({ fg = clrs.nord9 }), -- For keywords that don't fall in previous categories.
    -- TSRepeat { fg = clrs.nord9 }, -- For keywords related to loops.
    TSKeywordFunction({ fg = clrs.nord8 }),
    TSFunction({ fg = clrs.nord8 }), -- For fuction (calls and definitions).
    TSMethod({ fg = clrs.nord7 }), -- For method calls and definitions.
    -- TSFuncBuiltin({ fg = clrs.nord8 }),
    -- TSVariable({ fg = clrs.accent }),
    -- Any variable name that does not have another highlight.
    -- TSVariableBuiltin({ fg = clrs.accent }),
    -- +-----------+
    -- + Languages +
    -- +-----------+
    asciidocAttributeEntry({ fg = clrs.nord10 }),
    asciidocAttributeList({ fg = clrs.nord10 }),
    asciidocAttributeRef({ fg = clrs.nord10 }),
    asciidocHLabel({ fg = clrs.nord9 }),
    asciidocListingBlock({ fg = clrs.nord7 }),
    asciidocMacroAttributes({ fg = clrs.nord8 }),
    asciidocOneLineTitle({ fg = clrs.nord8 }),
    asciidocPassthroughBlock({ fg = clrs.nord9 }),
    asciidocQuotedMonospaced({ fg = clrs.nord7 }),
    asciidocTriplePlusPassthrough({ fg = clrs.nord7 }),
    asciidocAdmonition({ Keyword }),
    -- asciidocAttributeRef {markdownH1},
    asciidocBackslash({ Keyword }),
    asciidocMacro({ Keyword }),
    asciidocQuotedBold({ Bold }),
    asciidocQuotedEmphasized({ Italic }),
    asciidocQuotedMonospaced2({ asciidocQuotedMonospaced }),
    asciidocQuotedUnconstrainedBold({ asciidocQuotedBold }),
    asciidocQuotedUnconstrainedEmphasized({ asciidocQuotedEmphasized }),
    -- asciidocURL {markdownLinkText},

    awkCharClass({ fg = clrs.nord7 }),
    awkPatterns({ fg = clrs.nord9, gui = spec.bold }),
    awkArrayElement({ Identifier }),
    awkBoolLogic({ Keyword }),
    awkBrktRegExp({ SpecialChar }),
    awkComma({ Delimiter }),
    awkExpression({ Keyword }),
    awkFieldVars({ Identifier }),
    awkLineSkip({ Keyword }),
    awkOperator({ Operator }),
    awkRegExp({ SpecialChar }),
    awkSearch({ Keyword }),
    awkSemicolon({ Delimiter }),
    awkSpecialCharacter({ SpecialChar }),
    awkSpecialPrintf({ SpecialChar }),
    awkVariables({ Identifier }),
    cIncluded({ fg = clrs.nord7 }),
    cOperator({ Operator }),
    cPreCondit({ PreCondit }),
    cmakeGeneratorExpression({ fg = clrs.nord10 }),
    csPreCondit({ PreCondit }),
    csType({ Type }),
    csXmlTag({ SpecialComment }),
    cssAttributeSelector({ fg = clrs.nord7 }),
    cssDefinition({ fg = clrs.nord7, gui = "NONE" }),
    cssIdentifier({ fg = clrs.nord7, gui = spec.underline }),
    cssStringQ({ fg = clrs.nord7 }),
    cssAttr({ Keyword }),
    cssBraces({ Delimiter }),
    cssClassName({ cssDefinition }),
    cssColor({ Number }),
    cssProp({ cssDefinition }),
    cssPseudoClass({ cssDefinition }),
    cssPseudoClassId({ cssPseudoClass }),
    cssVendor({ Keyword }),
    dosiniHeader({ fg = clrs.nord8 }),
    dosiniLabel({ Type }),
    dtBooleanKey({ fg = clrs.nord7 }),
    dtExecKey({ fg = clrs.nord7 }),
    dtLocaleKey({ fg = clrs.nord7 }),
    dtNumericKey({ fg = clrs.nord7 }),
    dtTypeKey({ fg = clrs.nord7 }),
    dtDelim({ Delimiter }),
    dtLocaleValue({ Keyword }),
    dtTypeValue({ Keyword }),
    DiffAdd({
      fg = clrs.nord14,
      bg = cfg.nord_uniform_diff_background == 0 and clrs.nord0 or clrs.nord1,
      gui = spec.inverse,
    }),
    DiffChange({
      fg = clrs.nord13,
      bg = cfg.nord_uniform_diff_background == 0 and clrs.nord0 or clrs.nord1,
      gui = spec.inverse,
    }),
    DiffDelete({
      fg = clrs.nord11,
      bg = cfg.nord_uniform_diff_background == 0 and clrs.nord0 or clrs.nord1,
      gui = spec.inverse,
    }),
    DiffText({
      fg = clrs.nord9,
      bg = cfg.nord_uniform_diff_background == 0 and clrs.nord0 or clrs.nord1,
      gui = spec.inverse,
    }),
    gitconfigVariable({ fg = clrs.nord7 }),
    goBuiltins({ fg = clrs.nord7 }),
    goConst({ Keyword }),
    helpBar({ fg = clrs.nord3 }),
    helpHyperTextJump({ fg = clrs.nord8, gui = spec.underline }),
    markdownBlockquote({ fg = clrs.nord7 }),
    markdownCode({ fg = clrs.nord7 }),
    markdownCodeBlock({ fg = clrs.nord7 }),
    markdownCodeDelimiter({ fg = clrs.nord7 }),
    markdownFootnote({ fg = clrs.nord7 }),
    markdownId({ fg = clrs.nord7 }),
    markdownIdDeclaration({ fg = clrs.nord7 }),
    markdownH1({ fg = clrs.nord8 }),
    markdownLinkText({ fg = clrs.nord8 }),
    markdownUrl({ fg = clrs.nord4, gui = "NONE" }),
    markdownBold({ Bold }),
    markdownBoldDelimiter({ Keyword }),
    markdownFootnoteDefinition({ markdownFootnote }),
    markdownH2({ markdownH1 }),
    markdownH3({ markdownH1 }),
    markdownH4({ markdownH1 }),
    markdownH5({ markdownH1 }),
    markdownH6({ markdownH1 }),
    markdownIdDelimiter({ Keyword }),
    markdownItalic({ Italic }),
    markdownItalicDelimiter({ Keyword }),
    markdownLinkDelimiter({ Keyword }),
    markdownLinkTextDelimiter({ Keyword }),
    markdownListMarker({ Keyword }),
    markdownRule({ Keyword }),
    markdownHeadingDelimiter({ Keyword }),
    htmlArg({ fg = clrs.nord7 }),
    htmlLink({ fg = clrs.nord4, gui = "NONE" }),
    htmlBold({ Bold }),
    htmlTag({ Keyword }),
    htmlEndTag({ htmlTag }),
    htmlItalic({ Italic }),
    htmlH1({ markdownH1 }),
    htmlH2({ markdownH1 }),
    htmlH3({ markdownH1 }),
    htmlH4({ markdownH1 }),
    htmlH5({ markdownH1 }),
    htmlH6({ markdownH1 }),
    htmlSpecialChar({ SpecialChar }),
    htmlTagN({ htmlTag }),
    pandocReferenceURL({ gui = "none", gui = "none" }),
    pandocUListItem({ gui = "none", gui = "none" }),
    javaDocTags({ fg = clrs.nord7 }),
    javaCommentTitle({ Comment }),
    javaScriptBraces({ Delimiter }),
    javaScriptIdentifier({ Keyword }),
    javaScriptNumber({ Number }),
    jsonKeyword({ fg = clrs.nord7 }),
    lessClass({ fg = clrs.nord7 }),
    lessAmpersand({ Keyword }),
    lessCssAttribute({ Delimiter }),
    lessFunction({ Function }),
    cssSelectorOp({ Keyword }),
    lispAtomBarSymbol({ SpecialChar }),
    lispAtomList({ SpecialChar }),
    lispAtomMark({ Keyword }),
    lispBarSymbol({ SpecialChar }),
    lispFunc({ Function }),
    luaFunc({ Function }),
    luaConstant({ Number }), -- TODO: Could also be linked to Number for being violet <04-03-21, kunzaatko>
    perlPackageDecl({ fg = clrs.nord7 }),
    phpClasses({ fg = clrs.nord7 }),
    phpClass({ fg = clrs.nord7 }),
    phpDocTags({ fg = clrs.nord7 }),
    phpDocCustomTags({ phpDocTags }),
    phpMemberSelector({ Keyword }),
    phpMethod({ Function }),
    phpFunction({ Function }),
    podCmdText({ fg = clrs.nord7 }),
    podVerbatimLine({ fg = clrs.nord4 }),
    podFormat({ Keyword }),
    pythonBuiltin({ Type }),
    pythonEscape({ SpecialChar }),
    rubyConstant({ fg = clrs.nord7 }),
    rubySymbol({ fg = clrs.nord6, gui = spec.bold }),
    rubyAttribute({ Identifier }),
    rubyBlockParameterList({ Operator }),
    rubyInterpolationDelimiter({ Keyword }),
    rubyKeywordAsMethod({ Function }),
    rubyLocalVariableOrMethod({ Function }),
    rubyPseudoVariable({ Keyword }),
    rubyRegexp({ SpecialChar }),
    rustAttribute({ fg = clrs.nord10 }),
    rustEnum({ fg = clrs.nord7, gui = spec.bold }),
    rustMacro({ fg = clrs.nord8, gui = spec.bold }),
    rustModPath({ fg = clrs.nord7 }),
    rustPanic({ fg = clrs.nord9, gui = spec.bold }),
    rustTrait({ fg = clrs.nord7, gui = spec.italic }),
    rustCommentLineDoc({ Comment }),
    rustDerive({ rustAttribute }),
    rustEnumVariant({ rustEnum }),
    rustEscape({ SpecialChar }),
    rustQuestionMark({ Keyword }),
    sassClass({ fg = clrs.nord7 }),
    sassId({ fg = clrs.nord7, gui = spec.underline }),
    sassAmpersand({ Keyword }),
    sassClassChar({ Delimiter }),
    sassControl({ Keyword }),
    sassControlLine({ Keyword }),
    sassExtend({ Keyword }),
    sassFor({ Keyword }),
    sassFunctionDecl({ Keyword }),
    sassFunctionName({ Function }),
    sassidChar({ sassId }),
    sassInclude({ SpecialChar }),
    sassMixinName({ Function }),
    sassMixing({ SpecialChar }),
    sassReturn({ Keyword }),
    shCmdParenRegion({ Delimiter }),
    shCmdSubRegion({ Delimiter }),
    shDerefSimple({ Identifier }),
    shDerefVar({ Identifier }),
    sqlKeyword({ Keyword }),
    sqlSpecial({ Keyword }),
    vimAugroup({ fg = clrs.nord7 }),
    vimMapRhs({ fg = clrs.nord7 }),
    vimNotation({ fg = clrs.nord7 }),
    vimFunc({ Function }),
    vimFunction({ Function }),
    vimUserFunc({ Function }),
    xmlAttrib({ fg = clrs.nord7 }),
    xmlCdataStart({ fg = clrs.nord3_bright, gui = spec.bold }),
    xmlNamespace({ fg = clrs.nord7 }),
    xmlAttribPunct({ Delimiter }),
    xmlCdata({ Comment }),
    xmlCdataCdata({ xmlCdataStart }),
    xmlCdataEnd({ xmlCdataStart }),
    xmlTagName({ Keyword }),
    xmlEndTag({ xmlTagName }),
    xmlProcessingDelim({ Keyword }),
    yamlBlockMappingKey({ fg = clrs.nord7 }),
    yamlBool({ Keyword }),
    yamlDocumentStart({ Keyword }),

    -- +----------------+
    -- + Plugin Support +
    -- +----------------+
    -- +--- UI ---+
    -- dashboard
    DashboardShortCut({ fg = clrs.nord7 }),
    DashboardHeader({ fg = clrs.nord9 }),
    DashboardCenter({ fg = clrs.nord8 }),
    DashboardFooter({ fg = clrs.nord14, gui = "italic" }),
    -- Nvim LSP
    -- > neovim/nvim-lsp
    DiagnosticWarn({ fg = clrs.nord13 }),
    DiagnosticError({ fg = clrs.nord11 }),
    DiagnosticInfo({ fg = clrs.nord8 }),
    DiagnosticHint({ fg = clrs.nord10 }),
    DiagnosticUnderlineError({ fg = "none", gui = "none" }),
    DiagnosticUnderlineWarn({ fg = "none", gui = "none" }),
    DiagnosticUnderlineInfo({ fg = "none", gui = "none" }),
    DiagnosticUnderlineHint({ fg = "none", gui = "none" }),
    DiagnosticFloatingError({ fg = clrs.nord4 }),
    DiagnosticFloatingWarn({ fg = clrs.nord4 }),
    DiagnosticFloatingInfo({ fg = clrs.nord4 }),
    DiagnosticFloatingHint({ fg = clrs.nord4 }),
    DiagnosticSignWarn({ fg = clrs.nord13 }),
    DiagnosticSignError({ fg = clrs.nord11 }),
    DiagnosticSignInfo({ fg = clrs.nord8 }),
    DiagnosticSignHint({ fg = clrs.nord10 }),
    DiagnosticVirtualTextWarn({
      fg = DiagnosticWarn.fg.de(20).li(10),
      gui = spec.italic,
    }),
    DiagnosticVirtualTextError({
      fg = DiagnosticError.fg.de(20).li(10),
      gui = spec.italic,
    }),
    DiagnosticVirtualTextInfo({
      fg = DiagnosticInfo.fg.de(20).da(10),
      gui = spec.italic,
    }),
    DiagnosticVirtualTextHint({
      fg = DiagnosticHint.fg.de(20).li(10),
      gui = spec.italic,
    }),
    -- fugitive.vim
    -- > tpope/vim-fugitive
    gitcommitDiscardedFile({ fg = clrs.nord11 }),
    gitcommitUntrackedFile({ fg = clrs.nord11 }),
    gitcommitSelectedFile({ fg = clrs.nord14 }),
    -- vim-indent-guides
    -- > nathanaelkane/vim-indent-guides
    IndentGuidesEven({ bg = clrs.nord1 }),
    IndentGuidesOdd({ bg = clrs.nord2 }),
    -- vim-startify
    -- > mhinz/vim-startify
    StartifyFile({ fg = clrs.nord11 }),
    StartifyFooter({ fg = clrs.nord7 }),
    StartifyHeader({ fg = clrs.nord15 }),
    StartifyNumber({ fg = clrs.nord13 }),
    StartifyPath({ fg = clrs.nord8 }),
    StartifyBracket({ Delimiter }),
    StartifySlash({ Normal }),
    StartifySpecial({ Comment }),
    -- LspTrouble
    LspTroubleText({ fg = clrs.text }),
    LspTroubleCount({ fg = clrs.nord9, bg = clrs.active }),
    -- LspTroubleNormal({ fg = clrs.fg, bg = clrs.sidebar }),
    -- Diff
    diffAdded({ fg = clrs.nord14 }),
    diffRemoved({ fg = clrs.nord11 }),
    diffChanged({ fg = clrs.nord15 }),
    diffOldFile({ fg = clrs.yelow }),
    diffNewFile({ fg = clrs.nord12 }),
    diffFile({ fg = clrs.nord7 }),
    diffLine({ fg = clrs.comments }),
    diffIndexLine({ fg = clrs.nord9 }),
    -- Neogit
    NeogitBranch({ fg = clrs.nord10 }),
    NeogitRemote({ fg = clrs.nord9 }),
    -- NeogitHunkHeader({ fg = clrs.fg, bg = clrs.highlight }),
    NeogitHunkHeaderHighlight({ fg = clrs.nord7, bg = clrs.contrast }),
    -- NeogitDiffContextHighlight({ fg = clrs.bg_alt, bg = clrs.contrast }),
    NeogitDiffDeleteHighlight({ fg = clrs.nord11 }),
    NeogitDiffAddHighlight({ fg = clrs.nord14 }),
    -- GitGutter
    GitGutterAdd({ fg = clrs.nord14 }), -- diff mode: Added line |diff.txt|
    GitGutterChange({ fg = clrs.nord15 }), -- diff mode: Changed line |diff.txt|
    GitGutterDelete({ fg = clrs.nord11 }), -- diff mode: Deleted line |diff.txt|
    -- GitSigns
    GitSignsAdd({ fg = clrs.nord14 }), -- diff mode: Added line |diff.txt|
    GitSignsAddNr({ fg = clrs.nord14 }), -- diff mode: Added line |diff.txt|
    GitSignsAddLn({ fg = clrs.nord14 }), -- diff mode: Added line |diff.txt|
    GitSignsChange({ fg = clrs.nord15 }), -- diff mode: Changed line |diff.txt|
    GitSignsChangeNr({ fg = clrs.nord15 }), -- diff mode: Changed line |diff.txt|
    GitSignsChangeLn({ fg = clrs.nord15 }), -- diff mode: Changed line |diff.txt|
    GitSignsDelete({ fg = clrs.nord11 }), -- diff mode: Deleted line |diff.txt|
    GitSignsDeleteNr({ fg = clrs.nord11 }), -- diff mode: Deleted line |diff.txt|
    GitSignsDeleteLn({ fg = clrs.nord11 }), -- diff mode: Deleted line |diff.txt|
    -- Telescope
    TelescopePromptBorder({ fg = clrs.nord8 }),
    TelescopeResultsBorder({ fg = clrs.nord9 }),
    TelescopePreviewBorder({ fg = clrs.nord14 }),
    TelescopeSelectionCaret({ fg = clrs.nord9 }),
    TelescopeSelection({ fg = clrs.nord9 }),
    TelescopeMatching({ fg = clrs.nord8 }),
    -- -- NvimTree
    NvimTreeRootFolder({ fg = clrs.nord7, gui = "bold" }),
    NvimTreeGitDirty({ fg = clrs.nord15 }),
    NvimTreeGitNew({ fg = clrs.nord14 }),
    NvimTreeImageFile({ fg = clrs.nord15 }),
    NvimTreeExecFile({ fg = clrs.nord14 }),
    NvimTreeSpecialFile({ fg = clrs.nord9, gui = spec.underline }),
    NvimTreeFolderName({ fg = clrs.nord10 }),
    NvimTreeEmptyFolderName({ fg = clrs.disabled }),
    NvimTreeFolderIcon({ fg = clrs.accent }),
    NvimTreeIndentMarker({ fg = clrs.disabled }),
    -- LspDiagnosticsError({ fg = clrs.error }),
    -- LspDiagnosticsInformation({ fg = clrs.nord10 }),
    -- LspDiagnosticsHint({ fg = clrs.nord9 }),
    -- -- -- WhichKey
    -- -- LspSaga
    -- LspFloatWinNormal({ bg = clrs.contrast }),
    -- LspFloatWinBorder({ fg = clrs.nord9 }),
    -- LspSagaBorderTitle({ fg = clrs.nord8 }),
    -- LspSagaHoverBorder({ fg = clrs.nord10 }),
    -- LspSagaRenameBorder({ fg = clrs.nord14 }),
    -- LspSagaDefPreviewBorder({ fg = clrs.nord14 }),
    -- LspSagaCodeActionBorder({ fg = clrs.nord7 }),
    -- LspSagaFinderSelection({ fg = clrs.nord14 }),
    -- LspSagaCodeActionTitle({ fg = clrs.nord10 }),
    -- LspSagaCodeActionContent({ fg = clrs.nord9 }),
    -- LspSagaSignatureHelpBorder({ fg = clrs.nord13 }),
    -- ReferencesCount({ fg = clrs.nord9 }),
    -- DefinitionCount({ fg = clrs.nord9 }),
    -- DefinitionIcon({ fg = clrs.nord7 }),
    -- ReferencesIcon({ fg = clrs.nord7 }),
    -- TargetWord({ fg = clrs.nord8 }),
    -- --
    -- used for highlighting "text" references
    LspReferenceText({ gui = "underline", fg = clrs.nord14 }),
    -- used for highlighting "read" references
    LspReferenceRead({ gui = "underline", fg = clrs.nord14 }),
    -- used for highlighting "write" references
    LspReferenceWrite({ gui = "underline", fg = clrs.nord14 }),
    -- +--- Languages ---+
    -- Haskell
    -- > neovimhaskell/haskell-vim
    haskellPreProc({ fg = clrs.nord10 }),
    haskellType({ fg = clrs.nord7 }),
    haskellPragma({ haskellPreProc }),
    -- JavaScript
    -- > pangloss/vim-javascript
    jsGlobalNodeObjects({ fg = clrs.nord8, gui = spec.italic }),
    jsBrackets({ Delimiter }),
    jsFuncCall({ Function }),
    jsFuncParens({ Delimiter }),
    jsThis({ Keyword }),
    jsNoise({ Delimiter }),
    jsPrototype({ Keyword }),
    jsRegexpString({ SpecialChar }),
    -- TypeScript
    -- > HerringtonDarkholme/yats.vim
    typescriptBOMWindowMethod({ fg = clrs.nord8, gui = spec.italic }),
    typescriptClassName({ fg = clrs.nord7 }),
    typescriptDecorator({ fg = clrs.nord12 }),
    typescriptInterfaceName({ fg = clrs.nord7, gui = spec.bold }),
    typescriptRegexpString({ fg = clrs.nord13 }),
    -- TypeScript JSX
    tsxAttrib({ fg = clrs.nord7 }),
    typescriptOperator({ Operator }),
    typescriptBinaryOp({ Operator }),
    typescriptAssign({ Operator }),
    typescriptMember({ Identifier }),
    typescriptDOMStorageMethod({ Identifier }),
    typescriptArrowFuncArg({ Identifier }),
    typescriptGlobal({ typescriptClassName }),
    typescriptBOMWindowProp({ Function }),
    typescriptArrowFuncDef({ Function }),
    typescriptAliasDeclaration({ Function }),
    typescriptPredefinedType({ Type }),
    -- typescriptTypeReference({ Type }),
    typescriptTypeAnnotation({ Structure }),
    typescriptDocNamedParamType({ SpecialComment }),
    typescriptDocNotation({ Keyword }),
    typescriptDocTags({ Keyword }),
    typescriptImport({ Keyword }),
    typescriptExport({ Keyword }),
    typescriptTry({ Keyword }),
    -- typescriptVariable({ Keyword }),
    typescriptBraces({ Normal }),
    typescriptObjectLabel({ Normal }),
    typescriptCall({ Normal }),
    typescriptClassHeritage({ typescriptClassName }),
    typescriptFuncTypeArrow({ Structure }),
    typescriptMemberOptionality({ Structure }),
    typescriptNodeGlobal({ typescriptGlobal }),
    -- typescriptTypeBrackets({ Structure }),
    tsxEqual({ Operator }),
    tsxIntrinsicTagName({ htmlTag }),
    tsxTagName({ tsxIntrinsicTagName }),
    -- Markdown
    -- > plasticboy/vim-markdown
    mkdCode({ fg = clrs.nord7 }),
    mkdFootnote({ fg = clrs.nord8 }),
    mkdRule({ fg = clrs.nord10 }),
    mkdLineBreak({ fg = clrs.nord9 }),
    mkdBold({ Bold }),
    mkdItalic({ Italic }),
    mkdString({ Keyword }),
    mkdCodeStart({ mkdCode }),
    mkdCodeEnd({ mkdCode }),
    mkdBlockquote({ Comment }),
    mkdListItem({ Keyword }),
    mkdListItemLine({ Normal }),
    mkdFootnotes({ mkdFootnote }),
    mkdLink({ markdownLinkText }),
    mkdURL({ markdownUrl }),
    mkdInlineURL({ mkdURL }),
    mkdID({ Identifier }),
    mkdLinkDef({ mkdLink }),
    mkdLinkDefTarget({ mkdURL }),
    mkdLinkTitle({ mkdInlineURL }),
    mkdDelimiter({ Keyword }),
    -- Vimwiki
    -- > vimwiki/vimwiki
    VimwikiLink({ fg = clrs.nord8, gui = spec.underline }),
    VimwikiHeaderChar({ markdownHeadingDelimiter }),
    VimwikiHR({ Keyword }),
    VimwikiList({ markdownListMarker }),
    -- YAML
    -- > stephpy/vim-yaml
    yamlKey({ fg = clrs.nord7 }),
    -- gitsigns.nvim
    -- > lewis6991/gitsigns.nvim
    GreenSign({ fg = clrs.nord14 }),
    BlueSign({ fg = clrs.nord10 }),
    RedSign({ fg = clrs.nord11 }),
    PurpleSign({ fg = clrs.nord15 }),
  }
end)

return theme

-- vi:nowrap
