-- https://raw.githubusercontent.com/williamboman/mason.nvim/main/README.md
-- https://raw.githubusercontent.com/williamboman/mason-lspconfig.nvim/main/README.md

local mason_default = {
  ui = {
    -- Whether to automatically check for new versions when opening the :Mason window.
    check_outdated_packages_on_open = true,

    -- The border to use for the UI window. Accepts same border values as |nvim_open_win()|.
    border = 'none',

    icons = {
      -- The list icon to use for installed packages.
      package_installed = '◍',
      -- The list icon to use for packages that are installing, or queued for installation.
      package_pending = '◍',
      -- The list icon to use for packages that are not installed.
      package_uninstalled = '◍',
    },

    keymaps = {
      -- Keymap to expand a package
      toggle_package_expand = '<CR>',
      -- Keymap to install the package under the current cursor position
      install_package = 'i',
      -- Keymap to reinstall/update the package under the current cursor position
      update_package = 'u',
      -- Keymap to check for new version for the package under the current cursor position
      check_package_version = 'c',
      -- Keymap to update all installed packages
      update_all_packages = 'U',
      -- Keymap to check which installed packages are outdated
      check_outdated_packages = 'C',
      -- Keymap to uninstall a package
      uninstall_package = 'X',
      -- Keymap to cancel a package installation
      cancel_installation = '<C-c>',
      -- Keymap to apply language filter
      apply_language_filter = '<C-f>',
    },
  },

  -- The directory in which to install packages.
  -- install_root_dir = path.concat { vim.fn.stdpath "data", "mason" },

  pip = {
    -- These args will be added to `pip install` calls. Note that setting extra args might impact intended behavior
    -- and is not recommended.
    --
    -- Example: { "--proxy", "https://proxyserver" }
    install_args = {},
  },

  -- Controls to which degree logs are written to the log file. It's useful to set this to vim.log.levels.DEBUG when
  -- debugging issues with package installations.
  log_level = vim.log.levels.INFO,

  -- Limit for the maximum amount of packages to be installed at the same time. Once this limit is reached, any further
  -- packages that are requested to be installed will be put in a queue.
  max_concurrent_installers = 4,

  github = {
    -- The template URL to use when downloading assets from GitHub.
    -- The placeholders are the following (in order):
    -- 1. The repository (e.g. "rust-lang/rust-analyzer")
    -- 2. The release version (e.g. "v0.3.0")
    -- 3. The asset name (e.g. "rust-analyzer-v0.3.0-x86_64-unknown-linux-gnu.tar.gz")
    download_url_template = 'https://github.com/%s/releases/download/%s/%s',
  },
}

local tool_defaults = {
  -- a list of all tools you want to ensure are installed upon
  -- start; they should be the names Mason uses for each tool
  ensure_installed = {},

  -- if set to true this will check each tool for updates. If updates
  -- are available the tool will be updated. This setting does not
  -- affect :MasonToolsUpdate or :MasonToolsInstall.
  -- Default: false
  auto_update = false,

  -- automatically install / update on startup. If set to false nothing
  -- will happen on startup. You can use :MasonToolsInstall or
  -- :MasonToolsUpdate to install tools and check for updates.
  -- Default: true
  run_on_start = true,

  -- set a delay (in ms) before the installation starts. This is only
  -- effective if run_on_start is set to true.
  -- e.g.: 5000 = 5 second delay, 10000 = 10 second delay, etc...
  -- Default: 0
  start_delay = 0,
}

local tool_packages = require('configs.mason.tools')
local tool_settings = { ensure_installed = tool_packages }

local lspconfig_settings = {
  ensure_installed = {
    'awk_ls',
    'bashls',
    'clangd',
    'cssls',
    'dockerls',
    -- "efm",
    'golangci_lint_ls',
    'gopls',
    'graphql',
    'html',
    'jq-lsp',
    'jsonls',
    'pylsp',
    'sqls',
    'lua_ls',
    'terraformls',
    'tsserver',
    'vimls',
    'yamlls',
    -- "null-ls",
  },
  automatic_installation = false,
}

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

