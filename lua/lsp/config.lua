local utils = require "utils"
local config = require("settings")

local diagnostic_config = {
  virtual_text = {
    source = false, -- "if_many", "always", false
    prefix = "",
    spacing = 2,
    severity = 0. -- ERROR, WARN, INFO, HINT
    -- severity = { min = vim.diagnostic.severity.WARN }
    -- vim.diagnostic.get(0, { severity = {min=vim.diagnostic.severity.WARN} })
  },
  float = {
    header = false,
    source = "never"
  },
  signs = true,
  underline = false, -- { severity = ... }
  update_in_insert = false,
  severity_sort = true
}

vim.diagnostic.config(diagnostic_config)
vim.lsp.handlers["textDocument/publishDiagnostics"] =
  vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, diagnostic_config)

local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, lsp_opts, ...)
  lsp_opts = lsp_opts or {}
  -- lsp_opts.border = lsp_opts.border or {{" ", "FloatBorder"}}
  lsp_opts.border = lsp_opts.border or "rounded"
  lsp_opts.source = lsp_opts.source or "never"
  lsp_opts.pad_top = lsp_opts.pad_top or 0
  lsp_opts.pad_top = lsp_opts.pad_bottom or 0
  return orig_util_open_floating_preview(contents, syntax, lsp_opts, ...)
end

-- Gutter sign icons
for type, icon in pairs(utils.signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, {text = icon, texthl = hl, numhl = ""})
end

local lsplog = require("vim.lsp.log")
lsplog.set_level(config.Logging.lsp_level)

--see: https://microsoft.github.io/language-server-protocol/specifications/specification-current/#textDocument_hover
local hover_handler = require("lsp.hover").hover_handler
vim.lsp.handlers["textDocument/hover"] = hover_handler

local lspnotify = require("lsp.notify")
vim.lsp.handlers["window/showMessage"] = lspnotify.message_handler
-- vim.lsp.handlers["$/progress"] = lspnotify.progress_handler

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
lsplog.set_format_func(vim.inspect)
