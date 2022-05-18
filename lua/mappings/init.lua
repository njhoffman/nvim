local M = require("mappings.mapper")

M.map("Navigation", "n", ";", "quick_cmd", { noremap = true, nowait = true })
M.map("Navigation", "n", ":", "quick_cmdwin", { noremap = true, nowait = true })
M.map("Navigation", "v", ";", "quick_cmd_v", { noremap = true, nowait = true })
M.map("Navigation", "v", ":", "quick_cmdwin_v", { noremap = true, nowait = true })
M.map("Navigation", "n", "<BS>", "buffer_last")
M.map("Navigation", "n", "H", "buffer_left1")
M.map("Navigation", "n", "L", "buffer_right1")
M.map("Navigation", "n", "!!", "repeat_cmd")
M.map("Navigation", "n", "<M-r>", "restart")
M.map("Navigation", "n", "<C-x>", "nowrite_exit1")
M.map("Navigation", "n", "<A-x>", "write_exit1")
M.map("Navigation", "n", "<C-d>", "bufclose_nosave")
M.map("Navigation", "n", "<C-s>", "quick_save")
M.map("Navigation", "i", "<C-s>", "insert_quick_save")
M.map("Navigation", "n", "ZZ", "write_exit2") -- virtual
M.map("Navigation", "n", "<leader>x", "bufclose_save")
M.map("Navigation", "n", "<leader>z", "nowrite_exit2")
M.map("Navigation", "n", "<leader>!", "bufclose_all")
M.map("Navigation", "n", "<M-d>", "bufclose_all2")
M.map("Navigation", "n", "<leader>*", "bufwrite_all")
M.map("Navigation", "n", "<leader>w", "bufwrite_noa")
M.map("Navigation", "n", "<leader>d", "bufdelete")
M.map("Navigation", "n", "<leader>.", "open_altfile")
M.map("Navigation", "n", "<leader>fn", "open_newfile")
M.map("Navigation", "n", "<leader>fs", "open_newsplit")
M.map("Navigation", "n", "<leader>fp", "print_filename")
M.map("Navigation", "n", "gF", "goto_fileline") -- TODO: integrate goto definition
M.map("Navigation", "n", "gf", "goto_file") -- virtual
M.map("Navigation", "n", "xf", "open_file") -- virtual
M.map("Navigation", "n", ",cd", "cd_buffer")
M.map("Navigation", "n", ",cdh", "cd_home")
M.map("Navigation", "n", ",cdr", "cd_root")

