local M = {}

M.Navigation = {
  buffer_last = {cmd = ":e #<cr>", short = "last buffer", long = "select the last buffer"},
  buffer_left1 = {cmd = "<cmd>BufferPrev<cr>", short = "buffer left", long = "select the buffer to the left"},
  buffer_right1 = {cmd = "<cmd>BufferNext<cr>", short = "buffer right", long = "select the buffer to the right"},
  buffer_left2 = {cmd = "<cmd>bprev<cr>", short = "buffer left", long = "select the buffer to the left"},
  buffer_right2 = {cmd = "<cmd>bnext<cr>", short = "buffer right", long = "select the buffer to the right"},
  quick_cmd = {cmd = ":", short = "command line", long = "quickly open up command line"},
  quick_cmd_v = {cmd = ":", short = "command line", long = "quickly open up command line"},
  quick_cmdwin = {cmd = ":<C-f>", short = "command line window", long = "quickly open command line window"},
  quick_cmdwin_v = {cmd = ":<C-f>", short = "command line window", long = "quickly open command line window"},
  repeat_cmd = {cmd = "@:", short = "repeat command", long = "repeat last command"},
  -- TODO: consolidate, integrate "tabclose"
  bufdelete = {cmd = ":Sayonara<CR>", short = "delete buffer", long = "delete buffer with sayonara"},
  bufclose_nosave = {
    cmd = "<cmd>BufDel<cr>",
    short = "buffer close no save",
    long = "close buffer with without saving"
  },
  quit = {
    cmd = "<cmd>silent! tabclose | q<cr>",
    short = "quit",
    long = "quit"
  },
  nowrite_exit1 = {
    cmd = "<cmd>silent! tabclose | qa<cr>",
    short = "exit no save",
    long = "quick exit without saving"
  },
  write_exit1 = {
    cmd = "<cmd>silent! tabclose | xa<cr>",
    short = "exit prompt save",
    "quick exit with prompt for save"
  },
  quick_save = {cmd = "<cmd>w<cr><esc>", short = "quick save", long = "quick buffer save"},
  write_exit2 = {short = "write and exit", long = "quick write with exit"},
  bufclose_save = {
    cmd = "<cmd>update | silent! tabclose | Bdelete<cr>",
    short = "buffer close & save",
    long = "close buffer with saving"
  },
  restart = {cmd = "<cmd>Restart<cr>", short = "restart", long = "restart vim with same session"},
  nowrite_exit2 = {cmd = "<cmd>quitall<cr>", short = "exit no write", long = "quick exit without saving"},
  bufclose_all = {
    cmd = "<cmd>BufferCloseAllButCurrent<cr>",
    short = "close all other buffers",
    long = "close all buffers except current"
  },
  bufclose_all2 = {
    cmd = "<cmd>BufferCloseAllButCurrent<cr>",
    short = "close all other buffers",
    long = "close all buffers except current"
  },
  bufwrite_all = {cmd = "<cmd>wall<cr>", short = "save all buffers", long = "write all buffers to disk"},
  bufwrite_noa = {cmd = "<cmd>noa w<cr>", short = "save noautocmd", "save without autocommands"},
  open_altfile = {
    cmd = [[:call AltCommand(expand('%'), ':e')<cr>]],
    short = "open alt file",
    long = "open alternative file associated with buffer"
  },
  open_newfile = {
    cmd = [[:e <C-R>=expand("%:p:h") . "/" <CR>]],
    short = "create new file",
    long = "create new file in current directory"
  },
  open_newsplit = {
    cmd = [[:vsp <C-R>=expand("%:p:h") . "/" <CR>]],
    short = "create new file split",
    long = "create new file in a horizontal split"
  },
  print_filename = {
    cmd = "<leader>pfn :echo expand('%:p')<CR>",
    short = "print filename",
    long = "print path of current buffer"
  },
  goto_fileline = {
    -- ":exec 'normal ^f\'''<bar>exec 'normal f\"'<bar> exec 'normal gf'<cr>"
    cmd = '<cmd>exec "normal ^f(gf"<cr>',
    short = "edit file under line",
    long = "edit file under line"
  },
  insert_quick_save = {cmd = "<esc><cmd>w<cr>", short = "save in insert", long = "save in insert mode"},
  goto_file = {short = "goto file", long = "goto file under cursor"},
  open_file = {short = "open file", long = "open file under cursor"},
  cd_buffer = {cmd = ":cd %:h<CR>", short = "cd to %:h", long = "cd current buffer directory"},
  cd_home = {cmd = ":cd ~<CR>", short = "cd to ~", long = "cd to home"},
  cd_root = {cmd = ":cd /<CR>", short = "cd to /", long = "cd to root"}
}

M.Window = {
  close = {
    cmd = "<cmd>silent! tabclose | Sayonara<cr>",
    short = "close window",
    long = "close window smartly wih sayonara"
  },
  down = {cmd = "<C-w>j", short = "window down", long = "focus window below"},
  up = {cmd = "<C-w>k", short = "window up", long = "focus window above"},
  left = {cmd = "<C-w>h", short = "window left", long = "focus window to the left"},
  right = {cmd = "<C-w>l", short = "window right", long = "focus window to the right"},
  prev = {cmd = "<C-w>W", short = "window previous", long = "focus the previous window"},
  next = {cmd = "<C-w>w", short = "window next", long = "focus the next window"},
  split_horiz = {cmd = "<cmd>vnew<cr>", short = "window split-h", long = "window split horizontally"},
  split_vert = {cmd = "<cmd>new<cr>", short = "window split-v", long = "window split vertically"},
  max_vert = {cmd = "<C-w>_", short = "max vertical split", long = "maximize height of vertical split"},
  max_horiz = {cmd = "<C-w>|", short = "max horizontal split", long = "maximize width of horizontal split"},
  resize_even1 = {short = "resize even", long = "resize windows evenly"},
  resize_even2 = {cmd = "<C-w>=", short = "resize even", long = "resize windows evenly"},
  exit_others = {short = "exit others", long = "exit other windows except current"},
  exit_others_2 = {cmd = "<C-w>o", short = "exit others", long = "exit other windows except current"},
  swap = {short = "swap windows", long = "swap windows"},
  increase_height = {short = "increase height", long = "increase height of focused window"},
  decrease_height = {short = "decrease height", long = "decrease height of focused window"},
  increase_width = {short = "increase width", long = "increase width of focused window"},
  decrease_width = {short = "decrease width", long = "decrease width of focused window"}
}

