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
  -- 'nginx-language-server',
  -- 'docker-compose-language-service',
  -- "zk",
}

local lspconfig = require('lspconfig')

local lspconfig_settings = {
  ensure_installed = servers,
  automatic_installation = true,
}

local tool_packages = require('plugs.config.mason.tools')
local tool_settings = { ensure_installed = tool_packages }
require('mason-tool-installer').setup(tool_settings)

require('mason').setup(mason_settings)
require('mason-lspconfig').setup(lspconfig_settings)

local util = require('lspconfig.util')

util.default_config = vim.tbl_extend('force', util.default_config, {
  on_attach = require('lsp.on_attach'),
  capabilities = require('lsp.capabilities').make(),
})

require('mason-lspconfig').setup_handlers({
  function(server_name) -- default handler (optional)
    -- vim.notify("setting up lsp: " .. server_name, 1)
    -- local opts = vim.tbl_deep_extend("force", opts, lspconfig[server_name] or {})
    -- local config = get_config(server_name)

    -- separate tsserver setup using jose-elias-alvarez/typescript.nvim
    if server_name ~= 'tsserver' then
      lspconfig[server_name].setup(lspconfig[server_name])
    end
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
  -- ['tsserver'] = require('lsp.servers.tsserver'),
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
  ['ansiblels'] = function()
    lspconfig.ansiblels.setup({
      filetypes = {
        'yaml.ansible',
      },
      settings = {
        ansible = {
          ansible = {
            path = 'ansible',
            useFullyQualifiedCollectionNames = true,
          },
          ansibleLint = {
            enabled = true,
            path = 'ansible-lint',
          },
          executionEnvironment = {
            enabled = false,
          },
          python = {
            interpreterPath = 'python',
          },
          completion = {
            provideRedirectModules = true,
            provideModuleOptionAliases = true,
          },
        },
      },
    })
  end,
  ['yamlls'] = function()
    lspconfig.yamlls.setup({
      settings = {
        yaml = {
          hover = true,
          completion = true,
          validate = true,
          schemaStore = {
            enable = true,
            url = 'https://www.schemastore.org/api/json/catalog.json',
          },
          schemas = require('schemastore').yaml.schemas(),
        },
      },
    })
  end,
  ['jsonls'] = function()
    lspconfig.jsonls.setup({
      settings = {
        json = {
          format = {
            enable = true,
          },
          schemas = require('schemastore').json.schemas(), -- ignore = { '.eslintrc', 'package.json', },
          validate = { enable = true },
        },
      },
      setup = {
        commands = {
          Format = {
            function()
              vim.lsp.buf.range_formatting({}, { 0, 0 }, { vim.fn.line('$'), 0 })
            end,
          },
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
