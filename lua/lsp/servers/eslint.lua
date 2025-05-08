-- https://github.com/stevearc/conform.nvim/issues/515
-- https://github.com/stevearc/conform.nvim/issues/364
-- https://github.com/mantoni/eslint_d.js

local lspconfig = require("lspconfig")
local util = require("lsp.utils")
local lspconfig_util = require("lspconfig.util")

local root_file = {
  ".eslintrc",
  ".eslintrc.js",
  ".eslintrc.cjs",
  ".eslintrc.yaml",
  ".eslintrc.yml",
  ".eslintrc.json",
  "eslint.config.js",
  "eslint.config.mjs",
  "eslint.config.cjs",
  "eslint.config.ts",
  "eslint.config.mts",
  "eslint.config.cts",
}

local eslint = function()
  vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = { "*.tsx", "*.ts", "*.jsx", "*.js" },
    command = "silent! EslintFixAll",
    group = vim.api.nvim_create_augroup("JavaScriptFormatting", {}),
  })
  -- root_dir = utils.initRoot("eslint", {
  --   "package_json:eslintConfig",
  --   {
  --     ".eslintrc",
  --     ".eslintrc.js",
  --     ".eslintrc.cjs",
  --     ".eslintrc.yaml",
  --     ".eslintrc.yml",
  --     ".eslintrc.json",
  --     "eslint.config.js",
  --   },
  -- }),

  lspconfig.eslint.setup({
    root_dir = function(fname)
      root_file = lspconfig_util.insert_package_json(root_file, "eslintConfig", fname)
      return util.root_pattern(unpack(root_file))(fname)
    end,
    filetypes = {
      "javascript",
      "javascriptreact",
      "javascript.jsx",
      "typescript",
      "typescriptreact",
      "typescript.tsx",
      "vue",
      "svelte",
      "astro",
    },
    -- handlers = {
    --   {
    --     ["eslint/confirmESLintExecution"] = <function 1>,
    --     ["eslint/noLibrary"] = <function 2>,
    --     ["eslint/openDoc"] = <function 3>,
    --     ["eslint/probeFailed"] = <function 4>
    --   }
    -- },
    settings = {
      enable = true,
      packageManager = "yarn",
      probe = {
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "html",
        "vue",
        "markdown",
      },
      tslint = {
        enable = true,
      },
      codeAction = {
        disableRuleComment = {
          enable = true,
          location = "separateLine",
        },
        showDocumentation = {
          enable = true,
        },
      },
      codeActionOnSave = {
        enable = true,
        mode = "all",
      },
      experimental = {
        useFlatConfig = false,
      },
      format = true,
      nodePath = "",
      onIgnoredFiles = "off",
      problems = {
        shortenToSingleLine = false,
      },
      quiet = false,
      rulesCustomizations = {},
      run = "onType",
      useESLintClass = false,
      validate = "on",
      workingDirectory = {
        mode = "location",
      },
      -- workingDirectories = { "./client", "./server" }
    },
    on_attach = function(client, bufnr)
      require("lsp.on_attach")(client, bufnr)
    end,
  })
end

--   "eslint",
--     lspconfig.eslint.setup({
--       cmd = { "vscode-eslint-language-server", "--stdio" },
--       capabilities = capabilities,
--       handlers = handlers,
--       filetypes = {
--         "javascript",
--         "javascriptreact",
--         "javascript.jsx",
--         "typescript",
--         "typescriptreact",
--         "typescript.tsx",
--         "vue",
--         "svelte",
--         "astro",
--       },
--       root_dir = require("lspconfig.util").root_pattern(".git"),
--       settings = {
--         codeAction = {
--           disableRuleComment = {
--             enable = true,
--             location = "separateLine",
--           },
--           showDocumentation = {
--             enable = true,
--           },
--         },
--         codeActionOnSave = {
--           enable = false,
--           mode = "all",
--         },
--         experimental = {
--           useFlatConfig = false,
--         },
--         format = true,
--         nodePath = "",
--         onIgnoredFiles = "off",
--         packageManager = "npm",
--         problems = {
--           shortenToSingleLine = false,
--         },
--         quiet = false,
--         rulesCustomizations = {},
--         run = "onType",
--         useESLintClass = false,
--         validate = "on",
--         workingDirectory = {
--           mode = "location",
--         },
--       },
--       on_attach = function(_, bufnr)
--         api.nvim_create_autocmd("BufWritePre", {
--           buffer = bufnr,
--           command = "EslintFixAll",
--         })
--       end,
--     })
return eslint
