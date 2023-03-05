local M = {
  packer_update = {
    cmd = "<cmd>PackerUpdate<cr>",
    short = "packer update",
    long = "clean, then update and install plugins",
  },
  packer_compile = {
    cmd = "<cmd>PackerCompile<cr>",
    short = "packer compile",
    long = "regenerate compiled loader file",
  },
  packer_install = {
    cmd = "<cmd>PackerInstall<cr>",
    short = "packer install",
    long = "clean, then install plugin",
  },
  lazy_sync = {
    cmd = "<cmd>Lazy sync<cr>",
    short = "lazy sync",
  },
  lazy_check = {
    cmd = "<cmd>Lazy check<cr>",
    short = "lazy check",
  },
  lazy_profile = {
    cmd = "<cmd>Lazy profile<cr>",
    short = "lazy profile",
  },
  import_status = {
    cmd = "<cmd>ImportStatus<cr>",
    short = "view import details",
  },
  lazy_telescope = {
    cmd = "<cmd>require('telescope.run')('lazy', 'lazy')<cr>",
    long = "lazy telescope",
  },
  yank_filename = {
    cmd = "!xsel -ib <<< %:p",
    short = "yank the current filename",
  },
  yank_buffer = {
    cmd = ":%y+<CR>",
    short = "yank the current buffer",
  },
  display_filename = {
    cmd = "lua print(expand('%:p'))",
    short = "display current filename",
  },
  shada_edit = {
    cmd = "<cmd>n $HOME/.vim/.shada",
    short = "view shada",
    long = "view the shada file",
  },
}
return M
