-- local res = require('configs.vimade')
local res_ok, res = pcall(require, 'configs.nvim-treesitter')
vim.dbglog(res_ok, res)