-- ORDER IS IMPORTANT HERE
-- require("mason").setup(mason_settings)
-- require("mason-lspconfig").setup(lspconfig_settings)
-- require("mason-tool-installer").setup(tool_settings)
--
-- -- local default_lsp_on_attach = function(client, bufnr)
-- --   -- require("mappings").keys_lsp()
-- --   -- client.server_capabilities.document_formatting = false
-- --   -- client.server_capabilities.document_range_formatting = false
-- --   -- vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"
-- --   -- vim.opt_local.tagfunc = "v:lua.vim.lsp.tagfunc"
-- --
-- --   if type(client.server_capabilities.signatureHelpProvider) == "table" then
-- --     local lsp_sig = require("lsp.signature")
-- --     require("lsp_signature").on_attach(lsp_sig.cfg, bufnr)
-- --   end
-- --
-- --   local ft = vim.api.nvim_buf_get_option(bufnr, 'filetype')
-- --   if client.server_capabilities.documentFormattingProvider == true or
-- --     ft == 'sh' or
-- --     ft == 'bash'  then
-- --     local augroup = vim.api.nvim_create_augroup("Formatting", {})
-- --     vim.api.nvim_create_autocmd("BufWritePre", {
-- --       group = augroup,
-- --       buffer = bufnr,
-- --       command = "Format",
-- --     })
-- --   end
-- -- end
-- --
-- -- local default_lsp_capabilities = vim.lsp.protocol.make_client_capabilities()
-- -- -- require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())
-- --
-- -- local lspconfig = require("lspconfig")
-- -- lspconfig.util.default_config = vim.tbl_extend("force", lspconfig.util.default_config, {
-- --   on_attach = default_lsp_on_attach,
-- --   capabilities = default_lsp_capabilities,
-- -- })
-- --
-- -- require("mason-lspconfig").setup_handlers({
-- --   -- The first entry (without a key) will be the default handler
-- --   -- and will be called for each installed server that doesn't have
-- --   -- a dedicated handler.
-- --   function(server_name) -- default handler (optional)
-- --     vim.notify("setting up lsp: " .. server_name, "trace")
-- --     -- local opts = vim.tbl_deep_extend("force", server_options, servers[server_name] or {})
-- --     -- lspconfig[server_name].setup(opts)
-- --     lspconfig[server_name].setup({})
-- --   end,
-- --   -- ["tsserver"] = function()
-- --   --   -- local opts = vim.tbl_deep_extend("force", server_options, servers["tsserver"] or {})
-- --   --   require("typescript").setup {
-- --   --     disable_commands = false,
-- --   --     debug = false,
-- --   --     -- server = opts,
-- --   --   }
-- --   -- end,
-- --   ["sumneko_lua"] = function()
-- --     lspconfig.sumneko_lua.setup(require("lua-dev").setup({
-- --       library = {
-- --         vimruntime = true, -- runtime path
-- --         types = true, -- full signature, docs and completion of vim.api, vim.treesitter, vim.lsp and others
-- --         plugins = false, -- installed opt or start plugins in packpath
-- --         -- plugins = { "nvim-treesitter", "plenary.nvim", "telescope.nvim" },
-- --       },
-- --       runtime_path = false,
-- --       settings = {
-- --         Lua = {
-- --           format = {
-- --             enable = false,
-- --           },
-- --           hint = {
-- --             enable = true,
-- --             arrayIndex = "Disable", -- "Enable", "Auto", "Disable"
-- --             await = true,
-- --             paramName = "Disable", -- "All", "Literal", "Disable"
-- --             paramType = false,
-- --             semicolon = "Disable", -- "All", "SameLine", "Disable"
-- --             setType = true,
-- --           },
-- --           diagnostics = {
-- --             globals = { "vim" },
-- --           },
-- --         },
-- --       },
-- --     }))
-- --   end,
-- -- })
--
-- -- -- Capability-based keymaps.
-- -- if client.server_capabilities.declarationProvider then
-- --   vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts("Go to declaration"))
-- -- end
-- -- if client.server_capabilities.definitionProvider then
-- --   vim.api.nvim_buf_set_option(bufnr, 'tagfunc', 'v:lua.vim.lsp.tagfunc')
-- --   vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts("Go to definition"))
-- -- end
-- -- if client.server_capabilities.typeDefinitionProvider then
-- --   vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts("Go to type definition"))
-- -- end
-- -- if client.server_capabilities.hoverProvider then
-- --   vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts("LSP hover"))
-- -- end
-- -- if client.server_capabilities.implementationProvider then
-- --   vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts("Go to implementation"))
-- -- end
-- -- if client.server_capabilities.signatureHelpProvider then
-- --   vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts("Show signature help"))
-- -- end
-- -- if client.server_capabilities.referencesProvider then
-- --   vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts("Go to references"))
-- -- end
-- -- if client.server_capabilities.documentFormattingProvider then
-- --   vim.keymap.set('n', '<leader>f', vim.lsp.buf.format, opts("Format buffer"))
-- -- end
-- -- if client.server_capabilities.documentRangeFormattingProvider then
-- --   vim.api.nvim_buf_set_option(bufnr, 'formatexpr', 'v:lua.vim.lsp.formatexpr()')
-- --   vim.keymap.set('v', '<leader>f', vim.lsp.buf.range_formatting, opts("Format range"))
-- -- end
