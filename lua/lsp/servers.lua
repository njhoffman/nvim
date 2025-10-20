-- https://gpanders.com/blog/whats-new-in-neovim-0-11/#lsp
-- Neovim 0.11 provided a new LSP API as discussed in this gpanders blog post.
-- Myself, I did not pay much attention since I was and still am using nvim-lspconfig.
-- However, just this week I noticed that the README for nvim-lspconfig states that legacy API is deprecated.

-- Legacy API being code such as this that uses setup:
-- require("lspconfig").ts_ls.setup({
--   on_attach = my_attach_func,
--   flags = { debounce_text_changes = 300 },
-- })

-- Instead it is recommended to do this:
-- vim.lsp.config("ts_ls", {
--   flags = { debounce_text_changes = 300 }
-- })
-- vim.lsp.enable({"ts_ls"})

-- Also, it appears that on_attach should be replaced by LspAttach auto-command, for example to setup your own LSP-only key mappings.
-- If you are using nvim-lspconfig than I recommend you check your Neovim configuration and see if you are using the legacy setup API. If so, please change it over to config + enable + LspAttach.
-- The nvim-lspconfig folks do state that the legacy setup API will be removed at some point. Better to convert over now before that day arrives.

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
  "groovyls",
  "helm_ls",
  "html",
  "intelephense",
  "jdtls",
  "jsonls",
  "jqls",
  "kotlin_language_server",
  "ltex",
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
  "volar",
  "yamlls",
  "zk",
  -- 'nginx-language-server',
  -- 'docker-compose-language-service',
}

local lspconfig = require("lspconfig")

local lspconfig_settings = {
  ensure_installed = servers,
  automatic_installation = true,
}

local tool_packages = require("configs.mason.tools")
local tool_settings = { ensure_installed = tool_packages }
require("mason-tool-installer").setup(tool_settings)

require("mason").setup(mason_settings)
require("mason-lspconfig").setup(lspconfig_settings)

local util = require("lspconfig.util")

util.default_config = vim.tbl_extend("force", util.default_config, {
  on_attach = require("lsp.on_attach"),
  capabilities = require("lsp.capabilities").make(),
  flags = {
    allow_incremental_sync = false,
    debounce_text_changes = 500,
  },
})

