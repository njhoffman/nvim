local mason_settings = {
  ui = {
    border = 'rounded',
    icons = {
      package_installed = '✓',
      package_pending = '➜',
      package_uninstalled = '✗',
    },
    keymaps = {
      -- Keymap to apply language filter
      apply_language_filter = '<leader>ff',
    },
  },
}

local servers = {
  'ansiblels',
  'awk_ls',
  'bashls',
  'clangd',
  'cmake',
  'cssls',
  'dockerls',
  'eslint',
  'golangci_lint_ls',
  'gopls',
  'graphql',
  'html',
  'intelephense',
  'jsonls',
  'ltex',
  'marksman',
  'pyright',
  'solargraph',
  'sqlls',
  'stylelint_lsp',
  'lua_ls',
  'svelte',
  'tailwindcss',
  'terraformls',
  'tflint',
  'texlab',
  'tsserver',
  'vimls',
  'volar',
  'yamlls',
  -- "zk",
}

local lspconfig = require('lspconfig')

local lspconfig_settings = {
  ensure_installed = servers,
  automatic_installation = true,
}

local tool_packages = require('plugs.config.mason.tools')
local tool_settings = { ensure_installed = tool_packages }

require('mason').setup(mason_settings)
require('mason-lspconfig').setup(lspconfig_settings)
require('mason-tool-installer').setup(tool_settings)

local capabilities = require('lsp.capabilities')

local on_attach = function(client, bufnr)
  -- vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
  -- vim.api.nvim_buf_set_option(bufnr, "omnifunc", "")

  vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded', max_width = 80 })
  vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'rounded' })
  -- local icons = require("nvim-nonicons")
  -- ✘  i 
  vim.fn.sign_define('DiagnosticSignError', { text = '', texthl = 'LspDiagnosticsSignError' })
  vim.fn.sign_define('DiagnosticSignWarn', { text = '', texthl = 'LspDiagnosticsSignWarn' })
  vim.fn.sign_define('DiagnosticSignInfo', { text = '', texthl = 'LspDiagnosticsSignInfo' }) -- 
  vim.fn.sign_define('DiagnosticSignHint', { text = '', texthl = 'LspDiagnosticsSignHint' })
  local keymap_opts = { noremap = true, silent = true }
  vim.api.nvim_set_keymap('n', '<C-T>', "<cmd>lua require('telescope.run')('builtin', 'diagnostics', { bufnr = true })<cr>", keymap_opts)
  vim.api.nvim_set_keymap('n', '<M-T>', "<cmd>lua require('telescope.run')('builtin', 'diagnostics')<cr>", keymap_opts)
  vim.api.nvim_set_keymap('n', '<Leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', keymap_opts)
  vim.api.nvim_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', keymap_opts)
  vim.api.nvim_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', keymap_opts)
  vim.api.nvim_set_keymap('n', '<Leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', keymap_opts)

  if client.server_capabilities.semanticTokensProvider then
    client.server_capabilities.semanticTokensProvider = nil
  end

  if client.name == 'lua_ls' then
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end
  capabilities.resolve(client, bufnr)
end

local util = require('lspconfig.util')
util.default_config = vim.tbl_extend('force', util.default_config, {
  on_attach = on_attach,
  capabilities = capabilities.make(),
})

require('mason-lspconfig').setup_handlers({
  function(server_name) -- default handler (optional)
    -- vim.notify("setting up lsp: " .. server_name, 1)
    -- local opts = vim.tbl_deep_extend("force", opts, lspconfig[server_name] or {})
    -- local config = get_config(server_name)
    lspconfig[server_name].setup(lspconfig[server_name])
  end,
  -- { "clangd" }
  -- capabilities :
  -- default capabilities, with offsetEncoding utf-8
  -- cmd : clangd --offset-encoding=utf-16
  ['bashls'] = require('lsp.servers.bashls'),
  ['eslint'] = require('lsp.servers.eslint'),
  ['lua_ls'] = require('lsp.servers.lua_ls'),
  ['stylelint_lsp'] = require('lsp.servers.stylelint_lsp'),
  ['tailwindcss'] = require('lsp.servers.tailwindcss'),
  ['tsserver'] = require('lsp.servers.tsserver'),
  ['ltex'] = function()
    lspconfig.ltex.setup({
      filetypes = {
        'bib',
        'gitcommit',
        -- "markdown",
        'org',
        -- "pandoc",
        'plaintex',
        'rst',
        'rnoweb',
        'tex',
      },
      settings = {
        ltex = {
          language = 'en-GB',
        },
      },
    })
  end,
  ['yamlls'] = function()
    lspconfig.yamlls.setup({
      settings = {
        yaml = {
          schemas = require('schemastore').yaml.schemas(),
          validate = { enable = true },
        },
      },
    })
  end,
  ['jsonls'] = function()
    lspconfig.jsonls.setup({
      settings = {
        json = {
          schemas = require('schemastore').json.schemas(), -- ignore = { '.eslintrc', 'package.json', },
          validate = { enable = true },
        },
      },
    })
  end,
  ['dockerls'] = function()
    lspconfig.dockerls.setup({
      diagnostics = {
        -- string values must be equal to "ignore", "warning", or "error"
        -- deprecatedMaintainer = string,
        -- directiveCasing = string,
        -- emptyContinuationLine = string,
        -- instructionCasing = string,
        -- instructionCmdMultiple = string,
        -- instructionEntrypointMultiple = string,
        -- instructionHealthcheckMultiple = string,
        -- instructionJSONInSingleQuotes = string
      },
      formatter = {
        ignoreMultilineInstructions = true,
      },
    })
  end,
})
