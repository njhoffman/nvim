local M = {}

M.get_counts = function()
  local counts = { }

  return counts
end


-- local clients = vim.lsp..get_active_clients()
local clients = vim.lsp.buf_get_clients()

local capabilities_map = {
  codeAction = 'code_action',
  completion = 'completion',
  declaration = 'declaration',
  definition = 'definition',
  documentHighlight = 'document_highlight',
  documentSymbol = 'document_symbol',
  formatting = 'formatting',
  hover = 'hover',
  implementation = 'implementation',
  publishDiagnostics = 'publish_diagnostics',
  rangeFormatting = 'range_formatting',
  references = 'references',
  rename = 'rename',
  signatureHelp = 'signature_help',
  typeDefinition = 'type_definition',
  workspaceSymbol = 'workspace_symbol'
}

-- codeActionProvider
-- completionProvider
-- definitionProvider
-- documentHighlightProvider
-- documentOnTypeFormattingProvider
-- documentSymbolProvider
-- executeCommandProvider
-- foldingRangeProvider
-- hoverProvider
-- offsetEncoding
-- referencesProvider
-- renameProvider
-- signatureHelpProvider
-- textDocumentSync
-- typeDefinitionProvider
-- workspaceSymbolProvider

--   call_hierarchy
--   code_action
--   code_lens
--   code_lens_resolve
--   completion
--   declaration
--   document_formatting
--   document_highlight
--   document_range_formatting
--   document_symbol
--   execute_command
--   find_references
--   goto_definition
--   hover
--   implementation
--   rename
--   signature_help
--   signature_help_trigger_characters
--   text_document_did_change
--   text_document_open_close
--   text_document_save
--   text_document_save_include_text
--   text_document_will_save
--   text_document_will_save_wait_until
--   type_definition
--   workspace_folder_properties
--   workspace_symbol

-- vim.lsp.buf.code_action()
-- vim.lsp.buf.hover()
-- vim.lsp.buf.references()
-- vim.lsp.buf.implementation()
-- vim.lsp.buf.type_definition()
-- vim.lsp.buf.formatting()
-- vim.lsp.buf.list_workspace_folders()

local capabilities = {}

for name, capability in pairs(vim.lsp._request_name_to_capability) do
  capabilities[capability] = { full_name = name, clients = {} }
end

for _, client in pairs(clients) do
  -- client.handlers, requests, id name, server_capabilities, messages, is_stopped, rpc
  -- supports_method, commands, config, attached_buffers, initialized, supports_method, workspace_did_change_configuration

  local params = vim.lsp.util.make_position_params()
  for name, capability in pairs(capabilities) do
    if type(capability.clients[client.name] ~= 'table') then capability.clients[client.name] = {} end
    local resolved = client.resolved_capabilities[name]
    capability.clients[client.name] = resolved
    if resolved == true then
      vim.lsp.buf_request(0, capability.full_name, params, function(err, result, _ctx, _config)
        if err then
          -- vim.api.nvim_err_writeln("Error when finding references: " .. err.message)
          vim.dbg("Error when finding " .. name .. ": \n" .. err.message)
          return
        end

        if not result or vim.tbl_isempty(result) then
          vim.dbg("No results from " .. capability.full_name)
          return
        end
        -- vim.dbg(name .. ' result: ' .. vim.inspect(result))
      end)
    end
  end
  -- vim.dbg('Name: ' .. client.name .. ', id: ' .. client.id .. ', running: '.. tostring(client.is_stopped() == false) )
  -- for name in pairs(client.resolved_capabilities) do

  -- end

end

return M


-- LspProgressUpdate                                          *LspProgressUpdate*
--    Upon receipt of a progress notification from the server. See
--    |vim.lsp.util.get_progress_messages()|.

-- LspRequest                                                        *LspRequest*
--    After a change to the active set of pending LSP requests. See {requests}
--    in |vim.lsp.client|.

-- Example: >
--    autocmd User LspProgressUpdate redrawstatus
--    autocmd User LspRequest redrawstatus
-- <

