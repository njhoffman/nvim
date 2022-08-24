local M = {
  packer_update = {
    cmd = "<cmd>PackerUpdate<cr>",
    short = "packer update",
    long = "clean, then update and install plugins"
  },
  packer_compile = {
    cmd = "<cmd>PackerCompile<cr>",
    short = "packer compile",
    long = "regenerate compiled loader file"
  },
  packer_install = {
    cmd = "<cmd>PackerInstall<cr>",
    short = "packer install",
    long = "clean, then install plugin"
  },
  packer_sync = {
    cmd = "<cmd>PackerSync<cr>",
    short = "packer sync",
    long = "perform 'packer update' and then 'packer compile'"
  },
  packer_clean = {
    cmd = "<cmd>PackerClean<cr>",
    short = "packer clean",
    long = "remove plugins not loaded by packer"
  },
  packer_status = {
    cmd = "<cmd>PackerStatus<cr>",
    short = "packer status",
    long = "list all plugins loaded by packer"
  },
  import_status = {
    cmd = "<cmd>ImportStatus<cr>",
    short = "view import details",
    long = "show interactive summary of imported files",
  },
  plugins_edit = {
    cmd = "<cmd>n stdpath('config') . /lua/plugins/*.lua<cr>",
    short = "edit plugins",
    long = "edit packer plugin files"
  },
  yank_filename = {
    cmd = "!xsel -ib <<< %:p",
    short = "yank the current filename",
  },
  yank_buffer = {
    cmd = ":%y+<CR>",
    short = "yank the current buffer"
  },
  display_filename = {
    cmd = "lua print(expand('%:p'))",
    short = "display current filename",
  },
  shada_edit = {
    cmd = "<cmd>n $HOME/.vim/.shada",
    short = "view shada",
    long = "view the shada file"
  }
}
return M
