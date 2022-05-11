local M = {}

-- cmd = {"typescript-language-server", "--stdio"},
-- single_file_support = true,
-- flags = {debounce_text_changes = 500},
-- filetypes = {"javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx"},
-- init_options = {
--   hostInfo = "neovim"
-- },
-- root_dir = util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git")

M.setup = function(on_attach, capabilities)
  local lspconfig = require "lspconfig"
  lspconfig.tsserver.setup {
    server = {
      on_attach = function(client, bufnr)
        client.server_capabilities.document_formatting = false
        client.server_capabilities.document_range_formatting = false
        local opts = {noremap = true, silent = true, nowait = true}
        vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>tr", "<cmd>TypescriptRemoveUnused<CR>", opts)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>to", ":TypescriptOrganizeImports<CR>", opts)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>ta", ":TypescriptAddMissingImports<CR>", opts)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>tx", ":TypescriptFixAll<CR>", opts)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>tr", ":TypescriptRenameFile<CR>", opts)

        on_attach(client, bufnr)
      end,
      capabilities = capabilities
    }
  }
end

return M
