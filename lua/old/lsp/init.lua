
local lspconfig = require("lspconfig")
vim.import("lsp.config", function(lspconfig)
  lspconfig.setup()
end)

-- luacheck: globals vim

-- local lspconfig_configs = require("lspconfig.configs")
-- local attach = require("plugins.config.lsp-attach")
-- local css_settings = require("plugins.config.lsp.css_settings")

-- For doing diagnostics:
-- vim.lsp.set_log_level("info")

-- lspconfig_configs.lualsp = {
--   default_config = {
--     cmd = { "lua-lsp" },
--     filetypes = { "lua" },
--     root_dir = function(file)
--       return lspconfig.util.find_git_ancestor(file) or vim.fn.getcwd()
--     end,
--   },
-- }

attach.keybindings_defaults()
