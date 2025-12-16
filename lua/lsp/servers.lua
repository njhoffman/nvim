-- Migrated to vim.lsp.config API (Neovim 0.11+)
-- Reference: https://gpanders.com/blog/whats-new-in-neovim-0-11/#lsp
--
-- The new API replaces the old lspconfig.setup() pattern:
-- OLD: require("lspconfig").ts_ls.setup({ ... })
-- NEW: vim.lsp.config("ts_ls", { ... }) + vim.lsp.enable({"ts_ls"})
--
-- LspAttach autocmd (in on_attach.lua) replaces the on_attach callback pattern

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
  "gradle_ls",
  -- 'grammarly',
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
  -- 'nginx-language-server',
  -- 'docker-compose-language-service',
}

local lspconfig_settings = {
  ensure_installed = servers,
  automatic_installation = true,
}

local tool_packages = require("configs.mason.tools")
local tool_settings = { ensure_installed = tool_packages }
require("mason-tool-installer").setup(tool_settings)

require("mason").setup(mason_settings)
require("mason-lspconfig").setup(lspconfig_settings)

-- Set default LSP configuration for all servers
-- This replaces the old util.default_config pattern
vim.lsp.config("*", {
  capabilities = require("lsp.capabilities").make(),
  flags = {
    allow_incremental_sync = false,
    debounce_text_changes = 500,
  },
})

-- Configure individual server-specific settings using vim.lsp.config
-- Server-specific handlers are defined below

-- cssls - CSS Language Server
vim.lsp.config("cssls", {
  capabilities = vim.tbl_deep_extend("force", vim.lsp.config["*"].capabilities or {}, {
    textDocument = {
      completion = {
        completionItem = {
          snippetSupport = true,
        },
      },
    },
  }),
})
-- { "clangd" }
-- capabilities :
-- default capabilities, with offsetEncoding utf-8
-- cmd : clangd --offset-encoding=utf-16

-- kotlin_language_server - Kotlin Language Server
vim.lsp.config("kotlin_language_server", {
  cmd = { "kotlin-language-server" },
  filetypes = { "kotlin" },
  -- root_dir = root_pattern('settings.gradle'),
})

-- jqls - jq Language Server
vim.lsp.config("jqls", {})

-- sqls - SQL Language Server
vim.lsp.config("sqls", {
  root_markers = { ".git", "CLAUDE.md" },
  single_file_support = false,
  on_new_config = function(new_config, new_rootdir)
    table.insert(new_config.cmd, "-config")
    table.insert(new_config.cmd, new_rootdir .. "/.config.yaml")
  end,
})
-- bashls - Bash Language Server
vim.lsp.config("bashls", {
  root_markers = { ".project", "courseleaf.cfg", ".git", "CLAUDE.md" },
  filetypes = { "sh", "bash" },
  logLevel = "debug", -- debug, info, warn, error
  includeAllWorkspaceSymbols = true,
  cmd_env = {
    INCLUDE_ALL_WORKSPACE_SYMBOLS = true,
  },
  bashIde = {
    logLevel = "debug", -- debug, info, warn, error
    -- ignoredRootPaths = {"~"},
    -- backgroundAnalysisMaxFiles = 500,
    -- Configure explainshell server endpoint in order to get hover documentation on flags and options.
    -- And empty string will disable the feature.
    -- explainshellEndpoint: z.string().trim().default(''),
    -- shellCheckArguments = "shellcheck",
  },
})

-- Server-specific configurations loaded from separate files
require("lsp.servers.eslint")()
require("lsp.servers.lua_ls")()
require("lsp.servers.stylelint_lsp")()
require("lsp.servers.ts_ls")()
require("lsp.servers.jsonls")()
-- tailwindcss - Tailwind CSS Language Server
-- https://github.com/xna00/unocss-language-server
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
-- ansiblels - Ansible Language Server
vim.lsp.config("ansiblels", {
  filetypes = {
    "yaml.ansible",
  },
  settings = {
    ansible = {
      ansible = {
        path = "ansible",
        useFullyQualifiedCollectionNames = true,
      },
      ansibleLint = {
        enabled = true,
        path = "ansible-lint",
      },
      executionEnvironment = {
        enabled = false,
      },
      python = {
        interpreterPath = "python",
      },
      completion = {
        provideRedirectModules = true,
        provideModuleOptionAliases = true,
      },
    },
  },
})

