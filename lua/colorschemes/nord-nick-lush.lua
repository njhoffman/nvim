---@diagnostic disable: undefined-global

local ok, lush = pcall(require, "lush")
if not ok then
  return
end

local ok_nord, nord = pcall(require, "colorschemes.lush-themes.nord-nvim")
if not ok_nord then
  return
end

local ok_plugins, hl_plugins = pcall(require, "colorschemes.nord-nick-plugins")
if not ok_plugins then
  return
end

local ok_main, hl_main = pcall(require, "colorschemes.nord-nick-main")
if not ok_main then
  return
end

local plugins = lush.extends({nord}).with(hl_plugins)
local main = lush.extends({plugins}).with(hl_main)
return main

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