M.Plugins = {
  update = {
    cmd = "<cmd>PackerUpdate<cr>",
    short = "packer update",
    long = "clean, then update and install plugins"
  },
  compile = {cmd = "<cmd>PackerCompile<cr>", short = "packer compile", long = "regenerate compiled loader file"},
  install = {cmd = "<cmd>PackerInstall<cr>", short = "packer install", long = "clean, then install plugin"},
  sync = {
    cmd = "<cmd>PackerSync<cr>",
    short = "packer sync",
    long = "perform 'packer update' and then 'packer compile'"
  },
  clean = {cmd = "<cmd>PackerClean<cr>", short = "packer clean", long = "remove plugins not loaded by packer"},
  status = {cmd = "<cmd>PackerStatus<cr>", short = "packer status", long = "list all plugins loaded by packer"},
  edit = {
    cmd = "<cmd>n stdpath('config') . /lua/plugins/*.lua<cr>",
    short = "edit plugins",
    long = "edit packer plugin files"
  },
  shada_edit = {cmd = "<cmd>n $HOME/.vim/.shada", short = "view shada", long = "view the shada file"}
}

M.Zettel = {
  enter1 = {cmd = "<plug>EditZettelUnderCursor", short = "enter zettel link", long = "enter zettel link"},
  enter2 = {
    cmd = "<cmd>lua require('neuron').enter_link()<cr>",
    short = "enter zettel link",
    long = "enter zettel link"
  },
  edit_new = {cmd = "<plug>EditZettelNew", short = "edit new zettel", long = "edit new zettel"},
  edit_last = {cmd = "<plug>EditZettelLast", short = "edit last zettel", long = "edit last zettel"},
  refresh_virtual_titles = {
    cmd = "<cmd>lua require('neuron').update_virtual_titles()<cr>",
    short = "refresh virtual titles",
    long = "refresh virtual titles"
  },
  new = {
    cmd = "<cmd>lua require'neuron/cmd'.new_edit('/home/nicholas/zettelkasten')<CR>",
    short = "new zettel",
    long = "new zettel"
  },
  -- new_cb = { cmd = "<cmd>lua require'neuron/cmd'.new_and_callback('/home/nicholas/zettelkasten', cb)<CR>", short = "new zettel", long = "new zettel" },
  edit_new_cword = {cmd = "<plug>EditZettelNewFromCword", short = "new zettel cursor", long = "new zettel cursor"},
  -- refresh_cache = {
  -- 	cmd = "<plug>NeuronRefreshCache",
  -- 	short = "neuron refresh cache",
  -- 	long = "neuron refresh cache",
  --  },
  prev_link = {
    cmd = " <cmd>lua require'neuron'.goto_prev_extmark()",
    short = "neuron prev link",
    long = "neuron prev link"
  },
  next_link = {
    cmd = " <cmd>lua require'neuron'.goto_next_extmark()",
    short = "neuron next link",
    long = "neuron next link"
  },
  prev_history = {
    cmd = ":<C-U>call neuron#move_history(-1)<cr>",
    short = "neuron prev history",
    long = "neuron prev history"
  },
  next_history = {
    cmd = ":<C-U>call neuron#move_history(1)<cr>",
    short = "neuron next history",
    long = "neuron next history"
  },
  edit_select = {cmd = "<plug>EditZettelSelect", short = "edit zettel select", long = "edit zettel select"},
  edit_backlink = {
    cmd = "<plug>EditZettelBacklink",
    short = "edit zettel backlink",
    long = "edit zettel backlink"
  },
  edit_cursor = {cmd = "<plug>EditZettelUnderCursor", short = "edit zettel cursor", long = "edit zettel cursor"},
  search_content = {
    cmd = "<plug>EditZettelSearchContent",
    short = "zettel search content",
    long = "zettel search content"
  },
  search_cursor = {
    cmd = "<plug>EditZettelSearchContentUnderCursor",
    short = "zettel search cursor",
    long = "zettel search cursor"
  },
  insert_last1 = {cmd = "<plug>InsertZettelLast", short = "insert zettel last", long = "insert zettel last"},
  index = {
    cmd = "<cmd>lua require'neuron'.goto_index()<cr>",
    short = "goto zettel index",
    long = "goto zettel index"
  },
  insert_last2 = {
    cmd = "<cmd>call neuron#insert_zettel_last(1)<cr>",
    short = "insert zettel last",
    long = "insert zettel last"
  },
  insert_next = {
    cmd = "<cmd>call neuron#insert_zettel_select(1)<cr>",
    short = "insert zettel select",
    long = "insert zettel select"
  },
  toggle_backlinks = {cmd = "<plug>ToggleBacklinks", short = "toggle backlinks", long = "toggle backlinks"},
  tag_new = {cmd = "<plug>TagsAddNew", short = "add new tag", long = "add new tag"},
  tag_select = {cmd = "<plug>TagsAddSelect", short = "add existing tag", long = "add existing tag"},
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
    cmd = "<plug>EditZettelNewFromVisual",
    short = "new zettel from selected",
    long = "new zettel from selected"
  },
  start_server = {
    cmd = "<cmd>lua require'neuron'.rib {address = '127.0.0.1:8200', verbose = true}<CR>",
    short = "start or reboot server",
    long = "start or reboot server"
  },
  refresh_cache = {cmd = "<cmd>lua require'neuron/cmd'.gen()<CR>", short = "generate cache", long = "generate cache"},
  -- NOTE: removed <expr>
  insert_last = {cmd = ":<C-U>call neuron#insert_zettel_complete(0)", short = "zettel insert last", long = ""},
  insert_select = {cmd = ":<C-U>call neuron#insert_zettel_complete(1)", short = "zettel insert selet", long = ""}
}

