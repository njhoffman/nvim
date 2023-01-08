-- codeActionProvider = {
--   codeActionKinds = { "", "quickfix", "refactor.rewrite", "refactor.extract" },
--   resolveProvider = false
-- },
-- colorProvider = true,
-- completionProvider = {
--   resolveProvider = true,
--   triggerCharacters = { "\t", "\n", ".", ":", "(", "'", '"', "[", ",", "#", "*", "@", "|", "=", "-", "{", " ", "+", "?" }
-- },
-- definitionProvider = true,
-- documentFormattingProvider = true,
-- documentHighlightProvider = true,
-- documentOnTypeFormattingProvider = {
--   firstTriggerCharacter = "\n"
-- },
-- documentRangeFormattingProvider = true,
-- documentSymbolProvider = true,
-- executeCommandProvider = {
--   commands = { "lua.removeSpace", "lua.solve", "lua.jsonToLua", "lua.setConfig", "lua.autoRequire" }
-- },
-- foldingRangeProvider = true,
-- hoverProvider = true,
-- inlayHintProvider = {
--   resolveProvider = true
-- },
-- offsetEncoding = "utf-16",
-- referencesProvider = true,
-- renameProvider = {
--   prepareProvider = true
-- },
-- semanticTokensProvider = {
--   full = true,
--   legend = {
--     tokenModifiers = { "declaration", "definition", "readonly", "static", "deprecated", "abstract", "async", "modification", "documentation", "defaultLibrary" },
--     tokenTypes = { "namespace", "type", "class", "enum", "interface", "struct", "typeParameter", "parameter", "variable", "property", "enumMember", "event", "function", "method", "macro", "keyword", "modifier", "comment", "string", "number", "regexp", "operator", "decorator" }
--   },
--   range = true
-- },
-- signatureHelpProvider = {
--   triggerCharacters = { "(", "," }
-- },
-- textDocumentSync = {
--   change = 2,
--   openClose = true
-- },
-- typeDefinitionProvider = true,
-- workspace = {
--   workspaceFolders = {
--     changeNotifications = true,
--     supported = true
--   }
-- },
-- workspaceSymbolProvider = true

-- {
--   ["codeLens/resolve"] = { "codeLensProvider", "resolveProvider" },
--   ["textDocument/codeAction"] = { "codeActionProvider" },
--   ["textDocument/codeLens"] = { "codeLensProvider" },
--   ["textDocument/completion"] = { "completionProvider" },
--   ["textDocument/declaration"] = { "declarationProvider" },
--   ["textDocument/definition"] = { "definitionProvider" },
--   ["textDocument/documentHighlight"] = { "documentHighlightProvider" },
--   ["textDocument/documentSymbol"] = { "documentSymbolProvider" },
--   ["textDocument/formatting"] = { "documentFormattingProvider" },
--   ["textDocument/hover"] = { "hoverProvider" },
--   ["textDocument/implementation"] = { "implementationProvider" },
--   ["textDocument/prepareCallHierarchy"] = { "callHierarchyProvider" },
--   ["textDocument/prepareRename"] = { "renameProvider", "prepareProvider" },
--   ["textDocument/rangeFormatting"] = { "documentRangeFormattingProvider" },
--   ["textDocument/references"] = { "referencesProvider" },
--   ["textDocument/rename"] = { "renameProvider" },
--   ["textDocument/signatureHelp"] = { "signatureHelpProvider" },
--   ["textDocument/typeDefinition"] = { "typeDefinitionProvider" },
--   ["workspace/executeCommand"] = { "executeCommandProvider" },
--   ["workspace/symbol"] = { "workspaceSymbolProvider" }
-- }

local display_keys = {
  "callHierarchyProvider",
  "codeActionProvider",
  "codeLensProvider",
  "colorProvider",
  "completionProvider",
  "declarationProvider",
  "documentHighlightProvider",
  "documentFormattingProvider",
  "documentFormattingRangeProvider",
  "documentSymbolProvider",
  -- "executeCommandProvider",
  "definitionProvider",
  "referencesProvider",
  "hoverProvider",
  "implementationProvider",
  "renameProvider",
  "signatureHelpProvider",
  "typeDefinitionProvider",
  "workspace",
}

return { display_keys = display_keys }

