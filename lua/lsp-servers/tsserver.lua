local lspconfig = require("lspconfig")
local util = lspconfig.util

local tsserver = function()
  lspconfig.tsserver.setup({
    init_options = { hostInfo = "neovim" },
    filetypes = {
      "javascript",
      "javascriptreact",
      "javascript.jsx",
      -- 'typescript',
      -- 'typescriptreact',
      -- 'typescript.tsx',
    },
    root_dir = function(fname)
      return util.root_pattern("tsconfig.json")(fname)
        or util.root_pattern("package.json", "jsconfig.json", ".git")(fname)
    end,
    single_file_support = true,
    settings = {
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
    },
  })
end
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
