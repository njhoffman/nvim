local M = {
  close = {
    cmd = "<cmd>silent! tabclose | Sayonara<cr>",
    short = "close window",
    long = "close window smartly wih sayonara"
  },
  down = {
    cmd = "<C-w>j",
    short = "window down",
    long = "focus window below"
  },
  up = {
    cmd = "<C-w>k",
    short = "window up",
    long = "focus window above"
  },
  left = {
    cmd = "<C-w>h",
    short = "window left",
    long = "focus window to the left"
  },
  right = {
    cmd = "<C-w>l",
    short = "window right",
    long = "focus window to the right"
  },
  prev = {
    cmd = "<C-w>W",
    short = "window previous",
    long = "focus the previous window"
  },
  next = {
    cmd = "<C-w>w",
    short = "window next",
    long = "focus the next window"
  },
  split_horiz = {
    cmd = "<cmd>vnew<cr>",
    short = "window split-h",
    long = "window split horizontally"
  },
  split_vert = {
    cmd = "<cmd>new<cr>",
    short = "window split-v",
    long = "window split vertically"
  },
  max_vert = {
    cmd = "<C-w>_",
    short = "max vertical split",
    long = "maximize height of vertical split"
  },
  max_horiz = {
    cmd = "<C-w>|",
    short = "max horizontal split",
    long = "maximize width of horizontal split"
  },
  resize_even1 = {
    short = "resize even",
    long = "resize windows evenly"
  },
  resize_even2 = {
    cmd = "<C-w>=",
    short = "resize even",
    long = "resize windows evenly"
  },
  exit_others = {
    short = "exit others",
    long = "exit other windows except current"
  },
  exit_others_2 = {
    cmd = "<C-w>o",
    short = "exit others",
    long = "exit other windows except current"
  },
  swap = {
    short = "swap windows",
    long = "swap windows"
  },
  increase_height = {
    short = "increase height",
    long = "increase height of focused window"
  },
  decrease_height = {
    short = "decrease height",
    long = "decrease height of focused window"
  },
  increase_width = {
    short = "increase width",
    long = "increase width of focused window"
  },
  decrease_width = {
    short = "decrease width",
    long = "decrease width of focused window"
  },
  cmd_open_n = {
    cmd = "q:",
    short = "open commandwin",
    long = "open commandwin from normal mode"
  },
  cmd_open_cedit = {
    cmd = "<C-T>",
    short = "open commandwin (cedit)",
    long = "open commandwin by cedit value"
  },
  cmd_open_cedit2 = {
    cmd = "<C-T>",
    short = "open commandwin from escape"
  },
  cmd_yank = {
    cmd = "<c-r>*",
    short = "yank from commandwin",
    long = "yank from commandwin"
  },
  cmd_save = {
    cmd = "<cmd>w<cr><esc>",
    short = "save",
    long = "save in commandwin"
  },
  cmd_next1 = {
    short = "next item",
    long = "next item in commandwin"
  }, -- virtual
  cmd_prev1 = {
    short = "prev item",
    long = "prev item in commandwin"
  }, -- virtual
  cmd_next2 = {
    short = "next item",
    long = "next item in commandwin"
  }, -- virtual
  cmd_prev2 = {
    short = "prev item",
    long = "prev item in commandwin"
  }, -- virtual
  cmd_close = {
    cmd = "<C-c>",
    short = "close command bar"
  },
  cmdwin_close = {
    cmd = "<C-c>",
    short = "close command window"
  }

  -- " Intuitive movement over long lines
  -- nnoremap k gk
  -- nnoremap j gj

  -- " Resize windows with the shift+arrow keys
  -- nnoremap <s-up> 10<C-W>+
  -- nnoremap <s-down> 10<C-W>-
  -- nnoremap <s-left> 3<C-W>>
  -- nnoremap <s-right> 3<C-W><

  -- " Move text around in visual mode
  -- vnoremap <left> <nop>
  -- vnoremap <right> <nop>
  -- vnoremap <up> xkP`[V`]
  -- vnoremap <down> xp`[V`]
}
-- " Make terminal mode behave more like any other mode
-- tnoremap <C-[> <C-\><C-n>
-- tnoremap <C-h> <C-\><C-n><C-w>h
-- tnoremap <C-j> <C-\><C-n><C-w>j
-- tnoremap <C-k> <C-\><C-n><C-w>k
-- tnoremap <C-l> <C-\><C-n><C-w>l
-- tnoremap <A-k> <C-\><C-n><C-W>+i
-- tnoremap <A-j> <C-\><C-n><C-W>-i
-- tnoremap <A-h> <C-\><C-n>3<C-W>>i
-- tnoremap <A-l> <C-\><C-n>3<C-W><i

return M
