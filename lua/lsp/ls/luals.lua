local lspconfig = require("lspconfig")
local lsp_cmds = require("lsp.commands")
local on_attach_hook = require("lsp.on_attach_hook")
local lsp_status = require("lsp-status")

local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities = vim.tbl_extend("keep", capabilities or {}, lsp_status.capabilities)

-- client.resolved_capabilities.document_formatting = true
local on_attach = function(client, bufnr)
  if string.find(vim.api.nvim_buf_get_name(0), "lush.lua$") then vim.notify("skipping lua lsp") end
  on_attach_hook.common_on_attach(client, bufnr)
end

local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "?.lua")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")


local luadev = require("lua-dev").setup({
  -- add any options here, or leave empty to use the default settings
  library = {
    vimruntime = true, -- runtime path
    types = true, -- full signature, docs and completion of vim.api, vim.treesitter, vim.lsp and others
    plugins = true, -- installed opt or start plugins in packpath
    -- you can also specify the list of plugins to make available as a workspace library
    -- plugins = { "nvim-treesitter", "plenary.nvim", "telescope.nvim" },
  },
  lspconfig = {
    -- cmd = {"lua-language-server"}
    cmd = lsp_cmds.lua,
    on_attach = on_attach,
    capabilities = capabilities,
    root_dir = lspconfig.util.root_pattern(".git") or bufdir,
    settings = {
      Lua = {
        telemetry = {
          enable = false
        }
      }
    },
    single_file_support = true,
    log_level = 4,
  },
})

lspconfig.sumneko_lua.setup(luadev)
