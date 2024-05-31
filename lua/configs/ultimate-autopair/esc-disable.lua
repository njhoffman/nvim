-- https://github.com/altermo/ultimate-autopair.nvim/issues/80
-- press Esc (leaving insert mode) without entering another subsequent character,
-- the autocomplete won't trigger. So for example just entering
-- (<Esc> would end up with ( or ('<Esc> would give me (',
-- but entering ('h<Esc> would give me ('h')

local pair = [[([{"']]
local end_pair = [[)]}"']]
local pair_insert
local save = {}
local group = vim.api.nvim_create_augroup('test', {})
vim.api.nvim_create_autocmd('InsertCharPre', {
  callback = function()
    pair_insert = false
    for c in pair:gmatch('.') do
      if vim.v.char == c then
        local action = require('ultimate-autopair.core').run(c)
        if
          action == '\aU\x80kr'--[[this is dont-new-undo + <right>]]
        then
          vim.api.nvim_feedkeys(action, 'n', false)
          vim.v.char = ''
          save = {}
          return
        elseif #action > 2 then
          table.insert(save, action:sub(3))
          pair_insert = true
          return
        end
      end
    end
    if not save[1] then
      return
    end
    local nsave = save
    save = {}
    if end_pair:find(vim.v.char, 1, true) then
      return
    end
    vim.api.nvim_feedkeys(table.concat(nsave), 'n', false)
  end,
  group = group,
})
vim.api.nvim_create_autocmd('CursorMovedI', {
  callback = function()
    if pair_insert then
      return
    end
    save = {}
  end,
  group = group,
})
vim.api.nvim_create_autocmd('ModeChanged', {
  callback = function()
    save = {}
  end,
  group = group,
})
for c in pair:gmatch('.') do
  vim.keymap.del('i', c)
end
vim.cmd.split()
vim.cmd.enew()
vim.bo.buftype = 'nofile'
vim.api.nvim_input('i')
local function step(c)
  if #c == 0 then
    return
  end
  vim.defer_fn(function()
    if vim.fn.mode() ~= 'i' then
      return
    end
    vim.api.nvim_input(c:sub(1, 1))
    step(c:sub(2))
  end, 1000)
end
step('(a)\n("a")\n(((a')
