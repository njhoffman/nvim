-- stylua: ignore start

  -- Add undo break-points
  vim.keymap.set("i", ",", ",<c-g>u")
  vim.keymap.set("i", ".", ".<c-g>u")
  vim.keymap.set("i", ";", ";<c-g>u")


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
  map("n", "[cc", ":call search('^<\\{4,\\} \\w\\+.*$', 'Wb')<CR>", { silent = true, noremap = true, })
  -- Jump to the previous git conflict end
  map("n", "[ce", ":call search('^>\\{4,\\} \\w\\+.*$', 'Wb')<CR>", { silent = true, noremap = true, })
  -- Jump to the next git conflict start
  map("n", "]cc", ":call search('^<\\{4,\\} \\w\\+.*$', 'W')<CR>", { silent = true, noremap = true })
  -- Jump to the next git conflict end
  map("n", "]ce", ":call search('^>\\{4,\\} \\w\\+.*$', 'W')<CR>", { silent = true, noremap = true })
  -- Jump to previous divider
  map("n", "[cm", ":call search('^=\\{4,\\}$', 'Wb')<CR>", { silent = true, noremap = true })
  -- Jump to next divider
  map("n", "]cm", ":call search('^=\\{4,\\}$', 'W')<CR>", { silent = true, noremap = true })

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

  map("n", "]a", ':execute ":" . v:count . "next"<CR>', { silent = true, noremap = true })
  map("n", "[a", ':execute ":" . v:count . "previous"<CR>', { silent = true, noremap = true })

  map("n", "]l", ':execute ":" . v:count . "lnext"<CR>', { silent = true, noremap = true })
  map("n", "[l", ':execute ":" . v:count . "lprevious"<CR>', { silent = true, noremap = true })

  map("n", "]q", ':execute ":" . v:count . "cnext"<CR>', { silent = true, noremap = true })
  map("n", "[q", ':execute ":" . v:count . "cprevious"<CR>', { silent = true, noremap = true })

  map("n", "]b", ':execute ":" . v:count . "bnext"<CR>', { silent = true, noremap = true })
  map("n", "[b", ':execute ":" . v:count . "bprevious"<CR>', { silent = true, noremap = true })

  -- Switch to a terminal buffer using [count]gs.
  map( "n", "<leader>gt", '<cmd>execute "lua require\\"vimrc.terminal\\".switch_to_terminal(" . v:count . ")"<CR>',
    { silent = true, noremap = true }
  )

  -- Taking from here: https://github.com/stoeffel/.dotfiles/blob/master/vim/visual-at.vim
  -- Allows running macros only on selected files.
  map( "x", "@", ':<C-u>echo "@".getcmdline() | execute ":\'<,\'>normal @" . nr2char(getchar())<CR>',
    { silent = true, noremap = true }
  )

  map("x", ".", ":normal .<CR>", { silent = true })

  -- Pressing <leader>ss will toggle and untoggle spell checking
  map("n", "<leader>ss", ":setlocal spell!<CR>", { silent = true })

  -- map("t", "<C-d>", "<PageDown>", { silent = true })
  -- map("t", "<C-u>", "<PageUp>", { silent = true })
  map("t", "<C-w><C-q>", "<C-\\><C-n>", { silent = true, noremap = true })
  map("t", "<C-w><C-h>", "<C-\\><C-n><C-w>h", { silent = true, noremap = true })
  map("t", "<C-w><C-j>", "<C-\\><C-n><C-w>j", { silent = true, noremap = true })
  map("t", "<C-w><C-k>", "<C-\\><C-n><C-w>k", { silent = true, noremap = true })
  map("t", "<C-w><C-l>", "<C-\\><C-n><C-w>l", { silent = true, noremap = true })


  vim.cmd([[
  cabbrev T Telescope
  cabbrev d lua vim.dbg(
  cabbrev D DebugLog
  cabbrev Plug execute "normal \<Plug>(
]])

local M = vim.import("mapper")

  M.map("Interface", "n", '"', "registers")
  M.map("Interface", "n", "<F2>", "whichkey")
  M.map("Interface", "n", "<F3>", "nvim_tree")
  -- M.map("Interface", "n", "<M-p>", "neo_tree")
  M.map("Interface", "n", "<F4>", "mundo1")
  -- M.map("Interface", "n", "<F5>", "term1")
  M.map("Interface", "n", "<F6>", "treesitter")
  M.map("Interface", "n", "<F7>", "aerial")
  M.map("Interface", "n", "<S-F7>", "aerial_float")

  M.map("System", "n", "<leader>iy", "yank_filename")
  M.map("System", "n", "<leader>iY", "yank_buffer")
  M.map("System", "n", "<leader>if", "display_filename")
  M.map("System", "n", "<leader>iO", "shada_edit")

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


  M.map("Unimpaired", "n", "]p", "paste_after_indent1")
  M.map("Unimpaired", "n", "[p", "paste_before_indent1")
  M.map("Unimpaired", "n", "]P", "paste_after_unindent1")
  M.map("Unimpaired", "n", "[P", "paste_before_unindent1")

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
