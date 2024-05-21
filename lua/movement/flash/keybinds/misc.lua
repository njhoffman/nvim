local lib = require('movement.flash.nav')
local Flash = lambda.reqidx('flash')

local jump_lines = function()
  Flash.jump({
    search = { mode = 'search', max_length = 0 },
    highlight = {
      label = { after = { 0, 0 } },
      matches = false,
    },
    pattern = '^\\s*\\S\\?', -- match non-whitespace at start plus any character (ignores empty lines)
  })
end

local god_fold = function()
  Flash.treesitter()
  vim.cmd('normal! Vzf')
end

return {
  jump_lines = jump_lines,
  god_fold = god_fold,
  jump_up = lib.jump_up,
  jump_windows = lib.jump_windows,
}
