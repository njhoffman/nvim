local M = {
  quick_insert_esc1 = { cmd = "<esc>", short = "insert mode escape", long = "quickly escape insert mode" },
  quick_insert_esc2 = { cmd = "<esc>", short = "insert mode escape", long = "quickly escape insert mode" },
  c_u_undo_friendly = { cmd = "<C-g>u<C-u>", short = "ctrl+u undo friendly", long = "make ctrl+u undo friendly" },
  c_w_undo_friendly = { cmd = "<C-g>u<C-w>", short = "ctrl+w undo friendly", long = "make ctrl+w undo friendly" },
  select_end_no_eol = {
    cmd = "$h",
    short = "select to end no eol",
    long = "select to end of line without new line"
  },
  select_a_line = {
    cmd = "<cmd>normal 0v$h<cr>",
    short = "select a line",
    long = "select all characters in line without new line"
  },
  select_inside_line = {
    cmd = "<cmd>normal ^vg_<cr>",
    short = "select in line",
    long = "select all characters in line from first non-blank to last non-blank character"
  },
  op_a_line = {
    cmd = "<cmd>normal 0v$h<cr>",
    short = "select a line",
    long = "select all characters in line without new line"
  },
  op_inside_line = {
    cmd = "<cmd>normal ^vg_<cr>",
    short = "select in line",
    long = "select all characters in line from first non-blank to last non-blank character"
  },
  delete_end = { cmd = "d$", short = "delete to end", long = "delete to end" },
  scroll_forwards = {
    cmd = "<Plug>(SmoothieDownwards)<Plug>(SmoothieDownwards)",
    short = "scroll forwards",
    long = "smooth scroll forwards"
  },
  scroll_forwards2 = {
    cmd = "<Plug>(SmoothieDownwards)<Plug>(SmoothieDownwards)",
    short = "scroll forwards",
    long = "smooth scroll forwards"
  },
  scroll_backwards = {
    cmd = "<Plug>(SmoothieBackwards)",
    short = "scroll backwards",
    long = "smooth scroll backwards"
  },
  scroll_forwardsx3 = {
    cmd = "<Plug>(SmoothieDownwards)<Plug>(SmoothieDownwards)<Plug>(SmoothieDownwards)<Plug>(SmoothieDownwards)<Plug>(SmoothieDownwards)<Plug>(SmoothieDownwards)",
    short = "scroll forwards",
    long = "smooth scroll forwards"
  },
  scroll_bottom = { cmd = "<Plug>(Smoothie_G)", short = "scroll to bottom", long = "smooth scroll to bottom" },
  scroll_top = { cmd = "<Plug>(Smoothie_gg)", short = "scroll to top", long = "smooth scroll to top" },
  select_last = {
    cmd = "`[v`]",
    "movement_select_last",
    short = "vis select last",
    long = "visual select last edited text"
  },
  ascii = {
    cmd   = "<cmd>ascii<cr>",
    short = "ascii cursor",
    long  = "ascii under cursor",
  },
  ascii_2 = {
    cmd   = "<cmd>ascii<cr>",
    short = "ascii cursor",
    long  = "ascii under cursor",
  },
  last_insertion = {
    short = "move to last ins",
    long  = "move to last insertion",
  }, -- virtual
  begin_insertion = {
    short = "insert at beginning",
    long  = "insert at beginning",
  }, -- virtual
  last_visual = {
    short = "visual last paste",
    long  = "visual select last paste",
  }, -- virtual
  total_counts = {
    short = "chars/words/lines count",
    long  = "show current and total characters, words and lines",
  }, -- virtual
  goto_definition = {
    short = "goto ts definition",
    long  = "goto ts definition",
  }, -- virtual
  incremental_selection_init = {
    -- cmd = "<cmd>lua require'nvim-treesitter.incremental_selection'.init_selection()<cr>",
    short = "init inc selection",
    long = "init incremental selection"
  },
  incremental_selection_scope = {
    -- cmd = "<cmd>lua require'nvim-treesitter.incremental_selection'.scope_incremental()<cr>",
    short = "scope inc selection",
    long = "scope incremental selection"
  },
  incremental_selection_expand = {
    -- cmd = "<cmd>lua require'nvim-treesitter.incremental_selection'.node_incremental()<cr>",
    short = "expand inc selection",
    long = "expand incremental selection"
  },
  incremental_selection_shrink = {
    -- cmd = "<cmd>lua require'nvim-treesitter.incremental_selection'.node_decremental()<cr>",
    short = "shrink inc selection",
    long = "shrink incremental selection"
  },
  incremental_selection_init2 = {
    -- cmd   = "<cmd>lua require'nvim-treesitter.incremental_selection'.init_selection()<cr>",
    short = "init incremental",
    long  = "start tree sitter incremental expansion",
  },
  incremental_selection_scope2 = {
    -- cmd = "<cmd>lua require'nvim-treesitter.incremental_selection'.scope_incremental()<cr>",
    -- cmd = '<cmd>visual <tab><cr>',
    short = "expand incremental",
    long = "expand tree sitter incremental visual expansion"
  },
  incremental_selection_shrink2 = {
    -- cmd = "<cmd>lua require'nvim-treesitter.incremental_selection'.node_decremental()<cr>",
    short = "shrink incremental",
    long = "shrink tree sitter incremental visual selection"
  },
  -- _ (underscore) - "inner line"
  -- Examples
  -- xnoremap il 0o$h onoremap il :normal vil<CR>
  -- v_ visually selects all the text in a line,
  -- except the leading and trailing whitespace.
  -- y_ yank "inner line".
  -- d_ delete the whole line, but only "inner line" gets into the register.
  -- It's shorter to type than ^vg_ + operator.
  -- omap <silent> _  <Plug>(inner_line)
  -- nmap <silent> d_ <Plug>(inner_line_delete)
  -- xmap <silent> _  <Plug>(inner_line)
  swap_visual_block = {
    cmd = "<Esc>`.``gvP``P",
    short = "swap visual selected block with register"
  },
  delete_inner_line = {
    cmd = "0D", -- nmap dil 0D
    -- "<cmd>line#inner_delete(v:register)<cr>",
    -- norm! m` | exec 'keepj norm! ^vg_"'.a:reg.'d' | norm! "_dd
    short = "delete inner line no eol",
    long = "delete inner line without ending new line character"
  },
  yank_inner_line_v = {
    cmd = "norm! m` | keepj norm! ^vg_",
    short = "yank inner line no eol",
    long = "yank inner line without eol"
  },
  yank_inner_line = {
    cmd = "norm! m` | keepj norm! ^vg_",
    short = "yank inner line no eol",
    long = "yank inner line without ending new line character"
  },
  yank_in_line_no_eol_o = {
    cmd = "<cmd>:normal vil<CR>",
    short = "yank in line no eol",
    long = "yank in line without ending new line character"
  },
  yank_in_line_no_eol = {
    cmd = "0o$y",
    short = "yank in line no eol",
    long = "yank in line without ending new line character"
  },
  yank_line_no_eol = {
    cmd = "mQ0y$`Q",
    short = "yank line no eol",
    long = "yank line without ending new line character"
  },
  yank_line_no_eol_return = {
    cmd = "^y$<c-o>",
    short = "yank line-no-eol return",
    long = "yank line without ending new line character and return cursor to previous location"
  },
  neoclip = { cmd = "<cmd>Telescope neoclip<cr>", short = "telescope neoclip", long = "telescope neoclip" },
  fzf_yanks = { cmd = "<cmd>FZFYanks<cr>", short = "fzf yanks", long = "fzf yanks" },
  paste_primary = { cmd = '"*p', short = "paste primary", long = "paste primary" },
  paste_comment = { cmd = '"+p<esc>gvgc^', short = "paste comment", long = "paste comment" },
  paste_mode_toggle = { cmd = "<cmd>set invpaste<cr>", short = "paste mode toggle", long = "paste mode toggle" },
  hop_to_line = {
    cmd = "<cmd>HopLineStart<cr>",
    short = "hop to line",
    long = "hop to line"
  },
  hop_to_word = {
    -- cmd = "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>",
    cmd = "<cmd>HopWord<cr>",
    short = "hop to word",
    long = "hop to word"
  },
  qfc_toggle = {
    cmd = "<cmd>QFix<cr>",
    short = "togggle quickfix window",
    long = "toggle  quickfix window"
  },
  -- TODO: make custom lua function to combine quickfix, location,  undotree, any nav list
  qfc_page_down = {
    cmd = "<cmd>call qf#wrap#WrapCommand('down', 'c')<CR>",
    -- cmd    = "<Plug>(qf_qf_next)",
    short = "quickfix nav page down",
    long = "navigate to next quickfix page",
    plugin = "vim-qf"
  },
  qfc_page_up = {
    cmd = "<cmd>call qf#wrap#WrapCommand('up', 'c')<CR>",
    -- cmd    = "<Plug>(qf_qf_next)",
    short = "quickfix nav page down",
    long = "navigate to next quickfix page",
    plugin = "vim-qf"
  },
  qfc_next = {
    cmd = "<cmd>call qf#wrap#WrapCommand('down', 'c')<CR>",
    -- cmd    = "<Plug>(qf_qf_next)",
    short = "quickfix nav next",
    long = "navigate to next quickfix entry",
    plugin = "vim-qf"
  },
  qfc_prev = {
    -- cmd    = "<Plug>(qf_qf_previous)",
    cmd = "<cmd>call qf#wrap#WrapCommand('up', 'c')<CR>",
    short = "quickfix nav prev",
    long = "navigate to prev quickfix entry",
    plugin = "vim-qf"
  },
  -- nnoremap <silent>        <Plug>(qf_qf_previous)
  -- nnoremap <silent>        <Plug>(qf_qf_next)         :<C-u> call qf#wrap#WrapCommand('down', 'c')<CR>
  qfl_next = {
    -- cmd    = "<Plug>(qf_loc_next)",
    cmd = "<cmd>call qf#wrap#WrapCommand('down', 'l')<CR>",
    short = "loc list nav next",
    long = "navigate to next location list entry",
    plugin = "vim-qf"
  },
  qfl_prev = {
    -- cmd    = "<Plug>(qf_loc_previous)",
    cmd = "<cmd>call qf#wrap#WrapCommand('up', 'l')<CR>",
    short = "loc list nav prev",
    long = "navigate to prev location list entry",
    plugin = "vim-qf"
  }
}
return M
