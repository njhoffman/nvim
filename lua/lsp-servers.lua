local mason_settings = {
  ui = {
    border = "rounded",
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗",
    },
    keymaps = {
      -- Keymap to apply language filter
      apply_language_filter = "<leader>ff",
    },
  },
}

local servers = {
  "ansiblels",
  "awk_ls",
  "bashls",
  "clangd",
  "cmake",
  "cssls",
  "dockerls",
  "eslint",
  "golangci_lint_ls",
  "gopls",
  "graphql",
  "html",
  "intelephense",
  "jsonls",
  "ltex",
  "pyright",
  "solargraph",
  "sqls",
  "stylelint_lsp",
  "lua_ls",
  "svelte",
  "tailwindcss",
  "terraformls",
  "tflint",
  "texlab",
  "tsserver",
  "vimls",
  "volar",
  "yamlls",
  -- "zk",
}

local lspconfig = require("lspconfig")

local lspconfig_settings = {
  ensure_installed = servers,
  automatic_installation = false,
}

local tool_packages = require("plugins.config.mason-nvim-tools")
local tool_settings = { ensure_installed = tool_packages }

require("mason").setup(mason_settings)
require("mason-lspconfig").setup(lspconfig_settings)
require("mason-tool-installer").setup(tool_settings)

local capabilities = require("lsp-capabilities")

local on_attach = function(client, bufnr)
  -- vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
  -- vim.api.nvim_buf_set_option(bufnr, "omnifunc", "")

  if client.name == "lua_ls" then
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end
  capabilities.resolve(client, bufnr)
end

local util = require("lspconfig.util")
util.default_config = vim.tbl_extend("force", util.default_config, {
  on_attach = on_attach,
  capabilities = capabilities.make(),
})

require("mason-lspconfig").setup_handlers({
  function(server_name) -- default handler (optional)
    -- vim.notify("setting up lsp: " .. server_name, 1)
    -- local opts = vim.tbl_deep_extend("force", opts, lspconfig[server_name] or {})
    -- local config = get_config(server_name)
    lspconfig[server_name].setup(lspconfig[server_name])
  end,
  ["tsserver"] = require("lsp-servers.tsserver"),
  ["eslint"] = require("lsp-servers.eslint"),
  ["tailwindcss"] = require("lsp-servers.tailwindcss"),
  ["lua_ls"] = require("lsp-servers.sumneko_lua"),
  ["stylelint_lsp"] = require("lsp-servers.stylelint_lsp"),
  ["bashls"] = function()
    lspconfig.bashls.setup({
      root_dir = util.root_pattern(".project", ".git"),
    })
  end,
  ["dockerls"] = function()
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
