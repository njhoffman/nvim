-- LSP Server Setup
-- Configures Mason, mason-lspconfig, and registers all LSP servers

local log = require("logger").init("lsp.servers")

local M = {}

-- Server list for mason-lspconfig
M.servers = {
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
  "gradle_ls",
  "graphql",
  "helm_ls",
  "html",
  "intelephense",
  "jdtls",
  "jsonls",
  "jqls",
  "kotlin_language_server",
  "lua_ls",
  "marksman",
  "pylsp",
  "pyright",
  "solargraph",
  "sqlls",
  "stylelint_lsp",
  "svelte",
  "tailwindcss",
  "terraformls",
  "texlab",
  "tflint",
  "ts_ls",
  "vimls",
  "yamlls",
  "zk",
}

-- Mason UI settings
local mason_settings = {
  ui = {
    border = "rounded",
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗",
    },
    keymaps = {
      apply_language_filter = "<leader>ff",
    },
  },
}

-- Mason-lspconfig settings
local lspconfig_settings = {
  ensure_installed = M.servers,
  automatic_installation = true,
}

-- Setup mason and mason-lspconfig
local function setup_mason()
  local tool_packages = require("configs.mason.tools")
  require("mason-tool-installer").setup({ ensure_installed = tool_packages })
  require("mason").setup(mason_settings)
  require("mason-lspconfig").setup(lspconfig_settings)
  log:debug("Mason setup complete")
end

-- Load server-specific configurations
local function load_server_configs()
  local defaults = require("lsp.servers.defaults")

  -- Set default config for all servers
  vim.lsp.config("*", defaults.config)
  log:debug("Default LSP config applied")

  -- Server-specific configurations
  -- Each file returns a config table (not a function)
  local server_configs = {
    "lua_ls",
    "ts_ls",
    "eslint",
    "jsonls",
    "stylelint_lsp",
  }

  for _, name in ipairs(server_configs) do
    local ok, config = pcall(require, "lsp.servers." .. name)
    if ok and type(config) == "table" then
      vim.lsp.config(name, config)
      log:debug("Loaded config for: " .. name)
    elseif not ok then
      log:warn("Failed to load config for " .. name .. ": " .. tostring(config))
    end
  end

  -- Inline configs for servers without dedicated files
  vim.lsp.config("cssls", {
    capabilities = vim.tbl_deep_extend("force", defaults.config.capabilities or {}, {
      textDocument = {
        completion = {
          completionItem = { snippetSupport = true },
        },
      },
    }),
  })

  vim.lsp.config("kotlin_language_server", {
    cmd = { "kotlin-language-server" },
    filetypes = { "kotlin" },
  })

  vim.lsp.config("jqls", {})

  vim.lsp.config("sqls", {
    root_markers = { ".git", "CLAUDE.md" },
    single_file_support = false,
    on_new_config = function(new_config, new_rootdir)
      table.insert(new_config.cmd, "-config")
      table.insert(new_config.cmd, new_rootdir .. "/.config.yaml")
    end,
  })

  vim.lsp.config("bashls", {
    root_markers = { ".project", "courseleaf.cfg", ".git", "CLAUDE.md" },
    filetypes = { "sh", "bash" },
    cmd_env = { INCLUDE_ALL_WORKSPACE_SYMBOLS = true },
    settings = {
      bashIde = { logLevel = "info" },
    },
  })

  vim.lsp.config("tailwindcss", {
    settings = {
      tailwindCSS = {
        classAttributes = { "class", "className", "class:list", "classList", "ngClass" },
        lint = {
          cssConflict = "warning",
          invalidApply = "error",
          invalidConfigPath = "error",
          invalidScreen = "error",
          invalidTailwindDirective = "error",
          invalidVariant = "error",
          recommendedVariantOrder = "warning",
        },
        validate = true,
      },
    },
  })

  vim.lsp.config("ansiblels", {
    filetypes = { "yaml.ansible" },
    settings = {
      ansible = {
        ansible = { path = "ansible", useFullyQualifiedCollectionNames = true },
        ansibleLint = { enabled = true, path = "ansible-lint" },
        executionEnvironment = { enabled = false },
        python = { interpreterPath = "python" },
        completion = { provideRedirectModules = true, provideModuleOptionAliases = true },
      },
    },
  })

  vim.lsp.config("awk_ls", {
    cmd = { "awk-ls" },
    filetypes = { "awk" },
    root_markers = { ".project", "courseleaf.cfg", ".git", "CLAUDE.md" },
  })

  vim.lsp.config("cmake", {})
  vim.lsp.config("gradle_ls", {})
  vim.lsp.config("helm_ls", {})
  vim.lsp.config("intelephense", {})
  vim.lsp.config("groovyls", {})
  vim.lsp.config("graphql", {})

  vim.lsp.config("ltex", {
    settings = {
      ltex = {
        language = "en-US",
        additionalRules = { enablePickyRulesForLanguageModeling = true },
      },
    },
  })

  vim.lsp.config("marksman", {})

  vim.lsp.config("yamlls", {
    settings = {
      yaml = {
        hover = true,
        completion = true,
        validate = true,
        schemaStore = {
          enable = true,
          url = "https://www.schemastore.org/api/json/catalog.json",
        },
        schemas = require("schemastore").yaml.schemas(),
      },
    },
  })

  vim.lsp.config("pylsp", {
    settings = {
      pylsp = {
        builtin = {
          installExtraArgs = { "flake8", "pycodestyle", "pydocstyle", "pyflakes", "pylint", "yapf" },
        },
        plugins = {
          black = { cache_config = true, enabled = true, line_length = 119 },
          flake8 = { enabled = false, maxLineLength = 119 },
          mypy = { enabled = false },
          jedi_completion = { enabled = false },
          rope_completion = { enabled = false },
          pyflakes = { enabled = false },
          pycodestyle = {
            enabled = true,
            ignore = { "E226", "E266", "E302", "E303", "E304", "E305", "E402", "C0103", "W0104", "W0621", "W391", "W503", "W504" },
            maxLineLength = 119,
          },
        },
      },
    },
  })

  vim.lsp.config("pyright", {
    settings = {
      python = {
        linting = { pylintEnabled = false },
        analysis = {
          useLibraryCodeForTypes = true,
          diagnosticSeverityOverrides = {
            reportGeneralTypeIssues = "none",
            reportOptionalMemberAccess = "none",
            reportOptionalSubscript = "none",
            reportPrivateImportUsage = "none",
          },
          autoImportCompletions = false,
        },
      },
    },
  })

  vim.lsp.config("vimls", {
    cmd = { "vim-language-server", "--stdio" },
    filetypes = { "vim" },
    root_markers = { ".project", ".git", "courseleaf.cfg", "CLAUDE.md" },
    single_file_support = true,
    init_options = {
      isNeovim = true,
      iskeyword = "@,48-57,_,192-255,-#",
      diagnostic = { enable = true },
      indexes = {
        runtimepath = true,
        gap = 100,
        count = 3,
        projectRootPatterns = { "runtime", "nvim", ".project", "courseleaf.cfg", ".git", "autoload", "plugin" },
      },
      suggest = { fromVimruntime = true, fromRuntimepath = true },
    },
  })

  vim.lsp.config("dockerls", {
    settings = {
      formatter = { ignoreMultilineInstructions = true },
    },
  })
end

-- Initialize
setup_mason()
load_server_configs()

-- Enable all servers
vim.lsp.enable(M.servers)
log:info("Enabled " .. #M.servers .. " LSP servers")

return M