-- verbose set omnifunc? "v:lua.vim.lsp.omnifunc": >
-- vim.tbl_keys(vim.lsp.handlers)
-- callHierarchy/incomingCalls
-- callHierarchy/outgoingCalls
-- textDocument/codeAction
-- textDocument/completion
-- textDocument/declaration*
-- textDocument/definition
-- textDocument/documentHighlight
-- textDocument/documentSymbol
-- textDocument/formatting
-- textDocument/hover
-- textDocument/implementation*
-- textDocument/publishDiagnostics
-- textDocument/rangeFormatting
-- textDocument/references
-- textDocument/rename
-- textDocument/signatureHelp
-- textDocument/typeDefinition*
-- window/logMessage
-- window/showMessage
-- window/showMessageRequest
-- workspace/applyEdit
-- workspace/symbol
--
--
-- vim.dbg(client.resolved_capabilities)
-- {
--   call_hierarchy = false,
--   code_action = {
--     codeActionKinds = { "", "quickfix", "refactor.rewrite", "refactor.extract" },
--     resolveProvider = false
--   },
--   code_lens = false,
--   code_lens_resolve = false,
--   completion = true,
--   declaration = false,
--   document_formatting = false,
--   document_highlight = true,
--   document_range_formatting = false,
--   document_symbol = true,
--   execute_command = true,
--   find_references = true,
--   goto_definition = true,
--   hover = true,
--   implementation = false,
--   rename = true,
--   signature_help = true,
--   signature_help_trigger_characters = { "(", "," },
--   text_document_did_change = 2,
--   text_document_open_close = true,
--   text_document_save = false,
--   text_document_save_include_text = false,
--   text_document_will_save = false,
--   text_document_will_save_wait_until = false,
--   type_definition = true,
--   workspace_folder_properties = {
--     changeNotifications = false,
--     supported = false
--   },
--   workspace_symbol = true
--
--
-- vim.dbg(client.server_capabilities)
-- {
-- codeActionProvider = {
--   codeActionKinds = { "", "quickfix", "refactor.rewrite", "refactor.extract" },
--   resolveProvider = false
-- },
-- completionProvider = {
--   resolveProvider = true,
--   triggerCharacters = { "\t", "\n", ".", ":", "(", "'", '"', "[", ",", "#", "*", "@", "|", "=", "-", "{", "/", "\\", " ", "+", "?" }
-- },
-- definitionProvider = true,
-- documentHighlightProvider = true,
-- documentOnTypeFormattingProvider = {
--   firstTriggerCharacter = "\n"
-- },
-- documentSymbolProvider = true,
-- executeCommandProvider = {
--   commands = { "lua.removeSpace:3139066", "lua.solve:3139066", "lua.jsonToLua:3139066", "lua.setConfig:3139066", "lua.autoRequire:3139066" }
-- },
-- foldingRangeProvider = true,
-- hoverProvider = true,
-- offsetEncoding = "utf-16",
-- referencesProvider = true,
-- renameProvider = {
--   prepareProvider = true
-- },
-- signatureHelpProvider = {
--   triggerCharacters = { "(", "," }
-- },
-- textDocumentSync = {
--   change = 2,
--   openClose = true
-- },
-- typeDefinitionProvider = true,
-- workspaceSymbolProvider = true

--
-- vim.dbg(client.config)
-- {
-- autostart = true,
-- capabilities = {
--   callHierarchy = {
--     dynamicRegistration = false
--   },
--   textDocument = {
--     codeAction = {
--       codeActionLiteralSupport = {
--         codeActionKind = {
--           valueSet = { "", "Empty", "QuickFix", "Refactor", "RefactorExtract", "RefactorInline", "RefactorRewrite", "Source", "SourceOrganizeImports", "quickfix", "refactor", "refactor.extract", "refactor.inline", "refactor.rewrite", "source", "source.organizeImports" }
--         }
--       },
--       dataSupport = true,
--       dynamicRegistration = false,
--       resolveSupport = {
--         properties = { "edit" }
--       }
--     },
--     completion = {
--       completionItem = {
--         commitCharactersSupport = false,
--         deprecatedSupport = false,
--         documentationFormat = { "markdown", "plaintext" },
--         preselectSupport = false,
--         snippetSupport = false
--       },
--       completionItemKind = {
--         valueSet = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25 }
--       },
--       contextSupport = false,
--       dynamicRegistration = false
--     },
--     declaration = {
--       linkSupport = true
--     },
--     definition = {
--       linkSupport = true
--     },
--     documentHighlight = {
--       dynamicRegistration = false
--     },
--     documentSymbol = {
--       dynamicRegistration = false,
--       hierarchicalDocumentSymbolSupport = true,
--       symbolKind = {
--         valueSet = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26 }
--       }
--     },
--     hover = {
--       contentFormat = { "markdown", "plaintext" },
--       dynamicRegistration = false
--     },
--     implementation = {
--       linkSupport = true
--     },
--     publishDiagnostics = {
--       relatedInformation = true,
--       tagSupport = {
--         valueSet = { 1, 2 }
--       }
--     },
--     references = {
--       dynamicRegistration = false
--     },
--     rename = {
--       dynamicRegistration = false,
--       prepareSupport = true
--     },
--     signatureHelp = {
--       dynamicRegistration = false,
--       signatureInformation = {
--         activeParameterSupport = true,
--         documentationFormat = { "markdown", "plaintext" },
--         parameterInformation = {
--           labelOffsetSupport = true
--         }
--       }
--     },
--     synchronization = {
--       didSave = true,
--       dynamicRegistration = false,
--       willSave = false,
--       willSaveWaitUntil = false
--     },
--     typeDefinition = {
--       linkSupport = true
--     }
--   },
--   window = {
--     showDocument = {
--       support = false
--     },
--     showMessage = {
--       messageActionItem = {
--         additionalPropertiesSupport = false
--       }
--     },
--     workDoneProgress = true
--   },
--   workspace = {
--     applyEdit = true,
--     configuration = true,
--     symbol = {
--       dynamicRegistration = false,
--       hierarchicalWorkspaceSymbolSupport = true,
--       symbolKind = {
--         valueSet = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26 }
--       }
--     },
--     workspaceEdit = {
--       resourceOperations = { "rename", "create", "delete" }
--     },
--     workspaceFolders = true
--   }
-- },
-- cmd_cwd = "/home/nicholas/.config/nvim-profiles/nick/lua/stats",
-- filetypes = { "lua" },
-- flags = {},
-- get_language_id = <function 1>,
-- handlers = {},
-- init_options = vim.empty_dict(),
-- log_level = 2,
-- message_level = 2,
-- name = "sumneko_lua",
-- on_attach = <function 2>,
-- on_exit = <function 3>,
-- on_init = <function 4>,
-- settings = {
--   Lua = {
--     telemetry = {
--       enable = false
--     }
--   }
-- },
-- single_file_support = true,
-- <metatable> = <1>{
--   __tostring = <function 5>
-- }
