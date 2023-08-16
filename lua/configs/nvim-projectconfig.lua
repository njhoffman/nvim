-- I want to change my directory inside neovim and load project config.
require("nvim-projectconfig").load_project_config()
vim.cmd(
  [[
          augroup NvimProjectConfig
          autocmd!
          autocmd DirChanged * lua require('nvim-projectconfig').load_project_config()
          augroup end
  ]]
)
