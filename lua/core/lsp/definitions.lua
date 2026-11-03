local display_keys = {
  "callHierarchyProvider",
  "codeActionProvider",
  "codeLensProvider",
  "colorProvider",
  "completionProvider",
  "declarationProvider",
  "definitionProvider",
  "diagnosticProvider",
  "documentFormattingProvider",
  "documentHighlightProvider",
  "documentRangeFormattingProvider",
  "documentSymbolProvider",
  "hoverProvider",
  "implementationProvider",
  "referencesProvider",
  "renameProvider",
  "signatureHelpProvider",
  "typeDefinitionProvider",
  "workspace",
  "workspaceSymbolProvider",
  -- "executeCommandProvider",
  -- 'semanticTokensProvider',
}

-- :lua print(vim.inspect(vim.tbl_keys(vim.lsp.handlers)))
-- - callHierarchy/incomingCalls
-- - callHierarchy/outgoingCalls
-- - textDocument/codeAction
-- - textDocument/completion
-- - textDocument/declaration*
-- - textDocument/definition
-- - textDocument/diagnostic
-- - textDocument/documentHighlight
-- - textDocument/documentSymbol
-- - textDocument/formatting
-- - textDocument/hover
-- - textDocument/implementation*
-- - textDocument/inlayHint
-- - textDocument/publishDiagnostics
-- - textDocument/rangeFormatting
-- - textDocument/references
-- - textDocument/rename
-- - textDocument/semanticTokens/full
-- - textDocument/semanticTokens/full/delta
-- - textDocument/signatureHelp
-- - textDocument/typeDefinition*
-- - window/logMessage
-- - window/showMessage
-- - window/showDocument
-- - window/showMessageRequest
-- - workspace/applyEdit
-- - workspace/configuration
-- - workspace/executeCommand
-- - workspace/inlayHint/refresh
-- - workspace/symbol
-- - workspace/workspaceFolders

return { display_keys = display_keys }

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
