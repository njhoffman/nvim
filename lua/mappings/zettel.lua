local M = {
  enter1 = {
    cmd   = "<plug>EditZettelUnderCursor",
    short = "enter zettel link",
  },
  enter2 = {
    cmd = "<cmd>lua require('neuron').enter_link()<cr>",
    short = "enter zettel link",
  },
  edit_new = { cmd = "<plug>EditZettelNew", short = "edit new zettel", long = "edit new zettel" },
  edit_last = { cmd = "<plug>EditZettelLast", short = "edit last zettel", long = "edit last zettel" },
  refresh_virtual_titles = {
    cmd = "<cmd>lua require('neuron').update_virtual_titles()<cr>",
    short = "refresh virtual titles",
  },
  new = {
    cmd = "<cmd>lua require'neuron/cmd'.new_edit('/home/nicholas/zettelkasten')<CR>",
    short = "new zettel",
  },
  -- new_cb = { cmd = "<cmd>lua require'neuron/cmd'.new_and_callback('/home/nicholas/zettelkasten', cb)<CR>", short = "new zettel", long = "new zettel" },
  edit_new_cword = {
    cmd = "<plug>EditZettelNewFromCword", short = "new zettel cursor",
    long = "new zettel cursor",
  },
  -- refresh_cache = {
  -- 	cmd = "<plug>NeuronRefreshCache",
  -- 	short = "neuron refresh cache",
  -- 	long = "neuron refresh cache",
  --  },
  prev_link = {
    cmd = "<cmd>lua require'neuron'.goto_prev_extmark()<cr>",
    short = "neuron prev link",
  },
  next_link = {
    cmd = "<cmd>lua require'neuron'.goto_next_extmark()<cr>",
    short = "neuron next link",
  },
  prev_history = {
    cmd = "<cmd>call neuron#move_history(-1)<cr>",
    short = "neuron prev history",
  },
  next_history = {
    cmd = ":<C-U>call neuron#move_history(1)<cr>",
    short = "neuron next history",
  },
  edit_select = { cmd = "<plug>EditZettelSelect", short = "edit zettel select", long = "edit zettel select" },
  edit_backlink = {
    cmd = "<Plug>EditZettelBacklink",
    short = "edit zettel backlink",
  },
  edit_cursor = { cmd = "<Plug>EditZettelUnderCursor", short = "edit zettel cursor", long = "edit zettel cursor" },
  search_content = {
    cmd = "<Plug>EditZettelSearchContent",
    short = "zettel search content",
  },
  search_cursor = {
    cmd = "<Plug>EditZettelSearchContentUnderCursor",
    short = "zettel search cursor",
  },
  insert_last1 = { cmd = "<Plug>InsertZettelLast", short = "insert zettel last", long = "insert zettel last" },
  index = {
    cmd = "<cmd>lua require'neuron'.goto_index()<cr>",
    short = "goto zettel index",
  },
  insert_last2 = {
    cmd = "<cmd>call neuron#insert_zettel_last(1)<cr>",
    short = "insert zettel last",
  },
  insert_next = {
    cmd = "<cmd>call neuron#insert_zettel_select(1)<cr>",
    short = "insert zettel select",
  },
  toggle_backlinks = { cmd = "<Plug>ToggleBacklinks", short = "toggle backlinks", long = "toggle backlinks" },
  tag_new = { cmd = "<Plug>TagsAddNew", short = "add new tag", long = "add new tag" },
  tag_select = { cmd = "<Plug>TagsAddSelect", short = "add existing tag", long = "add existing tag" },
  tag_search_fzf = {
    cmd = "<cmd>call neuron#tags_search()<cr>",
    short = "search zettel tags fzf",
    long = "search zettel tags in fzf"
  },
  content_search_fzf = {
    cmd = "<cmd>call neuron#search_content(0)<cr>",
    short = "search content fzf",
    long = "full content search fzf"
  },
  content_search_cursor_fzf = {
    cmd = "<cmd>call neuron#search_content(1)<cr>",
    short = "search cursor fzf",
    long = "fzf full content search under cursor"
  },
  tag_search_telescope = {
    cmd = "<cmd>lua require'neuron/telescope'.find_tags()<cr>",
    short = "search zettel tags telescope",
    long = "search zettel tags in telescope"
  },
  zettel_search_telescope = {
    cmd = "<cmd>lua require'neuron/telescope'.find_zettels()<cr>",
    short = "search zettels telescope",
    long = "search zettels in telescope"
  },
  backlinks_search_telescope = {
    cmd = "<cmd>lua require'neuron/telescope'.find_backlinks()<cr>",
    short = "search backlinks telescope",
    long = "search backlinks in telescope"
  },
  visual_new = {
    cmd = "<Plug>EditZettelNewFromVisual",
    short = "new zettel from selected",
    long = "new zettel from selected"
  },
  start_server = {
    cmd = "<cmd>lua require'neuron'.rib {address = '127.0.0.1:8200', verbose = true}<CR>",
    short = "start or reboot server",
    long = "start or reboot server"
  },
  refresh_cache = {
    cmd   = "<cmd>lua require'neuron/cmd'.gen()<CR>",
    short = "generate cache",
    long  = "generate cache",
  },
  -- NOTE: removed <expr>
  insert_last = { cmd = ":<C-U>call neuron#insert_zettel_complete(0)", short = "zettel insert last", long = "" },
  insert_select = { cmd = ":<C-U>call neuron#insert_zettel_complete(1)", short = "zettel insert selet", long = "" }
}

return M
