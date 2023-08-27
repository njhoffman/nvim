local newdev = require('devicons')
local olddev = require('nvim-web-devicons')
newdev.setup()
olddev.setup()

local newicons = newdev.get_icons()
local oldicons = olddev.get_icons()

vim.dbglog(#vim.tbl_keys(oldicons), #vim.tbl_keys(newicons))
vim.dbglog(olddev.get_icon('', 'tf'), newdev.get_icon('', 'tf'))

-- local missing = {}
-- for key, val in pairs(newicons) do
--   if type(oldicons[key]) == 'nil' then
--     missing[key] = val
--   end
-- end
--
-- --
-- vim.dbglog(missing)
-- vim.dbglog(#vim.tbl_keys(missing))
