local lspconfig = require('lspconfig')
local util = lspconfig.util

local eslint = function()
  vim.api.nvim_create_autocmd('BufWritePost', {
    pattern = { '*.tsx', '*.ts', '*.jsx', '*.js' },
    command = 'silent! EslintFixAll',
    group = vim.api.nvim_create_augroup('MyAutocmdsJavaScripFormatting', {}),
  })
  lspconfig.eslint.setup({
    -- root_dir = util.root_pattern('.project', '.git', '.eslintrc'),
    root_dir = util.root_pattern('.project', '.git', 'package.json'),
    filetypes = {
      'javascript',
      'javascriptreact',
      'javascript.jsx',
      'typescript',
      'typescriptreact',
      'typescript.tsx',
      'vue',
      'svelte',
      'astro',
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
      packageManager = 'yarn',
      probe = {
        'javascript',
        'javascriptreact',
        'typescript',
        'typescriptreact',
        'html',
        'vue',
        'markdown',
      },
      tslint = {
        enable = true,
      },
      codeAction = {
        disableRuleComment = {
          enable = true,
          location = 'separateLine',
        },
        showDocumentation = {
          enable = true,
        },
      },
      codeActionOnSave = {
        enable = true,
        mode = 'all',
      },
      experimental = {
        useFlatConfig = false,
      },
      format = true,
      nodePath = '',
      onIgnoredFiles = 'off',
      packageManager = 'npm',
      problems = {
        shortenToSingleLine = false,
      },
      quiet = false,
      rulesCustomizations = {},
      run = 'onType',
      useESLintClass = false,
      validate = 'on',
      workingDirectory = {
        mode = 'location',
      },
      -- workingDirectories = { "./client", "./server" }
    },
    on_attach = function(client, bufnr)
      require('lsp.on_attach')(client, bufnr)
    end,
  })
end

return eslint
