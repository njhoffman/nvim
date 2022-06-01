require("lsp.config")
local attach_formatting = require("lsp.format")

local servers = {
  "awk_ls",
  "bashls",
  "clangd",
  "cssls",
  "dockerls",
  "efm",
  "golangci_lint_ls",
  "gopls",
  "graphql",
  "html",
  "jsonls",
  "pylsp",
  "sqls",
  "sumneko_lua",
  "terraformls",
  "tsserver",
  "vimls",
  "yamlls"
  -- "null-ls",
}

local lsp_installer = require("nvim-lsp-installer")
for _, name in ipairs(servers) do
  local server_is_found, server = lsp_installer.get_server(name)
  if server_is_found and not server:is_installed() then
    vim.notify("Installing " .. name, "info")
    server:install()
  end
end

local cmp = require("cmp")
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))

local capabilities =
require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = { "documentation", "detail", "additionalTextEdits" }
}

local opts = { noremap = true, silent = true, nowait = true }
local on_attach = function(client, bufnr)
  local function keymap(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end

  local function option(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
  end

  attach_formatting(bufnr, client)
  require("lsp_signature").on_attach(
    {
      bind = true,
      handler_opts = {
        border = "rounded"
      }
    },
    bufnr
  )
  option("omnifunc", "v:lua.vim.lsp.omnifunc")

  keymap("i", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
  keymap("n", "gy", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)

  -- diagnostics
  keymap("n", "<leader>gi", "<cmd>Telescope lsp_implementations<CR>", opts)
  keymap("n", "<leader>d", "<cmd>Telescope lsp_workspace_diagnostics<CR>", opts)
  keymap("n", "<leader>c", "<cmd>lua vim.diagnostic.show_line_diagnostics()<CR>", opts)
  keymap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev({ enable_popup = false })<CR>", opts)
  keymap("n", "]d", "<cmd>lua vim.diagnostic.goto_next({ enable_popup = false })<CR>", opts)
  keymap("n", "[g", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
  keymap("n", "]g", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
  keymap("n", "<leader>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)

  -- actions
  keymap("n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
  keymap("n", "<leader>q", "<cmd>Telescope lsp_code_actions<CR>", opts)
  keymap("n", "<leader>a", "<cmd>Telescope lsp_code_actions<CR>", opts)
  keymap("n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
  keymap("n", "<leader>k", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
  keymap("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  keymap("n", "<space>lc", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
  keymap("n", "ca", "<cmd>CodeActionMenu<cr>", opts)
  keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
  keymap("n", "<space>lf", "<cmd>lua vim.lsp.buf.format()<CR>", opts)
  keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
  keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
  keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  keymap("n", "<leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
  keymap("n", "<leader>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
  keymap(
    "n",
    "<leader>wl",
    "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
    opts
  )
  keymap("n", "<leader>a", "<cmd>Telescope lsp_code_actions<CR>", opts)
  keymap("n", "K", ":lua show_documentation()<cr>", opts)
  keymap("n", "gh", ":lua show_help()<cr>", opts)
end

function show_documentation()
  local filetype = vim.bo.filetype
  if vim.tbl_contains({ "vim", "help" }, filetype) then
    vim.cmd("h " .. vim.fn.expand("<cword>"))
  elseif vim.tbl_contains({ "man" }, filetype) then
    vim.cmd("Man " .. vim.fn.expand("<cword>"))
  else
    vim.lsp.buf.hover({ border = "single" })
  end
end

function show_help()
  vim.cmd("h " .. vim.fn.expand("<cword>"))
end

for _, server in ipairs(servers) do
  require("lsp.servers." .. server).setup(on_attach, capabilities)
end

--    FormattingOptions
--   tabSize: uinteger; * Size of a tab in spaces.
--   insertSpaces: boolean; * Prefer spaces over tabs.
--   trimTrailingWhitespace?: boolean; * Trim trailing whitespace on a line.
--   insertFinalNewline?: boolean; * Insert a newline character at the end of the file if one does not exist.
--   trimFinalNewlines?: boolean; * Trim all newlines after the final newline at the end of the file.
--   [key: string]: boolean | integer | string; * Signature for further properties.
