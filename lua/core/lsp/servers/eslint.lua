-- eslint (ESLint Language Server) Configuration

local root_markers = {
  "courseleaf.cfg",
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
  ".project",
  ".git",
  "CLAUDE.md",
}

-- Setup auto-fix on save
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "*.tsx", "*.ts", "*.jsx", "*.js" },
  command = "silent! EslintFixAll",
  group = vim.api.nvim_create_augroup("EslintAutoFix", { clear = true }),
})

return {
  root_markers = root_markers,
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
    codeAction = {
      disableRuleComment = {
        enable = true,
        location = "separateLine",
      },
      showDocumentation = { enable = true },
    },
    codeActionOnSave = {
      enable = true,
      mode = "all",
    },
    experimental = { useFlatConfig = false },
    format = true,
    nodePath = "",
    onIgnoredFiles = "off",
    problems = { shortenToSingleLine = false },
    quiet = false,
    rulesCustomizations = {},
    run = "onType",
    useESLintClass = false,
    validate = "on",
    workingDirectory = { mode = "location" },
  },
}
