local lspconfig = require('lspconfig')
local util = lspconfig.util

local tsserver = function()
  -- local bufnr = vim.api.nvim_get_current_buf()
  -- vim.keymap.set({ c, x, o }, "gO", function()
  --   local params = {
  --     command = "_typescript.organizeImports",
  --     arguments = { vim.api.nvim_buf_get_name(0) },
  --   }
  --   vim.lsp.buf.execute_command(params)
  --   vim.notify("Imports organized.")
  -- end, { buffer = bufnr })

  -- dependencies = { "jose-elias-alvarez/typescript.nvim" },

  lspconfig.tsserver.setup({
    init_options = { hostInfo = 'neovim' },
    filetypes = {
      'javascript',
      'javascriptreact',
      'javascript.jsx',
      'typescript',
      'typescriptreact',
      'typescript.tsx',
    },
    root_dir = function(fname)
      return util.root_pattern('tsconfig.json')(fname)
        or util.root_pattern('package.json', 'jsconfig.json', '.git')(fname)
    end,
    single_file_support = true,
    settings = {
      typescript = {
        format = {
          indentSize = vim.o.shiftwidth,
          convertTabsToSpaces = vim.o.expandtab,
          tabSize = vim.o.tabstop,
        },
      },
      javascript = {
        format = {
          indentSize = vim.o.shiftwidth,
          convertTabsToSpaces = vim.o.expandtab,
          tabSize = vim.o.tabstop,
        },
      },
      completions = {
        completeFunctionCalls = true,
      },
    },
    setup = {
      tsserver = function(_, opts)
        require('lazyvim.util').on_attach(function(client, buffer)
          if client.name == 'tsserver' then
              -- stylua: ignore
              vim.keymap.set("n", "<leader>co", "<cmd>TypescriptOrganizeImports<CR>", { buffer = buffer, desc = "Organize Imports" })
              -- stylua: ignore
              vim.keymap.set("n", "<leader>cR", "<cmd>TypescriptRenameFile<CR>", { desc = "Rename File", buffer = buffer })
          end
        end)
        require('typescript').setup({ server = opts })
        return true
      end,
    },
  })
end
-- tsserver = { logDirectory, logVerbosity?: 'off' | 'terse' | 'normal' | 'requestTime' | 'verbose';)   trace?: 'off' | 'messages' | 'verbose';
-- prefrences = {
--   allowIncompleteCompletions =  true,
--   allowRenameOfImportPath =  true,
--   allowTextChangesInNewFiles =  true,
--   displayPartsForJSDoc =  true,
--   generateReturnInDocTemplate =  true,
--   includeAutomaticOptionalChainCompletions =  true,
--   includeCompletionsForImportStatements =  true,
--   includeCompletionsForModuleExports =  true,
--   includeCompletionsWithClassMemberSnippets =  true,
--   includeCompletionsWithObjectLiteralMethodSnippets =  true,
--   includeCompletionsWithInsertText =  true,
--   includeCompletionsWithSnippetText =  true,
--   jsxAttributeCompletionStyle =  "auto",
--   providePrefixAndSuffixTextForRename =  true,
--   provideRefactorNotApplicableReason =  true,
-- }
--   },
-- })
return tsserver
-- tsconfig.json
-- {
--   "compilerOptions": {
--     "module": "commonjs",
--     "target": "es6",
--     "checkJs": false
--   },
--   "exclude": [
--     "node_modules"
--   ]
-- }
