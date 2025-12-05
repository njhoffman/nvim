local capabilities = require("lsp.capabilities")

_G.jump = function()
  ---@diagnostic disable: undefined-global
  if type(MiniJump2d) == "table" and type(MiniAnimate) == "table" then
    MiniAnimate.config.scroll.enable = false
    MiniJump2d.start()
    -- Need `vim.schedule()` here to still have it disabled at animation's start
    vim.schedule(function()
      MiniAnimate.config.scroll.enable = true
    end)
  end
end

_G.diagnostic_goto = function(direction, severity)
  severity = severity and vim.diagnostic.severity[severity] or nil
  vim.diagnostic.jump({ count = (direction == "prev" and -1 or 1), severity = severity })
  MiniAnimate.execute_after("scroll", function()
    vim.schedule(function()
      vim.defer_fn(vim.diagnostic.open_float, 100)
    end)
  end)
end

-- LspAttach autocmd replaces the old on_attach callback pattern
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    if not client then
      return
    end

    -- Clear omnifunc and completefunc (handled by completion plugins)
    vim.api.nvim_set_option_value("omnifunc", nil, { buf = bufnr })
    vim.api.nvim_set_option_value("completefunc", nil, { buf = bufnr })

    -- Check if LSP is disabled for this buffer
    local ok, disable_lsp = pcall(vim.api.nvim_buf_get_var, bufnr, "disable_lsp")
    if ok and disable_lsp == 1 then
      vim.notify("Skipping buffer lsp", vim.log.levels.INFO)
      return
    end

    -- Setup keymappings
    require("lsp.mapping").setup_mappings(client, bufnr)

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
      vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    end

    -- Resolve capabilities
    capabilities.resolve(client, bufnr)
  end,
})

-- Legacy on_attach function kept for backward compatibility during migration
-- This should not be used anymore - LspAttach autocmd handles everything
local on_attach = function(client, bufnr)
  -- This function is deprecated and will be removed
  -- All logic has been moved to the LspAttach autocmd above
end

return on_attach
