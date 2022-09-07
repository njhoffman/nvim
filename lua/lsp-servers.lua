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
  "bashls",
  "clangd",
  "cmake",
  "cssls",
  "dockerls",
  "eslint",
  "gopls",
  "html",
  "intelephense",
  "jsonls",
  "ltex",
  "pyright",
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
      -- these settings will be used for your neovim config directory
      library = {
        runtime = false, -- runtime path
        types = true, -- full signature, docs and completion of vim.api, vim.treesitter, vim.lsp and others
        plugins = false, -- installed opt or start plugins in packpath
        -- you can also specify the list of plugins to make available as a workspace library
        -- plugins = { "nvim-treesitter", "plenary.nvim", "telescope.nvim" },
      },
      -- these settings will be used for plugins (root dirs containing a /lua directory)
      plugin_library = {
        runtime = false,
        types = true,
        -- disable other plugins by default
        plugins = false,
      },
    }
    require("lua-dev").setup(luadev_config)
    lspconfig.sumneko_lua.setup({
      Lua = {
        format = {
          enable = false,
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
