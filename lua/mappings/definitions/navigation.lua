return {
  buffer_last = {
    cmd = ":e #<cr>",
    short = "last buffer",
    long = "select the last buffer",
  },
  buffer_left2 = {
    cmd = "<cmd>BufferPrev<cr>",
    short = "buffer left",
    long = "select the buffer to the left",
  },
  buffer_right2 = {
    cmd = "<cmd>BufferNext<cr>",
    short = "buffer right",
    long = "select the buffer to the right",
  },
  buffer_left1 = {
    cmd = "<cmd>bprev<cr>",
    short = "buffer left",
    long = "select the buffer to the left",
  },
  buffer_right1 = {
    cmd = "<cmd>bnext<cr>",
    short = "buffer right",
    long = "select the buffer to the right",
  },
  buffer_cybu_left1 = {
    cmd = "<Plug>(CybuPrev)",
    short = "buffer left (cybu)",
    long = "select the buffer with cybu to the left",
  },
  buffer_cybu_right1 = {
    cmd = "<Plug>(CybuNext)",
    short = "buffer right (cybu)",
    long = "select the buffer with cybu to the right",
  },
  quick_cmd = {
    cmd = ":",
    short = "command line",
    long = "quickly open up command line",
  },
  quick_cmdwin2 = {
    cmd = "q:",
    short = "command line",
    long = "quickly open up command line",
  },
  quick_cmdwin = {
    cmd = "q:",
    short = "command line window",
    long = "quickly open command line window",
  },
  repeat_cmd = {
    cmd = "@:",
    short = "repeat command",
    long = "repeat last command",
  },
  -- TODO: consolidate, integrate "tabclose"
  bufclose_nosave = {
    cmd = "<cmd>silent! tabclose | BufferDelete<cr>",
    short = "buffer close no save",
    long = "close buffer with without saving",
  },
  quit = {
    cmd = "<cmd>silent! tabclose | q<cr>",
    short = "quit",
    long = "quit",
  },
  nowrite_exit = {
    cmd = "<cmd>silent! tabclose | qa<cr>",
    short = "exit no save",
    long = "quick exit without saving",
  },
  write_exit = {
    cmd = "<cmd>silent! tabclose | xa<cr>",
    short = "exit prompt save",
    long = "quick exit with prompt for save",
  },
  quick_save = {
    cmd = "<cmd>w<cr><esc>",
    short = "quick save",
    long = "quick buffer save",
  },
  write_exit_virt = {
    short = "write and exit",
    long = "quick write with exit",
  },
  bufclose_save = {
    cmd = "<cmd>update | silent! tabclose | Bdelete<cr>",
    short = "buffer close & save",
    long = "close buffer with saving",
  },
  restart_target = {
    cmd = "<cmd>RestartTarget<cr>",
    short = "restart target",
    long = "restart target nvim remote server",
  },
  restart = {
    cmd = "<cmd>Restart<cr>",
    short = "restart",
    long = "restart vim with same session",
  },
  nowrite_exit2 = {
    cmd = "<cmd>silent! tabclose | quitall<cr>",
    short = "exit no write",
    long = "quick exit without saving",
  },
  bufclose_all = {
    cmd = "<cmd>BufferCloseAllButCurrent<cr>",
    short = "close all other buffers",
    long = "close all buffers except current",
  },
  bufclose_all2 = {
    cmd = "<cmd>BufferCloseAllButCurrent<cr>",
    short = "close all other buffers",
    long = "close all buffers except current",
  },
  bufwrite_all = {
    cmd = "<cmd>wall<cr>",
    short = "save all buffers",
    long = "write all buffers to disk",
  },
  bufwrite_noa = {
    cmd = "<cmd>noa w<cr>",
    short = "save noautocmd",
    "save without autocommands",
  },
  open_altfile = {
    cmd = [[:call AltCommand(expand('%'), ':e')<cr>]],
    short = "open alt file",
    long = "open alternative file associated with buffer",
  },
  open_newfile = {
    cmd = [[:e <C-R>=expand("%:p:h") . "/" <CR>]],
    short = "create new file",
    long = "create new file in current directory",
  },
  open_newsplit = {
    cmd = [[:vsp <C-R>=expand("%:p:h") . "/" <CR>]],
    short = "create new file split",
    long = "create new file in a horizontal split",
  },
  print_filename = {
    cmd = "<cmd>pfn :echo expand('%:p')<CR>",
    short = "print filename",
    long = "print path of current buffer",
  },
  goto_fileline = {
    cmd = "0/\"\\|'<cr>gF",
    short = "edit file under line",
  },
  goto_file_virt = {
    short = "goto file",
    long = "goto file under cursor",
  },
  open_file_virt = {
    short = "open file",
    long = "open file under cursor",
  },
  cd_buffer = {
    cmd = ":cd %:h<CR>",
    short = "cd to %:h",
    long = "cd current buffer directory",
  },
  cd_home = {
    cmd = ":cd ~<CR>",
    short = "cd to ~",
    long = "cd to home",
  },
  cd_root = {
    cmd = ":cd /<CR>",
    short = "cd to /",
    long = "cd to root",
  },
}
