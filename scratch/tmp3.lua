local conf = require('telescope.config').values
local action_utils = require('telescope.actions.utils')

-- local buf_mappings = action_utils.get_registered_mappings(prompt_bufnr)
local default_mappings = conf.mappings
for key, name in pairs(default_mappings.i) do
  vim.dbglog(key, name)
end
-- for _, v in pairs(buf_mappings) do end
