require("bufjump").setup({
  forward = "<C-i>",
  backward = "<C-o>",
  on_success = function()
    vim.cmd([[execute "normal! g`\"zz"]])
  end,
})

-- local opts = { silent = true, noremap = true }
-- vim.api.nvim_set_keymap("n", "<M-o>", ":lua require('bufjump').backward()<cr>", opts)
-- vim.api.nvim_set_keymap("n", "<M-i>", ":lua require('bufjump').forward()<cr>", opts)
