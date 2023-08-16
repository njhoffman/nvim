-- eiw -> escape in word

vim.keymap.set({
  "n",
  "v",
}, "<leader>e", require("escape").escape, { noremap = true, silent = true })
