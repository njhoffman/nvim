-- stylelint_lsp (StyleLint Language Server) Configuration

return {
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
    },
  },
}