M.map("Window", "c", "<c-s>", "cmd_save")
M.map("Window", "c", "<c-y>", "cmd_yank")
M.map("Window", "c", "<C-n>", "cmd_next1") -- virtual
M.map("Window", "c", "<C-p>", "cmd_prev1") -- virtual
M.map("Window", "c", "<tab>", "cmd_next2") -- virtual
M.map("Window", "c", "<s-tab>", "cmd_prev2") -- virtual
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
M.map("Movement", "o", "al", "op_a_line", { noremap = false })
M.map("Movement", "o", "il", "op_inside_line", { noremap = false })
M.map("Movement", "n", "<C-f>", "scroll_forwards", { noremap = false })
M.map("Movement", "n", "<C-b>", "scroll_backwards", { noremap = false })
-- M.map("Movement", "n", "<space>", "scroll_forwardsx3", {noremap = false})
M.map("Movement", "n", "G", "scroll_bottom", { noremap = false })
M.map("Movement", "n", "gg", "scroll_top", { noremap = false })
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
M.map("Movement", "n", "<CR>", "incremental_selection_init", { noremap = true, silent = true })
M.map("Movement", "x", "<TAB>", "incremental_selection_scope", { noremap = true, silent = true })
M.map("Movement", "x", "<CR>", "incremental_selection_expand", { noremap = true, silent = true })
M.map("Movement", "x", "<S-TAB>", "incremental_selection_shrink", { noremap = true, silent = true })
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
-- M.map("Movement", "n", "<M-/>", "qfc_toggle")
M.map("Movement", "n", "<C-q>", "qfc_toggle")
M.map("Movement", "n", "<M-'>", "hop_to_word")
M.map("Movement", "n", "<M-;>", "hop_to_line")
-- M.map("Movement", "n", "<M-\">", "hop_to_line")
-- M.map("Movement", "n", "<M-;>", "hop_to_word")
-- M.map("Movement", "n", "<M-:>", "hop_to_line")
-- vim.api.nvim_set_keymap('n', '<M-;>', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>", {})
-- vim.api.nvim_set_keymap('n', 'F', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>", {})

M.map("Interface", "n", '""', "registers")
M.map("Interface", "n", "<F2>", "whichkey")
M.map("Interface", "n", "<F3>", "nvim_tree")
M.map("Interface", "n", "<F4>", "mundo1")
-- M.map("Interface", "n", "<F5>", "term1")
M.map("Interface", "n", "<F6>", "treesitter")
M.map("Interface", "n", "<F7>", "aerial")
M.map("Interface", "n", "<S-F7>", "aerial_float")
M.map("Interface", "n", "gU", "mundo2")
M.map("Interface", "n", "cll", "conceal_clear")
M.map("Interface", "n", "cl0", "conceal_0")
M.map("Interface", "n", "cl1", "conceal_1")
M.map("Interface", "n", "cl2", "conceal_2")
M.map("Interface", "n", "cl3", "conceal_3")
M.map("Interface", "n", "gh", "ts_highlights")
-- M.map("Interface", "n", "gH", "ts_highlights")
M.map("Interface", "n", "gnD", "list_definitions") -- virtual
M.map("Interface", "n", "g0", "toc_definitions") -- virtual

M.map("System", "n", "<leader>iu", "update")
M.map("System", "n", "<leader>ii", "install")
M.map("System", "n", "<leader>is", "sync")
M.map("System", "n", "<leader>ic", "compile")
M.map("System", "n", "<leader>iC", "clean")
M.map("System", "n", "<leader>iS", "status")
M.map("System", "n", "<leader>ie", "edit")
M.map("System", "n", "<leader>iO", "shada_edit")

M.map("Format", "n", "<leader>[", "indent_all")
M.map("Format", "n", "<leader>]", "unindent_all")
M.map("Format", "n", "<leader>fx", "swap")
M.map("Format", "n", "<leader>fU", "uppercase2")
M.map("Format", "n", "<leader>fu", "lowercase2")
M.map("Format", "n", "<leader>fs", "snakecase")
M.map("Format", "n", "<leader>fk", "kebabcase")
M.map("Format", "n", "<leader>fc", "camelcase")
M.map("Format", "n", "<leader>fC", "camelbcase")
M.map("Format", "v", "<leader>fs", "v_snakecase")
M.map("Format", "v", "<leader>fk", "v_kebabcase")
M.map("Format", "v", "<leader>fc", "v_camelcase")
M.map("Format", "v", "<leader>fC", "v_camelbcase")
M.map("Format", "v", "<", "v_unindent")
M.map("Format", "v", ">", "v_indent")
M.map("Format", "n", "gu", "lowercase1") -- virtual
M.map("Format", "n", "gU", "uppercase1") -- virtual
M.map("Format", "n", "gR", "rename") -- virtual
M.map("Format", "n", "<C-Up>", "dial_increment1")
M.map("Format", "n", "<C-Down>", "dial_decrement1")
M.map("Format", "n", "<leader>fi", "dial_increment2")
M.map("Format", "n", "<leader>fd", "dial_decrement2")
M.map("Format", "v", "<C-Up>", "v_dial_increment1")
M.map("Format", "v", "<C-Down>", "v_dial_decrement1")
M.map("Format", "v", "<leader>fi", "v_dial_increment2")
M.map("Format", "v", "<leader>fd", "v_dial_decrement2")
M.map("Format", "v", "g<M-a>", "v_dial_increment_additional", { noremap = true, nowait = true })
M.map("Format", "v", "g<M-x>", "v_dial_decrement_additional", { noremap = true, nowait = true })

M.map("Unimpaired", "n", "yob", "toggle_background")
M.map("Unimpaired", "n", "yoc", "toggle_cursorline")
M.map("Unimpaired", "n", "yod", "toggle_diff")
M.map("Unimpaired", "n", "yoh", "toggle_search_highlight")
M.map("Unimpaired", "n", "yoi", "toggle_search_case_ignore")
M.map("Unimpaired", "n", "yol", "toggle_list")
M.map("Unimpaired", "n", "yon", "toggle_number")
M.map("Unimpaired", "n", "yor", "toggle_relative_number")
M.map("Unimpaired", "n", "yos", "toggle_spell_check")
M.map("Unimpaired", "n", "you", "toggle_cursorcolumn")
M.map("Unimpaired", "n", "yov", "toggle_virtualedit_text")
M.map("Unimpaired", "n", "yow", "toggle_word_wrap")
M.map("Unimpaired", "n", "yox", "toggle_crosshairs")
M.map("Unimpaired", "n", "]p", "paste_after_indent1")
M.map("Unimpaired", "n", "[p", "paste_before_indent1")
M.map("Unimpaired", "n", "]P", "paste_after_unindent1")
M.map("Unimpaired", "n", "[P", "paste_before_unindent1")
M.map("Unimpaired", "n", ">p", "paste_after_indent2")
M.map("Unimpaired", "n", ">P", "paste_before_indent2")
M.map("Unimpaired", "n", "<p", "paste_after_unindent2")
M.map("Unimpaired", "n", "<P", "paste_before_unindent2")
M.map("Unimpaired", "n", "=p", "paste_after_reindent")
M.map("Unimpaired", "n", "=P", "paste_before_reindent")
M.map("Unimpaired", "n", "]op", "paste_after")
M.map("Unimpaired", "n", "[op", "paste_before")
M.map("Unimpaired", "n", "yop", "paste_within")
M.map("Unimpaired", "n", "[a", "pairs_edit_prev_files")
M.map("Unimpaired", "n", "]a", "pairs_edit_next_files")
M.map("Unimpaired", "n", "[b", "pairs_prev_buffer")
M.map("Unimpaired", "n", "]b", "pairs_next_buffer")
M.map("Unimpaired", "n", "[l", "pairs_prev_location")
M.map("Unimpaired", "n", "]l", "pairs_next_location")
M.map("Unimpaired", "n", "[<C-L>", "pairs_prev_location_file")
M.map("Unimpaired", "n", "]<C-L>", "pairs_next_location_file")
M.map("Unimpaired", "n", "[q", "pairs_prev_qf")
M.map("Unimpaired", "n", "]q", "pairs_next_qf")
M.map("Unimpaired", "n", "[<C-Q>", "pairs_prev_qf_file")
M.map("Unimpaired", "n", "]<C-Q>", "pairs_next_qf_file")
M.map("Unimpaired", "n", "[t", "pairs_prev_tag")
M.map("Unimpaired", "n", "]t", "pairs_next_tag")
M.map("Unimpaired", "n", "[<C-T>", "pairs_prev_tag_window")
M.map("Unimpaired", "n", "]<C-T>", "pairs_next_tag_window")

-- vim.cmd([[nnoremap / /\v]])
-- vim.cmd([[vnoremap / /\v]])
-- vim.cmd([[cnoremap %s/ %smagic/]])
-- vim.cmd([[cnoremap \>s/ \>smagic/]])

-- vim.cmd([[nnoremap :g/ :g/\v]])
-- vim.cmd([[nnoremap :g// :g//]])
-- vim.cmd([[vnoremap :g// :g//]])
-- let g:VeryMagic = 0
-- nnoremap / /\v
-- nnoremap ? ?\v
-- vnoremap / /\v
-- vnoremap ? ?\v
-- " If I type // or ??, I don't EVER want \v, since I'm repeating the previous
-- " search.
-- noremap // //
-- noremap ?? ??
-- " no-magic searching
-- noremap /v/ /\V
-- noremap ?V? ?\V
-- TODO: make this an option
-- M.map("Search", "n", "/", "search_magic_1")
-- M.map("Search", "v", "/", "search_magic_2")
-- M.map("Search", "c", "%s/", "sub_magic_1")
M.map("Search", "n", "<M-S>", "sub_magic_3")
M.map("Search", "v", "<M-S>", "sub_magic_4")
-- ,/ : toggle whole word matching
-- ,/ visual block search within
-- ClearAllButMatches, SearchForAnyLine
-- visual g* g# to search for selected text
-- Substituting
-- Visual && to do :&& on selected text (repeat last substitute with the same flags).

-- Make g& work how you'd expect on visual selections: only act on the visual selection.
-- Unlike &&, it uses the current search query.
M.map("Search", "n", "_", "rmhl")
M.map("Search", "n", "<M-_>", "rmhl_refresh")
M.map("Search", "n", "n", "next")
M.map("Search", "n", "N", "prev")
M.map("Search", "n", "*", "cursor_next1")
M.map("Search", "n", "#", "cursor_prev1")
M.map("Search", "n", "g*", "cursor_next2")
M.map("Search", "n", "g#", "cursor_prev2")
M.map("Search", "n", "gn", "last_match")
M.map("Search", "n", "<leader>sr", "cursor_replace")

M.map("Git", "n", "<leader>gf", "telescope_files")
-- M.map("Git", "n", "<leader>gc", "telescope_commits")
-- M.map("Git", "n", "<leader>gC", "telescope_bcommits")
M.map("Git", "n", "<leader>gb", "telescope_branches")
M.map("Git", "n", "<leader>gs", "telescope_status")
M.map("Git", "n", "<leader>gn", "signs_next_hunk")
M.map("Git", "n", "<leader>gp", "signs_prev_hunk")
M.map("Git", "n", "<leader>gv", "signs_preview_hunk")
M.map("Git", "n", "<leader>gr", "signs_reset_hunk")
M.map("Git", "n", "<leader>gR", "signs_reset_buffer")
M.map("Git", "n", "<C-g>", "telescope_bcommits")
M.map("Git", "n", "<A-g>", "telescope_commits")
-- Git log, Git diff, Git difftool, Git mergetool, Git blame, Gdiff, Gedit HEAD-3:%, Ggrep
-- http://vimcasts.org/episodes/fugitive-vim-resolving-merge-conflicts-with-vimdiff/
-- DiffviewOpen, DiffviewFileHistory
-- g!;
-- :DiffviewOpen HEAD~2
-- :DiffviewOpen HEAD~4..HEAD~2
-- :DiffviewOpen d4a7b0d
-- :DiffviewOpen d4a7b0d..519b30e
-- :DiffviewOpen origin/main...HEAD
-- :DiffviewOpen HEAD~2 -- lua/diffview plugin
-- :DiffviewOpen d4a7b0d -uno

-- nmap("Pickers", "<C-d>", "<cmd>FzfPreviewGitCurrentLogsRpc<cr>", "picker_buffer_log", "git buffer log")
M.map("Pickers", "n", "<C-p>", "files_tele")
M.map("Pickers", "n", "<A-p>", "files_fzflua")
M.map("Pickers", "n", "<C-\\>", "files_directory_tele")
M.map("Pickers", "n", "<M-i>", "notifications_teleivy")
M.map("Pickers", "n", "<A-o>", "home_files_fzfprev")
M.map("Pickers", "n", "<C-U>", "frecency_files_teleivy")
M.map("Pickers", "n", "<A-U>", "mru_files_teleivy")
M.map("Pickers", "n", "<C-E>", "buffers_teleleaderf_nopreview")
M.map("Pickers", "n", "<A-j>", "jumps_fzfprev")
M.map("Pickers", "n", "<C-_>", "telescope_live_search")
-- M.map("Pickers", "n", "<M-/>", "telescope_grep_search")
M.map("Pickers", "n", "<M-/>", "helptags_tele")
M.map("Pickers", "n", "<A-m>", "location_list_fzfprev")
-- M.map("Pickers", "n", "<A-u>", "commands_fzfprev")
-- M.map("Pickers", "n", "<C-c>", "commit_log_fzfprev")
-- M.map("Pickers", "n", "<C-e>", "buffers_fzflua")
-- M.map("Pickers", "n", "<A-e>", "sessions")
-- M.map("Pickers", "n", "<M-S>", "fzf_live_search_2")
-- M.map("Pickers", "n", "<A-g>", "git_status_fzfprev")
-- M.map("Pickers", "n", "<M-g>", "commit_log_telescope")
-- M.map("Pickers", "n", "<C-g>", "telescope_live_search")
M.map("Pickers", "n", "<leader>Fb", "find_buffer")
M.map("Pickers", "n", "<leader>Fc", "find_colorscheme_tele")
M.map("Pickers", "n", "<leader>Ff", "find_file_tele")
M.map("Pickers", "n", "<leader>Fg", "grep_text_tele")
M.map("Pickers", "n", "<leader>Fh", "find_helptags_tele")
M.map("Pickers", "n", "<leader>Fn", "find_nvim_dotfiles")
M.map("Pickers", "n", "<leader>Fo", "find_oldfiles")
M.map("Pickers", "n", "<leader>Fm", "find_mappings_n")
M.map("Pickers", "n", "<leader>Fmi", "find_mappings_i")
M.map("Pickers", "n", "<leader>Fmv", "find_mappings_v")
M.map("Pickers", "n", "<leader>Fmo", "find_mappings_o")

vim.cmd("cabbrev T Telescope")

M.map("Zettel", "n", "<cr>", "enter2")
M.map("Zettel", "n", "gzn", "new")
M.map("Zettel", "n", "gzu", "edit_last")
M.map("Zettel", "n", "gzb", "backlinks_search_telescope")
M.map("Zettel", "n", "gzN", "edit_new_cword")
M.map("Zettel", "n", "gzr", "refresh_virtual_titles")
M.map("Zettel", "n", "gzR", "refresh_cache")
M.map("Zettel", "n", "gzU", "prev_history")
M.map("Zettel", "n", "gzP", "next_history")
M.map("Zettel", "n", "gzz", "zettel_search_telescope")
M.map("Zettel", "n", "gzZ", "tag_search_telescope")
-- M.map("Zettel", "n", "gzz", "edit_select")
-- M.map("Zettel", "n", "gzZ", "edit_backlink")
M.map("Zettel", "n", "gzo", "edit_cursor")
M.map("Zettel", "n", "gzS", "content_search_cursor_fzf")
M.map("Zettel", "n", "gzl", "insert_last1")
M.map("Zettel", "n", "gzi", "index")
M.map("Zettel", "n", "gzL", "insert_last2")
M.map("Zettel", "n", "gzI", "insert_next")
M.map("Zettel", "n", "gzv", "toggle_backlinks")
M.map("Zettel", "n", "gzt", "tag_new")
M.map("Zettel", "n", "gzT", "tag_select")
M.map("Zettel", "n", "gzts", "tag_search_fzf")
M.map("Zettel", "v", "gzN", "visual_new")
-- NOTE: removed <expr>
M.map("Zettel", "i", "<c-x><c-u>", "insert_last")
M.map("Zettel", "i", "<c-x><c-y>", "insert_select")


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

M.map("Debug", "n", "<F8>", "continue1")
M.map("Debug", "n", "<F9>", "step_over1")
M.map("Debug", "n", "<F10>", "step_into1")
M.map("Debug", "n", "<F11>", "step_out1")
M.map("Debug", "n", "<F12>", "toggle_ui1")
M.map("Debug", "n", "<S-F12>", "repl_run_last")
M.map("Debug", "n", "<F5>", "toggle_breakpoint3")
M.map("Debug", "n", "yob", "toggle_breakpoint4")
M.map("Debug", "n", "<leader>bp", "set_breakpoint")
M.map("Debug", "n", "<leader>bb", "toggle_breakpoint1")
M.map("Debug", "n", "<leader>bt", "toggle_breakpoint2")
M.map("Debug", "n", "<leader>bc", "conditional_breakpoint")
M.map("Debug", "n", "<leader>bl", "logging_breakpoint")
M.map("Debug", "n", "<leader>dt", "toggle_ui2")
M.map("Debug", "n", "<leader>d ", "start_lua")
M.map("Debug", "n", "<leader>ds", "toggle_ui_sidebar")
M.map("Debug", "n", "<leader>dc", "continue2")
M.map("Debug", "n", "<leader>di", "step_into2")
M.map("Debug", "n", "<leader>do", "step_over2")
M.map("Debug", "n", "<leader>dr", "repl_toggle")
M.map("Debug", "n", "<leader>dS", "debug_start")
M.map("Debug", "n", "<M-CR>", "tmux_send")

M.map("LSP", "n", "K", "hover_doc1")
M.map("LSP", "n", "gd", "definitions")
M.map("LSP", "n", "gD", "declaration")
M.map("LSP", "n", "gk", "hover_doc2")
M.map("LSP", "n", "go", "organize_imports")
M.map("LSP", "n", "gr", "references")
M.map("LSP", "n", "gs", "signature_help1")
M.map("LSP", "n", "gy", "buffer_definitions")
M.map("LSP", "n", "[d", "diagnostic_prev")
M.map("LSP", "n", "]d", "diagnostic_next")
M.map("LSP", "n", "<leader>la", "code_action")
M.map("LSP", "n", "<leader>lA", "range_code_action")
M.map("LSP", "n", "<leader>ld", "doc_diagnostics")
M.map("LSP", "n", "<leader>lD", "workspace_diagnostics")
M.map("LSP", "n", "<leader>le", "view_log")
M.map("LSP", "n", "<leader>ll", "line_diagnostics")
M.map("LSP", "n", "<leader>lf", "finder2")
M.map("LSP", "n", "<leader>li", "server_info")
M.map("LSP", "n", "<leader>lk", "signature_help2")
M.map("LSP", "n", "<leader>lF", "format_buffer")
M.map("LSP", "n", "<leader>lp", "preview_definition")
M.map("LSP", "n", "<leader>lr", "rename")
M.map("LSP", "n", "<leader>ls", "doc_symbols")
M.map("LSP", "n", "<leader>lS", "workspace_symbols")
M.map("LSP", "n", "<leader>l.a", "stop_all")
M.map("LSP", "n", "<C-t>", "doc_diagnostics_ivy")
M.map("LSP", "n", "<A-T>", "doc_diagnostics_2")


vim.api.nvim_set_keymap("n", "<leader>xx", "<cmd>Trouble<cr><bar><cmd>VimadeBufDisable<cr><bar><cmd>wincmd p<cr>",
  { silent = true, noremap = true }
)
vim.api.nvim_set_keymap("n", "<leader>xw", "<cmd>Trouble lsp_workspace_diagnostics<cr><bar><cmd>VimadeBufDisable<cr><bar><cmd>wincmd p<cr>",
  { silent = true, noremap = true }
)
vim.api.nvim_set_keymap("n", "<leader>xd", "<cmd>Trouble lsp_document_diagnostics<cr><bar><cmd>VimadeBufDisable<cr><bar><cmd>wincmd p<cr>",
  { silent = true, noremap = true }
)
vim.api.nvim_set_keymap("n", "<leader>xl", "<cmd>Trouble loclist<cr><bar><cmd>VimadeBufDisable<cr><bar><cmd>wincmd p<cr>",
  { silent = true, noremap = true }
)
vim.api.nvim_set_keymap("n", "<leader>xq", "<cmd>Trouble quickfix<cr><bar><cmd>VimadeBufDisable<cr><bar><cmd>wincmd p<cr>",
  { silent = true, noremap = true }
)
vim.api.nvim_set_keymap("n", "<leader>xr", "<cmd>Trouble lsp_references<cr><bar><cmd>VimadeBufDisable<cr><bar><cmd>wincmd p<cr>",
  { silent = true, noremap = true }
)

-- TODO: enable cycling
-- jump to the previous/next item, skipping the groups
vim.api.nvim_set_keymap("n", "[x",
  "<cmd>lua require('trouble').previous({ skip_groups = true, jump = true, })<cr>",
  { silent = true, noremap = true }
)
vim.api.nvim_set_keymap("n", "]x",
  "<cmd>lua require('trouble').next({ skip_groups = true, jump = true, })<cr>",
  { silent = true, noremap = true }

)

vim.cmd([[vmap <M-a> <C-a> ]])
vim.cmd([[vmap <M-x> <C-x> ]])
vim.cmd([[vmap g<M-a> g<C-a> ]])
vim.cmd([[vmap g<M-x> g<C-x> ]])

-- print(M.inspect(M.whichkey_map))
-- print(M.inspect(M.stats))

-- local whichkeys = M.whichkeyDump()
-- print("OK:   " .. length(whichkeys.ok) .. "\nTODO: " .. length(whichkeys.todo))

-- yoinks
-- Change current yank and see a preview of it in the status bar
-- " Also replace the default gp with yoink paste so we can toggle paste in this case too
-- You might also want to add a map for toggling whether the current paste is formatted or not:
-- normal p P will swap/cycle through yoinks

vim.cmd([[nmap <expr> p yoink#canSwap() ? '<plug>(YoinkPostPasteSwapBack)' : '<plug>(YoinkPaste_p)']])
vim.cmd([[nmap <expr> P yoink#canSwap() ? '<plug>(YoinkPostPasteSwapForward)' : '<plug>(YoinkPaste_P)']])
-- TODO: paste linewise within
-- Paste yanked line without line breaks before/after cursor position
-- inoremap <c-a> <c-r>1<esc>k$Jxi
vim.cmd([[nnoremap gp <plug>(YoinkPaste_gp) \| kJxJx]])
vim.cmd([[nnoremap gP <plug>(YoinkPaste_gP) \| kJxJx]])
vim.cmd([[nmap [y <plug>(YoinkRotateBack)]])
vim.cmd([[nmap ]y <plug>(YoinkRotateForward)]])

-- vim.cmd([[nmap y <plug>(YoinkYankPreserveCursorPosition) \| <cmd>call system("xsel -ip", getreg("@+"))<cr> ]])
-- vim.cmd([[xmap y <plug>(YoinkYankPreserveCursorPosition) \| <cmd>call system("xsel -ip", getreg("@+"))<cr> ]])
vim.cmd([[nmap y <plug>(YoinkYankPreserveCursorPosition)]])
vim.cmd([[xmap y <plug>(YoinkYankPreserveCursorPosition)]])

-- hitting <c-=> after a paste will toggle between formatted and unformatted (equivalent to using the = key).
-- By default pastes will not be formatted until you toggle it afterwards using <c-=> (however you can also change this with the yoinkAutoFormatPaste setting as described below)
-- vim.cmd([[nmap = <plug>(YoinkPostPasteToggleFormat)]])

M.registerWhichkey()

--
-- TODO: come up with iswap key bindings
-- ISwap, ISwapWith: ists, arrays, function arguments, function parameters

--- Spectre
-- vim.api.nvim_set_keymap('n', '<leader>S', ":lua require('spectre').open()<CR>", {noremap = true, silent = false})
-- vim.api.nvim_set_keymap('v', '<leader>S', ":lua require('spectre').open_visual()<CR>", {noremap = true, silent = false})
-- vim.api.nvim_set_keymap('n', '<leader>Sw', "viw:lua require('spectre').open_visual()<CR>", {noremap = true, silent = false})
-- vim.api.nvim_set_keymap('n', '<leader>sp', "viw:lua require('spectre').open_file_search()<CR>", {noremap = true, silent = false})- vim.api.nvim_set_keymap('n', '<leader>to', ':TodoTelescope<CR>', {noremap = true, silent = false})
-- -- Fterm
-- vim.api.nvim_set_keymap('n', '<F5>', '<CMD>lua require("FTerm").toggle()<CR>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('t', '<F5>', '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>', { noremap = true, silent = true })

-- vim.api.nvim_set_keymap('n', '<leader>gc', ':Octo issue create<CR>', {noremap = true, silent = false})
-- vim.api.nvim_set_keymap('n', '<leader>i', ':Octo issue list<CR>', {noremap = true, silent = false})

-- vim.api.nvim_set_keymap("n", "<C-p>", ":lua FindFile()<CR>", {silent = true, noremap = true})
-- vim.api.nvim_set_keymap("n", "<leader>ff", ":lua FindBuffer()<CR>", {silent = true, noremap = true})
-- vim.api.nvim_set_keymap("n", "<leader>fg", ":lua FindString()<CR>", {silent = true, noremap = true})
-- vim.api.nvim_set_keymap("n", "<leader>fl", ":lua FindLive()<CR>", {silent = true, noremap = true})
-- vim.api.nvim_set_keymap("n", "<leader>fd", ":lua FindDot()<CR>", {silent = true, noremap = true})
-- vim.api.nvim_set_keymap("n", "<leader>fb", ":lua FindGit()<CR>", {silent = true, noremap = true})
-- map("n", "<leader>fn", ":lua require('utils.core').search_nvim()<CR>")
-- map("n", "<leader>b", ":Telescope buffers show_all=true sort_lastued=true<CR>")
-- ["p"] = {
--   name = "+personal-config",
--   ["n"] = { "<cmd>e ~/.config/nvim/lua/config.lua<cr>", "nvim" },
--   ["s"] = { "<cmd>e ~/.shell/.zshrc<cr>", "shell" },
-- },
-- ["gf"] = {"<cmd>TSLspFixCurrent<cr>", "eslint fix"},
-- ["gr"] = {"<cmd>TSLspRenameFile<cr>", "rename file"},
-- ["gi"] = {"<cmd>TSLspImportAll<cr>", "import all"},
-- vim.api.nvim_set_keymap("n", "<Leader>d", ":Sayonara<CR>", {noremap = true, silent = true})
-- vim.cmd([[xmap <leader>s <plug>(scratch-selection-reuse)]])
-- vim.cmd([[xmap <leader>S <plug>(scratch-selection-clear)]])
-- :map <C-X> <ESC>:x<CR>
-- :imap <C-X> <ESC>:x<CR>
-- nnoremap <leader>e :exe getline(line('.'))<cr>
-- nmap("Format", "^[^M", "] ", "format_insert_line", "insert line")
-- map("n", "<leader>tS", ":luafile %<CR>", { silent = false })
-- map("n", ",gdb", "<Plug>(EasyAlign)", {noremap = false, silent = true})
-- vim.cmd([[xmap <leader>s <plug>(scratch-selection-reuse)]])
-- vim.cmd([[xmap <leader>S <plug>(scratch-selection-clear)]])
--   ["n ]c"] = {expr = true, '&diff ? \']c\' : \'<cmd>lua require"gitsigns".next_hunk()<CR>\''},
--   ["n [c"] = {expr = true, '&diff ? \'[c\' : \'<cmd>lua require"gitsigns".prev_hunk()<CR>\''},
--   ["n <leader>hs"] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
--   ["n <leader>hu"] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
--   ["n <leader>hb"] = '<cmd>lua require"gitsigns".blame_line()<CR>',
--   -- Text objects
--   ["o ih"] = ':<C-U>lua require"gitsigns".text_object()<CR>',
--   ["x ih"] = ':<C-U>lua require"gitsigns".text_object()<CR>'

-- ocal log = [[\%C(yellow)\%h\%Cred\%d \%Creset\%s \%Cgreen(\%ar) \%Cblue\%an\%Creset]]
-- map('n', '<leader>g<space>', ':Git ')
-- map('n', '<leader>gd', '<cmd>Gvdiffsplit<CR>')
-- map('n', '<leader>gg', '<cmd>Git<CR>')
-- map('n', '<leader>gl', fmt('<cmd>term git log --graph --all --format="%s"<CR><cmd>start<CR>',
-- ocal log = [[\%C(yellow)\%h\%Cred\%d \%Creset\%s \%Cgreen(\%ar) \%Cblue\%an\%Creset]]
-- map('n', '<leader>g<space>', ':Git ')
-- map('n', '<leader>gd', '<cmd>Gvdiffsplit<CR>')
-- map('n', '<leader>gg', '<cmd>Git<CR>')
-- map('n', '<leader>gl', fmt('<cmd>term git log --graph --all --format="%s"<CR><cmd>start<CR>',

-- nmap("REPL", "<leader>y<cr>", "<Plug>(ripple_open_repl)", "repl_open", "repl open")
-- nmap("REPL", "<leader>yr", "<Plug>(ripple_send_motion)", "repl_send_motion", "repl send motion")
-- nmap("REPL", "<leader>yp", "<Plug>(ripple_send_previous)", "repl_send_previous", "repl send previous")
-- nmap("REPL", "<leader>yrr", "<Plug>(ripple_send_line)", "repl_send_line", "repl send line")
-- nmap("REPL", "<leader>yr<cr>", "<Plug>(ripple_send_buffer)", "repl_send_buffer", "repl send buffer")
-- vmap("REPL", "<leader>r", "<Plug>(ripple_send_selection)", "repl_send_visual", "repl send visual")

-- vmap("Movement", "K", "<cmd>move '<-2<CR>gv=gv<cr>", "movement_selected_up", "move selected text up")
-- vmap("Movement", "J", "<cmd>move '<+1<CR>gv=gv<cr>", "movement_selected_down", "move selected text down")
-- nmap("Navigation", ";", ":", "navigation_quick_cmd", "quickly open up command line", true)
-- nmap("Navigation", ":", ":<C-f>", "navigation_quick_cmdwin", "quickly open command line window")

-- -- Directory
-- wk.register({
--     d = {
--         name = "directory",
--         a = "add directory",
--         l = "list directories",
--         r = "remove directory",
--     }

-- }, { prefix = "<leader>" })

-- nmap cs  <Plug>Csurround
-- nmap cS  <Plug>CSurround
-- nmap ys  <Plug>Ysurround
-- nmap yS  <Plug>YSurround
-- nmap yss <Plug>Yssurround
-- nmap ySs <Plug>YSsurround
-- nmap ySS <Plug>YSsurround

-- xmap S   <Plug>VSurround
-- xmap gS  <Plug>VgSurround

-- nmap sa  <Plug>Ysurround
-- nmap sA  <Plug>YSurround
-- nmap sas <Plug>Yssurround
-- nmap saS <Plug>YSsurround
-- nmap sAA <Plug>YSsurround


-- TODO: maybe gn/gp will be better
-- nmap <leader>qq	<Plug>(qf_qf_toggle)
-- nmap gn		<Plug>(qf_qf_next)
-- nmap gp		<Plug>(qf_qf_previous)
-- populate quickfix list with diagnostics local method =

-- "textDocument/publishDiagnostics" local default_callback = vim.lsp.callbacks[method]
--  vim.lsp.callbacks[method] = function(err, method, result, client_id) default_callback(err, method, result, client_id)
--  if result and result.diagnostics then local item_list = {} for _, v in ipairs(result.diagnostics)
--  do local fname = result.uri table.insert(item_list, { filename = fname, lnum = v.range.start.line + 1, col = v.range.start.character + 1; text = v.message; }) end
--  local old_items = vim.fn.getqflist()
--  for _, old_item in ipairs(old_items)
--  do local bufnr = vim.uri_to_bufnr(result.uri)
--  if vim.uri_from_bufnr(old_item.bufnr) ~= result.uri then
--    table.insert(item_list, old_item)
--    end end vim.fn.setqflist({}, ' ', { title = 'LSP'; items = item_list; })
--  end end
