local M = require("mappings.mapper")

M.map("Window", "n", "<C-j>", "down")
M.map("Window", "n", "<C-k>", "up")
M.map("Window", "n", "<C-h>", "left")
M.map("Window", "n", "<C-l>", "right")
M.map("Window", "n", "<C-w>o", "exit_others") -- virtual
M.map("Window", "n", "<C-w>x", "swap") -- virtual
M.map("Window", "n", "<C-w>+", "increase_height") -- virtual
M.map("Window", "n", "<C-w>-", "decrease_height") -- virtual
M.map("Window", "n", "<C-w><", "increase_width") -- virtual
M.map("Window", "n", "<C-w>>", "decrease_width") -- virtual
M.map("Window", "n", "<C-w>=", "resize_even1") -- virtual
M.map("Window", "n", "<leader>o", "exit_others_2")
M.map("Window", "n", "<leader>=", "resize_even2")
M.map("Window", "n", "<leader>:", "prev")
M.map("Window", "n", "<leader>;", "next")
M.map("Window", "n", "<leader>H", "split_horiz")
M.map("Window", "n", "<leader>V", "split_vert")
M.map("Window", "n", "<leader>_", "max_vert")
M.map("Window", "n", "<leader>|", "max_horiz")
M.map("Window", "n", "<leader>q", "close")