require("mason-lspconfig").setup_handlers({
  function(server_name) -- default handler (optional)
    -- vim.notify("setting up lsp: " .. server_name, 1)
    -- local opts = vim.tbl_deep_extend("force", opts, lspconfig[server_name] or {})
    -- local config = get_config(server_name)

    local capabilities = lspconfig[server_name].capabilities or util.default_config.capabilities
    if server_name == "cssls" then
      capabilities.textDocument.completion.completionItem.snippetSupport = true
    end

    -- if server_name == "lua_ls" then
    --   capabilities.textDocument.foldingRange = {
    --     dynamicRegistration = false,
    --     lineFoldingOnly = true,
    --   }
    -- end
    lspconfig[server_name].capabilities = capabilities
    lspconfig[server_name].on_attach = lspconfig[server_name].on_attach
      or util.default_config.on_attach
  end,
  -- { "clangd" }
  -- capabilities :
  -- default capabilities, with offsetEncoding utf-8
  -- cmd : clangd --offset-encoding=utf-16

  ["kotlin_language_server"] = function()
    lspconfig.kotlin_language_server.setup({
      cmd = { "kotlin-language-server" },
      filetypes = { "kotlin" },
      -- root_dir = root_pattern('settings.gradle'),
    })
  end,
  ["cssls"] = function() end,
  -- ['jdtls'] = noop,  root_dir = vim.fs.dirname(vim.fs.find({'gradlew', '.git', 'mvnw'}, { upward = true })[1]),

  ["jqls"] = function()
    lspconfig.jqls.setup({})
  end,

  ["sqls"] = function()
    lspconfig.sqls.setup({
      root_dir = util.root_pattern(".git"),
      single_file_support = false,
      on_new_config = function(new_config, new_rootdir)
        table.insert(new_config.cmd, "-config")
        table.insert(new_config.cmd, new_rootdir .. "/.config.yaml")
      end,
    })
  end,
  ["bashls"] = function()
    lspconfig.bashls.setup({
    -- vim.lsp.config('bashls', {
      root_dir = require('lsp.servers.utils').find_root({ '.project', '.git' }),
      filetypes = { "sh", "bash" },
      logLevel = "debug", -- debug, info, warn, error
      includeAllWorkspaceSymbols = true,
      cmd_env = {
        INCLUDE_ALL_WORKSPACE_SYMBOLS = true,
      },
      on_attach = function(client, bufnr)
        require("lsp.on_attach")(client, bufnr)
      end,
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
  end,
  ["eslint"] = require("lsp.servers.eslint"),
  ["lua_ls"] = require("lsp.servers.lua_ls"),
  ["stylelint_lsp"] = require("lsp.servers.stylelint_lsp"),
  ["ts_ls"] = require("lsp.servers.ts_ls"),
  ["jsonls"] = require("lsp.servers.jsonls"),
  -- https://github.com/xna00/unocss-language-server
  ["tailwindcss"] = function()
    lspconfig.tailwindcss.setup({
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
    })
  end,
  ["ansiblels"] = function()
    lspconfig.ansiblels.setup({
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
  end,
  ["awk_ls"] = function()
    lspconfig.awk_ls.setup({
      cmd = { "awk-ls" },
      filetypes = { "awk" },
      root_dir = require('lsp.servers.utils').find_root({ '.project', '.git' }),
    })
  end,
  ["clangd"] = function()
    lspconfig.clangd.setup({
      cmd = { "clangd", "--offset-encoding=utf-16" },
      filetypes = { "c", "cpp", "objc", "objcpp" },
      root_dir = util.root_pattern("compile_commands.json", ".git"),
    })
  end,
  ["cmake"] = function()
    lspconfig.cmake.setup({
      capabilities = require("lsp.capabilities").make(),
    })
  end,
  ["gradle_ls"] = function()
    lspconfig.gradle_ls.setup({})
  end,
  ["helm_ls"] = function()
    lspconfig.helm_ls.setup({})
  end,
  ["intelephense"] = function()
    lspconfig.intelephense.setup({})
  end,
  ["groovyls"] = function()
    lspconfig.groovyls.setup({})
  end,
  ["graphql"] = function()
    lspconfig.graphql.setup({})
  end,
  ["ltex"] = function()
    lspconfig.ltex.setup({
      settings = {
        ltex = {
          language = "en-US",
          additionalRules = {
            enablePickyRulesForLanguageModeling = true,
          },
        },
      },
    })
  end,
  ["marksman"] = function()
    lspconfig.marksman.setup({
      root_dir = require('lsp.servers.utils').find_root({ '.project', '.git' }),
    })
  end,
  ["yamlls"] = function()
    lspconfig.yamlls.setup({
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
  end,
  -- ['pylsp'] = function() end,
  ["pylsp"] = function()
    lspconfig.pylsp.setup({
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
  end,
  ["pyright"] = function()
    lspconfig.pyright.setup({
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
  end,
  ["vimls"] = function()
    lspconfig.vimls.setup({
      cmd = { "vim-language-server", "--stdio" },
      filetypes = { "vim" },
      root_dir = util.root_pattern(".project", ".git"),
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
          projectRootPatterns = { "runtime", "nvim", ".git", "autoload", "plugin" },
        },
        suggest = { fromVimruntime = true, fromRuntimepath = true },
      },
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

  -- -- pnpm install -D eslint eslint-plugin-astro
  -- nvim_lsp.astro.setup({
  --   on_attach = lsp_on_attach_no_formatting,
  --   capabilities = capabilities,
  --   flags = { debounce_text_changes = 300 },
  --   root_dir = nvim_lsp.util.root_pattern("astro.config.mjs"),
  -- })

  -- nvim_lsp.cssls.setup({
  --   on_attach = lsp_on_attach_no_formatting,
  --   capabilities = capabilities,
  --   flags = { debounce_text_changes = 300 },
  --   settings = {
  --     css = {
  --       lint = {
  --         unknownAtRules = "ignore",
  --       },
  --     },
  --   },
  -- })

  -- nvim_lsp.eslint.setup({
  --   on_attach = lsp_on_attach_no_formatting,
  --   capabilities = capabilities,
  --   filetypes = { "astro", "javascript", "typescript" },
  --   flags = { debounce_text_changes = 300 },
  -- })

  -- -- nvim_lsp.gopls.setup({
  -- --   on_attach = lsp_on_attach,
  -- --   capabilities = capabilities,
  -- --   flags = { debounce_text_changes = 300 },
  -- --   settings = { gopls = { semanticTokens = true } },
  -- -- })

  -- nvim_lsp.html.setup({
  --   on_attach = lsp_on_attach_no_formatting,
  --   capabilities = capabilities,
  --   filetypes = { "eruby", "html" },
  --   flags = { debounce_text_changes = 300 },
  -- })

  -- -- gem install ruby-lsp ruby-lsp-rails
  -- nvim_lsp.ruby_lsp.setup({
  --   on_attach = lsp_on_attach_no_formatting, -- Use standardrb for formatting
  --   capabilities = capabilities,
  --   flags = { debounce_text_changes = 300 },
  -- })

  -- nvim_lsp.rust_analyzer.setup({
  --   on_attach = lsp_on_attach,
  --   capabilities = capabilities,
  --   flags = { debounce_text_changes = 300 },
  --   root_dir = nvim_lsp.util.root_pattern("Cargo.toml"),
  --   settings = {
  --     ["rust-analyzer"] = {
  --       checkOnSave = {
  --         command = "clippy",
  --         extraArgs = { "--", "-Aclippy::needless_return" },
  --       },
  --     },
  --   },
  -- })

  -- -- gem install standard standard-rails
  -- nvim_lsp.standardrb.setup({
  --   on_attach = lsp_on_attach,
  --   capabilities = capabilities,
  -- })

  -- nvim_lsp.ts_ls.setup({
  --   on_attach = lsp_on_attach_no_formatting,
  --   capabilities = capabilities,
  --   flags = { debounce_text_changes = 300 },
  --   root_dir = nvim_lsp.util.root_pattern("package.json"),
  -- })

  -- nvim_lsp.tailwindcss.setup({
  --   on_attach = lsp_on_attach_no_formatting,
  --   capabilities = capabilities,
  --   filetypes = { "astro", "eruby", "html" },
  --   flags = { debounce_text_changes = 300 },
  --   root_dir = nvim_lsp.util.root_pattern("tailwind.config.js"),
  --   settings = {
  --     tailwindCSS = {
  --       experimental = {
  --         classRegex = {
  --           "(?:class:[\\s\\n]*|class=)['\"]([^'\"]+)['\"]",
  --         },
  --       },
  --     },
  --   },
  -- })
})
