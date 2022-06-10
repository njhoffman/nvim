-- require("lsp.config")

-- h["$/progress"]                      = with(vim.lsp.handlers['$/progress'], lspnotify.progress_handler)
-- h["window/showMessage"]              = with(vim.lsp.handlers["window/showMessage"], lspnotify.message_handler)
-- h["textDocument/hover"]              = with(vim.lsp.handlers["textDocument/hover"], handlers.hover)
-- h["textDocument/signatureHelp"]      = with(vim.lsp.handlers["textDocument/signatureHelp"], { border = "rounded" })
-- h["textDocument/publishDiagnostics"] = with(vim.lsp.diagnostic.on_publish_diagnostics, diagnostic_config)

local lspinstall = require("nvim-lsp-installer")
require("lsp.config").setup()
require("lsp.server").init()

local cmp = require("cmp")
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))

-- local status_ok_fidget, fidget = pcall(require, "fidget")
-- if not status_ok_fidget then return end
-- fidget.setup({
--   fmt = { stack_upwards = false }
-- })

-- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
-- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
lspinstall.post_install_hook = function()
  require("lsp.server").init()
  vim.cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
end
