local Manager = require('noice.message.manager')
local id = vim.notify('HELLO 1 ')
local id2 = vim.notify('HELLO 2 ' .. id.id, nil, { replace = id.id })
local id3 = vim.notify('HELLO 3 ' .. id2.id, nil, { replace = id2.id })
vim.notify('HELLO 4 ' .. id3.id, nil, { replace = id3.id })
local msgs = Manager.get()
for _, msg in ipairs(msgs) do
  -- for _, line in ipairs(msg._lines) do
  --   for _, text in ipairs(line._texts) do
  --     vim.dbglog('TEXT', text._content)
  --   end
  -- end
  vim.dbglog('MSG', msg)
end
