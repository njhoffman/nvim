local M = {}

M.setup = function(on_attach, capabilities)
  local lspconfig = require "lspconfig"
  local path = vim.fn.stdpath('data')

  lspconfig.pylsp.setup {
    on_attach = on_attach,
    cmd = { path .. "/lsp_servers/pylsp/venv/bin/pylsp" },
    flags = {
      debounce_text_changes = 150,
    },
    capabilities = capabilities,
    -- root_dir = function(fname)
    --   local root_files = {"pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile"}
    --   return lspconfig.util.root_pattern(unpack(root_files))(fname) or util.find_git_ancestor(fname)
    -- end,
    -- single_file_support = true,
    -- settings = {
    --   pylsp = {
    --     plugins = {
    --       pylint = {enabled = true, executable = "pylint"},
    --       pyflakes = {enabled = false},
    --       pycodestyle = {enabled = false},
    --       jedi_completion = {fuzzy = true},
    --       pyls_isort = {enabled = true},
    --       pylsp_mypy = {enabled = true}
    --     }
    --   }
    -- }
  }
end

return M
