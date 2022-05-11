local utils = require "utils"

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

local lsp_installer = require "nvim-lsp-installer"

for _, name in ipairs(servers) do
  local server_is_found, server = lsp_installer.get_server(name)
  if server_is_found and not server:is_installed() then
    vim.notify("Installing " .. name, "info")
    server:install()
  end
end

-- Floating border
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or {{" ", "FloatBorder"}}
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

local lsp_formatting = function(bufnr)
  vim.lsp.buf.formatting_sync {
    bufnr = bufnr --, FormatOptions
  }
end

if type(vim.lsp.buf.format) == "function" then
  lsp_formatting = function(bufnr)
    vim.lsp.buf.format {
      bufnr = bufnr,
      filter = function(clients)
        return vim.tbl_filter(
          function(client)
            if client.name == "efm" then
              return true
            elseif client.name == "eslint" then
              return true
            end
            -- if client.name == "null-ls" then
            --   return not utils.table.some(clients, function(_, other_client)
            --     return other_client.name == "eslint"
            --   end)
            -- end
          end,
          clients
        )
      end
    }
  end
end

local opts = {noremap = true, silent = true, nowait = true}

vim.api.nvim_set_keymap("n", "<space>e", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
vim.api.nvim_set_keymap("n", "<space>lp", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
vim.api.nvim_set_keymap("n", "<space>ln", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
vim.api.nvim_set_keymap("n", "<space>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)

local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
  vim.api.nvim_buf_set_keymap(
    bufnr,
    "n",
    "<space>wl",
    "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
    opts
  )
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>lr", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>lc", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>lf", "<cmd>lua vim.lsp.buf.format()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>lf", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)

  if client.supports_method "textDocument/formatting" then
    utils.buf_command(
      bufnr,
      "LspFormatting",
      function()
        lsp_formatting(bufnr)
      end
    )

    vim.api.nvim_clear_autocmds {group = augroup, buffer = bufnr}
    vim.api.nvim_create_autocmd(
      "BufWritePre",
      {
        group = augroup,
        buffer = bufnr,
        command = "LspFormatting"
      }
    )
  end
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
local had_cmp_nvim_lsp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if had_cmp_nvim_lsp then
  capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)
end

local had_lspconfig = pcall(require, "lspconfig")
if had_lspconfig then
  for _, server in ipairs(servers) do
    require("lsp.servers." .. server).setup(on_attach, capabilities)
  end
end

-- Gutter sign icons
for type, icon in pairs(utils.signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, {text = icon, texthl = hl, numhl = ""})
end

-- Prefix diagnostic virtual text
vim.diagnostic.config {
  virtual_text = {
    source = false, -- "if_many", "always", false
    prefix = "",
    spacing = 2,
    severity = {min = vim.diagnostic.severity.INFO}
    -- vim.diagnostic.get(0, { severity = {min=vim.diagnostic.severity.WARN} })
    -- vim.diagnostic.severity.ERROR, WARN, INFO, HINT
  },
  float = {
    header = false,
    source = "always"
  },
  signs = true,
  underline = false, -- { severity = ... }
  update_in_insert = false,
  severity_sort = true
  -- format =  function(diagnostic)
  --     if diagnostic.severity == vim.diagnostic.severity.ERROR then
  --       return string.format("E: %s", diagnostic.message)
  --     end
  --     return diagnostic.message
  --   end
}

-- require('lspconfig').rust_analyzer.setup {
--   handlers = {
--     ["textDocument/publishDiagnostics"] = vim.lsp.with(
--       vim.lsp.diagnostic.on_publish_diagnostics, {
--         -- Disable virtual_text
--         virtual_text = false
--       }
--     ),
--   }
-- }

-- Handlers can be set by:

-- - Setting a field in vim.lsp.handlers.                      *vim.lsp.handlers*
-- vim.lsp.handlers is a global table that contains the default mapping of
-- |lsp-method| names to |lsp-handlers|.

-- To override the handler for the `"textDocument/definition"` method: >

-- vim.lsp.handlers["textDocument/definition"] = my_custom_default_definition
-- <
-- - The {handlers} parameter for |vim.lsp.start_client|.
-- This will set the |lsp-handler| as the default handler for this server.

-- For example: >

-- vim.lsp.start_client {
-- ..., -- Other configuration omitted.
-- handlers = {
-- ["textDocument/definition"] = my_custom_server_definition
--     },
--   }

-- - The {handler} parameter for |vim.lsp.buf_request()|.
-- This will set the |lsp-handler| ONLY for the current request.

-- For example: >

-- vim.lsp.buf_request(
-- 0,
-- "textDocument/definition",
-- definition_params,
-- my_request_custom_definition

-- callHierarchy/incomingCalls
-- callHierarchy/outgoingCalls
-- textDocument/codeAction
-- textDocument/completion
-- textDocument/declaration*
-- textDocument/definition
-- textDocument/documentHighlight
-- textDocument/documentSymbol
-- textDocument/formatting
-- textDocument/hover
-- textDocument/implementation*
-- textDocument/publishDiagnostics
-- textDocument/rangeFormatting
-- textDocument/references
-- textDocument/rename
-- textDocument/signatureHelp
-- textDocument/typeDefinition*
-- window/logMessage
-- window/showMessage
-- window/showMessageRequest
-- workspace/applyEdit
-- workspace/symbol

--    FormattingOptions
--    * Size of a tab in spaces.
--   tabSize: uinteger;
--    * Prefer spaces over tabs.
--   insertSpaces: boolean;
--    * Trim trailing whitespace on a line.
--   trimTrailingWhitespace?: boolean;
--    * Insert a newline character at the end of the file if one does not exist.
--   insertFinalNewline?: boolean;
--    * Trim all newlines after the final newline at the end of the file.
--   trimFinalNewlines?: boolean;
--    * Signature for further properties.
--   [key: string]: boolean | integer | string;
