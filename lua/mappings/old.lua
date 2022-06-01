-- local Mapper = require("nvim-mapper")
-- {
--   c = {
--     mode = "c",
--     tree = {
--       root = {
--         children = {
--           ["\2"] = {
--             children = {},
--             mapping = {
--               cmd = 'wilder#in_context() ? wilder#previous() : "\\<C-B>"',
--               id = "\2",
--               keys = {
--                 keys = "\2",
--                 nvim = { "<C-B>" },
--                 term = { "\2" }
--               },
--               prefix = "<C-B>"
--             },
--             prefix = "\2"
--           },
--           ["\6"] = {
--             children = {},
--             mapping = {
--               cmd = 'wilder#in_context() ? wilder#next() : "\\<C-F>"',
--               id = "\6",
--               keys = {
--                 keys = "\6",
--                 nvim = { "<C-F>" },
--                 term = { "\6" }
--               },
--               prefix = "<C-F>"
-- -- More --

-- local cmap = function(cat, keys, cmd, id, desc, nr)
--   local mode = { silent = false, noremap = nr }
--   Mapper.map("c", keys, cmd, mode, cat, id, desc)
-- end
-- local nmap = function(cat, keys, cmd, id, desc, nr)
--   local mode = { silent = false, noremap = nr }
--   Mapper.map("n", keys, cmd, mode, cat, id, desc)
-- end
-- local vmap = function(cat, keys, cmd, id, desc, nr)
--   local mode = { silent = false, noremap = nr }
--   Mapper.map("v", keys, cmd, mode, cat, id, desc)
-- end
-- local imap = function(cat, keys, cmd, id, desc, nr)
--   local mode = { silent = false, noremap = nr }
--   Mapper.map("i", keys, cmd, mode, cat, id, desc)
-- end
-- local cvir = function(cat, keys, id, desc) Mapper.map_virtual("c", keys, "", {}, cat, id, desc) end
-- local nvir = function(cat, keys, id, desc) Mapper.map_virtual("n", keys, "", {}, cat, id, desc) end
-- local vvir = function(cat, keys, id, desc) Mapper.map_virtual("v", keys, "", {}, cat, id, desc) end
-- local ivir = function(cat, keys, id, desc) Mapper.map_virtual("i", keys, "", {}, cat, id, desc) end
----------------------------------
-- nmap("Navigation", "<bs>", "<C-^>", "navigation_buffer_last", "buffer last")
-- nmap("Navigation", ";", ":", "navigation_quick_cmd", "quickly open up command line", true)
-- nmap("Navigation", ":", ":<C-f>", "navigation_quick_cmdwin", "quickly open command line window")
-- nmap("Navigation", "!", ":@", "navigation_repeat_cmd", "repeat last command")
-- nmap("Navigation", "H", "<cmd>BufferPrev<cr>", "navigation_buffer_left", "buffer left")
-- nmap("Navigation", "L", "<cmd>BufferNext<cr>", "navigation_buffer_right", "buffer right")
-- nmap("Navigation", "<C-q>", "<cmd>tabclose | qa<cr>", "navigation_nowrite_exit1", "quick exit no save", true)
-- nmap("Navigation", "<C-x>", "<cmd>silent! tabclose | xa<cr>", "navigation_write_exit1", "quick exit with prompt", true)
-- nmap("Navigation", "<C-d>", "<cmd>BufDel<cr>", "navigation_buffer_close_nosave", "buffer close with no save", true)
-- nmap("Navigation", "<C-s>", "<cmd>w<cr><esc>", "navigation_write", "quick save")
-- nvir("Navigation", "ZZ", "navigation_write_exit2", "write and exit")
-- -- nmap("Navigation", "<leader>q", "<cmd>silent! tabclose | Sayonara<cr>", "navigation_window_close_save",
-- --      "close window with save")
-- nmap("Navigation", "<leader>x", "<cmd>update | silent! tabclose | Bdelete<cr>", "navigation_buffer_close_save",
--      "close buffer with save")
-- nmap("Navigation", "<leader>z", "<cmd>quitall<cr>", "navigation_nowrite_exit2", "quick exit")
-- nmap("Navigation", "<leader>!", "<cmd>BufferCloseAllButCurrent<cr>", "navigation_buffer_close_all",
--      "close all buffers but current")
-- nmap("Navigation", "<leader>*", "<cmd>wall<cr>", "navigation_buffer_write_all", "save all buffers")
-- nmap("Navigation", "<leader>w", "<cmd>noa w<cr>", "navigation_buffer_write_noa", "save without autocommands")
-- nmap("Navigation", "<leader>.", [[:call AltCommand(expand('%'), ':e')<cr>]], "navigation_buffer_altfile",
--      "open alt file")
-- --
-- nmap("Navigation", "<leader>nf", [[:e <C-R>=expand("%:p:h") . "/" <CR>]], "navigation_new_file", "create new file")
-- nmap("Navigation", "<leader>ns", [[:vsp <C-R>=expand("%:p:h") . "/" <CR>]], "navigation_new_split",
--      "create new file split")
-- nmap("Navigation", "<leader>nt", [[:tabedit <C-R>=expand("%:p:h") . "/" <CR>]], "navigation_new_tab",
--      "create new file tab")
-- --
-- nmap("Window", "<C-j>", "<C-w>j", "window_down", "window down")
-- nmap("Window", "<C-k>", "<C-w>k", "window_up", "window up")
-- nmap("Window", "<C-h>", "<C-w>h", "window_left", "window left")
-- nmap("Window", "<C-l>", "<C-w>l", "window_right", "window right")
-- nmap("Window", "<leader>:", "<C-w>W", "window_prev", "window prev")
-- nmap("Window", "<leader>;", "<C-w>w", "window_next1", "window next")
-- nmap("Window", "<leader>H", "<cmd>vnew<cr>", "window_split_h", "winsplit-h new ")
-- nmap("Window", "<leader>V", "<cmd>new<cr>", "window_split_v", "winsplit-v new")
-- nmap("Window", "<leader>_", "<C-w>_", "window_split_v_max", "winspit-v maximize")
-- nmap("Window", "<leader>|", "<C-w>|", "window_split_h_max", "winsplit-h maximize")
-- nmap("Window", "<leader>=", "<C-w>=", "window_split_even", "winsplit even")
-- nmap("Window", "<C-w>;", "<C-w>w", "window_next2", "window next")
-- nvir("Window", "<C-w>o", "window_exit_others", "exit other windows")
-- nvir("Window", "<C-w>x", "window_swap", "swap windows")
-- -- " C-W make all equal, C-W -/+ change height, CTRL-W >/< change width
-- nmap("Navigation", "gF", ":exec 'normal ^f\'''<bar>exec 'normal f\"'<bar> exec 'normal gf'<cr>", "navigation_goto_line",
--      "edit file under line")
-- nvir("Navigation", "gf", "navigation_goto_file", "edit file under cursor")
-- nvir("Navigation", "xf", "navigation_open_file", "open file under cursor")
-- imap("Navigation", "<C-s>", "<esc><cmd>w<cr>", "navigation_insert_save", "save with insert")
-- nmap("Plugins", "<leader>iu", "<cmd>PackerUpdate<cr>", "plugins_update", "packer update")
-- nmap("Plugins", "<leader>ii", "<cmd>PackerInstall<cr>", "plugins_install", "packer install")
-- nmap("Plugins", "<leader>is", "<cmd>PackerSync<cr>", "plugins_sync", "packer sync")
-- nmap("Plugins", "<leader>ic", "<cmd>PackerClean<cr>", "plugins_clean", "packer clean")
-- nmap("Plugins", "<leader>iS", "<cmd>PackerStatus<cr>", "plugins_status", "packer status")
-- nmap("Plugins", "<leader>ie", "<cmd>n $HOME/.config/nvim-profiles/nick/lua/plugins/*.lua<cr>", "plugins_edit",
--      "edit plugins")
-- nmap("Plugins", "<leader>iO", "<cmd>n $HOME/.vim/.shada", "shadafile_edit", "view shada file")
-- nmap("Zettel", "<cr>", "<plug>EditZettelUnderCursor", "zettel_enter", "enter zettel link")
-- nmap("Zettel", "gzn", "<plug>EditZettelNew", "zettel_edit_new", "edit new zettel")
-- nmap("Zettel", "gzu", "<plug>EditZettelLast", "zettel_edit_last", "edit last zettel")
-- nmap("Zettel", "gzc", "<plug>NewZettel", "zettel_new", "new zettel")
-- nmap("Zettel", "gzN", "<plug>EditZettelNewFromCword", "zettel_edit_new_cword", "new zettel cursor")
-- nmap("Zettel", "gzr", "<plug>NeuronRefreshCache", "zettel_refresh_cache", "neuron refresh cache")
-- nmap("Zettel", "gzU", ":<C-U>call neuron#move_history(-1)<cr>", "zettel_prev_history", "neuron prev history")
-- nmap("Zettel", "gzP", ":<C-U>call neuron#move_history(1)<cr>", "zettel_next_history", "neuron next history")
-- nmap("Zettel", "gzz", "<plug>EditZettelSelect", "zettel_edit_select", "edit zettel select")
-- nmap("Zettel", "gzZ", "<plug>EditZettelBacklink", "zettel_edit_backlink", "edit zettel backlink")
-- nmap("Zettel", "gzo", "<plug>EditZettelUnderCursor", "zettel_edit_cursor", "edit zettel cursor")
-- nmap("Zettel", "gzs", "<plug>EditZettelSearchContent", "zettel_search_content", "zettel search content")
-- nmap("Zettel", "gzS", "<plug>EditZettelSearchContentUnderCursor", "zettel_search_content_cursor", "zettel search cursor")
-- nmap("Zettel", "gzl", "<plug>InsertZettelLast", "zettel_insert_last1", "insert zettel last")
-- nmap("Zettel", "gzi", "<cmd>lua require'neuron'.goto_index()<cr>", "zettel_index", "goto zettel index")
-- nmap("Zettel", "gzL", ":<C-U>call neuron#insert_zettel_last(1)<cr>", "zettel_insert_last2", "insert zettel last")
-- nmap("Zettel", "gzI", ":<C-U>call neuron#insert_zettel_select(1)<cr>", "zettel_insert_next", "insert zettel select")
-- nmap("Zettel", "gzv", "<plug>ToggleBacklinks", "zettel_toggle_backlinks", "toggle backlinks")
-- nmap("Zettel", "gzt", "<plug>TagsAddNew", "zettel_tag_new", "add new tag")
-- nmap("Zettel", "gzT", "<plug>TagsAddSelect", "zettel_tag_select", "add existing tag")
-- nmap("Zettel", "gzts", "<plug>TagsZettelSearch", "zettel_tag_search", "search zettel tags")
-- vmap("Zettel", "gzN", "<plug>EditZettelNewFromVisual", "zettel_new_visual", "new zettel from selected")
-- -- NOTE: removed <expr>
-- imap("Zettel", "<c-x><c-u>", ":<C-U>call neuron#insert_zettel_complete(0)", "zettel_insert_complete_last",
--      "zettel insert last")
-- imap("Zettel", "<c-x><c-y>", ":<C-U>call neuron#insert_zettel_complete(1)", "zettel_insert_complete_select",
--      "zettel insert selet")
-- nmap("Git", "<leader>gf", "<cmd>Telescope git_files<cr>", "git_telescope_files", "telescope git files")
-- nmap("Git", "<leader>gc", "<cmd>Telescope git_commits<cr>", "git_telescope_commits", "telescope git files")
-- nmap("Git", "<leader>gb", "<cmd>Telescope git_branches<cr>", "git_telescope_branches", "telescope git files")
-- nmap("Git", "<leader>gs", "<cmd>Telescope git_status<cr>", "git_telescope_status", "telescope git status")
-- nmap("Git", "<leader>gn", "<cmd>Gitsigns next_hunk<cr>", "git_next_hunk", "git next hunk")
-- nmap("Git", "<leader>gp", "<cmd>Gitsigns prev_hunk<cr>", "git_prev_hunk", "git prev hunk")
-- nmap("Git", "<leader>gv", "<cmd>Gitsigns preview_hunk<cr>", "git_preview_hunk", "git preview hunk")
-- nmap("Git", "<leader>gr", "<cmd>Gitsigns reset_hunk<cr>", "git_reset_hunk", "git reset hunk")
-- nmap("Git", "<leader>gR", "<cmd>Gitsigns reset_buffer<cr>", "git_reset_buffer", "git reset buffer")
-- --   ["n ]c"] = {expr = true, '&diff ? \']c\' : \'<cmd>lua require"gitsigns".next_hunk()<CR>\''},
-- --   ["n [c"] = {expr = true, '&diff ? \'[c\' : \'<cmd>lua require"gitsigns".prev_hunk()<CR>\''},
-- --   ["n <leader>hs"] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
-- --   ["n <leader>hu"] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
-- --   ["n <leader>hb"] = '<cmd>lua require"gitsigns".blame_line()<CR>',
-- --   -- Text objects
-- --   ["o ih"] = ':<C-U>lua require"gitsigns".text_object()<CR>',
-- --   ["x ih"] = ':<C-U>lua require"gitsigns".text_object()<CR>'
-- -- ocal log = [[\%C(yellow)\%h\%Cred\%d \%Creset\%s \%Cgreen(\%ar) \%Cblue\%an\%Creset]]
-- -- map('n', '<leader>g<space>', ':Git ')
-- -- map('n', '<leader>gd', '<cmd>Gvdiffsplit<CR>')
-- -- map('n', '<leader>gg', '<cmd>Git<CR>')
-- -- map('n', '<leader>gl', fmt('<cmd>term git log --graph --all --format="%s"<CR><cmd>start<CR>',
-- -- ocal log = [[\%C(yellow)\%h\%Cred\%d \%Creset\%s \%Cgreen(\%ar) \%Cblue\%an\%Creset]]
-- -- map('n', '<leader>g<space>', ':Git ')
-- -- map('n', '<leader>gd', '<cmd>Gvdiffsplit<CR>')
-- -- map('n', '<leader>gg', '<cmd>Git<CR>')
-- -- map('n', '<leader>gl', fmt('<cmd>term git log --graph --all --format="%s"<CR><cmd>start<CR>',
-- -- LSP
-- nmap("LSP", "K", "<cmd>Lspsaga hover_doc<cr>", "lsp_hover_doc1", "lsp hover document")
-- nmap("LSP", "gd", "<cmd>Telescope lsp_definitions<cr>", "lsp_definitions", "lsp definitions")
-- nmap("LSP", "gD", "<cmd>lua vim.lsp.buf_declaration()<cr>", "lsp_declaration", "lsp declaration")
-- nmap("LSP", "gk", "<cmd>Lspsaga hover_doc<cr>", "lsp_hover_doc2", "lsp hover document ")
-- nmap("LSP", "go", "<cmd>TSLspOrganize<cr>", "lsp_organize_imports", "lsp organize imports")
-- nmap("LSP", "gh", "<cmd>Telescope lsp_finder<cr>", "lsp_finder1", "lsp finder")
-- nmap("LSP", "gr", "<cmd>Telescope lsp_references<cr>", "lsp_references", "lsp references")
-- nmap("LSP", "gs", "<cmd>Telescope lsp_signature_help<cr>", "lsp_signature_help1", "lsp signature help")
-- nmap("LSP", "gy", "<cmd>lua vim.lsp.buf.type_definition()<cr>", "lsp_buffer_definitions", "lsp buffer definitions")
-- -- ["gf"] = {"<cmd>TSLspFixCurrent<cr>", "eslint fix"},
-- -- ["gr"] = {"<cmd>TSLspRenameFile<cr>", "rename file"},
-- -- ["gi"] = {"<cmd>TSLspImportAll<cr>", "import all"},
-- nmap("LSP", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>", "lsp_diag_prev", "lsp diagnostic prev ")
-- nmap("LSP", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<cr>", "lsp_diag_next", "lsp diagnostic next")
-- nmap("LSP", "<leader>la", "<cmd>Lspsaga code_action<cr>", "lsp_code_action", "lsp code action")
-- nmap("LSP", "<leader>lA", "<cmd>Lspsaga range_code_action<cr>", "lsp_range_code_action", "lsp range code action")
-- nmap("LSP", "<leader>ld", "<cmd>Telescope lsp_document_diagnostics<cr>", "lsp_document_diagnostics",
--      "lsp document diagnostics")
-- nmap("LSP", "<leader>lD", "<cmd>Telescope lsp_workspace_diagnostics<cr>", "lsp_workspace_diagnostics",
--      "lsp workspace diagnostics")
-- nmap("LSP", "<leader>le", "<cmd>lua vim.cmd('e'..vim.lsp.get_log_path())<cr>", "lsp_view_log", "lsp view log")
-- nmap("LSP", "<leader>ll", "<cmd>Lspsaga show_line_diagnostics<cr>", "lsp_line_diagnostics", "lsp line diagnostics")
-- nmap("LSP", "<leader>lf", "<cmd>Lspsaga lsp_finder<cr>", "lsp_finder2", "lsp finder")
-- nmap("LSP", "<leader>li", "<cmd>LspInfo<cr>", "lsp_server_info", "lsp server info")
-- nmap("LSP", "<leader>lk", "<cmd>Lspsaga signature_help<cr>", "lsp_signature_help2", "lsp signature help")
-- nmap("LSP", "<leader>lF", "<cmd>lua vim.lsp.buf.formatting()<cr>", "lsp_format_buffer", "lsp format buffer")
-- nmap("LSP", "<leader>lp", "<cmd>Lspsaga preview_definition<cr>", "lsp_preview_definition", "lsp preview definition")
-- nmap("LSP", "<leader>lr", "<cmd>Lspsaga rename<cr>", "lsp_rename", "lsp rename")
-- nmap("LSP", "<leader>ls", "<cmd>Telescope lsp_document_symbols<cr>", "lsp_document_symbols", "lsp document symbols")
-- nmap("LSP", "<leader>lS", "<cmd>Telescope lsp_workspace_symbols<cr>", "lsp_workspace_symbols", "lsp workspace symbols")
-- nmap("LSP", "<leader>l.a", "<cmd>LspStop<cr>", "lsp_stop_all", "lsp stop all")
-- -- pickers
-- nmap("Pickers", "<C-p>", "<cmd>FzfLua files<cr>", "picker_files", "project files")
-- nmap("Pickers", "<A-P>", "<cmd>FzfLua lsp_workspace_diagnostics<cr>", "picker_workspace_diagnostics",
--      "workspace diagnostics")
-- nmap("Pickers", "<A-o>", "<cmd>FzfPreviewDirectoryFilesRpc ~<cr>", "picker_home_files", "home files")
-- nmap("Pickers", "<C-g>", "<cmd>FzfPreviewGitActionsRpc<cr>", "picker_git_actions", "git actions")
-- nmap("Pickers", "<A-g>", "<cmd>FzfPreviewGitStatusRpc<cr>", "picker_git_status", "git status")
-- nmap("Pickers", "<C-u>", "<cmd>FzfLua oldfiles<cr>", "picker_mru_files", "mru files")
-- nmap("Pickers", "<A-u>", "<cmd>FzfPreviewCommandPaletteRpc<cr>", "picker_commands", "commands")
-- -- nmap("Pickers", "<C-d>", "<cmd>FzfPreviewGitCurrentLogsRpc<cr>", "picker_buffer_log", "git buffer log")
-- nmap("Pickers", "<A-d>", "<cmd>FzfPreviewGitLogsRpc<cr>", "picker_commit_log", "git commit log")
-- nmap("Pickers", "<C-e>", "<cmd>FzfLua buffers<cr>", "picker_bufers", "buffers")
-- nmap("Pickers", "<A-e>", "<cmd>Sessions<cr>", "picker_sessions", "sessions")
-- nmap("Pickers", "<A-j>", "<cmd>FzfPreviewJumpsRpc<cr>", "picker_jumps", "jumps")
-- nmap("Pickers", "<A-/>", "<cmd>Telescope help_tags<cr>", "picker_helptags", "helptags")
-- nmap("Pickers", "<A-m>", "<cmd>FzfPreviewLocationListRpc<cr>", "picker_location_list", "location list")
-- nmap("Pickers", "<A-S>", "<cmd>Rg<cr>", "picker_live_search", "live search (rg)")
-- nmap("Pickers", "<leader>Fb", "<cmd>FindBuffer<cr>", "picker_find_buffer", "find buffer")
-- nmap("Pickers", "<leader>Fc", "<cmd>Telescope colorscheme<cr>", "picker_find_colorscheme", "find colorscheme")
-- nmap("Pickers", "<leader>Ff", "<cmd>Telescope find_files<cr>", "picker_find_file", "find file")
-- nmap("Pickers", "<leader>Fg", "<cmd>Telescope live_grep<cr>", "picker_grep_text", "grep text")
-- nmap("Pickers", "<leader>Fh", "<cmd>Telescope help_tags<cr>", "picker_find_helptags", "find helptags")
-- nmap("Pickers", "<leader>Fn", "<cmd>lua require('utils.core').search_nvim()<cr>", "picker_find_nvim_dotfiles",
--      "find nvim dotfiles")
-- nmap("Pickers", "<leader>Fo", "<cmd>Telescope oldfiles<cr>", "picker_find_oldfiles", "find oldfiles")
-- nmap("Pickers", "<leader>Fm", "<plug>(fzf-maps-n)", "picker_find_mappings_n", "find mappings (normal)")
-- nmap("Pickers", "<leader>Fmi", "<plug>(fzf-maps-i)", "picker_find_mappings_i", "find mappings (insert)")
-- nmap("Pickers", "<leader>Fmv", "<plug>(fzf-maps-v)", "picker_find_mappings_v", "find mappings (visual)")
-- nmap("Pickers", "<leader>Fmo", "<plug>(fzf-maps-o)", "picker_find_mappings_o", "find mappings (operator)")
-- -- vim.api.nvim_set_keymap("n", "<C-p>", ":lua FindFile()<CR>", {silent = true, noremap = true})
-- -- vim.api.nvim_set_keymap("n", "<leader>ff", ":lua FindBuffer()<CR>", {silent = true, noremap = true})
-- -- vim.api.nvim_set_keymap("n", "<leader>fg", ":lua FindString()<CR>", {silent = true, noremap = true})
-- -- vim.api.nvim_set_keymap("n", "<leader>fl", ":lua FindLive()<CR>", {silent = true, noremap = true})
-- -- vim.api.nvim_set_keymap("n", "<leader>fd", ":lua FindDot()<CR>", {silent = true, noremap = true})
-- -- vim.api.nvim_set_keymap("n", "<leader>fb", ":lua FindGit()<CR>", {silent = true, noremap = true})
-- -- map("n", "<leader>fn", ":lua require('utils.core').search_nvim()<CR>")
-- -- map("n", "<leader>b", ":Telescope buffers show_all=true sort_lastued=true<CR>")
-- -- ["p"] = {
-- --   name = "+personal-config",
-- --   ["n"] = { "<cmd>e ~/.config/nvim/lua/config.lua<cr>", "nvim" },
-- --   ["s"] = { "<cmd>e ~/.shell/.zshrc<cr>", "shell" },
-- -- },
-- nmap("REPL", "<M-CR>", "<cmd>SlimuxShellLast<cr>", "tmux_send", "tmux send")
-- -- nmap("REPL", "<leader>y<cr>", "<Plug>(ripple_open_repl)", "repl_open", "repl open")
-- -- nmap("REPL", "<leader>yr", "<Plug>(ripple_send_motion)", "repl_send_motion", "repl send motion")
-- -- nmap("REPL", "<leader>yp", "<Plug>(ripple_send_previous)", "repl_send_previous", "repl send previous")
-- -- nmap("REPL", "<leader>yrr", "<Plug>(ripple_send_line)", "repl_send_line", "repl send line")
-- -- nmap("REPL", "<leader>yr<cr>", "<Plug>(ripple_send_buffer)", "repl_send_buffer", "repl send buffer")
-- -- vmap("REPL", "<leader>r", "<Plug>(ripple_send_selection)", "repl_send_visual", "repl send visual")
-- -- -- Directory
-- -- wk.register({
-- --     d = {
-- --         name = "directory",
-- --         a = "add directory",
-- --         l = "list directories",
-- --         r = "remove directory",
-- --     }
-- -- }, { prefix = "<leader>" })
-- nvir("Movement", "gi", "movement_last_insertion", "move to last insertion")
-- nvir("Movement", "gI", "movement_begin_insertion", "insert at beginning")
-- nvir("Movement", "gv", "movement_last_visual", "visual select last paste")
-- nvir("Movement", "ga", "movement_ascii", "ascii under cursor")
-- nmap("Movement", "D", "d$", "movement_delete_end", "delete to end")
-- --
-- nmap("Movement", "<C-f>", "<Plug>(SmoothieDownwards)<Plug>(SmoothieDownwards)", "movement_scroll_forward",
--      "scroll forward", false)
-- nmap("Movement", "<C-b>", "<Plug>(SmoothieBackwards)", "movement_scroll_backwards", "scroll backwards", false)
-- nmap("Movement", "G", "<Plug>(Smoothie_G)", "movement_scroll_bottom", "scroll to bottom")
-- nmap("Movement", "gg", "<Plug>(Smoothie_gg)", "movement_scroll_top", "scroll to top")
-- nmap("Movement", "gv", "`[v`]", "movement_select_last", "select last edited text")
-- nvir("Movement", "gn", "movement_start_inc", "start incremental selection")
-- nvir("Movement", "gnd", "movement_goto_definition", "goto ts definition")
-- nmap("Search", "_", "<cmd>noh<cr> | :nohlsearch<cr>", "search_rmhl", "remove highlight")
-- nvir("Search", "gn", "search_last_match", "select last search match")
-- nmap("Search", "n", "<cmd>execute('normal! ' . v:count1 . 'n')<cr><cmd>lua require('hlslens').start()<cr>",
--      "search_next", "next matching")
-- nmap("Search", "N", "<cmd>execute('normal! ' . v:count1 . 'N')<cr><cmd>lua require('hlslens').start()<cr>",
--      "search_prev", "prev_matching")
-- nmap("Search", "*", "*<cmd>lua require('hlslens').start()<cr>", "search_cursor_next1", "next word under cursor")
-- nmap("Search", "#", "#<cmd>lua require('hlslens').start()<cr>", "search_cursor_prev1", "prev word under cursor")
-- nmap("Search", "g*", "g*<cmd>lua require('hlslens').start()<cr>", "search_cursor_next2", "next word under cursor")
-- nmap("Search", "g#", "g#<cmd>lua require('hlslens').start()<cr>", "search_cursor_prev2", "prev word under cursor")
-- -- vmap("Movement", "K", "<cmd>move '<-2<CR>gv=gv<cr>", "movement_selected_up", "move selected text up")
-- -- vmap("Movement", "J", "<cmd>move '<+1<CR>gv=gv<cr>", "movement_selected_down", "move selected text down")
-- -- map("i", "jk", [[col('.') == 1 ? '<esc>' : '<esc>l']], { expr = true })
-- vvir("Movement", "grn", "movement_expand_inc1", "expand incremental selection")
-- vvir("Movement", "grm", "movement_shrink_inc1", "shrink incremental selection")
-- vvir("Movement", "grc", "movement_scope_inc", "scope incremental selection")
-- vmap("Movement", "+", "<cmd>lua require'nvim-treesitter.incremental-selection'.node_incremental()<cr>", "movement_expand_inc2", "expand incremental selection")
-- vmap("Movement", "-", "<cmd>lua require'nvim-treesitter.incremental-selection'.node_incremental()<cr>", "movement_shrink_inc2", "shrink incremental selection")
-- nmap("Movement", "<leader>py", "<cmd>Telescope neoclip<cr>", "movement_neoclip", "telescope neocip")
-- nmap("Movement", "<leader>pY", "<cmd>FZFYanks<cr>", "movement_fzf_yanks", "fzf yanks")
-- nmap("Movement", "<leader>pp", "\"*p", "movement_paste_primary", "paste primary")
-- nmap("Movement", "<leader>pc", "\"+p<esc>gvgc^", "movement_paste_comment", "paste comment")
-- nmap("Movement", "<leader>pm", "<cmd>set invpaste<cr>", "movement_paste_mode_toggle", "paste mode toggle")
-- nmap("Interface", "\"\"", "<cmd>Registers<cr>", "interface_registers", "view registers")
-- nmap("Interface", "<F2>", "<cmd>WhichKey<cr>", "interface_whichkey", "toggle whichkey")
-- nmap("Interface", "<F3>", "<cmd>NvimTreeToggle<cr>", "interface_nvim_tree", "toggle nvim-tree")
-- nmap("Interface", "<F4>", "<cmd>MundoToggle<cr>", "interface_mundo1", "toggle mundo")
-- nmap("Interface", "<F5>", "<cmd>FloatermToggle<cr>", "interface_term1", "toggle floaterm")
-- nmap("Interface", "<F6>", "<cmd>TSPlaygroundToggle<cr>", "interface_treesitter", "toggle treesitter")
-- nmap("Interface", "U", "<cmd>MundoToggle<cr>", "interface_mundo2", "toggle mundo")
-- nmap("Interface", "cll", "<cmd>set conceallevel=0<cr>", "visual_conceal_clear", "clear conceal")
-- nmap("Interface", "cl0", "<cmd>set conceallevel=0<cr>", "visual_conceal_0", "set conceal 0")
-- nmap("Interface", "cl1", "<cmd>set conceallevel=1<cr>", "visual_conceal_1", "set conceal 1")
-- nmap("Interface", "cl2", "<cmd>set conceallevel=2<cr>", "visual_conceal_2", "set conceal 2")
-- nmap("Interface", "cl3", "<cmd>set conceallevel=3<cr>", "visual_conceal_3", "set conceal 3")
-- nmap("Interface", "gH", "<cmd>TSHighlightCapturesUnderCursor<cr>", "visual_ts_highlight", "ts highlight cursor")
-- nvir("Interface", "gnD", "interface_list_definitions", "list ts definitions")
-- nvir("Interface", "g0", "interface_toc_definitions", "toc ts definitions")
----------------------------------
-- TODO: add shift mapping for twice the speed
-- local movement_map = {
-- Treesitter
-- ["da*"] = { "delete around *" }, -- f: function       w/W: word
-- ["di*"] = { "delete inside *" }, -- c: class          a: parameter
-- ["ca*"] = { "change around *" }, -- b: block [( )]    B: block [{ }]
-- ["ci*"] = { "change inside *" }, -- []: block []      t: tag
-- ["ya*"] = { "yank around *" }, -- p: paragraph     '"`: ' or " or " quotes
-- ["yi*"] = { "yank inside *" },
-- [",a"] = { "swap parameter next"}          [",A"] = { "swap parameter prev"}
-- ["[m"] = { "goto next/prev start method"}  ["[M"] = { "goto next/prev end method"},
-- ["[]"] = { "prev end class , ][ next end"} ["]]"] = { "prev start class, [[ prev end class"},
-- ["gp"] = { "peak function"}                ["gP"] = { "peak class"},
-- goto_next_usage = "<a-*>",
-- goto_previous_usage = "<a-#>",
-- }
-- local movement_opts = { mode = "n", buffer = nil, silent = true, noremap = true, nowait = false }
-- require("which-key").register(movement_map, movement_opts)
-- --- Spectre
-- -- vim.api.nvim_set_keymap('n', '<leader>S', ":lua require('spectre').open()<CR>", {noremap = true, silent = false})
-- -- vim.api.nvim_set_keymap('v', '<leader>S', ":lua require('spectre').open_visual()<CR>", {noremap = true, silent = false})
-- -- vim.api.nvim_set_keymap('n', '<leader>Sw', "viw:lua require('spectre').open_visual()<CR>", {noremap = true, silent = false})
-- -- vim.api.nvim_set_keymap('n', '<leader>sp', "viw:lua require('spectre').open_file_search()<CR>", {noremap = true, silent = false})- vim.api.nvim_set_keymap('n', '<leader>to', ':TodoTelescope<CR>', {noremap = true, silent = false})
-- -- -- Fterm
-- -- vim.api.nvim_set_keymap('n', '<F5>', '<CMD>lua require("FTerm").toggle()<CR>', { noremap = true, silent = true })
-- -- vim.api.nvim_set_keymap('t', '<F5>', '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>', { noremap = true, silent = true })
-- -- vim.api.nvim_set_keymap('n', '<leader>gc', ':Octo issue create<CR>', {noremap = true, silent = false})
-- -- vim.api.nvim_set_keymap('n', '<leader>i', ':Octo issue list<CR>', {noremap = true, silent = false})
-- -- yoinks
-- -- Change current yank and see a preview of it in the status bar
-- -- " Also replace the default gp with yoink paste so we can toggle paste in this case too
-- -- You might also want to add a map for toggling whether the current paste is formatted or not:
-- -- normal p P will swap/cycle through yoinks
-- vim.cmd([[nmap <expr> p yoink#canSwap() ? '<plug>(YoinkPostPasteSwapBack)' : '<plug>(YoinkPaste_p)']])
-- vim.cmd([[nmap <expr> P yoink#canSwap() ? '<plug>(YoinkPostPasteSwapForward)' : '<plug>(YoinkPaste_P)']])
-- -- TODO: paste linewise within
-- -- Paste yanked line without line breaks before/after cursor position
-- -- inoremap <c-a> <c-r>1<esc>k$Jxi
-- vim.cmd([[nnoremap gp <plug>(YoinkPaste_gp) \| kJxJx]])
-- vim.cmd([[nnoremap gP <plug>(YoinkPaste_gP) \| kJxJx]])
-- vim.cmd([[nmap dil 0D]])
-- vim.cmd([[nmap [y <plug>(YoinkRotateBack)]])
-- vim.cmd([[nmap ]y <plug>(YoinkRotateForward)]])
-- vim.cmd([[nmap y <plug>(YoinkYankPreserveCursorPosition)]])
-- vim.cmd([[xmap y <plug>(YoinkYankPreserveCursorPosition)]])
-- -- hitting <c-=> after a paste will toggle between formatted and unformatted (equivalent to using the = key). By default pastes will not be formatted until you toggle it afterwards using <c-=> (however you can also change this with the yoinkAutoFormatPaste setting as described below)
-- vim.cmd([[nmap = <plug>(YoinkPostPasteToggleFormat)]])
-- vim.cmd([[nmap <leader>fi <Plug>(dial-increment)]])
-- vim.cmd([[nmap <leader>fd <Plug>(dial-decrement)]])
-- vim.cmd([[vmap <leader>fi <Plug>(dial-increment)]])
-- vim.cmd([[vmap <leader>fd <Plug>(dial-decrement)]])
-- vim.cmd([[nmap <c-Up> <Plug>(dial-increment)]])
-- vim.cmd([[nmap <c-Down> <Plug>(dial-decrement)]])
-- vim.cmd([[vmap <c-Up> <Plug>(dial-increment)]])
-- vim.cmd([[vmap <c-Down> <Plug>(dial-decrement)]])
-- vim.cmd([[vmap g<c-Up> <Plug>(dial-increment-additional)]])
-- vim.cmd([[vmap g<c-Down> <Plug>(dial-decrement-additional)]])
-- -- nmap("Format", "+", "`<Plug>(dial-increment)", "format_increment_n", "increment under cursor")
-- nmap("Format", "-", "`<Plug>(dial-decrement)", "format_decrement_n", "decrement under cursor")
-- vmap("Format", "+", "`<Plug>(dial-increment)", "format_increment_v", "increment selection")
-- vmap("Format", "-", "`<Plug>(dial-decrement)", "format_decrement_v", "decrement selection")
-- vmap("Format", "g+", "`<Plug>(dial-increment-additional)", "format_increment_g", "increment additional")
-- vmap("Format", "g-", "`<Plug>(dial-decrement-additional)", "format_decrement_g", "decrement additional")
--
-- nmap("CommandWin", "q;", "q:", "commandwin_open", "open commandwin")
-- cmap("CommandWin", "<c-y>", "<c-r>*", "commandwin_yank", "yank from commandwin")
-- cvir("CommandWin", "<C-n>", "commandwin1_next", "next item")
-- cvir("CommandWin", "<C-p>", "commandwin1_prev", "prev item")
-- cvir("CommandWin", "<tab>", "commandwin2_next", "next item")
-- cvir("CommandWin", "<s-tab>", "commandwin2_prev", "prev item")
-- --
-- -- TODO: come up with iswap key bindings
-- -- ISwap, ISwapWith: ists, arrays, function arguments, function parameters
-- nvir("Format", "gu", "format_lowercase1", "lowercase")
-- nvir("Format", "gU", "format_uppercase1", "uppercase")
-- nvir("Format", "gR", "format_rename", "ts rename under cursor")
-- nmap("Format", "<leader>[", "`[V`]<", "format_indent_all", "indent all lines")
-- nmap("Format", "<leader>]", "`[V`]>", "format_unindent_all", "unindent all lines")
-- nmap("Format", "<leader>fU", "gUw", "format_uppercase2", "uppercase")
-- nmap("Format", "<leader>fu", "guw", "format_lowercase2", "lowercase")
-- nmap("Format", "<leader>fs", "<cmd>Snek<cr>", "format_snakecase", "snake case")
-- nmap("Format", "<leader>fk", "<cmd>Kebab<cr>", "format_kebabcase", "kebab case")
-- nmap("Format", "<leader>fc", "<cmd>Camel<cr>", "format_camelcase", "camel case")
-- nmap("Format", "<leader>fC", "<cmd>CamelB<cr>", "format_camelbcase", "camelB case")
-- vmap("Format", "<leader>fs", "<cmd>Snek<cr>", "format_v_snakecase", "snake case")
-- vmap("Format", "<leader>fk", "<cmd>Kebab<cr>", "format_v_kebabcase", "kebab case")
-- vmap("Format", "<leader>fc", "<cmd>Camel<cr>", "format_v_camelcase", "camel case")
-- vmap("Format", "<leader>fC", "<cmd>CamelB<cr>", "format_v_camelbcase", "camelB case")
-- nmap("Markdown", "<leader>mp", ":MarkdownPreview<CR>", "md_preview", "display markdown preview")
-- vmap("Markdown", "<leader>tn", "<plug>(mkdx-toggle-checkbox-v)", "md_toggle_cb_v", "toggle checkbox")
-- nmap("Markdown", "<leader>tn", "<plug>(mkdx-toggle-checkbox-n)", "md_toggle_cb_n", "toggle checkbox")
-- nmap("Markdown", "<leader>tt", "<cmd>ToggleCB<cr>", "md_toggle_cb_value", "toggle checkbox value")
-- nvir("Markdown", "<leader>tm", "md_tablemode_toggle", "toggle tablemode")
-- nvir("Markdown", "<leader>T", "md_tableize_n", "tableize cursor")
-- vvir("Markdown", "<leader>T", "md_tableize_v", "tableize selection")
-- nvir("Markdown", "<leader>tr", "md_table_relign_n", "relign table")
-- vvir("Markdown", "<leader>tr", "md_table_relign_v", "relign table")
-- nvir("Markdown", "<leader>tic", "md_table_insert_col_n", "insert table column")
-- vvir("Markdown", "<leader>tic", "md_table_insert_col_v", "insert table column")
-- nvir("Markdown", "<leader>dic", "md_table_delete_col_n", "delete table column")
-- vvir("Markdown", "<leader>dic", "md_table_delete_col_v", "delete table column")
--
local formatters_map = {
  ["s"] = {
    name = "+surround",
    ["a"] = "add surrounding",
    ["d"] = "delete surrounding",
    ["r"] = "replace surrounding",
    ["bd"] = "search and delete",
    ["br"] = "search and replace"
  }
  -- ["<leader>t"] = {
  --   name = "+text format",
  --   [","] = { "A,<esc>", "add comma to end of line" },
  --   [";"] = { "A;<esc>", "add semicolon to end of line" },
  --   [":"] = { "A:<esc>", "add colon to end of line" },
  --   ["S"] = "source file",

  -- },
}

-- local formatter_opts = { mode = "n", buffer = nil, silent = true, noremap = true, nowait = false }
-- require("which-key").register(formatters_map, formatter_opts)

local buffer_map = {
  -- [":"] = { ":<C-f>", "auto open task window" },
  -- ["<Leader>s"] = { "<cmd>call scratch#insert(0)<cr>", "scratch clear"},
  -- ["<Leader>S"] = { "<cmd>call scratch#insert(1)<cr>", "scratch reuse"},
  -- ["p"] = { "p`]", "Jump to end of pasted text" },
  ["Q"] = { "<nop>", "which_key_ignore" },
  ["q;"] = "open command window",
  ["_"] = "remove highlight",
  ["D"] = "delete to line end",
  ["G"] = "scroll to bottom",
  ["H"] = "buffer left",
  ["K"] = "lsp hover document",
  ["L"] = "buffer right",
  ["T"] = "toggle terminal",
  ["U"] = "toggle undo tree",
  ["n"] = "next matching search",
  ["N"] = "prev matching search",
  ["ZZ"] = "exit with save",
  ["*"] = "next matching cursor",
  ["#"] = "prev matching cursor",
  ["<bs>"] = "back to prev file",
  ["<cr>"] = "enter zettel link",
  ["<C-b>"] = "scroll backwards",
  ["<C-d>"] = "picker git file log",
  ["<A-d>"] = "picker git log",
  ["<C-e>"] = "picker buffers",
  ["<A-e>"] = "picker sessions",
  ["<C-f>"] = "scroll forward",
  ["<C-g>"] = "picker git actions",
  ["<A-g>"] = "picker git status",
  ["<C-h>"] = "window left",
  ["<C-j>"] = "window down",
  ["<C-k>"] = "window up",
  ["<A-j>"] = "picker jumps",
  ["<C-l>"] = "window right",
  ["<A-m>"] = "picker location list",
  ["<C-p>"] = "picker project files",
  ["<A-p>"] = "picker workspace diagnostics",
  ["<C-q>"] = "quick exit no save",
  ["<C-s>"] = "quick save",
  ["<A-s>"] = "picker search (rg)",
  ["<C-x>"] = "quick exit with save",
  ["<A-o>"] = "picker home files",
  ["<C-u>"] = "picker mru files",
  ["<A-u>"] = "picker commands",
  ["<A-/>"] = "picker helptags",
  ['""'] = "view registers",
  ["<F2>"] = "toggle whichkey",
  ["<F3>"] = "toggle explorer",
  ["<F4>"] = "toggle mundo tree",
  ["<F5>"] = "toggle terminal",
  ["<F6>"] = "toggle treesitter",
  ["["] = { name = "+prev pairing", ["d"] = "lsp diagnostic prev" },
  ["]"] = { name = "+next pairing", ["d"] = "lsp diagnostic next" },
  ["<leader>["] = "un-indent all lines",
  ["<leader>]"] = "indent all lines",
  ["<leader>f"] = {
    name = "+transform",
    ["u"] = "lower case",
    ["U"] = "upper case",
    ["s"] = "snake case",
    ["k"] = "kebab case",
    ["c"] = "camel case",
    ["C"] = "camelB case"
  },
  ["<leader>F"] = {
    name = "+find",
    ["b"] = "buffer",
    ["c"] = "colorscheme",
    ["f"] = "file",
    ["g"] = "grep text",
    ["h"] = "vim tags",
    ["n"] = "nvim dotfiles",
    ["o"] = "recent files",
    ["m"] = "maps (normal)",
    ["mi"] = "maps (insert)",
    ["mv"] = "maps (visual)",
    ["mo"] = "maps (operator)"
  },
  ["g"] = {
    name = "+go actions",
    ["<"] = "view most recent message",
    ["*"] = "next matching cursor",
    ["#"] = "prev matching cursor",
    ["0"] = "toc ts definitions",
    ["U"] = "uppercase motion",
    ["a"] = "ascii under cursor",
    ["d"] = "lsp definitions",
    ["D"] = "lsp buffer declaration",
    ["f"] = "goto file under cursor",
    ["F"] = "goto file under line",
    ["g"] = "scroll to top",
    ["h"] = "packer lsp finder",
    ["i"] = "move to last insertion",
    ["I"] = "insert at beginning",
    ["k"] = "lsp hover document",
    ["nn"] = "start incremental selection",
    ["nd"] = "goto ts definition",
    ["nD"] = "list ts definitions",
    ["o"] = "lsp organize imports",
    ["R"] = "ts rename under cursor",
    ["r"] = "packer lsp references",
    ["s"] = "packer signature help",
    ["u"] = "lowercase motion",
    ["v"] = "select last edited text",
    ["x"] = "open file under cursor",
    ["y"] = "packer buffer definition"
  },
  ["gz"] = {
    name = "+zettelkasten",
    ["c"] = "new zettel",
    ["N"] = "new zettel from cursor",
    ["r"] = "neuron refresh cache",
    ["U"] = "neuron prev history",
    ["P"] = "neuron next history",
    ["n"] = "edit new zettel",
    ["u"] = "edit last zetel",
    ["z"] = "edit zettel select",
    ["Z"] = "edit zettel backlink",
    ["o"] = "edit zettel cursor",
    ["s"] = "edit zettel from search",
    ["S"] = "edit zettel search cursor",
    ["l"] = "inesrt zettel last",
    ["i"] = "goto zettel index",
    ["L"] = "neuron insert zettel last",
    ["I"] = "neuron insert zettel select",
    ["v"] = "toggle backlinks",
    ["t"] = "add new tag",
    ["T"] = "add existing tag",
    ["ts"] = "search zettel tags"
  },
  ["<leader>"] = {
    ["q"] = "close window with save",
    ["x"] = "close buffer with save",
    ["z"] = "quick exit with prompt",
    ["!"] = "close all buffers but current",
    ["w"] = "save files without autocommands",
    ["*"] = "save all buffers",
    [":"] = "window prev",
    [";"] = "window next",
    ["H"] = "winsplit-h new",
    ["V"] = "winsplit-v new",
    ["_"] = "winsplit-v maximize",
    ["|"] = "winsplit-h maximize",
    ["="] = "winsplit even",
    ["."] = "load alt file",
    ["n"] = {
      name = "+new",
      ["f"] = "create new file",
      ["s"] = "create new file in a split",
      ["t"] = "create new file in tab"
    },
    ["i"] = {
      name = "+nvim internal",
      ["u"] = "packer update",
      ["i"] = "packer install",
      ["s"] = "packer sync",
      ["c"] = "packer clean",
      ["S"] = "packer status",
      ["e"] = "edit plugins"
    },
    ["g"] = {
      name = "+git",
      ["f"] = "telescope git files",
      ["c"] = "telescope git commits",
      ["b"] = "telescope git branches",
      ["s"] = "telescope git status",
      ["n"] = "git next hunk",
      ["p"] = "git prev hunk",
      ["v"] = "git preview hunk",
      ["r"] = "git reset hunk",
      ["R"] = "git reset buffer"
    },
    ["l"] = {
      name = "+lsp",
      ["a"] = "code action",
      ["A"] = "selected action",
      ["d"] = "document diagnostics",
      ["D"] = "workspace diagnostics",
      ["e"] = "view lsp log",
      ["l"] = "line diagnostics",
      ["f"] = "lsp finder",
      ["i"] = "lsp server info",
      ["k"] = "signature help",
      ["F"] = "format",
      ["p"] = "preview definition",
      ["r"] = "rename",
      ["s"] = "document symbols",
      ["S"] = "workspace symbols",
      [".a"] = "stop all"
    },
    ["y"] = {
      name = "+repl",
      ["<cr>"] = "open",
      ["r"] = "send motion",
      ["p"] = "send previous",
      ["rr"] = "send line",
      ["r<cr>"] = "send selection"
    },
    ["cl"] = {
      name = "+conceallevel",
      ["l"] = { "clear conceal" },
      ["0"] = { "set conceal 0" },
      ["1"] = { "set conceal 1" },
      ["2"] = { "set conceal 2" },
      ["3"] = { "set conceal 3" }
    }
    -- ["<leader>s"] = {
    --   name = "+session",
    --   ["s"] = {"<cmd>SSave<cr>", "session save"},
    --   ["c"] = {"<cmd>SClose<cr>", "session close"},
    --   ["d"] = {"<cmd>SDelete<cr>", "session delete"},
    --   ["l"] = {"<cmd>SLoad<cr>", "session load"}
    -- }
  }
}

-- local buffer_opts = { mode = "n", buffer = nil, silent = true, noremap = true, nowait = false }
-- require("which-key").register(buffer_map, buffer_opts)

local insert_map = {
  ["<c-s>"] = "save in insert",
  ["jk"] = { "<esc>", "exit from insert" },
  ["<C-u>"] = { "<C-g>u<C-u>", "which_key_ignore" }, -- Make <C-u> undo-friendly
  ["<C-w>"] = { "<C-g>u<C-w>", "which_key_ignore" } -- Make <C-w> undo-friendly
}
-- local insert_opts = { mode = "i", buffer = nil, silent = true, noremap = true, nowait = true }
-- require("which-key").register(insert_map, insert_opts)

-- vmap("Visual", "<", "<gv", "visual_unindent", "unindent repeatedly")
-- vmap("Visual", ">", ">gv", "visual_indent", "indent repeatedly")

-- Automatically jump to the end of pasted text
-- map("v", "y", "y`]")
-- map("v", "p", "p`]")
local visual_map = {
  ["<"] = "unindent lines continuously",
  [">"] = "indent lines continuously",
  ["+"] = "expand incremental selection",
  ["-"] = "shrink incremental selection",
  ["K"] = "move selected text up",
  ["J"] = "move selected text down",
  ["grn"] = "expand incremental selection",
  ["grm"] = "shrink incremental selection",
  ["grc"] = "scope incremental selection",
  ["<leader>r"] = "repl send visual",
  ["<leader>f"] = {
    name = "+transform",
    ["u"] = "lower case",
    ["U"] = "upper case",
    ["s"] = "snake case",
    ["k"] = "kebab case",
    ["c"] = "camel case",
    ["C"] = "camelB case"
  }
}

-- local visual_opts = { mode = "x", buffer = nil, silent = true, noremap = true, nowait = false }
-- disabled unimpaired mappings commented out
-- TODO: toggle neoformat au, lsp_diagnostic, gitsigns
local unimpaired_map = {
  ["yo"] = {
    name = "+toggle options",
    ["b"] = "light/dark background",
    ["c"] = "cursorline",
    ["d"] = "diff this / diffoff",
    ["h"] = "search highlight",
    ["i"] = "search case ignore",
    ["l"] = "list",
    ["n"] = "number",
    ["r"] = "relative number",
    ["s"] = "spell check",
    ["u"] = "cursorcolumn",
    ["v"] = "virtualedit text",
    ["w"] = "word wrap",
    ["x"] = "crosshairs"
  },
  ------- pasting
  ["]p"] = "Paste after line incr indent.",
  ["[p"] = "Paste before line incr indent.",
  ["[P"] = "Paste after line decr indent.",
  ["]P"] = "Paste before line decr indent.",
  [">p"] = "Paste after line incr indent.",
  [">P"] = "Paste before line incr indent.",
  ["<p"] = "Paste after line decr indent.",
  ["<P"] = "Paste before line decr indent.",
  ["=p"] = "hPaste after line reindenting.",
  ["=P"] = " Paste before line reindenting.",
  ["[op"] = "new line paste after ",
  ["]op"] = "new line paste before",
  ["yop"] = "paste within",
  -- next/prev pairs
  ["[a"] = "ed prev files (args)",
  ["]a"] = "ed next files (args)",
  ["[b"] = "prev buf (list)",
  ["]b"] = "next buf (list)",
  ["[l"] = "loc prev",
  ["]l"] = "loc next",
  ["[<C-L>"] = "loc prev in file",
  ["]<C-L>"] = "loc next in file",
  ["[q"] = "qf prev",
  ["]q"] = "qf next",
  ["[<C-Q>"] = "qf prev in file",
  ["]<C-Q>"] = "qf next in file",
  ["[t"] = "tag previous",
  ["]t"] = "tag next",
  ["[<C-T>"] = "tag prev in prev window",
  ["]<C-T>"] = "tag next in prev window"
}

local opts = { mode = "n", buffer = nil, silent = true, noremap = true, nowait = false }
-- ["[B"]       = { ":bfirst","first buf (list)"},
-- ["]B"]       = { ":blast", "last buf (list)"},
-- ["[L"]       = { ":lfirst", "loc first"},
-- ["]L"]       = { ":llast", "loc last"},
-- ["[Q"]       = { ":cfirst", "qfirst"},
-- ["]Q"]       = { ":clast", "qf last"},
-- ["[T"]       = { ":tfirst", "tag first"},
-- ["]T"]       = { ":tlast", "tag last"},
-- ["[f"]       = { "<Plug>unimpairedDirectoryPrevious", "prev file alpha"},  -- **
-- ["]f"]       = { "<Plug>unimpairedDirectoryNext", "next file alpha"}, -- **
-- ["[n"]       = { "<Plug>unimpairedContextPrev", "prev scm/git hunk"},
-- ["]n"]       = { "<Plug>unimpairedContextNext", "next scm/git hunk"},
-- ["[<Space>"] = { "<Plug>unimpairedBlankUp", "add lines above"},
-- ["]<Space>"] = { "<Plug>unimpairedBlankDown", "add lines below"},
-- ["[e"]       = { "<Plug>unimpairedMoveUp", "exchange with line above"}, --**
-- ["]e"]       = { "<Plug<unimpairedMoveDown", "exchange with line below"}, --**

-- require("which-key").register(visual_map, visual_opts)

local command_map = {
  -- cnoremap <silent> <M-[> <C-u>:History:<CR>
  -- <c-r>,+  pastes into comman
  -- cmap <Tab> <C-f>a<Tab>
  -- ["<C-n>"] = { "<Tab>", "autocomplete down" },
  -- ["<C-p>"] = { "<Up>", "autocomplete up" },
  ["<C-y>"] = "yank from commandwin",
  ["<C-n>"] = "next item",
  ["<C-p>"] = "prev item",
  ["<tab>"] = "next item",
  ["<s-tab>"] = "prev item"
}

--- DAP interactions
local dap_maps = {
  ["<F8>"] = { "<cmd>lua require('dap').continue()<cr>", "dap continue" },
  ["<F9>"] = { "<cmd>lua require('dap').step_over()<cr>", "dap step-over" },
  ["<F10>"] = { "<cmd>lua require('dap').step_into()<cr>", "dap step-into" },
  ["<F11>"] = { "<cmd>lua require('dap').step_out()<cr>", "dap step-out" },
  ["<S-F12>"] = { "<cmd>lua require('dap').repl.run_last()<cr>", "dap repl run last" },
  ["<leader>b"] = {
    name = "+breakpoints",
    ["p"] = { "<cmd>lua require'dap'.set_breakpoint()<cr>", "set breakpoint" },
    ["b"] = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", "toggle breakpoint1" },
    ["t"] = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", "toggle breakpoint2" },
    ["c"] = {
      "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>",
      "conditional breakpoint"
    },
    ["l"] = {
      "<cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<cr>",
      "logging breakpoint"
    }
  },
  ["<leader>d"] = {
    name = "+dap",
    ["t"] = { "<cmd>lua require'dapui'.toggle()<cr>", "toggle dap ui" },
    [" "] = { "<cmd>lua require'dap'.continue()<cr>", "start lua dap" },
    ["s"] = { "<cmd>lua require'dapui'.toggle('sidebar')<cr>", "toggle ui sidebar" },
    ["c"] = { "<cmd>lua require'dap'.continue()<cr>", "dap continue" },
    ["i"] = { "<cmd>lua require('dap').step_into()<cr>", "dap step-into" },
    ["o"] = { "<cmd>lua require('dap').step_over()<cr>", "dap step-over" },
    ["r"] = { "<cmd>lua require('dap').repl.toggle()<cr>", "dap repl toggle" }
    -- ["s"] = { "<cmd>DebugStart<cr>", "Start" },
  }
}

-- TODO: vimade buf disable, assign shortcuts to windows, investigate floats
-- require("dapui").open()
-- require("dapui").close()
-- require("dapui").toggle(), toggle("sidebar"), toggle("tray")
-- require("dapui").float_element(<element ID>)
-- require("dapui").eval(<expression>)
-- dap.goto_(15) dap.goto_(), dap. pause, run, restart, stop, list breakpoints,
-- set_exception_breakpoints, run_last, run_to_cursor
-- ["S"] = { "<cmd>lua require'osv'.run_this()<cr>", "start lua dap" },
-- nnoremap <silent> <leader>dn :lua require('dap-python').test_method()<CR>
-- vnoremap <silent> <leader>ds <ESC>:lua require('dap-python').debug_selection()<CR>

local dap_v_maps = {
  ["<M-k>"] = { "<cmd>lua require('dapui').eval()<CR>>", "dap evaluate under cursor" }
}

local dap_opts = { mode = "n", buffer = nil, silent = true, noremap = true, nowait = false }

local dap_v_opts = { mode = "v", buffer = nil, silent = true, noremap = true, nowait = false }

-- require("which-key").register(dap_v_maps, dap_v_opts)
-- require("which-key").register(dap_maps, dap_opts)

-- local command_opts = { mode = "c", buffer = nil, silent = true, noremap = true, nowait = false }
-- require("which-key").register(command_map, command_opts)

-- TODO: terminal mappings
-- "Terminal normal mode
-- if has('nvim')
-- tnoremap <A-[> <C-\><C-n> "<-- exit key bind
-- "Switching between split windows:
-- tnoremap <A-h> <c-\><c-n><c-w>h
-- tnoremap <A-j> <c-\><c-n><c-w>j
-- tnoremap <A-k> <c-\><c-n><c-w>k
-- tnoremap <A-l> <c-\><c-n><c-w>l
-- nnoremap <A-h> <c-w>h
-- nnoremap <A-j> <c-w>j
-- nnoremap <A-k> <c-w>k
-- nnoremap <A-l> <c-w>l
-- "  tnoremap <Tab> <C-\><C-n>:bn<CR>
-- "  tnoremap <S-Tab> <C-\><C-n>:bp<CR>
-- endif
-- Note that g! is equivalent to v, so you could also do the above with:
-- deleting lines
-- :g/profile/d
-- :g/^\s*$/d
-- :g!/^\s*"/d
-- map("t", "<C-o>", [[<C-\><C-n>]])
-- Esc in the terminal
-- map("t", "jj", [[<C-\><C-n>]])
-- map('t', '<ESC>', '&filetype == "fzf" ? "\\<ESC>" : "\\<C-\\>\\<C-n>"' , {expr = true})
-- map('t', 'jj', '<ESC>', {noremap = false})
-- map('v', '<leader>s', ':s//gcI<Left><Left><Left><Left>')

-- buf_set_keymap('n', '<leader>lrn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
-- buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
-- buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
-- buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
-- buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
-- buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
-- buf_set_keymap('n', '<leader>law', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
-- buf_set_keymap('n', '<leader>lrw', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
-- buf_set_keymap('n', '<leader>llw', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
-- buf_set_keymap('n', '<leader>ll', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
-- vim.api.nvim_buf_set_keymap(bufnr, "n", "<C-]>", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
-- vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
-- vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>wd", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
-- vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
-- vim.api.nvim_buf_set_keymap(bufnr, "n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", opts)
-- vim.api.nvim_buf_set_keymap(bufnr, "n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts)
-- vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
-- vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
-- vim.api.nvim_buf_set_keymap(bufnr, "n", "gq", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", opts)
-- vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
-- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
-- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
-- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
-- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
-- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
-- vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
-- vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
-- vim.cmd("nnoremap <silent>gh :Lspsaga lsp_finder<CR>")
-- vim.cmd("nnoremap <silent>gca :Lspsaga code_action<CR>")
-- vim.cmd("vnoremap <silent>gca :<C-U>Lspsaga range_code_action<CR>")
-- vim.cmd("nnoremap <silent><leader>gs :Lspsaga signature_help<CR>")
-- vim.cmd("nnoremap <silent><leader>gd :Lspsaga preview_definition<CR>")
-- vim.cmd("nnoremap <silent>gD :Lspsaga preview_definition<CR>")
-- vim.cmd("nnoremap <silent>gk :Lspsaga hover_doc<CR>")
-- vim.cmd("nnoremap <silent>ge :Lspsaga show_line_diagnostics<CR>")
-- vim.cmd("nnoremap <silent><leader>ca :Lspsaga code_action<CR>")
-- vim.cmd("vnoremap <silent><leader>ca :<C-U>Lspsaga range_code_action<CR>")
-- vim.cmd("nnoremap <silent>[e :Lspsaga diagnostic_jump_next<CR>")
-- vim.cmd("nnoremap <silent>]e :Lspsaga diagnostic_jump_prev<CR>")
-- vim.cmd('nnoremap <silent><PageDown> <cmd>lua require("lspsaga.action").smart_scroll_with_saga(1)<CR>')
-- vim.cmd('nnoremap <silent><PageUp> <cmd>lua require("lspsaga.action").smart_scroll_with_saga(-1)<CR>')
-- vim.cmd("nnoremap <silent><leader>rn :Lspsaga rename<CR>")
-- vim.cmd('nnoremap <silent> <A-d> :Lspsaga open_floaterm<CR>')
-- vim.cmd('tnoremap <silent> <A-d> <C-\><C-n>:Lspsaga close_floaterm<CR>')
-- vim.cmd('nnoremap <silent><leader>cd <cmd>lua<CR> require"lspsaga.diagnostic".show_line_diagnostics()<CR>')
-- -- only show diagnostic if cursor is over the area
-- -- vim.cmd('nnoremap <silent><leader>cc <cmd>lua<CR> require"lspsaga.diagnostic".show_cursor_diagnostics()<CR>')
-- -- float terminal also you can pass the cli command in open_float_terminal function
-- map("n", "<leader>tv", ":lua diagnostic_toggle_virtual_text()<CR>")
--
-- TODO: create generic goto next/prev with [[ , ]] that handles loc lists, qf lists, diagnostics
--

-- nnoremap <buffer> <CR> <cmd>lua require'neuron'.enter_link()<CR>
-- " create a new note
-- nnoremap <buffer> gzn <cmd>lua require'neuron/cmd'.new_edit(require'neuron'.config.neuron_dir)<CR>
-- " find your notes, click enter to create the note if there are not notes that match
-- nnoremap <buffer> gzz <cmd>lua require'neuron/telescope'.find_zettels()<CR>
-- " insert the id of the note that is found
-- nnoremap <buffer> gzZ <cmd>lua require'neuron/telescope'.find_zettels {insert = true}<CR>
-- " find the backlinks of the current note all the note that link this note
-- nnoremap <buffer> gzb <cmd>lua require'neuron/telescope'.find_backlinks()<CR>
-- " same as above but insert the found id
-- nnoremap <buffer> gzB <cmd>lua require'neuron/telescope'.find_backlinks {insert = true}<CR>
-- " find all tags and insert
-- nnoremap <buffer> gzt <cmd>lua require'neuron/telescope'.find_tags()<CR>
-- " start the neuron server and render markdown, auto reload on save
-- nnoremap <buffer> gzs <cmd>lua require'neuron'.rib {address = "127.0.0.1:8200", verbose = true}<CR>
-- " go to next [[my_link]] or [[[my_link]]]
-- nnoremap <buffer> gz] <cmd>lua require'neuron'.goto_next_extmark()<CR>
-- " go to previous
-- nnoremap <buffer> gz[ <cmd>lua require'neuron'.goto_prev_extmark()<CR>]]

-- map("n", "<Leader>/", ":Ack!<Space>")
-- map("n", "<Leader>/", "<Plug>AgActionWord")
-- map("v", "<Leader>/", "<Plug>AgActionVisual")

-- -- lsp-saga
--   -- vim.cmd('nnoremap <silent><leader>cd <cmd>lua<CR> require"lspsaga.diagnostic".show_line_diagnostics()<CR>')
--   -- only show diagnostic if cursor is over the area
--   -- vim.cmd('nnoremap <silent><leader>cc <cmd>lua<CR> require"lspsaga.diagnostic".show_cursor_diagnostics()<CR>')
--   -- float terminal also you can pass the cli command in open_float_terminal function
--   -- vim.cmd('nnoremap <silent> <A-d> :Lspsaga open_floaterm<CR>')
--   -- vim.cmd('tnoremap <silent> <A-d> <C-\><C-n>:Lspsaga close_floaterm<CR>')
-- end

-- function mappings.lsp_attach(_client, bufnr)
--   vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

--   local opts = {noremap = true, silent = true}
--   vim.api.nvim_buf_set_keymap(
--     bufnr,
--     "n",
--     "<leader>wl",
--     "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
--     opts
--   )
-- end

-- local telescope_maps = {
-- t = {
-- autocommands
-- buffers
-- colorscheme
-- command_history
-- commands
-- current_buffer_fuzzy_find
-- current_buffer_tags
-- fd
-- file_browser
-- filetypes
-- find_files
-- help_pages
-- highlights
-- keymaps
-- live_grep
-- loclist
-- man_pages
-- marks
-- oldfiles
-- quickfix
-- registers
-- search_history
-- spell_suggest
-- tags
-- vim_options
--
-- lsp_references
-- lsp_document_symbols
-- lsp_worksplace_symbols
-- lsp_dynamic_worksplace_symbols
-- lsp_code_actions
-- lsp_range_code_actions
-- lsp_document_diagnostics
-- lsp_workspace_diagnostics
-- lsp_implementations
-- lsp_definitions
--
-- dap commands
-- dap configurations
-- dap list_breakpoints
-- dap frames
-- dap variaables
--
-- git commits
-- git_bcommits
-- git_branches
-- git_status
-- git_stash
--
-- treesitter
-- builtin
-- reloader
-- }
-- }

-- FzfPreview
-- " fzf-preview.ProjectFiles
-- " fzf-preview.GitFiles
-- " fzf-preview.DirectoryFiles
-- " fzf-preview.Buffers
-- " fzf-preview.AllBuffers
-- " fzf-preview.ProjectOldFiles
-- " fzf-preview.ProjectMruFiles
-- " fzf-preview.ProjectMrwFiles
-- " fzf-preview.ProjectGrep {word}
-- " fzf-preview.Ctags
-- " fzf-preview.BufferTags
-- " fzf-preview.OldFiles
-- " fzf-preview.MruFiles
-- " fzf-preview.MrwFiles
-- " fzf-preview.QuickFix
-- " fzf-preview.LocationList
-- " fzf-preview.Lines
-- " fzf-preview.BufferLines
-- " fzf-preview.Jumps
-- " fzf-preview.Changes
-- " fzf-preview.Marks
-- " fzf-preview.FromResources
--   (project, git, directory, buffer, project_old, project_mru, project_mrw, old, mru, mrw)
-- " fzf-preview.CommandPalette
-- " fzf-preview.GitActions
-- " fzf-preview.GitStatus
-- " fzf-preview.VistaCtags
-- " fzf-preview.VistaBufferCtags
-- " fzf-preview.Bookmarks
-- " fzf-preview.Yankround
-- " fzf-preview.BlamePR

-- FZF:
-- Jumps, Registers, Highlights, AsyncTaskFzf, Sessions, Dots
-- " :Files [PATH]	Files (runs $FZF_DEFAULT_COMMAND if defined)
-- " :GFiles [OPTS]	Git files (git ls-files)
-- " :GFiles?	Git files (git status)
-- " :Buffers	Open buffers
-- " :Colors	Color schemes
-- " :Ag [PATTERN]	ag search result (ALT-A to select all, ALT-D to deselect all)
-- " :Rg [PATTERN]	rg search result (ALT-A to select all, ALT-D to deselect all)
-- " :Lines [QUERY]	Lines in loaded buffers
-- " :BLines [QUERY]	Lines in the current buffer
-- " :Tags [QUERY]	Tags in the project (ctags -R)
-- " :BTags [QUERY]	Tags in the current buffer
-- " :Marks	Marks
-- " :Windows	Windows
-- " :Locate PATTERN	locate command output
-- " :History	v:oldfiles and open buffers
-- " :History:	Command history
-- " :History/	Search history
-- " :Snippets	Snippets (UltiSnips)
-- " :Commits	Git commits (requires fugitive.vim)
-- " :BCommits	Git commits for the current buffer
-- " :Commands	Commands
-- " :Maps	Normal mode mappings
-- " :Helptags	Help tags 1
-- " :Filetypes	File types
