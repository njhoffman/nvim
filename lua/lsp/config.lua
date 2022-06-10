local config = require("settings")
local handlers = require("lsp.handlers")

require("vim.lsp.protocol").CompletionItemKind = {
  "  Text", -- = 1
  "  Function", -- = 2;
  "  Method", -- = 3;
  "  Constructor", -- = 4;
  "  Field", -- = 5;
  "  Variable", -- = 6;
  "  Class", -- = 7;
  "  Interface", -- = 8;
  "  Module", -- = 9;
  "  Property", -- = 10;
  "  Unit", -- = 11;
  "  Value", -- = 12;
  "  Enum", -- = 13;
  "  Keyword", -- = 14;
  "  Snippet", -- = 15;
  "  Color", -- = 16;
  "  File", -- = 17;
  "  Reference", -- = 18;
  "  Folder", -- = 19;
  "  EnumMember", -- = 20;
  "  Constant", -- = 21;
  "  Struct", -- = 22;
  "  Event", -- = 23;
  "  Operator", -- = 24;
  "  TypeParameter", -- = 25;
}

local diagnostic_config = {
  virtual_text = {
    source = false, -- "if_many", "always", false
    prefix = "",
    spacing = 2,
    -- severity = 0. -- ERROR, WARN, INFO, HINT
    -- severity = { min = vim.diagnostic.severity.WARN }
    -- vim.diagnostic.get(0, { severity = {min=vim.diagnostic.severity.WARN} })
  },
  float = {
    focusable = false,
    style = "minimal",
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
  signs = true,
  underline = false, -- { severity = ... }
  update_in_insert = false,
  severity_sort = true
}

local M = {}

M.getsigns = function()
  -- local icons = require("nvim-nonicons")
  vim.fn.sign_define("DiagnosticSignError",
    {
      text   = '', -- icons.get("x-circle"),
      texthl = "LspDiagnosticsSignError",
    })

  vim.fn.sign_define("DiagnosticSignWarn",
    {
      text   = '', -- icons.get("alert"),
      texthl = "LspDiagnosticsSignWarn",
    })

  vim.fn.sign_define("DiagnosticSignInfo",
    {
      text   = '', -- icons.get("info"),
      texthl = "LspDiagnosticsSignInfo",
    })

  vim.fn.sign_define("DiagnosticSignHint",
    {
      text   = '', -- icons.get("comment"),
      texthl = "LspDiagnosticsSignHint",
    })
  -- Gutter sign icons
  -- for _, sign in ipairs(signs) do
  --   vim.lsp.diagnostic.config.signs_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
  -- end
end

M.setup = function()
  -- Setup logging and initial settings
  local lsplog = require("vim.lsp.log")
  lsplog.set_level(config.Logging.lsp_level)
  -- local lspnotify = require("lsp.notify")
  M.getsigns()

  -- global one time lsp capabilities
  -- require("lsp-codelens").setup()

  vim.diagnostic.config(diagnostic_config)
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = 'rounded',
    max_width = 80
  })

  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = 'rounded'
  })
end

return M


-- local function len(t)
--   local count = 0
--   for _ in pairs(t) do
--     count = count + 1
--   end
--   return count
-- end
-- lsplog.set_format_func(
--   function(messages)
--     local inspected = vim.inspect(messages)
--     local formatted = ""
--     if type(messages) == "table" then
--       formatted = formatted .. "Length: " .. len(messages) .. "\n"
--     end
--     for line in string.gmatch(inspected, "[^\n\r]+") do
--       formatted = formatted .. "\n  " .. line
--     end
--     return formatted
--   end
-- )

--    FormattingOptions
--   tabSize: uinteger; * Size of a tab in spaces.
--   insertSpaces: boolean; * Prefer spaces over tabs.
--   trimTrailingWhitespace?: boolean; * Trim trailing whitespace on a line.
--   insertFinalNewline?: boolean; * Insert a newline character at the end of the file if one does not exist.
--   trimFinalNewlines?: boolean; * Trim all newlines after the final newline at the end of the file.
--   [key: string]: boolean | integer | string; * Signature for further properties.


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
-- textDocument/typeDefinition*
-- window/logMessage
-- window/showMessage
-- window/showMessageRequest
-- workspace/applyEdit
-- workspace/symbol
