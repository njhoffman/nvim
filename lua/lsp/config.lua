local virtual_text_config = {
  source = "if_many",
  spacing = 2,
  -- severity = 0. -- ERROR, WARN, INFO, HINT
  severity = { min = vim.diagnostic.severity.WARN },
  -- format = function(diagnostic)
  --   if diagnostic.severity == vim.diagnostic.severity.ERROR then
  --     return string.format("E: %s", diagnostic.message)
  --   end
  --   return diagnostic.message
  -- end,
}

local diagnostic_config = {
  float = {
    focusable = false,
    style = "minimal",
    border = "rounded",
    source = "if_many",
    prefix = " ",
    header = "",
    -- format = function(diag)
    --   -- See null-ls.nvim#632, neovim#17222 for how to pick up `code`
    --   local user_data
    --   user_data = diag.user_data or {}
    --   user_data = user_data.lsp or user_data.null_ls or user_data
    --   -- TODO: symbol is specific to pylint (will be removed)
    --   local code = (diag.symbol or diag.code or user_data.symbol or user_data.code)
    --   if code then
    --     return string.format("%s (%s)", diag.message, code)
    --   else
    --     return diag.message
    --   end
    -- end,
  },
  virtual_text = false,
  signs = true,
  underline = false,
  -- underline = {
  --   severity = { min = vim.diagnostic.severity.ERROR },
  -- },
  update_in_insert = false,
  severity_sort = true,
}
vim.api.nvim_set_hl(0, "DiagnosticUnnecessary", { link = "Comment" })

vim.diagnostic.config(diagnostic_config)

-- vim.api.nvim_create_autocmd("DiagnosticChanged", {
--   callback = function(args)
--     local diagnostics = args.data.diagnostics
--     -- vim.dbglog(diagnostics)
--   end,
-- })
