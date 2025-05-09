-- https://github.com/maan2003/lsp_lines.nvim/compare/main...josephcourtney:lsp_lines.nvim:main
-- https://github.com/maan2003/lsp_lines.nvim/compare/main...iErik:lsp_lines.nvim:main
-- https://github.com/maan2003/lsp_lines.nvim/compare/main...Kazy:lsp_lines.nvim:main
-- https://git.sr.ht/~whynothugo/lsp_lines.nvim/log
-- Disable virtual_text since it's redundant due to lsp_lines.
-- vim.diagnostic.config({ virtual_lines = { only_current_line = true } })
-- vim.diagnostic.config({ virtual_lines = { highlight_whole_line = false } })

-- vim.lsp.util.open_floating_preview({
--   vim.api.nvim_get_current_line(), '      └──── Unused local `lsp`.'},
--   'lua',
--   { width = 50, height = 2, focusable = false, wrap = false}
-- )
--

require("lsp.lsp_lines").setup({
  -- virtual_lines = {
  only_current_line = false,
  highlight_whole_line = false,
  symbol_arrow = "──── ",
  -- },
})
