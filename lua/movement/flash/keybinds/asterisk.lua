local lib = require('movement.flash.nav')

local M = {}

M.search_lask_star = function()
  require('lasterisk').search()
  lib.search_win()
end

M.search_lask_cword = function()
  require('lasterisk').search({ is_whole = false })
  vim.schedule(lib.search_win)
  return '<C-\\><C-N>'
end

M.search_lask_gword = function()
  require('lasterisk').search({ is_whole = false })
  lib.search_win()
end

M.search_lask_ref = function()
  if lib.search_ref() then
    return
  end
  require('lasterisk').search()
  lib.search_win()
end

M.search_lask_pound = function()
  require('lasterisk').search({ is_whole = false })
  vim.schedule(lib.search_win)
  return '<C-\\><C-N>'
end

M.search_lask_gpound = function()
  require('lasterisk').search({ is_whole = false })
  lib.search_win()
end

return M