M.Git = {
  telescope_files = {
    cmd = "<cmd>Telescope git_files<cr>",
    short = "telescope git files",
    long = "telescope git files"
  },
  telescope_commits = {
    cmd = "<cmd>Telescope git_commits<cr>",
    short = "telescope git commits",
    long = "telescope git project commits"
  },
  telescope_bcommits = {
    cmd = "<cmd>Telescope git_bcommits<cr>",
    short = "telescope git bcommits",
    long = "telescope git file commits"
  },
  fzf_commits2 = {
    cmd = "<cmd>FzfPreviewGitLogs<cr>",
    short = "fzf preview git commits",
    long = "fzf preview git project commits"
  },
  fzf_bcommits2 = {
    cmd = "<cmd>FzfPreviewGitCurrentLogs<cr>",
    short = "fzf preview git bcommits",
    long = "fzf preview file commits"
  },
  fzf_commits = {
    cmd = "<cmd>FzfLua git_commits<cr>",
    short = "fzf git commits",
    long = "fzf git project commits"
  },
  fzf_bcommits = {
    cmd = "<cmd>FzfLua git_bcommits<cr>",
    short = "fzf git bcommits",
    long = "fzf file commits"
  },
  telescope_branches = {
    cmd = "<cmd>Telescope git_branches<cr>",
    short = "telescope git branches",
    long = "telescope git branches"
  },
  telescope_status = {
    cmd = "<cmd>Telescope git_status<cr>",
    short = "telescope git status",
    long = "telescope git status files"
  },
  signs_next_hunk = {cmd = "<cmd>Gitsigns next_hunk<cr>", short = "git next hunk", long = "gitsigns next hunk"},
  signs_prev_hunk = {
    cmd = "<cmd>Gitsigns prev_hunk<cr>",
    short = "git prev hunk",
    long = "gitsigns previous hunk"
  },
  signs_preview_hunk = {
    cmd = "<cmd>Gitsigns preview_hunk<cr>",
    short = "git preview hunk",
    long = "gitsigns preview hunk"
  },
  signs_reset_hunk = {
    cmd = "<cmd>Gitsigns reset_hunk<cr>",
    short = "git reset hunk",
    long = "gitsigns reset hunk"
  },
  signs_reset_buffer = {
    cmd = "<cmd>Gitsigns reset_buffer<cr>",
    short = "git reset buffer",
    long = "gitsigns reset buffer"
  }
}

M.LSP = {
  hover_doc1 = {cmd = "<cmd>Lspsaga hover_doc<cr>", short = "lsp hover document", long = "lsp hover document"},
  definitions = {cmd = "<cmd>Telescope lsp_definitions<cr>", short = "lsp definitions", long = "lsp definitions"},
  declaration = {
    cmd = "<cmd>lua vim.lsp.buf_declaration()<cr>",
    short = "lsp declaration",
    long = "lsp declaration"
  },
  hover_doc2 = {cmd = "<cmd>Lspsaga hover_doc<cr>", short = "lsp hover document ", long = "lsp hover document "},
  organize_imports = {
    cmd = "<cmd>TSLspOrganize<cr>",
    short = "lsp organize imports",
    long = "lsp organize imports"
  },
  finder1 = {cmd = "<cmd>Telescope lsp_finder<cr>", short = "lsp finder", long = "lsp finder"},
  references = {cmd = "<cmd>Telescope lsp_references<cr>", short = "lsp references", long = "lsp references"},
  signature_help1 = {
    cmd = "<cmd>Telescope lsp_signature_help<cr>",
    short = "lsp signature help",
    long = "lsp signature help"
  },
  buffer_definitions = {
    cmd = "<cmd>lua vim.lsp.buf.type_definition()<cr>",
    short = "lsp buffer definitions",
    long = "lsp buffer definitions"
  },
  diagnostic_prev = {
    cmd = "<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>",
    short = "lsp diagnostic prev ",
    long = "lsp diagnostic prev "
  },
  diagnostic_next = {
    cmd = "<cmd>lua vim.lsp.diagnostic.goto_next()<cr>",
    short = "lsp diagnostic next",
    long = "lsp diagnostic next"
  },
  code_action = {cmd = "<cmd>Lspsaga code_action<cr>", short = "lsp code action", long = "lsp code action"},
  range_code_action = {
    cmd = "<cmd>Lspsaga range_code_action<cr>",
    short = "lsp range code action",
    long = "lsp range code action"
  },
  doc_diagnostics = {
    cmd = "<cmd>lua _G._LspDiagDocument()<cr>",
    short = "lsp document diagnostics",
    long = "lsp document diagnostics"
  },
  doc_diagnostics_2 = {
    cmd = "<cmd>lua _G._LspDiagDocument()<cr>",
    short = "lsp document diagnostics",
    long = "lsp document diagnostics"
  },
  doc_diagnostics_ivy = {
    cmd = "<cmd>lua _G._LspDiagDocumentIvy()<cr>",
    short = "lsp document diagnostics",
    long = "lsp document diagnostics ivy theme"
  },
  doc_diagnostics_fzf = {
    cmd = "<cmd>FzfLua lsp_document_diagnostics<cr>",
    short = "lsp document diagnostics",
    long = "lsp document diagnostics"
  },
  workspace_diagnostics = {
    cmd = "<cmd>lua _G._LspDiagWorkspace<cr>",
    short = "lsp workspace diagnostics",
    long = "lsp workspace diagnostics"
  },
  workspace_diagnostics_ivy = {
    cmd = "<cmd>lua _G._LspDiagWorkspaceIvy()<cr>",
    short = "lsp workspace diag ivy",
    long = "lsp workspace diagnostics ivy theme"
  },
  view_log = {
    cmd = "<cmd>lua vim.cmd('e'..vim.lsp.get_log_path())<cr>",
    short = "lsp view log",
    long = "lsp view log"
  },
  line_diagnostics = {
    cmd = "<cmd>Lspsaga show_line_diagnostics<cr>",
    short = "lsp line diagnostics",
    long = "lsp line diagnostics"
  },
  finder2 = {cmd = "<cmd>Lspsaga lsp_finder<cr>", short = "lsp finder", long = "lsp finder"},
  server_info = {cmd = "<cmd>LspInfo<cr>", short = "lsp server info", long = "lsp server info"},
  signature_help2 = {
    cmd = "<cmd>Lspsaga signature_help<cr>",
    short = "lsp signature help",
    long = "lsp signature help"
  },
  format_buffer = {
    cmd = "<cmd>lua vim.lsp.buf.formatting()<cr>",
    short = "lsp format buffer",
    long = "lsp format buffer"
  },
  preview_definition = {
    cmd = "<cmd>Lspsaga preview_definition<cr>",
    short = "lsp preview definition",
    long = "lsp preview definition"
  },
  rename = {cmd = "<cmd>Lspsaga rename<cr>", short = "lsp rename", long = "lsp rename"},
  doc_symbols = {
    cmd = "<cmd>Telescope lsp_document_symbols<cr>",
    short = "lsp document symbols",
    long = "lsp document symbols"
  },
  workspace_symbols = {
    cmd = "<cmd>Telescope lsp_workspace_symbols<cr>",
    short = "lsp workspace symbols",
    long = "lsp workspace symbols"
  },
  stop_all = {cmd = "<cmd>LspStop<cr>", short = "lsp stop all", long = "lsp stop all"}
}

