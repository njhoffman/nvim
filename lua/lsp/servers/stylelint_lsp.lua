local stylelint_lsp = function()
  vim.lsp.config("stylelint_lsp", {
    root_markers = {
      ".stylelintrc",
      "package.json",
      "courseleaf.cfg",
      ".project",
      ".git",
      "CLAUDE.md",
    },
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
