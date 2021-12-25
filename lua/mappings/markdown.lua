local M = require("mappings.mapper")

-- snip run, ,/ ,? vim-printer
M.map("Markdown", "n", "<leader>mp", "preview")
M.map("Markdown", "n", "<leader>tn", "toggle_cb_n")
M.map("Markdown", "n", "<leader>tt", "toggle_cb_value")
M.map("Markdown", "v", "<leader>tn", "toggle_cb_v")
M.map("Markdown", "n", "<leader>tm", "tablemode_toggle") -- virtual
M.map("Markdown", "n", "<leader>T", "tableize_n") -- virtual
M.map("Markdown", "v", "<leader>T", "tableize_v") -- virtual
M.map("Markdown", "n", "<leader>tr", "table_realign_n")
M.map("Markdown", "v", "<leader>tr", "table_realign_v")
-- M.map("Markdown", "n", "<leader>tr", "table_realign_n") -- virtual
-- M.map("Markdown", "v", "<leader>tr", "table_realign_v") -- virtual
M.map("Markdown", "n", "<leader>tic", "table_insert_col_n") -- virtual
M.map("Markdown", "v", "<leader>tic", "table_insert_col_v") -- virtual
M.map("Markdown", "n", "<leader>dic", "table_delete_col_n") -- virtual
M.map("Markdown", "v", "<leader>dic", "table_delete_col_v") -- virtual