M.Pickers = {
  files_fzflua = {cmd = "<cmd>FzfLua files<cr>", short = "project files", long = "project files (fzf-lua)"},
  files_fzflua_ivy = {
    cmd = "lua require('fzf-lua').files({ winopts = { split = 'belowright new' } })",
    short = "project files fzf-ivy",
    long = "project files (fzf-lua) ivy theme"
  },
  files_tele = {
    cmd = "<cmd>lua _G._FindFiles()<cr>",
    short = "files telescope",
    long = "project files telescope"
  },
  files_telecenter = {
    cmd = "<cmd>lua _G._FindFilesCenter()<cr>",
    short = "files telescope center",
    long = "project files telescope center theme"
  },
  files_teledropdown = {
    cmd = "<cmd>lua _G._FindFilesDropdown()<cr>",
    short = "files telescope dropdown",
    long = "project files telescope dropdown theme"
  },
  files_teleivy = {
    cmd = "<cmd>lua _G._FindFilesIvy()<cr>",
    short = "files telescope ivy",
    long = "projet files telescope ivy theme"
  },
  files_directory_tele = {
    cmd = "<cmd>lua _G._FindFilesDirectory()<cr>",
    short = "files directory telescope",
    long = "directory files with telescope"
  },
  files_directory_teleivy = {
    cmd = "<cmd>lua _G._FindFilesDirectoryIvy()<cr>",
    short = "files directory telescope ivy",
    long = "directory files with telescope ivy theme"
  },
  notifications_teleivy = {
    cmd = "<cmd>lua _G._FindNotificationsIvy()<cr>",
    short = "notifications telescope ivy",
    long = "notifications list with telescope ivy theme"
  },
  notifications_tele = {
    cmd = "<cmd>lua _G._FindNotifications()<cr>",
    short = "notifications telescope",
    long = "notifications list with telescope"
  },
  workspace_diagnostics_fzflua = {
    cmd = "<cmd>FzfLua lsp_workspace_diagnostics<cr>",
    short = "workspace diagnostics fzf",
    long = "workspace diagnostics (fzf-lua)"
  },
  workspace_diagnostics_fzflua_ivy = {
    cmd = "lua require('fzf-lua').workspace_diagnostics({ winopts = { split = 'belowright new' } })",
    short = "project workspace_diagnostics fzf-ivy",
    long = "project workspace_diagnostics (fzf-lua) ivy theme"
  },
  home_files_fzfprev = {
    cmd = "<cmd>FzfPreviewDirectoryFiles~<cr>",
    short = "home files fzf",
    long = "home files (fzf-prev)"
  },
  git_actions_fzfprev = {
    cmd = "<cmd>FzfPreviewGitActions<cr>",
    short = "git actions fzf",
    long = "git actions (fzf-prev)"
  },
  git_status_fzfprev = {
    cmd = "<cmd>FzfPreviewGitStatus<cr>",
    short = "git status fzf",
    long = "git status (fzf-prev)"
  },
  mru_files_fzflua = {cmd = "<cmd>FzfLua oldfiles<cr>", short = "mru files fzf", long = "mru files (fzf-lua)"},
  mru_files_fzflua_ivy = {
    cmd = "lua require('fzf-lua').oldfiles({ winopts = { split = 'belowright new' } })",
    short = "project mru_files fzf-ivy",
    long = "project mru_files (fzf-lua) ivy theme"
  },
  mru_files_tele = {
    cmd = "<cmd>lua _G._FindOldFiles()<cr>",
    short = "mru telescope",
    long = "mru files telescope"
  },
  mru_files_telecenter = {
    cmd = "<cmd>lua _G._FindOldFilesCenter()<cr>",
    short = "mru center",
    long = "mru files telescope center theme"
  },
  mru_files_teledropdown = {
    cmd = "<cmd>lua _G._FindOldFilesDropdown()<cr>",
    short = "mru dropdown",
    long = "mru files telescope dropdown theme"
  },
  mru_files_teleivy = {
    cmd = "<cmd>lua _G._FindOldFilesIvy()<cr>",
    short = "mru ivy",
    long = "mru files telescope ivy theme"
  },
  frecency_files_tele = {
    cmd = "<cmd>lua _G._FindFrecency()<cr>",
    short = "frecency ",
    long = "frecency files telescope t"
  },
  frecency_files_telecenter = {
    cmd = "<cmd>lua _G._FindFrecencyCenter()<cr>",
    short = "frecency center",
    long = "frecency files telescope center theme"
  },
  frecency_files_teleivy = {
    cmd = "<cmd>lua _G._FindFrecencyIvy()<cr>",
    short = "frecency ivy",
    long = "frecency files telescope ivy theme"
  },
  commands_fzfprev = {
    cmd = "<cmd>FzfPreviewCommandPalette<cr>",
    short = "commands fzf",
    long = "commands (fzf-prev)"
  },
  commit_log_fzfprev = {
    cmd = "<cmd>FzfPreviewGitLogs<cr>",
    short = "git commit log",
    long = "git commit log (fzf-lua)"
  },
  commit_log_telescope = {
    cmd = "<cmd>Telescope git_commits<cr>",
    short = "git commit log telescope",
    long = "telescope git commit log"
  },
  bcommit_log_telescope = {
    cmd = "<cmd>Telescope git_bcommits<cr>",
    short = "git bcommit log telescope",
    long = "telescope git bcommit log"
  },
  buffers_fzflua = {cmd = "<cmd>FzfLua buffers<cr>", short = "buffers fzf", long = "buffers (fzf-lua)"},
  buffers_teledropdown = {
    cmd = "<cmd>lua _G._FindBufferDropdown()<cr>",
    short = "buffers telescope dropdown",
    long = "find buffers telescope dropdown theme"
  },
  buffers_teleleaderf = {
    cmd = "<cmd>lua _G._FindBufferLeaderF()<cr>",
    short = "buffers leader f ",
    long = "find buffers telescope leader f theme"
  },
  buffers_teleleaderf_nopreview = {
    cmd = "<cmd>lua _G._FindBufferLeaderFNoPreview()<cr>",
    short = "buffers leader f no preview ",
    long = "find buffers telescope leader f no preview theme"
  },
  sessions = {cmd = "<cmd>Sessions<cr>", short = "sessions", long = "sessions"},
  jumps_fzfprev = {cmd = "<cmd>FzfPreviewJumps<cr>", short = "jumps", long = "jumps"},
  helptags_tele = {cmd = "<cmd>Telescope help_tags<cr>", short = "helptags", long = "helptags"},
  manpages_tele = {cmd = "<cmd>Telescope man_pages<cr>", short = "man pages", long = "man pages telescope"},
  location_list_fzfprev = {
    cmd = "<cmd>FzfPreviewLocationList<cr>",
    short = "location list",
    long = "location list"
  },
  telescope_grep_search = {
    cmd = "<cmd>Telescope grep_string<cr>",
    short = "grep string search (telescope)",
    long = "grep string search (telescope)"
  },
  telescope_live_search = {
    cmd = "<cmd>Telescope live_grep<cr>",
    short = "live search (telescope)",
    long = "live search (telescope)"
  },
  fzf_live_search_1 = {cmd = "<cmd>Rg<cr>", short = "live search (rg)", long = "live search (rg)"},
  fzf_live_search_2 = {
    cmd = "<cmd>FzfLua live_grep_glob<cr>",
    short = "live search (fzf)",
    long = "live search (fzf)"
  },
  find_buffer = {cmd = "<cmd>FindBuffer<cr>", short = "find buffer", long = "find buffer"},
  find_colorscheme_tele = {
    cmd = "<cmd>Telescope colorscheme<cr>",
    short = "find colorscheme",
    long = "find colorscheme"
  },
  find_file_tele = {cmd = "<cmd>Telescope find_files<cr>", short = "find file", long = "find file"},
  grep_text_tele = {cmd = "<cmd>Telescope live_grep<cr>", short = "grep text", long = "grep text"},
  find_helptags_tele = {cmd = "<cmd>Telescope help_tags<cr>", short = "find helptags", long = "find helptags"},
  find_nvim_dotfiles = {
    cmd = "<cmd>lua require('utils.core').search_nvim()<cr>",
    short = "find nvim dotfiles",
    long = "find nvim dotfiles"
  },
  find_oldfiles = {cmd = "<cmd>Telescope oldfiles<cr>", short = "find oldfiles", long = "find oldfiles"},
  find_mappings_n = {
    cmd = "<plug>(fzf-maps-n)",
    short = "find mappings (normal)",
    long = "find mappings (normal)"
  },
  find_mappings_i = {
    cmd = "<plug>(fzf-maps-i)",
    short = "find mappings (insert)",
    long = "find mappings (insert)"
  },
  find_mappings_v = {
    cmd = "<plug>(fzf-maps-v)",
    short = "find mappings (visual)",
    long = "find mappings (visual)"
  },
  find_mappings_o = {
    cmd = "<plug>(fzf-maps-o)",
    short = "find mappings (operator)",
    long = "find mappings (operator)"
  }
  -- nmap("Pickers", "<C-d>", "<cmd>FzfPreviewGitCurrentLogs<cr>", "buffer_log", "git buffer log")
}

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

