local M = {}

M.setup = function(on_attach, capabilities)
  local lspconfig = require "lspconfig"
  local path = vim.fn.stdpath("data")
  lspconfig.tsserver.setup {
    on_attach = function(client, bufnr)
      -- local opts = { noremap = true, silent = true, nowait = true }
      -- needs null-ls
      -- vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>tr", "<cmd>TypescriptRemoveUnused<CR>", opts)
      -- vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>to", ":TypescriptOrganizeImports<CR>", opts)
      -- vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>ta", ":TypescriptAddMissingImports<CR>", opts)
      -- vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>tx", ":TypescriptFixAll<CR>", opts)
      -- vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>tr", ":TypescriptRenameFile<CR>", opts)
      client.resolved_capabilities.document_formatting = false
      client.resolved_capabilities.range_formatting = false
      on_attach(client, bufnr)
    end,
    single_file_support = true,
    root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git"),
    filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
    flags = {
      debounce_text_changes = 150
    },
    cmd = { path .. "/lsp_servers/tsserver/node_modules/.bin/typescript-language-server", "--stdio" },
    capabilities = capabilities
  }
end

return M
