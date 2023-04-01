require("hover").setup({
  init = function()
    -- Require providers
    require("hover.providers.lsp-hover")
    require("hover.providers.lsp-signature")
    require("hover.providers.lsp-definition")
    -- -- require("hover.providers.lsp-type-definition")
    require("hover.providers.help")
    -- require("hover.providers.man")
    require("hover.providers.dictionary")
    require("hover.providers.gh")
  end,
  border = "rounded",
  focusable = false,
})

-- vim.keymap.set("n", "M", require("hover").hover({ behavior = 'once' }), { desc = "hover.nvim (once)" })
-- vim.keymap.set("n", "M", require("hover").hover_sticky, { desc = "hover.nvim (sticky)" })
-- vim.keymap.set("n", "gM", require("hover").hover_cursor, { desc = "hover.nvim (cursor)" })
-- vim.keymap.set("n", "<leader>M", require("hover").hover_select, { desc = "hover.nvim (select)" })
-- vim.keymap.set("n", "<leader>gM", require("hover").hover_select_cursor, { desc = "hover.nvim (select)" })