-- awk_ls - AWK Language Server
vim.lsp.config("awk_ls", {
  cmd = { "awk-ls" },
  filetypes = { "awk" },
  root_markers = { ".project", "coursealeaf.cfg", ".git", "CLAUDE.md" },
})

-- clangd - C/C++ Language Server
vim.lsp.config("clangd", {
  cmd = { "clangd", "--offset-encoding=utf-16" },
  filetypes = { "c", "cpp", "objc", "objcpp" },
  root_markers = { "compile_commands.json", ".git", "CLAUDE.md" },
})

-- cmake - CMake Language Server
vim.lsp.config("cmake", {})

-- gradle_ls - Gradle Language Server
vim.lsp.config("gradle_ls", {})

-- helm_ls - Helm Language Server
vim.lsp.config("helm_ls", {})

-- intelephense - PHP Language Server
vim.lsp.config("intelephense", {})

-- groovyls - Groovy Language Server
vim.lsp.config("groovyls", {})

-- graphql - GraphQL Language Server
vim.lsp.config("graphql", {})
-- ltex - LaTeX/Markdown Language Server
vim.lsp.config("ltex", {
  settings = {
    ltex = {
      language = "en-US",
      additionalRules = {
        enablePickyRulesForLanguageModeling = true,
      },
    },
  },
})

-- marksman - Markdown Language Server
vim.lsp.config("marksman", {})

-- yamlls - YAML Language Server
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

-- pylsp - Python Language Server
vim.lsp.config("pylsp", {
  settings = {
    pylsp = {
      builtin = {
        installExtraArgs = {
          "flake8",
          "pycodestyle",
          "pydocstyle",
          "pyflakes",
          "pylint",
          "yapf",
        },
      },
      plugins = {
        black = {
          cache_config = true,
          enabled = true,
          line_length = 119,
        },
        flake8 = {
          enabled = false,
          maxLineLength = 119,
        },
        mypy = { enabled = false },
        jedi_completion = { enabled = false },
        rope_completion = { enabled = false },
        pyflakes = { enabled = false },
        pycodestyle = {
          enabled = true,
          ignore = {
            "E226",
            "E266",
            "E302",
            "E303",
            "E304",
            "E305",
            "E402",
            "C0103",
            "W0104",
            "W0621",
            "W391",
            "W503",
            "W504",
          },
          maxLineLength = 119,
        },
      },
    },
  },
})

-- pyright - Python Language Server (Type Checking)
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
        -- typeCheckingMode = 'off',
      },
    },
  },
})
-- vimls - Vim Language Server
vim.lsp.config("vimls", {
  cmd = { "vim-language-server", "--stdio" },
  filetypes = { "vim" },
  root_markers = { ".project", ".git", "courseleaf.ccfg", "CLAUDE.md" },
  single_file_support = true,
  init_options = {
    isNeovim = true,
    iskeyword = "@,48-57,_,192-255,-#",
    vimruntime = "",
    runtimepath = "",
    diagnostic = { enable = true },
    indexes = {
      runtimepath = true,
      gap = 100,
      count = 3,
      projectRootPatterns = {
        "runtime",
        "nvim",
        ".project",
        "coursealeaf.cfg",
        ".git",
        "autoload",
        "plugin",
      },
    },
    suggest = { fromVimruntime = true, fromRuntimepath = true },
  },
})

-- dockerls - Docker Language Server
vim.lsp.config("dockerls", {
  settings = {
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
  },
})

-- Enable all configured LSP servers
vim.lsp.enable(servers)
