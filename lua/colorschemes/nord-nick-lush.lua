---@diagnostic disable: undefined-global

local ok, lush = pcall(require, "lush")
local ok_nord, nord = pcall(require, "colorschemes.lush-themes.nord-nvim")
local ok_main, hl_main = pcall(require, "colorschemes.nord-nick-main")
local ok_plugins, hl_plugins = pcall(require, "colorschemes.nord-nick-plugins")
if not ok or not ok_nord or not ok_plugins or not ok_main then
  return
end

local plugins = lush.extends({ nord }).with(hl_plugins)
local main = lush.extends({ plugins }).with(hl_main)
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
