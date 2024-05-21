-- local conf = require('telescope.config').values

-- ---Get current all entries
local cmp = require('cmp')
local dbg = require('cmp.utils.debug')

-- vim.dbglog(vim.tbl_keys(cmp.config.cache.entries))
-- vim.dbglog(cmp.config.get().sources)
vim.dbglog(cmp.get_entries())
-- vim.dbglog(dbg.source_summary())
