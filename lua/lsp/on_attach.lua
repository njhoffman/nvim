local handlers = require('lsp.handlers')
local M = {}
local opts = { noremap = true, silent = true }

M.on_attach = function(client, bufnr)
  local function keymap(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end

  local function option(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
  end

  handlers.attach_formatting(client, bufnr)
  handlers.attach_code_lens(client, bufnr)
  require "lsp_signature".on_attach(require('lsp.signature'), bufnr)

  -- vim.api.nvim_buf_set_option(bufnr, "formatexpr", "v:lua.vim.lsp.formatexpr()")
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
  vim.api.nvim_buf_set_option(bufnr, "tagfunc", "v:lua.vim.lsp.tagfunc")

  if client.name == "tailwindcss" then
    if client.server_capabilities.colorProvider then
      require("lsp.servers.tailwind-colorizer").buf_attach(bufnr)
    end
    client.server_capabilities.textDocument.completion.completionItem.snippetSupport = true
    client.server_capabilities.textDocument.colorProvider = { dynamicRegistration = false }
  end


  -- keymap("n", "<C-]>", "gd tags or definitions or help or man, opts)
  -- keymap("n", "<C-S-]>", "cyle references, diagnostics, gotofiles", opts)
  keymap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev({ enable_popup = false })<CR>", opts)
  keymap("n", "]d", "<cmd>lua vim.diagnostic.goto_next({ enable_popup = false })<CR>", opts)
  keymap("n", "[g", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
  keymap("n", "]g", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
  keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  keymap("n", "<leader>gi", "<cmd>Telescope lsp_implementations<CR>", opts)
  keymap("n", "K", ":lua require('lsp.handlers').show_documentation()<cr>", opts)
  keymap("n", "gh", ":lua require('lsp.handlers').show_help()<cr>", opts)
  keymap("n", "<leader><gh>", ":Telescope help_tags<cr>", opts)
  keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
  keymap("n", "gy", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
  keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
  keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
  keymap("n", "<leader>gr", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
  keymap("n", "gR", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)

  -- diagnostics
  keymap("n", "<leader>d", "<cmd>Telescope lsp_workspace_diagnostics<CR>", opts)
  keymap("n", "<leader>c", "<cmd>lua vim.diagnostic.show_line_diagnostics()<CR>", opts)
  keymap("n", "<leader>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
  -- keymap("n", "<leader>q", "<cmd>Telescope lsp_code_actions<CR>", opts)
  keymap("n", "<leader>a", "<cmd>Telescope lsp_code_actions<CR>", opts)
  keymap("n", "<leader>k", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
  keymap("n", "ff", "<cmd>lua vim.lsp.buf.format()<CR>", opts)
  keymap("n", "ca", "<cmd>CodeActionMenu<cr>", opts)

  -- actions
  keymap("n", "<space>lc", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
  keymap("n", "<leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
  keymap("n", "<leader>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
  keymap("n", "<leader>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
end



M.make_capabilities = function()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  local cmp_ok, cmp = pcall(require, "cmp_nvim_lsp")
  if (cmp_ok) then
    cmp.update_capabilities(capabilities)
  else
    vim.notify({ 'Completion error with CMP', cmp }, 'error')
  end
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = { "documentation", "detail", "additionalTextEdits" }
  }
  capabilities.textDocument.colorProvider = { dynamicRegistration = false }
  return capabilities
end

return M
