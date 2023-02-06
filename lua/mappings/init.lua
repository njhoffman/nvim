vim.import("mapper", function(M)
  -- M.plugin('treesitter', function()
  --   return {
  --     refactor = {
  --       goto_definition = "gtd",
  --       list_definitions = "gtD",
  --       list_definitions_toc = "gt0",
  --       goto_next_usage = "<a-*>",
  --       goto_previous_usage = "<a-#>"
  --     }
  --   }
  -- end)

  -- virtual keymaps to document other/default keymaps
  -- function M.treesitter_text_objects()
  --   require("nvim-treesitter.configs").setup {
  --     textobjects = {
  --       select = {
  --         enable = true,
  --         lookahead = true,
  --         -- The keymaps are defined in the configuration table, no way to get our Mapper in there !
  --         keymaps = {
  --           ["af"] = "@function.outer",
  --           ["if"] = "@function.inner",
  --           ["ac"] = "@class.outer",
  --           ["ic"] = "@class.inner",
  --         },
  --       },
  --     },
  --   }
  --   -- Hopefully we can still document them
  --   Mapper.map_virtual("o", "af", "", {}, "Navigation", "treesitter_function_outer", "Function outer motion")
  --   Mapper.map_virtual("o", "if", "", {}, "Navigation", "treesitter_function_inner", "Function inner motion")
  --   Mapper.map_virtual("o", "ac", "", {}, "Navigation", "treesitter_class_outer", "Class outer motion")
  --   Mapper.map_virtual("o", "ic", "", {}, "Navigation", "treesitter_class_inner", "Class inner motion")
  -- end

  M.map("Navigation", "n", ";", "quick_cmd", { nowait = true })
  M.map("Navigation", "n", "-+:", "quick_cmdwin2", { nowait = true })
  M.map("Navigation", "v", ";", "quick_cmd", { nowait = true })
  M.map("Navigation", "v", ":", "quick_cmdwin", { nowait = true })
  M.map("Navigation", "n", "<BS>", "buffer_last")
  M.map("Navigation", "n", "H", "buffer_left2")
  M.map("Navigation", "n", "L", "buffer_right2")
  M.map("Navigation", "n", "!!", "repeat_cmd")
  M.map("Navigation", "n", "<M-T>", "restart_target")
  M.map("Navigation", "n", "<M-r>", "restart")
  M.map("Navigation", "n", "<M-x>", "write_exit")
  M.map("Navigation", "n", "<A-x>", "nowrite_exit")
  M.map("Navigation", "n", "<C-d>", "bufclose_nosave")
  M.map("Navigation", "s", "<C-s>", "quick_save")
  M.map("Navigation", "v", "<C-s>", "quick_save")
  M.map("Navigation", "n", "<C-s>", "quick_save")
  M.map("Navigation", "i", "<C-s>", "quick_save")
  -- M.map("Navigation", "n", "ZZ", "write_exit_virt")
  M.map("Navigation", "n", "<leader>x", "bufclose_save")
  M.map("Navigation", "n", "<leader>z", "nowrite_exit2")
  M.map("Navigation", "n", "<leader>!", "bufclose_all")
  M.map("Navigation", "n", "<M-d>", "write_exit")
  -- M.map("Navigation", "n", "<M-d>", "bufclose_all2")
  M.map("Navigation", "n", "<leader>*", "bufwrite_all")
  M.map("Navigation", "n", "<leader>w", "bufwrite_noa")
  M.map("Navigation", "n", "<leader>.", "open_altfile")
  M.map("Navigation", "n", "<leader>fn", "open_newfile")
  M.map("Navigation", "n", "<leader>fs", "open_newsplit")
  M.map("Navigation", "n", "<leader>fp", "print_filename")
  M.map("Navigation", "n", "gf", "goto_fileline")
  M.map("Navigation", "n", "gx", "open_file_virt")
  M.map("Navigation", "n", "<leader>cd", "cd_buffer")
  M.map("Navigation", "n", "<leader>cdh", "cd_home")
  M.map("Navigation", "n", "<leader>cdr", "cd_root")

  -- M.map("Window", "c", "<C-[>", "cmd_open_cedit2")
  -- M.map("Window", "c", "<c-d>", "cmdwin_close")
  M.map("Window", "c", "<c-d>", "cmd_close")
  M.map("Window", "c", "<c-s>", "cmd_save")
  M.map("Window", "c", "<c-y>", "cmd_yank")
  M.map("Window", "c", "", "cmd_beginning")
  M.map("Window", "c", "<C-n>", "cmd_next1") -- virtual
  M.map("Window", "c", "<C-p>", "cmd_prev1") -- virtual
  M.map("Window", "c", "<tab>", "cmd_next2") -- virtual
  M.map("Window", "c", "<s-tab>", "cmd_prev2") -- virtual
  M.map("Window", "c", "<M-f>", "cmd_open_cwin1")
  M.map("Window", "c", "<M-b>", "cmd_open_cwin2") -- same keycode as Ctrl-Shift-[
  M.map("Window", "c", "<M-g>", "cmd_insert_filename")
  -- M.map("Window", "c", "<M-d>", "cmd_insert_filename")
  M.map("Window", "n", "<M-f>", "open_cwin")
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

  -- aw	a word (with white space)			|v_aw|
  -- iw	inner word					|v_iw|
  -- aW	a WORD (with white space)			|v_aW|
  -- iW	inner WORD					|v_iW|
  -- as	a sentence (with white space)			|v_as|
  -- is	inner sentence					|v_is|
  -- ap	a paragraph (with white space)			|v_ap|
  -- ip	inner paragraph					|v_ip|
  -- ab	a () block (with parentheses)			|v_ab|
  -- ib	inner () block					|v_ib|
  -- aB	a {} block (with braces)			|v_aB|
  -- iB	inner {} block					|v_iB|
  -- at	a <tag> </tag> block (with tags)		|v_at|
  -- it	inner <tag> </tag> block			|v_it|
  -- a<	a <> block (with <>)				|v_a<|
  -- i<	inner <> block					|v_i<|
  -- a[	a [] block (with [])				|v_a[|
  -- i[	inner [] block					|v_i[|
  -- a"	a double quoted string (with quotes)		|v_aquote|
  --   i"	inner double quoted string			|v_iquote|
  -- a'	a single quoted string (with quotes)		|v_a'|
  -- i'	inner simple quoted string			|v_i'|
  -- a`	a string in backticks (with backticks)		|v_a`|
  -- i`	inner string in backticks			|v_i`|

  -- In linewise visual mode, the
  -- surroundings are placed on separate lines and indented.  In blockwise visual
  -- mode, each line is surrounded.

  -- M.map("Surround", "n", "sAS", "surround_around_line_trim_nl1")
  -- M.map("Surround", "n", "sA", "surround_around_nl")
  -- M.map("Surround", "n", "yS", "you_surround_nl")
  -- M.map("Surround", "n", "sa", "surround_around")
  M.map("Surround", "n", "ySS", "you_surround_line_trim_nl1")
  M.map("Surround", "n", "ysS", "you_surround_line_trim_nl2")
  M.map("Surround", "n", "yss", "you_surround_line_trim")
  M.map("Surround", "n", "saS", "surround_around_line_trim_nl2")
  M.map("Surround", "n", "sas", "surround_around_line_trim")
  M.map("Surround", "x", "s", "surround_visual_add_inner")
  M.map("Surround", "x", "S", "surround_visual_add_outer")
  M.map("Surround", "x", "gS", "surround_visual_add_newline")
  M.map("Surround", "n", "ds", "delete_surround")
  M.map("Surround", "n", "ds)", "delete_paren")
  M.map("Surround", "n", "ds(", "delete_paren")
  M.map("Surround", "n", "ds}", "delete_brace")
  M.map("Surround", "n", "ds{", "delete_brace")
  M.map("Surround", "n", "ds]", "delete_bracket")
  M.map("Surround", "n", "ds[", "delete_bracket")
  M.map("Surround", "n", "dsb", "delete_block")
  M.map("Surround", "n", "dsB", "delete_block")
  M.map("Surround", "n", "dsf", "delete_func")
  M.map("Surround", "n", 'ds"', "delete_quote")
  M.map("Surround", "n", "ds`", "delete_grave")
  M.map("Surround", "n", "ds'", "delete_single_quote")
  -- M.Map("Surround", "n", "dst", "delete_tag")
  -- TODO: cs)] ?
  M.map("Surround", "n", "cs", "change_surround")
  M.map("Surround", "n", "cs)", "change_paren")
  M.map("Surround", "n", "cs(", "change_paren")
  M.map("Surround", "n", "cs}", "change_brace")
  M.map("Surround", "n", "cs{", "change_brace")
  M.map("Surround", "n", "cs]", "change_bracket")
  M.map("Surround", "n", "cs[", "change_bracket")
  M.map("Surround", "n", "csb", "change_block")
  M.map("Surround", "n", "csB", "change_block")
  M.map("Surround", "n", "csf", "change_func")
  M.map("Surround", "n", 'cs"', "change_quote")
  M.map("Surround", "n", "cs`", "change_grave")
  M.map("Surround", "n", "cs'", "change_single_quote")
  -- M.Map("Surround", "n", "cst", "change_tag")

  M.map("Movement", "i", "jk", "quick_insert_esc1")
  M.map("Movement", "i", "kj", "quick_insert_esc2")
  M.map("Movement", "i", "<C-u>", "c_u_undo_friendly") -- Make <C-u> undo-friendly
  M.map("Movement", "i", "<C-w>", "c_w_undo_friendly") -- Make <C-w> undo-friendly)

  -- Add undo break-points
  vim.keymap.set("i", ",", ",<c-g>u")
  vim.keymap.set("i", ".", ".<c-g>u")
  vim.keymap.set("i", ";", ";<c-g>u")

  M.map("Movement", "n", "D", "delete_end")
  -- M.map("Movement", "v", "$", "select_end_no_eol")
  M.map("Movement", "v", "al", "select_a_line")
  M.map("Movement", "v", "il", "select_inside_line")
  M.map("Movement", "o", "al", "op_a_line", { noremap = false })
  M.map("Movement", "o", "il", "op_inside_line", { noremap = false })
  M.map("Movement", "n", "<C-f>", "scroll_forwards", { noremap = false })
  M.map("Movement", "n", " ", "scroll_forwards2", { noremap = false })
  M.map("Movement", "n", "<C-b>", "scroll_backwards", { noremap = false })
  -- M.map("Movement", "n", "<space>", "scroll_forwardsx3", {noremap = false})
  M.map("Movement", "n", "G", "scroll_bottom", { noremap = false })
  M.map("Movement", "n", "gg", "scroll_top", { noremap = false })

  -- get last copied text
  M.map("Movement", "n", "gv", "select_last_visual")
  -- vim.cmd([[nnoremap <expr> g<c-v> '`[' . strpart(getregtype(), 0, 1) . '`]']])

  M.map("Movement", "n", "g<M-g>", "ascii")
  M.map("Movement", "n", "gA", "ascii_2")
  M.map("Movement", "n", "gi", "last_insertion") -- virtual
  M.map("Movement", "n", "gI", "begin_insertion") -- virtual
  M.map("Movement", "n", "gv", "last_visual") -- virtual
  M.map("Movement", "n", "g<M-G>", "total_counts") -- virtual
  -- x  <CR>        *@:lua require'nvim-treesitter.incremental_selection'.scope_incremental()<CR>
  -- x  <CR>        * <Cmd>lua require'nvim-treesitter.incremental_selection'.scope_incremental()<CR>
  -- virtual until treesitter integration figured out
  M.map("Movement", "n", "<CR>", "incremental_selection_init")
  M.map("Movement", "x", "<TAB>", "incremental_selection_scope")
  M.map("Movement", "x", "<CR>", "incremental_selection_expand")
  M.map("Movement", "x", "<S-TAB>", "incremental_selection_shrink")
  M.map("Movement", "n", "<leader>si", "iswap")
  M.map("Movement", "n", "<leader>sw", "iswap_with")
  M.map("Movement", "n", "<M-}>", "iswap_with2")

  -- M.map("Movement", "n", "vv", "incremental_selection_init2", { noremap = true, silent = true })
  -- M.map("Movement", "x", "v", "incremental_selection_node2", { noremap = false, silent = true })
  -- M.map("Movement", "x", "V", "incremental_selection_shrink2", { noremap = false, silent = true })
  -- vim.cmd([[
  --   nnoremap <buffer> v <cmd>lua require('nvim-treesitter.incremental_selection').init_selection()<cr>
  --   xnoremap <buffer> + <cmd>lua require('nvim-treesitter.incremental_selection').scope_incremental()<cr>
  --   xnoremap <buffer> = <cmd>lua require('nvim-treesitter.incremental_selection').node_decremental()<cr>
  -- ]])

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
  M.map("Movement", "n", "<leader>pp", "paste_primary")
  M.map("Movement", "n", "<leader>pc", "paste_comment")
  M.map("Movement", "n", "<leader>pm", "paste_mode_toggle")
  -- M.map("Movement", "n", "<M-,>", "qfc_prev")
  -- M.map("Movement", "n", "<M-.>", "qfc_next")
  -- M.map("Movement", "n", "<M-/>", "qfc_toggle")
  M.map("Movement", "n", "<C-q>", "qfc_toggle")
  M.map("Movement", "n", "<M-'>", "hop_to_word")
  M.map("Movement", "n", "<M-;>", "hop_to_line")
  M.map("Movement", "v", "<M-'>", "hop_to_word")
  M.map("Movement", "v", "<C-X>", "swap_visual_block")

  -- M.map("Movement", "n", "<M-\">", "hop_to_line")
  -- M.map("Movement", "n", "<M-;>", "hop_to_word")
  -- M.map("Movement", "n", "<M-:>", "hop_to_line")
  -- vim.api.nvim_set_keymap('n', '<M-;>', "<>cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>", {})
  -- vim.api.nvim_set_keymap('n', 'F', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>", {})

  M.map("Interface", "n", '""', "registers")
  M.map("Interface", "n", "<F2>", "whichkey")
  M.map("Interface", "n", "<F3>", "nvim_tree")
  M.map("Interface", "n", "<M-p>", "neo_tree")
  M.map("Interface", "n", "<M-Bslash>", "neo_tree_2")
  M.map("Interface", "n", "<F4>", "mundo1")
  -- M.map("Interface", "n", "<F5>", "term1")
  M.map("Interface", "n", "<F6>", "treesitter")
  M.map("Interface", "n", "<F7>", "aerial")
  M.map("Interface", "n", "<S-F7>", "aerial_float")
  M.map("Interface", "n", "cll", "conceal_clear")
  M.map("Interface", "n", "cl0", "conceal_0")
  M.map("Interface", "n", "cl1", "conceal_1")
  M.map("Interface", "n", "cl2", "conceal_2")
  M.map("Interface", "n", "cl3", "conceal_3")
  M.map("Interface", "n", "gH", "ts_highlights")
  M.map("Interface", "n", "gth", "ts_highlights2")
  M.map("Interface", "n", "gtd", "list_definitions") -- virtual
  M.map("Interface", "n", "g0", "toc_definitions") -- virtual
  M.map("Interface", "n", "<a-*>", "ts_next_usage") -- virtual
  M.map("Interface", "n", "<a-#>", "ts_prev_usage") -- virtual
  M.map("Interface", "n", "_", "clear_hl")
  M.map("Interface", "n", "<M-->", "clear_popups_hl")
  M.map("Interface", "n", "<M-b>", "reset_lsp_clear_hl")
  M.map("Interface", "n", "<M-C-_>", "clear_popups_splits_hl")

  M.map("System", "n", "<leader>iy", "yank_filename")
  M.map("System", "n", "<leader>iY", "yank_buffer")
  M.map("System", "n", "<leader>if", "display_filename")
  M.map("System", "n", "<leader>ii", "import_status")
  M.map("System", "n", "<leader>iu", "packer_update")
  M.map("System", "n", "<leader>is", "packer_sync")
  M.map("System", "n", "<leader>ic", "packer_compile")
  M.map("System", "n", "<leader>iS", "packer_status")
  M.map("System", "n", "<leader>ie", "plugins_edit")
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
  -- M.map("Format", "n", "<C-Up>", "dial_increment1")
  -- M.map("Format", "n", "<C-Down>", "dial_decrement1")
  M.map("Format", "n", "<leader>fi", "dial_increment2")
  M.map("Format", "n", "<leader>fd", "dial_decrement2")
  -- M.map("Format", "v", "<C-Up>", "v_dial_increment1")
  -- M.map("Format", "v", "<C-Down>", "v_dial_decrement1")
  M.map("Format", "v", "<leader>fi", "v_dial_increment2")
  M.map("Format", "v", "<leader>fd", "v_dial_decrement2")
  M.map("Format", "v", "g<M-a>", "v_dial_increment_additional", { noremap = true, nowait = true })
  M.map("Format", "v", "g<M-x>", "v_dial_decrement_additional", { noremap = true, nowait = true })
  M.map("Format", "n", "<leader>fd", "dial_decrement2")

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

  local map = function(mode, lhs, rhs, opts)
    local options = {}
    if opts then
      options = vim.tbl_extend("force", options, opts)
    end
    if opts.buffer ~= nil then
      assert(type(opts.buffer) == "number")

      local bufnr = opts.buffer
      options.buffer = nil
      vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, options)
    else
      vim.api.nvim_set_keymap(mode, lhs, rhs, options)
    end
  end

  -- Jump to the previous git conflict start
  map("n", "[cc", ":call search('^<\\{4,\\} \\w\\+.*$', 'Wb')<CR>", {
    silent = true,
    noremap = true,
  })

  -- Jump to the previous git conflict end
  map("n", "[ce", ":call search('^>\\{4,\\} \\w\\+.*$', 'Wb')<CR>", {
    silent = true,
    noremap = true,
  })

  -- Jump to the next git conflict start
  map("n", "]cc", ":call search('^<\\{4,\\} \\w\\+.*$', 'W')<CR>", { silent = true, noremap = true })
  -- Jump to the next git conflict end
  map("n", "]ce", ":call search('^>\\{4,\\} \\w\\+.*$', 'W')<CR>", { silent = true, noremap = true })
  -- Jump to previous divider
  map("n", "[cm", ":call search('^=\\{4,\\}$', 'Wb')<CR>", { silent = true, noremap = true })
  -- Jump to next divider
  map("n", "]cm", ":call search('^=\\{4,\\}$', 'W')<CR>", { silent = true, noremap = true })

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
  M.map("Search", "n", "n", "next")
  M.map("Search", "n", "N", "prev")
  M.map("Search", "n", "*", "cursor_next1")
  M.map("Search", "n", "#", "cursor_prev1")
  M.map("Search", "n", "g*", "cursor_next2")
  M.map("Search", "n", "g#", "cursor_prev2")
  M.map("Search", "n", "gn", "last_match")
  M.map("Search", "n", "<leader>sr", "cursor_replace")

  M.map("Git", "n", "<leader>gf", "telescope_files")
  M.map("Git", "n", "<leader>gb", "telescope_branches")
  M.map("Git", "n", "<leader>gs", "telescope_status")
  M.map("Git", "n", "<leader>gn", "signs_next_hunk")
  M.map("Git", "n", "<leader>gp", "signs_prev_hunk")
  M.map("Git", "n", "<leader>gv", "signs_preview_hunk")
  M.map("Git", "n", "<leader>gr", "signs_reset_hunk")
  M.map("Git", "n", "<leader>gR", "signs_reset_buffer")
  M.map("Git", "n", "<leader>gC", "telescope_bcommits2")

  M.map("Git", "n", "<leader>gc", "telescope_gcommits2")
  -- M.map("Git", "n", "<A-g>", "telescope_commits")
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

  M.map("Pickers", "n", "<C-p>", "find_files")
  M.map("Pickers", "n", "<C-\\>", "find_files_currdir")
  M.map("Pickers", "n", "<M-i>", "notifications")
  M.map("Pickers", "n", "<C-U>", "frecency_files")
  M.map("Pickers", "n", "<A-U>", "mru_files")
  M.map("Pickers", "n", "<M-Space>", "grep_string_cursor")
  M.map("Pickers", "n", "<M-/>", "helptags_string_cursor")
  -- M.map("Pickers", "n", "<C-_>", "telescope_live_search")
  -- M.map("Pickers", "n", "<M-/>", "telescope_grep_search")
  -- M.map("Pickers", "n", "<A-e>", "sessions")
  -- M.map("Pickers", "n", "<M-g>", "commit_log_telescope")
  -- M.map("Pickers", "n", "<C-g>", "telescope_live_search")
  -- M.map("Pickers", "n", "<leader>Fc", "find_colorscheme_tele")
  -- M.map("Pickers", "n", "<leader>Ff", "find_files")
  -- M.map("Pickers", "n", "<leader>Fg", "grep_text_tele")
  -- M.map("Pickers", "n", "<leader>Fn", "find_nvim_dotfiles")
  -- M.map("Pickers", "n", "<leader>Fo", "find_oldfiles")
  -- M.map("Pickers", "n", "<M-g>", "print_filename")
  M.map("Pickers", "n", "<C-g>", "find_buffers")
  M.map("Pickers", "n", "<A-g>", "find_projects")
  M.map("Pickers", "n", "<leader><leader>", "find_pickers")
  M.map("Pickers", "n", "<leader-,>", "telescope_repeat")
  M.map("Pickers", "n", "<C-Space>", "find_files")
  -- M.map("Pickers", "v", "<C-f>", "live_grep_visual")
  M.map("Pickers", "n", "<M-e>", "live_grep")
  M.map("Pickers", "n", "<C-e>", "grep_buffers")

  vim.cmd([[
  cabbrev T Telescope
  cabbrev d lua vim.dbg(
  cabbrev D DebugLog
  cabbrev Plug execute "normal \<Plug>(
]])

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
  M.map("Zettel", "n", "gzl", "insert_last1")
  M.map("Zettel", "n", "gzi", "index")
  M.map("Zettel", "n", "gzL", "insert_last2")
  M.map("Zettel", "n", "gzI", "insert_next")
  M.map("Zettel", "n", "gzv", "toggle_backlinks")
  M.map("Zettel", "n", "gzt", "tag_new")
  M.map("Zettel", "n", "gzT", "tag_select")
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
  -- M.map("LSP", "n", "gd", "definitions")
  -- M.map("LSP", "n", "gD", "declaration")
  M.map("LSP", "n", "gk", "hover_doc2")
  M.map("LSP", "n", "go", "organize_imports")
  -- M.map("LSP", "n", "gr", "references")
  M.map("LSP", "n", "gs", "signature_help1")
  -- M.map("LSP", "n", "gy", "buffer_definitions")
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
  -- M.map("LSP", "n", "<A-T>", "doc_diagnostics_2")

  vim.api.nvim_set_keymap(
    "n",
    "<leader>xx",
    "<cmd>Trouble<cr><bar><cmd>VimadeBufDisable<cr><bar><cmd>wincmd p<cr>",
    { silent = true, noremap = true }
  )
  vim.api.nvim_set_keymap(
    "n",
    "<leader>xw",
    "<cmd>Trouble lsp_workspace_diagnostics<cr><bar><cmd>VimadeBufDisable<cr><bar><cmd>wincmd p<cr>",
    { silent = true, noremap = true }
  )
  vim.api.nvim_set_keymap(
    "n",
    "<leader>xd",
    "<cmd>Trouble lsp_document_diagnostics<cr><bar><cmd>VimadeBufDisable<cr><bar><cmd>wincmd p<cr>",
    { silent = true, noremap = true }
  )
  vim.api.nvim_set_keymap(
    "n",
    "<leader>xl",
    "<cmd>Trouble loclist<cr><bar><cmd>VimadeBufDisable<cr><bar><cmd>wincmd p<cr>",
    { silent = true, noremap = true }
  )
  vim.api.nvim_set_keymap(
    "n",
    "<leader>xq",
    "<cmd>Trouble quickfix<cr><bar><cmd>VimadeBufDisable<cr><bar><cmd>wincmd p<cr>",
    { silent = true, noremap = true }
  )
  vim.api.nvim_set_keymap(
    "n",
    "<leader>xr",
    "<cmd>Trouble lsp_references<cr><bar><cmd>VimadeBufDisable<cr><bar><cmd>wincmd p<cr>",
    { silent = true, noremap = true }
  )

  -- TODO: enable cycling
  -- jump to the previous/next item, skipping the groups
  vim.api.nvim_set_keymap(
    "n",
    "[x",
    "<cmd>lua require('trouble').previous({ skip_groups = true, jump = true, })<cr>",
    { silent = true, noremap = true }
  )
  vim.api.nvim_set_keymap(
    "n",
    "]x",
    "<cmd>lua require('trouble').next({ skip_groups = true, jump = true, })<cr>",
    { silent = true, noremap = true }
  )

  -- vim.cmd([[vmap <M-a> <C-a> ]])
  -- vim.cmd([[vmap <M-x> <C-x> ]])
  -- vim.cmd([[vmap g<M-a> g<C-a> ]])
  -- vim.cmd([[vmap g<M-x> g<C-x> ]])

  -- Moving around, tabs, windows and buffers {{{

  -- Jump to the previous git conflict start
  map("n", "[cc", ":call search('^<\\{4,\\} \\w\\+.*$', 'Wb')<CR>", {
    silent = true,
    noremap = true,
  })

  -- Jump to the previous git conflict end
  map("n", "[ce", ":call search('^>\\{4,\\} \\w\\+.*$', 'Wb')<CR>", {
    silent = true,
    noremap = true,
  })

  -- Jump to the next git conflict start
  map("n", "]cc", ":call search('^<\\{4,\\} \\w\\+.*$', 'W')<CR>", { silent = true, noremap = true })

  -- Jump to the next git conflict end
  map("n", "]ce", ":call search('^>\\{4,\\} \\w\\+.*$', 'W')<CR>", { silent = true, noremap = true })

  -- Jump to previous divider
  map("n", "[cm", ":call search('^=\\{4,\\}$', 'Wb')<CR>", { silent = true, noremap = true })

  -- Jump to next divider
  map("n", "]cm", ":call search('^=\\{4,\\}$', 'W')<CR>", { silent = true, noremap = true })

  -- Maps, Commands {{{

  map("n", "]a", ':execute ":" . v:count . "next"<CR>', { silent = true, noremap = true })
  map("n", "[a", ':execute ":" . v:count . "previous"<CR>', { silent = true, noremap = true })

  map("n", "]l", ':execute ":" . v:count . "lnext"<CR>', { silent = true, noremap = true })
  map("n", "[l", ':execute ":" . v:count . "lprevious"<CR>', { silent = true, noremap = true })

  map("n", "]q", ':execute ":" . v:count . "cnext"<CR>', { silent = true, noremap = true })
  map("n", "[q", ':execute ":" . v:count . "cprevious"<CR>', { silent = true, noremap = true })

  map("n", "]b", ':execute ":" . v:count . "bnext"<CR>', { silent = true, noremap = true })
  map("n", "[b", ':execute ":" . v:count . "bprevious"<CR>', { silent = true, noremap = true })

  -- Switch to a terminal buffer using [count]gs.
  map(
    "n",
    "<leader>gt",
    '<cmd>execute "lua require\\"vimrc.terminal\\".switch_to_terminal(" . v:count . ")"<CR>',
    { silent = true, noremap = true }
  )

  -- Taking from here: https://github.com/stoeffel/.dotfiles/blob/master/vim/visual-at.vim
  -- Allows running macros only on selected files.
  map(
    "x",
    "@",
    ':<C-u>echo "@".getcmdline() | execute ":\'<,\'>normal @" . nr2char(getchar())<CR>',
    { silent = true, noremap = true }
  )

  map("x", ".", ":normal .<CR>", { silent = true })

  map("n", "Y", "y$", { silent = true })

  -- Pressing <leader>ss will toggle and untoggle spell checking
  map("n", "<leader>ss", ":setlocal spell!<CR>", { silent = true })

  -- map("t", "<C-d>", "<PageDown>", { silent = true })
  -- map("t", "<C-u>", "<PageUp>", { silent = true })

  map("t", "<C-w><C-q>", "<C-\\><C-n>", { silent = true, noremap = true })
  map("t", "<C-w><C-h>", "<C-\\><C-n><C-w>h", { silent = true, noremap = true })
  map("t", "<C-w><C-j>", "<C-\\><C-n><C-w>j", { silent = true, noremap = true })
  map("t", "<C-w><C-k>", "<C-\\><C-n><C-w>k", { silent = true, noremap = true })
  map("t", "<C-w><C-l>", "<C-\\><C-n><C-w>l", { silent = true, noremap = true })

  -- print(M.inspect(M.whichkey_map))
  -- print(M.inspect(M.stats))

  -- local whichkeys = M.whichkeyDump()
  -- print("OK:   " .. length(whichkeys.ok) .. "\nTODO: " .. length(whichkeys.todo))

  -- dont overwrite default register when pasting
  -- vim.cmd([[ vnoremap p "_dP]])
  vim.cmd([[vnoremap p :<C-U>let @p = @+<cr>gvp:let @+ = @p<cr>]])

  M.registerWhichkey()
end)

--
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
