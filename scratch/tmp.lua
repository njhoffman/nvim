-- local res = require('configs.vimade')
local exec_file = os.getenv('HOME') .. '/ghq/github.com/quilrbusiness/quilr-server/request.sh'
os.execute(exec_file)

local res_ok, res = pcall(require, 'configs.nvim-treesitter')
vim.dbglog(res_ok, res)
