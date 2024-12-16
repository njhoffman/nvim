local lsp_icons = require("lsp.icons")
local capabilities = require("lsp.capabilities")
local format = require("lsp.format")
local original_paste = vim.paste

_G.jump = function()
  MiniAnimate.config.scroll.enable = false
  MiniJump2d.start()
  -- Need `vim.schedule()` here to still have it disabled at animation's start
  vim.schedule(function()
    MiniAnimate.config.scroll.enable = true
  end)
end

_G.diagnostic_goto = function(direction)
  -- vim.diagnostic["goto_" .. direction]()
  vim.diagnostic.jump({ count = (direction == "prev" and -1 or 1) })
  MiniAnimate.execute_after("scroll", function()
    vim.schedule(function()
      vim.defer_fn(vim.diagnostic.open_float, 100)
    end)
  end)
end

-- local cache_enable_scroll = MiniAnimate.config.scroll.enable

-- 'MiniAnimate.execute_after("scroll", "normal! zvzz")<CR>'
-- vim.paste = function(lines, phase)
--   if phase == 1 then
--     cache_enable_scroll = MiniAnimate.config.scroll.enable
--     MiniAnimate.config.scroll.enable = false
--   end

--   pcall(original_paste, lines, phase)

--   if phase == 3 then
--     MiniAnimate.config.scroll.enable = cache_enable_scroll
--   end
-- end
-- local diagnostic_goto = function(next, severity)
--   local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
--   severity = severity and vim.diagnostic.severity[severity] or nil
--   return function()
--     go({ severity = severity })
--   end
-- end
-- map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
-- map("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
-- map("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
-- map("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
-- map("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
-- map("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
-- map("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

local setup_mappings = function(client, bufnr)
  vim.api.nvim_set_keymap(
    "n",
    "<C-t>",
    "<cmd>lua require('telescope.run')('builtin', 'diagnostics', { bufnr = true })<cr>",
    { silent = true, desc = "show buffer diagnostics" }
  )

  vim.api.nvim_set_keymap(
    "n",
    "<M-T>",
    "<cmd>lua require('telescope.run')('builtin', 'diagnostics')<cr>",
    { silent = true, desc = "show workspace  diagnostics" }
  )

  -- vim.api.nvim_set_keymap('n', '<M-C-T>', '', {
  --   silent = true,
  --   desc = 'show full workspace  diagnostics',
  --   callback = function()
  --     require('workspace-diagnostics').populate_workspace_diagnostics(client, bufnr)
  --     require('telescope.run')('builtin', 'diagnostics')
  --   end,
  -- })

  vim.api.nvim_set_keymap(
    "n",
    "<Leader>e",
    "<cmd>lua vim.diagnostic.open_float()<CR>",
    { silent = true, desc = "open diagnostic float" }
  )
  vim.api.nvim_set_keymap(
    "n",
    "[d",
    '<cmd>lua _G.diagnostic_goto("prev")<cr>',
    { silent = true, desc = "prev diagnostic problem" }
  )
  vim.api.nvim_set_keymap(
    "n",
    "]d",
    '<cmd>lua _G.diagnostic_goto("next")<cr>',
    { silent = true, desc = "next diagnostic problem" }
  )
  vim.api.nvim_set_keymap(
    "n",
    "[e",
    "<cmd>lua vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })<CR>",
    { silent = true, desc = "jump to prev error" }
  )
  vim.api.nvim_set_keymap(
    "n",
    "]e",
    "<cmd>lua vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })<CR>",
    { silent = true, desc = "jump to next error" }
  )
  vim.api.nvim_set_keymap(
    "n",
    "gQd",
    "<cmd>lua vim.diagnostic.setqflist({ open = true  })<CR>",
    { silent = true, desc = "diagnostics to quickfix" }
  )

  -- if the file is .sql
  if vim.bo.filetype == "sql" then
    vim.keymap.set("n", "<leader>", ":!sqlfluff fix -fq --dialect=postgres %<cr>")
  end
end

local icons = lsp_icons.get_icons("diagnostics")
vim.fn.sign_define(
  "DiagnosticSignError",
  { text = icons.error, texthl = "LspDiagnosticsSignError" }
)
vim.fn.sign_define("DiagnosticSignWarn", { text = icons.warn, texthl = "LspDiagnosticsSignWarn" })
vim.fn.sign_define("DiagnosticSignInfo", { text = icons.info, texthl = "LspDiagnosticsSignInfo" }) -- 󰌵
vim.fn.sign_define("DiagnosticSignHint", { text = icons.hint, texthl = "LspDiagnosticsSignHint" })

-- format.setup()

-- exclude is a table of LSP servers that should not format the buffer.
-- Alternatively, you can also just not call on_attach for the clients you don't want to use for formatting.
-- order is a table that determines the order formatting is requested from the LSP server.
-- sync turns on synchronous formatting. The editor will block until the formatting is done.
-- force will write the format result to the buffer, even if the buffer changed after the format request started.
-- vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded', max_width = 80 })
-- vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'rounded' })
local on_attach = function(client, bufnr)
  local ok, disable_lsp = pcall(vim.api.nvim_buf_get_var, 0, "disable_lsp")
  if disable_lsp == 1 then
    return vim.notify("Skipping buffer lsp", 1)
  end

  --       vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'
  -- vim.lsp.omnifunc = nil
  -- vim.api.nvim_set_option_value('omnifunc', nil, {})
  -- vim.api.nvim_set_option_value('omnifunc', nil, { buf = bufnr })
  -- format.on_attach(client, bufnr)
  setup_mappings(client, bufnr)

  -- client.config.flags.debounce_text_changes = 300
  -- client.config.flags.allow_incremental_sync = true

  if client.name == "lua_ls" then
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  elseif client.name == "pyright" then
    client.server_capabilities.hoverProvider = false
  elseif client.name == "pylsp" then
    client.server_capabilities.documentSymbolProvider = false
    client.server_capabilities.renameProvider = false
    client.server_capabilities.signatureHelpProvider = false
  elseif client.name == "cssls" then
    client.server_capabilities.textDocument.completion.completionItem.snippetSupport = true
  end

  -- if client.server_capabilities.inlayHintProvider then
  --   -- vim.dbglog('INLAY HINTS AVAILABLE')
  --   vim.lsp.inlay_hint.enable(bufnr, true)
  -- end
  -- TODO: fix vimls documentSymbolProvider sorting
  if client.server_capabilities.documentSymbolProvider and client.name ~= "vimls" then
    vim.api.nvim_set_var("navic_silence", true)
    require("nvim-navic").attach(client, bufnr)
  end

  capabilities.resolve(client, bufnr)
end

return on_attach