-- local old_keys = {
--   "call_hierarchy",
--   "code_action",
--   "code_lens",
--   "completion",
--   "declaration",
--   "document_formatting",
--   "document_highlight",
--   "document_range_formatting",
--   "document_symbol",
--   "execute_command",
--   "find_references",
--   "goto_definition",
--   "hover",
--   "implementation",
--   "rename",
--   "signature_help",
--   "type_definition",
-- }
--

-- call v:lua.show_capabilities()
--   codeActionProvider = {
--     codeActionKinds = { "", "quickfix", "refactor.rewrite", "refactor.extract" },
--     resolveProvider = false
--   },
--   colorProvider = true,
--   completionProvider = {
--     resolveProvider = true,
--     triggerCharacters = { "\t", "\n", ".", ":", "(", "'", '"', "[", ",", "#", "*", "@", "|", "=", "-", "{", " ", "+", "?" }
--   },
--   definitionProvider = true,
--   documentFormattingProvider = true,
--   documentHighlightProvider = true,
--   documentOnTypeFormattingProvider = {
--     firstTriggerCharacter = "\n"
--   },
--   documentRangeFormattingProvider = true,
--   documentSymbolProvider = true,
--   executeCommandProvider = {
--     commands = { "lua.removeSpace", "lua.solve", "lua.jsonToLua", "lua.setConfig", "lua.autoRequire" }
--   },
--   foldingRangeProvider = true,
--   hoverProvider = true,
--   inlayHintProvider = {
--     resolveProvider = true
--   },
--   offsetEncoding = "utf-16",
--   referencesProvider = true,
--   renameProvider = {
--     prepareProvider = true
--   },
--   semanticTokensProvider = {
--     full = true,
--     legend = {
--       tokenModifiers = { "declaration", "definition", "readonly", "static", "deprecated", "abstract", "async", "modification", "documentation", "defaultLibrary" },
--       tokenTypes = { "namespace", "type", "class", "enum", "interface", "struct", "typeParameter", "parameter", "variable", "property", "enumMember", "event", "function", "method", "macro", "keyword", "modifier", "comment", "string", "number", "regexp", "operator", "decorator" }
--     },
--     range = true
--   },
--   signatureHelpProvider = {
--     triggerCharacters = { "(", "," }
--   },
--   textDocumentSync = {
--     change = 2,
--     openClose = true
--   },
--   typeDefinitionProvider = true,
--   workspace = {
--     workspaceFolders = {
--       changeNotifications = true,
--       supported = true
--     }
--   },
--   workspaceSymbolProvider = true
-- }

-- "callHierarchyProvider",
-- "codeActionProvider",
-- "codeLensProvider",
-- "completionProvider",
-- "declarationProvider",
-- "documentFormattingProvider",
-- "documentHighlightProvider",
-- "documentRangeFormattingProvider",
-- "documentSymbolProvider",
-- "executeCommandProvider",
-- "findReferencesProvider",
-- "codeActionProvider",
-- "gotoDefinitionProvider",
-- "hoverProvider",
-- "implementationProvider",
-- "renameProvider",
-- "signatureHelpProvider",
-- "typeDefinitionProvider",

-- completionProvider
-- documentOnTypeFormattingProvider
-- executeCommandProvider
-- foldingRangeProvider
-- inlayHintProvider
-- offsetEncoding
-- referencesProvider
-- semanticTokensProvider
-- textDocumentSync
-- workspace
-- workspaceSymbolProvider

-- :lua print(vim.inspect(vim.tbl_keys(vim.lsp.handlers)))
-- $/progress
-- callHierarchy/incomingCalls
-- callHierarchy/outgoingCalls
-- client/registerCapability
-- hover
-- signature_help
-- textDocument/codeLens
-- textDocument/completion
-- textDocument/declaration
-- textDocument/definition
-- textDocument/documentHighlight
-- textDocument/documentSymbol
-- textDocument/formatting
-- textDocument/hover
-- textDocument/implementation
-- textDocument/publishDiagnostics
-- textDocument/rangeFormatting
-- textDocument/references
-- textDocument/rename
-- textDocument/signatureHelp
-- textDocument/typeDefinition
-- window/logMessage
-- window/showMessage
-- window/showMessageRequest
-- window/workDoneProgress/create
-- workspace/applyEdit
-- workspace/configuration
-- workspace/executeCommand
-- workspace/symbol
-- workspace/workspaceFolders
