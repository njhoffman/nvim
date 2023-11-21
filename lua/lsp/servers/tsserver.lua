local utils = require('lsp.utils')

local opts = {
  init_options = {
    hostInfo = 'neovim',
    preferences = {
      disableSuggestions = true,
    },
  },
  filetypes = {
    'javascript',
    'javascriptreact',
    'javascript.jsx',
    'typescript',
    'typescriptreact',
    'typescript.tsx',
  },
  root_dir = utils.initRoot('tsserver', {
    {
      'tsconfig.json',
      'jsconfig.json',
    },
    {
      'package.json',
    },
    'git_ancestor',
  }),
  single_file_support = true,
  settings = {
    typescript = {
      suggestionActions = {
        enabled = false,
      },
      format = false,
      -- format = {
      --   indentSize = vim.o.shiftwidth,
      --   convertTabsToSpaces = vim.o.expandtab,
      --   tabSize = vim.o.tabstop,
      -- },
    },
    javascript = {
      suggestionActions = {
        enabled = false,
      },
      format = false,
    },
    diagnostics = {
      ignoredCodes = {
        80001,
        7006, -- parameter implicitly has any type
        2571, -- object is of type 'unknown'
      },
    }, -- File is a CommonJS module; it may be converted to an ES6 module.
    completions = {
      completeFunctionCalls = true,
    },
  },
  on_attach = function(client, bufnr)
    -- require('nvim-lsp-ts-utils').setup({ filter_out_diagnostics_by_code = { 80001 } })
    -- require('nvim-lsp-ts-utils').setup_client(client)
    require('lsp.on_attach')(client, bufnr)
  end,
  -- setup = function(_, _opts)
  --   vim.dbglog('tsserver setup', _opts)
  --   require('lazyvim.util').on_attach(function(client, buffer)
  --     vim.dbglog('lazy handler', client.name)
  --     if client.name == 'tsserver' then
  --       -- client.server_capabilities.documentFormatting = false
  --       vim.keymap.set('n', '<leader>co', '<cmd>TypescriptOrganizeImports<CR>', { buffer = buffer, desc = 'Organize Imports' })
  --       vim.keymap.set('n', '<leader>cR', '<cmd>TypescriptRenameFile<CR>', { desc = 'Rename File', buffer = buffer })
  --     end
  --   end)
  --   require('typescript').setup({ server = _opts })
  -- end
  -- },
}

local typescript_wrapper = function()
  -- Typescript: FixAll, RenameFile, RemoveUnused, OrganizeImports, AddMissingImports, GoToSourceDefinition
  require('typescript').setup({
    disable_commands = false,
    debug = false,
    go_to_source_definition = {
      fallback = true,
    },
    server = opts,
  })
end

local typescript_tools_wrapper = function()
  -- TSTools: OrgaqnizeImports, SortImports, RemoveUnusedImports, AddMissingImports RemoveUnused, FixAll, GoToSourceDefinition
  -- styled-components intellisense: npm i -g @styled/typescript-styled-plugin typescript-styled-plugin

  local tools_opts = {
    -- spawn additional tsserver instance to calculate diagnostics on it
    separate_diagnostic_server = true,
    -- "change"|"insert_leave" determine when the client asks the server about diagnostic
    publish_diagnostic_on = 'insert_leave',
    -- array of strings("fix_all"|"add_missing_imports"|"remove_unused"|
    -- "remove_unused_imports"|"organize_imports") -- or string "all"
    -- to include all supported code actions specify commands exposed as code_actions
    expose_as_code_action = {},
    -- string|nil - specify a custom path to `tsserver.js` file, if this is nil or file under path
    -- not exists then standard path resolution strategy is applied
    tsserver_path = nil,
    -- specify a list of plugins to load by tsserver, e.g., for support `styled-components`
    tsserver_plugins = {},
    -- tsserver_plugins = { "@styled/typescript-styled-plugin" },
    -- this value is passed to: https://nodejs.org/api/cli.html#--max-old-space-sizesize-in-megabytes
    -- memory limit in megabytes or "auto"(basically no limit)
    tsserver_max_memory = 'auto',
    -- https://github.com/pmizio/typescript-tools.nvim/blob/master/lua/typescript-tools/config.lua#L17
    tsserver_format_options = {},
    -- tsserver_format_options = {
    --   allowIncompleteCompletions = false,
    --   allowRenameOfImportPath = false,
    -- }
    tsserver_file_preferences = {},
    -- tsserver_file_preferences = {
    --   includeInlayParameterNameHints = "all",
    --   includeCompletionsForModuleExports = true,
    --   quotePreference = "auto",
    -- },
    -- mirror of VSCode's `typescript.suggest.completeFunctionCalls`
    complete_function_calls = false,
  }

  opts.settings = tools_opts

  -- Ignore 'This may be converted to an async function' diagnostics.
  opts.handlers = opts.handlers or {}
  opts.handlers['textDocument/publishDiagnostics'] = require('typescript-tools.api').filter_diagnostics({
    80006,
  })

  require('typescript-tools').setup(opts)
end

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

  -- lspconfig.tsserver.setup(opts)
  -- typescript_tools_wrapper()
  typescript_wrapper()
end

return tsserver

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
