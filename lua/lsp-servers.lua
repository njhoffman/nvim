local lspdefs = require("lsp-definitions")
local handlers = require("lsp-handlers")

local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
  -- Mappings.
  -- Set autocommands conditional on server_capabilities
  for _, providerKey in ipairs(lspdefs.display_keys) do
    handlers.check_capability(client, bufnr, providerKey)
  end

  -- if lsp_name == "tsserver" then
  --   map_buf(bufnr, "cxo", tsserver_organize_imports)
  -- elseif lsp_name == "pyright" then
  --   map_buf(bufnr, "cxo", function()
  --     vim.cmd("silent PyrightOrganizeImports")
  --   end)
end
--- }}}

-- require("lsp-zk").setup_zk(get_config("zk"))

--- {{{ setup servers
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
  "stylelint-lsp",
  "sumneko_lua",
  "svelte",
  "tailwindcss",
  "terraformls",
  "tflint",
  "texlab",
  "tsserver",
  "vimls",
  "volar",
  "yamlls",
  "zk",
}

local lspconfig = require("lspconfig")

local lspconfig_settings = {
  -- "null-ls",
  ensure_installed = servers,
  automatic_installation = false,
}

local tool_packages = require("plugins.config.mason-nvim-tools")
local tool_settings = { ensure_installed = tool_packages }

require("mason").setup(mason_settings)
require("mason-lspconfig").setup(lspconfig_settings)
require("mason-tool-installer").setup(tool_settings)

local def_capabilities = vim.lsp.protocol.make_client_capabilities()
require("cmp_nvim_lsp").update_capabilities(def_capabilities)
def_capabilities.textDocument.completion.completionItem.snippetSupport = true
def_capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = { "documentation", "detail", "additionalTextEdits" },
}

lspconfig.util.default_config = vim.tbl_extend("force", lspconfig.util.default_config, {
  on_attach = on_attach,
  capabilities = def_capabilities,
})
require("mason-lspconfig").setup_handlers({
  -- The first entry (without a key) will be the default handler
  -- and will be called for each installed server that doesn't have
  -- a dedicated handler.
  function(server_name) -- default handler (optional)
    vim.notify("setting up lsp: " .. server_name, "trace")
    -- local opts = vim.tbl_deep_extend("force", opts, lspconfig[server_name] or {})

    -- local config = get_config(server_name)
    lspconfig[server_name].setup(lspconfig[server_name])
  end,
  -- ["tsserver"] = function()
  --   -- local opts = vim.tbl_deep_extend("force", server_options, servers["tsserver"] or {})
  --   require("typescript").setup({
  --     disable_commands = false,
  --     debug = false,
  --     -- server = opts,
  --   })
  -- end,
  ["sumneko_lua"] = function()
    local luadev_config = {
      library = {
        enabled = true, -- when not enabled, lua-dev will not change any settings to the LSP server
        -- these settings will be used for your neovim config directory
        runtime = true, -- runtime path
        types = true, -- full signature, docs and completion of vim.api, vim.treesitter, vim.lsp and others
        plugins = false, -- installed opt or start plugins in packpath
        -- you can also specify the list of plugins to make available as a workspace library
        -- plugins = { "nvim-treesitter", "plenary.nvim", "telescope.nvim" },
      },
      -- for your neovim config directory, the config.library settings will be used as is
      -- for plugin directories (root_dirs having a /lua directory), config.library.plugins will be disabled
      -- for any other directory, config.library.enabled will be set to false
      override = function(root_dir, options) end,
      -- override = function(root_dir, library)
      --   if require("lua-dev.util").has_file(root_dir, "/etc/nixos") then
      --     library.enabled = true
      --     library.plugins = true
      --   end
      -- end,
    }
    require("lua-dev").setup(luadev_config)
    lspconfig.sumneko_lua.setup({
      Lua = {
        format = {
          enable = true,
        },
        hint = {
          enable = true,
          arrayIndex = "Disable", -- "Enable", "Auto", "Disable"
          await = true,
          paramName = "Disable", -- "All", "Literal", "Disable"
          paramType = false,
          semicolon = "Disable", -- "All", "SameLine", "Disable"
          setType = true,
        },
        diagnostics = {
          globals = { "vim" },
        },
      },
    })
  end,
})
