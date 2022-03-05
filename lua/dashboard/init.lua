vim.cmd [[
  let s:cwd = stdpath('config') . '/lua/dashboard'
  exec "source" s:cwd .. '/dashboard.vim'
]]

require("dashboard.options")
