-- 'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
-- Disable virtual_text since it's redundant due to lsp_lines.
-- vim.diagnostic.config({ virtual_lines = { only_current_line = true } })
-- vim.diagnostic.config({ virtual_lines = { highlight_whole_line = false } })

-- vim.lsp.util.open_floating_preview({
--   vim.api.nvim_get_current_line(), '      └──── Unused local `lsp`.'},
--   'lua',
--   { width = 50, height = 2, focusable = false, wrap = false}
-- )
--
vim.diagnostic.config({
  virtual_text = false,
})

-- https://github.com/folke/lazy.nvim/issues/620
-- vim.diagnostic.config({ virtual_lines = false }, require("lazy.core.config").ns)
--
require('lsp.lsp_lines').setup()