M.Movement = {
  -- ds: delete_surround <Plug>Dsurround
  s_delete_paren1 = {
    short = "delete surround paren )"
  },
  s_delete_paren2 = {
    short = "delete surround paren ("
  },
  s_delete_brace1 = {
    short = "delete surround brace }"
  },
  s_delete_brace2 = {
    short = "delete surround brace {"
  },
  s_delete_bracket1 = {
    short = "delete surround bracket ]"
  },
  s_delete_bracket2 = {
    short = "delete surround bracket ["
  },
  s_delete_block1 = {
    short = "delete surround block"
  },
  s_delete_block2 = {
    short = "delete surround Block"
  },
  s_delete_func = {
    short = "delete surround function"
  },
  s_delete_quote = {
    short = 'delete surround quote "'
  },
  s_delete_grave = {
    short = "delete surround grave mark`"
  },
  s_delete_single_quote = {
    short = "delete surround single-quote"
  },
  -- cs: change (replace) surround
  -- ys: you surround (add)
  -- as: add surround alias
  -- s: add surround visual
  -- add surround insert
  quick_insert_esc1 = {cmd = "<esc>", short = "insert mode escape", long = "quickly escape insert mode"},
  quick_insert_esc2 = {cmd = "<esc>", short = "insert mode escape", long = "quickly escape insert mode"},
  c_u_undo_friendly = {cmd = "<C-g>u<C-u>", short = "ctrl+u undo friendly", long = "make ctrl+u undo friendly"},
  c_w_undo_friendly = {cmd = "<C-g>u<C-w>", short = "ctrl+w undo friendly", long = "make ctrl+w undo friendly"},
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
  delete_end = {cmd = "d$", short = "delete to end", long = "delete to end"},
  scroll_forwards = {
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
  scroll_bottom = {cmd = "<Plug>(Smoothie_G)", short = "scroll to bottom", long = "smooth scroll to bottom"},
  scroll_top = {cmd = "<Plug>(Smoothie_gg)", short = "scroll to top", long = "smooth scroll to top"},
  select_last = {
    cmd = "`[v`]",
    "movement_select_last",
    short = "vis select last",
    long = "visual select last edited text"
  },
  ascii = {cmd = "<cmd>ascii<cr>", short = "ascii cursor", long = "ascii under cursor"},
  ascii_2 = {cmd = "<cmd>ascii<cr>", short = "ascii cursor", long = "ascii under cursor"},
  last_insertion = {short = "move to last ins", long = "move to last insertion"}, -- virtual
  begin_insertion = {short = "insert at beginning", long = "insert at beginning"}, -- virtual
  last_visual = {short = "visual last paste", long = "visual select last paste"}, -- virtual
  total_counts = {short = "chars/words/lines count", long = "show current and total characters, words and lines"}, -- virtual
  goto_definition = {short = "goto ts definition", long = "goto ts definition"}, -- virtual
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
  -- _ (underscore) - "inner line"
  -- Examples
  -- xnoremap il 0o$h onoremap il :normal vil<CR>
  -- v_ visually selects all the text in a line, except the leading and trailing whitespace.
  -- y_ yank "inner line".
  -- d_ delete the whole line, but only "inner line" gets into the register.
  -- It's shorter to type than ^vg_ + operator.
  -- omap <silent> _  <Plug>(inner_line)
  -- nmap <silent> d_ <Plug>(inner_line_delete)
  -- xmap <silent> _  <Plug>(inner_line)
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
  neoclip = {cmd = "<cmd>Telescope neoclip<cr>", short = "telescope neoclip", long = "telescope neoclip"},
  fzf_yanks = {cmd = "<cmd>FZFYanks<cr>", short = "fzf yanks", long = "fzf yanks"},
  paste_primary = {cmd = '"*p', short = "paste primary", long = "paste primary"},
  paste_comment = {cmd = '"+p<esc>gvgc^', short = "paste comment", long = "paste comment"},
  paste_mode_toggle = {cmd = "<cmd>set invpaste<cr>", short = "paste mode toggle", long = "paste mode toggle"},
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

M.Search = {
  -- vim.cmd([[nnoremap / /\v]])
  -- vim.cmd([[vnoremap / /\v]])
  -- vim.cmd([[cnoremap %s/ %smagic/]])
  -- vim.cmd([[cnoremap \>s/ \>smagic/]])

  -- vim.cmd([[nnoremap :g/ :g/\v]])
  -- vim.cmd([[nnoremap :g// :g//]])
  -- vim.cmd([[vnoremap :g// :g//]])

  -- x  ,/            <Plug>(searchsavvy-visual-block-search)
  -- Last set from ~/.local/share/nvim/site/pack/packer/start/vim-searchsavvy/plugin/searchsavvy.vim line 54

  search_magic_1 = {cmd = "/\\v", short = "magic mode saerch"},
  search_magic_2 = {cmd = "<Esc>/\\%V", short = "visual magic mode saerch"},
  sub_magic_1 = {cmd = "%smagic/", short = "command substitute magic"},
  sub_magic_3 = {cmd = ":%smagic/", short = "normal substitue magic quick"},
  sub_magic_4 = {cmd = ":smagic/", short = "visual substitute magic quick"},
  rmhl = {cmd = "<cmd>noh<cr> | :nohlsearch<cr>", short = "remove highlight"},
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
  last_match = {short = "select last search match", long = "select last search match"},
  cursor_replace = {
    cmd = "*:%s//",
    short = "replace word under cursor",
    long = "search and replace word under cursor"
  }
}

M.Interface = {
  registers = {cmd = "<cmd>Registers<cr>", short = "view registers", long = "view registers"},
  whichkey = {cmd = "<cmd>WhichKey<cr>", short = "toggle whichkey", long = "toggle whichkey"},
  nvim_tree = {cmd = "<cmd>NvimTreeToggle<cr>", short = "toggle nvim-tree", long = "toggle nvim-tree"},
  mundo1 = {cmd = "<cmd>MundoToggle<cr>", short = "toggle mundo", long = "toggle mundo"},
  term1 = {cmd = "<cmd>FloatermToggle<cr>", short = "toggle floaterm", long = "toggle floaterm"},
  treesitter = {cmd = "<cmd>TSPlaygroundToggle<cr>", short = "toggle treesitter", long = "toggle treesitter"},
  aerial = {cmd = "<cmd>AerialToggle!right<cr>", short = "toggle aerial", long = "toggle aerial"},
  aerial_float = {cmd = "<cmd>AerialToggle!float<cr>", short = "toggle aerial float", long = "toggle aerial float"},
  mundo2 = {cmd = "<cmd>MundoToggle<cr>", short = "toggle mundo", long = "toggle mundo"},
  conceal_clear = {cmd = "<cmd>set conceallevel=0<cr>", short = "clear conceal", long = "clear conceal"},
  conceal_0 = {cmd = "<cmd>set conceallevel=0<cr>", short = "set conceal 0", long = "set conceal 0"},
  conceal_1 = {cmd = "<cmd>set conceallevel=1<cr>", short = "set conceal 1", long = "set conceal 1"},
  conceal_2 = {cmd = "<cmd>set conceallevel=2<cr>", short = "set conceal 2", long = "set conceal 2"},
  conceal_3 = {cmd = "<cmd>set conceallevel=3<cr>", short = "set conceal 3", long = "set conceal 3"},
  ts_highlights = {
    cmd = "<cmd>TSHighlightCapturesUnderCursor<cr>",
    short = "ts highlight cursor",
    long = "ts highlight cursor"
  },
  list_definitions = {short = "list ts definitions", long = "list ts definitions"}, -- virtual
  toc_definitions = {short = "toc ts definitions", long = "toc ts definitions"} -- virtual
}

M.CommandWin = {
  open = {cmd = "q:", short = "open commandwin", long = "open commandwin"},
  yank = {cmd = "<c-r>*", short = "yank from commandwin", long = "yank from commandwin"},
  save = {cmd = "<cmd>w<cr><esc>", short = "save", long = "save in commandwin"},
  next1 = {short = "next item", long = "next item"}, -- virtual
  prev1 = {short = "prev item", long = "prev item"}, -- virtual
  next2 = {short = "next item", long = "next item"}, -- virtual
  prev2 = {short = "prev item", long = "prev item"} -- virtual
}

M.Format = {
  dial_increment1 = {cmd = "<Plug>(dial-increment)", short = "dial increment", long = "increment item(s)"},
  dial_decrement1 = {cmd = "<Plug>(dial-decrement)", short = "dial decrement", long = "decrement item(s)"},
  dial_increment2 = {cmd = "<Plug>(dial-increment)", short = "dial increment", long = "increment item(s)"},
  dial_decrement2 = {cmd = "<Plug>(dial-decrement)", short = "dial decrement", long = "decrement item(s)"},
  v_dial_increment1 = {
    cmd = "<Plug>(dial-increment)",
    short = "dial increment",
    long = "increment item(s) selected in visual mode"
  },
  v_dial_decrement1 = {
    cmd = "<Plug>(dial-decrement)",
    short = "dial decrement",
    long = "decrement item(s) selected in visual mode"
  },
  v_dial_increment2 = {
    cmd = "<Plug>(dial-increment)",
    short = "dial increment",
    long = "increment item(s) selected in visual mode"
  },
  v_dial_decrement2 = {
    cmd = "<Plug>(dial-decrement)",
    short = "dial decrement",
    long = "decrement item(s) selected in visual mode"
  },
  v_dial_increment_additional = {
    -- cmd = "g<C-a>"
    -- cmd = "<Plug>(dial-increment-additional)",
    short = "dial increment additional",
    long = "increment item(s) selected in visual mode"
  },
  v_dial_decrement_additional = {
    -- cmd = "g<C-x>"
    -- cmd = "<Plug>(dial-decrement-additional)",
    short = "dial decrement additional",
    long = "decrement item(s) selected in visual mode"
  },
  swap = {cmd = "<cmd>ISwap<cr>", short = "swap", long = "swap/exchange text objects with text hints"},
  indent_all = {cmd = "`[V`]<", short = "indent all lines", long = "indent all lines"},
  unindent_all = {cmd = "`[V`]>", short = "unindent all lines", long = "unindent all lines"},
  uppercase2 = {cmd = "gUw", short = "uppercase", long = "format uppercase"},
  lowercase2 = {cmd = "guw", short = "lowercase", long = "format lowercase"},
  snakecase = {cmd = "<cmd>Snek<cr>", short = "snake case", long = "format snake case"},
  kebabcase = {cmd = "<cmd>Kebab<cr>", short = "kebab case", long = "format kebab case"},
  camelcase = {cmd = "<cmd>Camel<cr>", short = "camel case", long = "format camel case"},
  camelbcase = {cmd = "<cmd>CamelB<cr>", short = "camelB case", long = "format camelB case"},
  v_snakecase = {cmd = "<cmd>Snek<cr>", short = "snake case", long = "format visual snake case"},
  v_kebabcase = {cmd = "<cmd>Kebab<cr>", short = "kebab case", long = "format visual kebab case"},
  v_camelcase = {cmd = "<cmd>Camel<cr>", short = "camel case", long = "format visual camel case"},
  v_camelbcase = {cmd = "<cmd>CamelB<cr>", short = "camelB case", long = "format visual camelB case"},
  lowercase1 = {short = "lowercase", long = "lowercase"}, -- virtual
  uppercase1 = {short = "uppercase", long = "uppercase"}, -- virtual
  rename = {short = "ts rename under cursor", long = "ts rename under cursor"}, -- virtual
  v_unindent = {cmd = "<gv", short = "unindent repeatedly", long = "unindent repeatedly visual mode"},
  v_indent = {cmd = ">gv", short = "indent repeatedly", long = "indent repeatedly visual mode"}
}

M.Markdown = {
  preview = {cmd = ":MarkdownPreview<CR>", short = "display markdown preview", long = "display markdown preview"},
  toggle_cb_v = {cmd = "<plug>(mkdx-toggle-checkbox-v)", short = "toggle cb vis", long = "toggle checkbox visual"},
  toggle_cb_n = {cmd = "<plug>(mkdx-toggle-checkbox-n)", short = "toggle cb", long = "toggle checkbox"},
  toggle_cb_value = {cmd = "<cmd>ToggleCB<cr>", short = "toggle cb value", long = "toggle checkbox value"},
  table_realign_n = {cmd = "<cmd>TableModeRealign<cr>", short = "realign table", long = "realign table"},
  table_realign_v = {cmd = "<plug>tablemode#Realign()", short = "realign table", long = "realign table"},
  -- table_realign_n = { short = "realign table", long = "realign table" }, -- virtual
  -- table_realign_v = { short = "realign table", long = "realign table" }, -- virtual

  tablemode_toggle = {short = "toggle tablemode", long = "toggle tablemode"}, -- virtual
  tableize_n = {short = "tableize cursor", long = "tableize cursor"}, -- virtual
  tableize_v = {short = "tableize selection", long = "tableize selection"}, -- virtual
  table_insert_col_n = {short = "insert table column", long = "insert table column"}, -- virtual
  table_insert_col_v = {short = "insert table column", long = "insert table column"}, -- virtual
  table_delete_col_n = {short = "delete table column", long = "delete table column"}, -- virtual
  table_delete_col_v = {short = "delete table column", long = "delete table column"} -- virtual
}

M.DAP = {
  continue1 = {cmd = "<cmd>lua require('dap').continue()<cr>", short = "dap continue", long = "dap continue"},
  step_over1 = {cmd = "<cmd>lua require('dap').step_over()<cr>", short = "dap step-over", long = "dap step-over"},
  step_into1 = {cmd = "<cmd>lua require('dap').step_into()<cr>", short = "dap step-into", long = "dap step-into"},
  step_out1 = {cmd = "<cmd>lua require('dap').step_out()<cr>", short = "dap step-out", long = "dap step-out"},
  repl_run_last = {
    cmd = "<cmd>lua require('dap').repl.run_last()<cr>",
    short = "dap repl run last",
    long = "dap repl run last"
  },
  set_breakpoint = {
    cmd = "<cmd>lua require'dap'.set_breakpoint()<cr>",
    short = "set breakpoint",
    ong = "dap set breakpoint"
  },
  toggle_breakpoint1 = {cmd = "<cmd>lua require'dap'.toggle_breakpoint()<cr>", short = "toggle breakpoint"},
  toggle_breakpoint2 = {cmd = "<cmd>lua require'dap'.toggle_breakpoint()<cr>", short = "toggle breakpoint"},
  toggle_breakpoint3 = {cmd = "<cmd>lua require'dap'.toggle_breakpoint()<cr>", short = "toggle breakpoint"},
  toggle_breakpoint4 = {cmd = "<cmd>lua require'dap'.toggle_breakpoint()<cr>", short = "toggle breakpoint"},
  conditional_breakpoint = {
    cmd = "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>",
    short = "conditional breakpoint",
    long = "conditional breakpoint"
  },
  logging_breakpoint = {
    cmd = "<cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<cr>",
    short = "logging breakpoint",
    long = "logging breakpoint"
  },
  toggle_ui1 = {cmd = "<cmd>lua require'dapui'.toggle()<cr>", short = "toggle dap ui", long = "toggle dap ui"},
  toggle_ui2 = {cmd = "<cmd>lua require'dapui'.toggle()<cr>", short = "toggle dap ui", long = "toggle dap ui"},
  start_lua = {cmd = "<cmd>lua require'dap'.continue()<cr>", short = "start lua dap", long = "start lua dap"},
  toggle_ui_sidebar = {
    cmd = "<cmd>lua require'dapui'.toggle('sidebar')<cr>",
    short = "toggle ui sidebar",
    long = "toggle ui sidebar"
  },
  continue2 = {cmd = "<cmd>lua require'dap'.continue()<cr>", short = "dap continue", long = "dap continue"},
  step_into2 = {cmd = "<cmd>lua require('dap').step_into()<cr>", short = "dap step-into", long = "dap step-into"},
  step_over2 = {cmd = "<cmd>lua require('dap').step_over()<cr>", short = "dap step-over", long = "dap step-over"},
  repl_toggle = {
    cmd = "<cmd>lua require('dap').repl.toggle()<cr>",
    short = "dap repl toggle",
    long = "dap repl toggle"
  },
  debug_start = {cmd = "<cmd>DebugStart<cr>", "Start", short = "debug start", long = "debug start"}
}

M.REPL = {
  tmux_send = {cmd = "<cmd>SlimuxShellLast<cr>", short = "tmux send", long = "tmux send via slimux"},
  sniprun_info = {cmd = "<cmd>lua require'sniprun'.info()<cr>", short = "sniprun info", long = "sniprun info"},
  sniprun_bloc = {cmd = "<Plug>SnipRun", short = "sniprun bloc", long = "sniprun bloc"}
  -- sniprun_bloc = { cmd = "<cmd>lua require'sniprun'.run('v')<cr>", short = "sniprun bloc", long = "sniprun bloc"}
}

M.Unimpaired = {
  toggle_background = {short = "toggle background", long = "toggle light/dark background"},
  toggle_cursorline = {short = "toggle cursorline", long = "toggle cursorline"},
  toggle_diff = {short = "toggle diff", long = "toggle diff"},
  toggle_search_highlight = {short = "toggle search highlight", long = "toggle search highlight"},
  toggle_search_case_ignore = {short = "toggle search case ignore", long = "toggle search case ignore"},
  toggle_list = {short = "toggle list", long = "toggle list"},
  toggle_number = {short = "toggle number", long = "toggle number"},
  toggle_relative_number = {short = "toggle relative number", long = "toggle relative number"},
  toggle_spell_check = {short = "toggle spell check", long = "toggle spell check"},
  toggle_cursorcolumn = {short = "toggle cursorcolumn", long = "toggle cursorcolumn"},
  toggle_virtualedit_text = {short = "toggle virtualedit txt", long = "toggle virtualedit text"},
  toggle_word_wrap = {short = "toggle word wrap", long = "toggle word wrap"},
  toggle_crosshairs = {short = "toggle crosshairs", long = "toggle crosshairs"},
  paste_after = {short = "paste after", long = "paste after"},
  paste_before = {short = "paste before", long = "paste before"},
  paste_after_indent1 = {short = "paste after indent", long = "paste after line increasing indent"},
  paste_before_indent1 = {short = "paste before indent", long = "paste before line increasing indent"},
  paste_after_unindent1 = {short = "paste after unindent", long = "paste after line decreasing indent"},
  paste_before_unindent1 = {short = "paste before unindent", long = "paste before line decreasing indent"},
  paste_after_indent2 = {short = "paste after indent", long = "paste after line increasing indent"},
  paste_before_indent2 = {short = "paste before indent", long = "paste before line increasing indent"},
  paste_after_unindent2 = {short = "paste after unindent", long = "paste after line decreasing indent"},
  paste_before_unindent2 = {short = "paste before unindent", long = "paste before line decreasing indent"},
  paste_after_reindent = {short = "paste after reindent", long = "paste after line reindenting"},
  paste_before_reindent = {short = "paste before reindent", long = "paste before line reindenting"},
  paste_within = {short = "paste within", long = "patse within"},
  pairs_edit_prev_files = {short = "edit prev files", long = "edit previous files"},
  pairs_edit_next_files = {short = "edit next files", long = "edit next files"},
  pairs_prev_buffer = {short = "prev buffer", long = "previous buffer"},
  pairs_next_buffer = {short = "next buffer", long = "next buffer"},
  pairs_prev_location = {short = "prev loc", long = "previous location"},
  pairs_next_location = {short = "next loc", long = "next location"},
  pairs_prev_location_file = {short = "prev loc in file", long = "previous location in file"},
  pairs_next_location_file = {short = "next loc in file", long = "next location in file"},
  pairs_prev_tag = {short = "prev tag", long = "previous location"},
  pairs_next_tag = {short = "next tag", long = "next location"},
  pairs_prev_tag_window = {short = "prev loc in prev window", long = "previous location in previous window"},
  pairs_next_tag_window = {short = "next loc in prev window", long = "next location in previous window"},
  pairs_prev_qf = {short = "prev qf", long = "previous quickfix"},
  pairs_next_qf = {short = "next qf", long = "next quickfix"},
  pairs_prev_qf_file = {short = "prev loc in file", long = "previous quickfix in file"},
  pairs_next_qf_file = {short = "next loc in file", long = "next quickfix in file"}
}

return M
