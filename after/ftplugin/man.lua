-- too easy to close manpage with escape, make it a bit tougher with ctrl-esc

vim.keymap.set("n", "<esc>", "<nop>", { buffer = true, silent = true })
vim.keymap.set("n", "<M-{>", "<cmd>q<cr>", { buffer = true, silent = true })
