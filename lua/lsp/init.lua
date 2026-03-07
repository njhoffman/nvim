-- LSP Configuration Entry Point
-- Orchestrates loading of all LSP-related modules

local log = require("logger").init("lsp")

log:debug("Loading LSP configuration")

-- Load modules in order
local ok, err

-- 1. Capabilities setup (needed before server registration)
ok, err = pcall(require, "lsp.capabilities")
if not ok then
  log:error("Failed to load lsp.capabilities: " .. tostring(err))
end

-- 2. Diagnostic configuration
ok, err = pcall(require, "lsp.diagnostics")
if not ok then
  log:error("Failed to load lsp.diagnostics: " .. tostring(err))
end

-- 3. UI components (float windows, etc.)
ok, err = pcall(require, "lsp.ui.float")
if not ok then
  log:error("Failed to load lsp.ui.float: " .. tostring(err))
end

-- 4. Server setup (mason + vim.lsp.config + vim.lsp.enable)
ok, err = pcall(require, "lsp.servers")
if not ok then
  log:error("Failed to load lsp.servers: " .. tostring(err))
end

-- 5. LSP lines (virtual diagnostics)
ok, err = pcall(require, "lsp.lsp_lines")
if not ok then
  log:warn("Failed to load lsp.lsp_lines: " .. tostring(err))
end

-- 6. Definition/references handler
ok, err = pcall(require, "configs.definition-or-references")
if not ok then
  log:warn("Failed to load definition-or-references: " .. tostring(err))
end

-- LspAttach autocmd - handles per-buffer setup when LSP attaches
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    if not client then
      log:warn("LspAttach: No client found for id " .. tostring(args.data.client_id))
      return
    end

    log:debug("LspAttach: " .. client.name .. " attached to buffer " .. bufnr)

    -- Clear omnifunc and completefunc (handled by completion plugins)
    vim.api.nvim_set_option_value("omnifunc", "", { buf = bufnr })
    vim.api.nvim_set_option_value("completefunc", "", { buf = bufnr })

    -- Check if LSP is disabled for this buffer
    local disable_ok, disable_lsp = pcall(vim.api.nvim_buf_get_var, bufnr, "disable_lsp")
    if disable_ok and disable_lsp == 1 then
      log:info("LSP disabled for buffer " .. bufnr)
      return
    end

    -- Setup keymappings
    local keymaps_ok, keymaps = pcall(require, "lsp.keymaps")
    if keymaps_ok and keymaps.setup then
      keymaps.setup(client, bufnr)
    end

    -- Per-server capability adjustments
    if client.name == "lua_ls" then
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
      client.server_capabilities.colorProvider = false
    elseif client.name == "ts_ls" then
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    elseif client.name == "bashls" then
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    elseif client.name == "pyright" then
      client.server_capabilities.hoverProvider = false
    elseif client.name == "pylsp" then
      client.server_capabilities.documentSymbolProvider = false
      client.server_capabilities.renameProvider = false
      client.server_capabilities.signatureHelpProvider = false
    elseif client.name == "cssls" then
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    end

    -- Enable inlay hints if supported
    if client.server_capabilities.inlayHintProvider then
      -- local inlay_ok, _ = pcall(vim.lsp.inlay_hint.enable, true, { bufnr = bufnr })
      -- if not inlay_ok then
      --   log:debug("Inlay hints not available for " .. client.name)
      -- end
    end

    -- Resolve capabilities (setup capability-specific features)
    local caps_ok, caps = pcall(require, "lsp.capabilities")
    if caps_ok and caps.resolve then
      caps.resolve(client, bufnr)
    end
  end,
})

log:info("LSP configuration loaded")

return {
  -- Expose modules for external access if needed
  capabilities = require("lsp.capabilities"),
}
