local M = {}
M.setup = function(on_attach, capabilities)
  local lspconfig = require "lspconfig"
  local path = vim.fn.stdpath('data')

  lspconfig.jsonls.setup {
    on_attach = on_attach,
    cmd = { path .. "/lsp_servers/json/node_modules/.bin/vscode-json-language-server", "--stdio" },
    -- filetypes = {"json"},
    -- root_dir = lspconfig.util.find_git_ancestor,
    flags = {
      debounce_text_changes = 150,
    },
    init_options = { provideFormatter = true },
    single_file_support = true,
    capabilities = capabilities,
    -- settings = {
    --   json = {
    --     schemas = {
    --       {fileMatch = {"package.json"}, url = "https://json.schemastore.org/package.json"},
    --       {fileMatch = {"tsconfig*.json"}, url = "https://json.schemastore.org/tsconfig.json"},
    --       {
    --         fileMatch = {".prettierrc", ".prettierrc.json", "prettier.config.json"},
    --         url = "https://json.schemastore.org/prettierrc.json"
    --       },
    --       {fileMatch = {".eslintrc", ".eslintrc.json"}, url = "https://json.schemastore.org/eslintrc.json"},
    --       {
    --         fileMatch = {".babelrc", ".babelrc.json", "babel.config.json"},
    --         url = "https://json.schemastore.org/babelrc.json"
    --       },
    --       {fileMatch = {"lerna.json"}, url = "https://json.schemastore.org/lerna.json"},
    --       {fileMatch = {"now.json", "vercel.json"}, url = "https://json.schemastore.org/now.json"},
    --       {
    --         fileMatch = {".stylelintrc", ".stylelintrc.json", "stylelint.config.json"},
    --         url = "http://json.schemastore.org/stylelintrc.json"
    --       }
    --     }
    --   }
    -- }

  }
end


return M
