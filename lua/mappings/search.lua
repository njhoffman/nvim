local M = {
  -- vim.cmd([[nnoremap / /\v]])
  -- vim.cmd([[vnoremap / /\v]])
  -- vim.cmd([[cnoremap %s/ %smagic/]])
  -- vim.cmd([[cnoremap \>s/ \>smagic/]])

  -- vim.cmd([[nnoremap :g/ :g/\v]])
  -- vim.cmd([[nnoremap :g// :g//]])
  -- vim.cmd([[vnoremap :g// :g//]])

  -- x  ,/            <Plug>(searchsavvy-visual-block-search)
  -- Last set from ~/.local/share/nvim/site/pack/packer/start/vim-searchsavvy/plugin/searchsavvy.vim line 54

  search_magic_1 = {
    cmd = "/\\v",
    short = "magic mode saerch"
  },
  search_magic_2 = {
    cmd = "<Esc>/\\%V",
    short = "visual magic mode saerch"
  },
  sub_magic_1 = {
    cmd = "%smagic/",
    short = "command substitute magic"
  },
  sub_magic_3 = {
    cmd = ":%smagic/",
    short = "normal substitue magic quick"
  },
  sub_magic_4 = {
    cmd = ":smagic/",
    short = "visual substitute magic quick"
  },
  rmhl = {
    cmd = "<cmd>noh<cr> | :nohlsearch<cr>",
    short = "remove highlight"
  },
  rmhl_refresh = {
    cmd = "<cmd>noh<cr>|:RefreshLSP<cr>|:lua require'feline'.reset_highlights()<cr>",
    short = "remove hls, refresh colors and lsp"
  },
  next = {
    cmd = "<cmd>execute('normal! ' . v:count1 . 'n')<cr><cmd>lua require('hlslens').start()<cr>",
    short = "next matching",
    long = "next matching"
  },
  prev = {
    cmd = "<cmd>execute('normal! ' . v:count1 . 'N')<cr><cmd>lua require('hlslens').start()<cr>",
    short = "prev matching",
    long = "prev matching"
  },
  cursor_next1 = {
    cmd = "*<cmd>lua require('hlslens').start()<cr>",
    short = "next word under cursor",
    long = "next word under cursor"
  },
  cursor_prev1 = {
    cmd = "#<cmd>lua require('hlslens').start()<cr>",
    short = "prev word under cursor",
    long = "prev word under cursor"
  },
  cursor_next2 = {
    cmd = "g*<cmd>lua require('hlslens').start()<cr>",
    short = "next word under cursor",
    long = "next word under cursor"
  },
  cursor_prev2 = {
    cmd = "g#<cmd>lua require('hlslens').start()<cr>",
    short = "prev word under cursor",
    long = "prev word under cursor"
  },
  last_match = { short = "select last search match", long = "select last search match" },
  cursor_replace = {
    cmd = "*:%s//",
    short = "replace word under cursor",
    long = "search and replace word under cursor"
  }
}

return M
