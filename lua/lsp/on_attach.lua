local handlers = require('lsp.handlers')
local M = {}
local opts = { noremap = true, silent = true }

M.make_config = function()
  local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = { "documentation", "detail", "additionalTextEdits" }
  }
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.colorProvider = { dynamicRegistration = false }
  return {
    -- enable snippet support
    capabilities = capabilities,
    -- map buffer local keybindings when the language server attaches
    on_attach = on_attach,
  }
end

M.on_attach = function(client, bufnr)
  local function keymap(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end

  local function option(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
  end

  -- if client.name == "gopls" then
  --   vim.diagnostic.disable(vim.api.nvim_get_current_buf(), nil)
  -- end
  handlers.attach_formatting(client, bufnr)
  -- handlers.attach_document_colors(client, bufnr)

  if client.server_capabilities.code_lens then
    vim.cmd [[
      augroup lsp_codelens
      autocmd! * <buffer>
      autocmd CursorHold,CursorHoldI,InsertLeave <buffer> lua require"lsp-codelens".buf_codelens_refresh()
      augroup END
      ]]
  end

  -- if client.server_capabilities.colorProvider then
  --   require "lsp-documentcolors".buf_attach(bufnr, { single_column = true })
  -- end

  if client.name == "tailwindcss" then
    if client.server_capabilities.colorProvider then
      require("lsp.servers.tailwind-colorizer").buf_attach(bufnr)
    end
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    capabilities.textDocument.colorProvider = { dynamicRegistration = false }
  end

  option("omnifunc", "v:lua.vim.lsp.omnifunc")
  keymap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev({ enable_popup = false })<CR>", opts)
  keymap("n", "]d", "<cmd>lua vim.diagnostic.goto_next({ enable_popup = false })<CR>", opts)
  keymap("n", "[g", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
  keymap("n", "]g", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
  keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  keymap("n", "<leader>gi", "<cmd>Telescope lsp_implementations<CR>", opts)
  keymap("n", "K", ":lua require('lsp.halders').show_documentation()<cr>", opts)
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


return M
