local lspconfig = require "lspconfig"
local lsp_cmds = require("lsp.commands")
local on_attach_hook = require("lsp.on_attach_hook")
local logger = require("logger").initLogger("vimls")

local lsp_status = require("lsp-status")
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities = vim.tbl_extend("keep", capabilities or {}, lsp_status.capabilities)
logger:info('Extend vimls')

-- function to attach completion when setting up lsp
local on_attach = function(client, bufnr)
  logger:info('Attaching vimls' .. bufnr)

  on_attach_hook.common_on_attach(client, bufnr)
end

lspconfig.vimls.setup {
  cmd = lsp_cmds.vim,
  on_attach = on_attach,
  filetypes = { "vim" },
  init_options = {
    diagnostic = { enable = true },
    indexes = {
      count = 3,
      gap = 100,
      projectRootPatterns = { "runtime", "nvim", ".git", "autoload", "plugin" },
      runtimepath = true,
    },
    iskeyword = "@,48-57,_,192-255,-#",
    runtimepath = "",
    suggest = { fromRuntimepath = true, fromVimruntime = true },
    vimruntime = "",
  },
  root_dir = function(fname)
    return lspconfig.util.find_git_ancestor(fname) or vim.fn.getcwd()
  end,
  -- root_dir = function(fname) return lspconfig.util.find_git_ancestor(fname) or vim.fn.getcwd() end,

}
