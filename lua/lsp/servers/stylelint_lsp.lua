local lspconfig = require("lspconfig")
local util = lspconfig.util

local stylelint_lsp = function()
  lspconfig.stylelint_lsp.setup({
    root_pattern = util.root_pattern(".stylelintrc", "package.json"),
    filetypes = {
      "css",
      "less",
      "scss",
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
      "sugarss",
      "vue",
      "wxss",
    },
    settings = {
      stylelintplus = {
        enable = true,
        cssInJs = false,
        -- autoFixOnSave (default false) - automatically apply fixes on save.
        -- config (default null) - stylelint config to use.
        -- configFile (default null) - path to stylelint config file.
        -- configOverrides (default null) - stylelint config overrides.
        -- enable (default true) - if false, disable linting and auto-formatting.
        -- validateOnSave (default false) - lint on save.
        -- validateOnType (default true) - lint after changes.
      },
    },
  })
end

return stylelint_lsp
