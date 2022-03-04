local M = require("mappings.mapper")

M.map("Movement", "n", "ds)", "s_delete_paren1")
M.map("Movement", "n", "ds(", "s_delete_paren2")
M.map("Movement", "n", "ds}", "s_delete_brace1")
M.map("Movement", "n", "ds{", "s_delete_brace2")
M.map("Movement", "n", "ds]", "s_delete_bracket1")
M.map("Movement", "n", "ds[", "s_delete_bracket2")
M.map("Movement", "n", "dsb", "s_delete_block1")
M.map("Movement", "n", "dsB", "s_delete_block2")
M.map("Movement", "n", "dsf", "s_delete_func")
M.map("Movement", "n", 'ds"', "s_delete_quote")
M.map("Movement", "n", "ds`", "s_delete_grave")
M.map("Movement", "n", "ds'", "s_delete_single_quote")

-- M.Map("Movement", "n", "dst", "s_delete_tag1")
-- M.Map("Movement", "n", "dsp", "s_delete_paragraph1")
-- M.Map("Movement", "n", "dsw", "s_delete_word1")

M.map("Movement", "i", "jk", "quick_insert_esc1")
M.map("Movement", "i", "kj", "quick_insert_esc2")
M.map("Movement", "i", "<C-u>", "c_u_undo_friendly") -- Make <C-u> undo-friendly
M.map("Movement", "i", "<C-w>", "c_w_undo_friendly") -- Make <C-w> undo-friendly)
M.map("Movement", "n", "D", "delete_end")
M.map("Movement", "v", "$", "select_end_no_eol")
M.map("Movement", "v", "al", "select_a_line")
M.map("Movement", "v", "il", "select_inside_line")
M.map("Movement", "o", "al", "op_a_line", {noremap = false})
M.map("Movement", "o", "il", "op_inside_line", {noremap = false})
M.map("Movement", "n", "<C-f>", "scroll_forwards", {noremap = false})
M.map("Movement", "n", "<C-b>", "scroll_backwards", {noremap = false})
-- M.map("Movement", "n", "<space>", "scroll_forwardsx3", {noremap = false})
M.map("Movement", "n", "G", "scroll_bottom", {noremap = false})
M.map("Movement", "n", "gg", "scroll_top", {noremap = false})
M.map("Movement", "n", "gv", "select_last")
M.map("Movement", "n", "g<M-g>", "ascii")
M.map("Movement", "n", "gA", "ascii_2")
M.map("Movement", "n", "gi", "last_insertion") -- virtual
M.map("Movement", "n", "gI", "begin_insertion") -- virtual
M.map("Movement", "n", "gv", "last_visual") -- virtual
M.map("Movement", "n", "g<M-G>", "total_counts") -- virtual
-- x  <CR>        *@:lua require'nvim-treesitter.incremental_selection'.scope_incremental()<CR>
-- x  <CR>        * <Cmd>lua require'nvim-treesitter.incremental_selection'.scope_incremental()<CR>
-- virtual until treesitter integration figured out
M.map("Movement", "n", "<CR>", "incremental_selection_init", {noremap = true, silent = true})
M.map("Movement", "x", "<TAB>", "incremental_selection_scope", {noremap = true, silent = true})
M.map("Movement", "x", "<CR>", "incremental_selection_expand", {noremap = true, silent = true})
M.map("Movement", "x", "<S-TAB>", "incremental_selection_shrink", {noremap = true, silent = true})
-- M.map("Movement", "v", "+", "incremental_selection_expand")
-- M.map("Movement", "v", "-", "incremental_selection_shrink")
-- defaults
-- M.map("Movement", "n", "gnn", "incremental_selection_init")
-- M.map("Movement", "v", "grn", "incremental_selection_expand")
-- M.map("Movement", "v", "grm", "incremental_selection_shrink")
-- M.map("Movement", "v", "grc", "incremental_selection_scope")
-- -- textsubjects
-- x  <CR>        *@:lua require("nvim-treesitter.textsubjects").select("textsubjects-smart", true, vim.fn.getpos("'<"), vim.fn.getpos("'>"))<CR>
-- o  <CR>        *@:lua require("nvim-treesitter.textsubjects").select("textsubjects-smart", false, vim.fn.getpos("."), vim.fn.getpos("."))<CR>
-- x  <Tab>       *@:lua require("nvim-treesitter.textsubjects").select("textsubjects-container-outer", true, vim.fn.getpos("'<"), vim.fn.getpos("'>"))<CR>
-- o  <Tab>       *@:lua require("nvim-treesitter.textsubjects").select("textsubjects-container-outer", false, vim.fn.getpos("."), vim.fn.getpos("."))<CR>
M.map("Movement", "n", "gnd", "goto_definition")
M.map("Movement", "x", "il", "yank_in_line_no_eol")
M.map("Movement", "o", "il", "yank_in_line_no_eol_o")
M.map("Movement", "n", "yy", "yank_line_no_eol")
M.map("Movement", "n", "<leader>py", "neoclip")
M.map("Movement", "n", "<leader>pY", "fzf_yanks")
M.map("Movement", "n", "<leader>pp", "paste_primary")
M.map("Movement", "n", "<leader>pc", "paste_comment")
M.map("Movement", "n", "<leader>pm", "paste_mode_toggle")
M.map("Movement", "n", "<M-,>", "qfc_prev")
M.map("Movement", "n", "<M-.>", "qfc_next")
M.map("Movement", "n", "<M-/>", "qfc_toggle")
M.map("Movement", "n", "<M-'>", "hop_to_word")
M.map("Movement", "n", "<M-;>", "hop_to_line")
-- M.map("Movement", "n", "<M-\">", "hop_to_line")
-- M.map("Movement", "n", "<M-;>", "hop_to_word")
-- M.map("Movement", "n", "<M-:>", "hop_to_line")
-- vim.api.nvim_set_keymap('n', '<M-;>', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>", {})
-- vim.api.nvim_set_keymap('n', 'F', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>", {})
