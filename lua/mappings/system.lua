local M = {
  update = {
    cmd = "<cmd>PackerUpdate<cr>",
    short = "packer update",
    long = "clean, then update and install plugins"
  },
  compile = { cmd = "<cmd>PackerCompile<cr>", short = "packer compile", long = "regenerate compiled loader file" },
  install = { cmd = "<cmd>PackerInstall<cr>", short = "packer install", long = "clean, then install plugin" },
  sync = {
    cmd = "<cmd>PackerSync<cr>",
    short = "packer sync",
    long = "perform 'packer update' and then 'packer compile'"
  },
  clean = { cmd = "<cmd>PackerClean<cr>", short = "packer clean", long = "remove plugins not loaded by packer" },
  status = { cmd = "<cmd>PackerStatus<cr>", short = "packer status", long = "list all plugins loaded by packer" },
  edit = {
    cmd = "<cmd>n stdpath('config') . /lua/plugins/*.lua<cr>",
    short = "edit plugins",
    long = "edit packer plugin files"
  },
  shada_edit = { cmd = "<cmd>n $HOME/.vim/.shada", short = "view shada", long = "view the shada file" }
}
return M
