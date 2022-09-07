require("hover").setup({
  init = function()
    -- Require providers
    require("hover.providers.lsp")
    require("hover.providers.gh")
    require("hover.providers.man")
    require("hover.providers.dictionary")
  end,
  preview_opts = {
    border = "rounded",
  },
  title = true,
})

-- Setup keymaps
vim.keymap.set("n", "M", require("hover").hover, { desc = "hover.nvim" })
vim.keymap.set("n", "gM", require("hover").hover_select, { desc = "hover.nvim (select)" })
