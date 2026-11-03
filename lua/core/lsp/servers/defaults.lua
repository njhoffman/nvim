-- LSP Server Defaults
-- Default configuration applied to all LSP servers

local M = {}

-- Make capabilities with cmp_nvim_lsp enhancements
local function make_capabilities()
  local capabilities =
    require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

  -- UFO folding support
  capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
  }

  -- Snippet support
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = { "documentation", "detail", "additionalTextEdits" },
  }

  return capabilities
end

-- Default config applied to all servers via vim.lsp.config("*", ...)
M.config = {
  capabilities = make_capabilities(),
  flags = {
    allow_incremental_sync = false,
    debounce_text_changes = 500,
  },
}

-- Common root markers used across servers
M.root_markers = {
  ".project",
  "courseleaf.cfg",
  ".git",
  "CLAUDE.md",
}

return M
