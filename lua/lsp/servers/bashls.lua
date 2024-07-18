local lspconfig = require("lspconfig")
local util = lspconfig.util
local bashls = function()
  lspconfig.bashls.setup({
    root_dir = util.root_pattern(".project", ".git"),
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
      includeAllWorkspaceSymbols = true,
      -- ignoredRootPaths = {"~"},
      -- backgroundAnalysisMaxFiles = 500,
      -- Configure explainshell server endpoint in order to get hover documentation on flags and options.
      -- And empty string will disable the feature.
      -- explainshellEndpoint: z.string().trim().default(''),
      -- shellCheckArguments = "shellcheck",
    },
  })
end

return bashls
