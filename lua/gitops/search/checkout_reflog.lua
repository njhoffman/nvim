local pickers = require('telescope.pickers')
local sorters = require('telescope.sorters')
local finders = require('telescope.finders')

local ags_mappings = require('gitops.mappings')

local M = {}

M.checkout_reflog = function()
  pickers
    .new({
      results_title = 'Git Reflog, <CR> to checkout',
      finder = finders.new_oneshot_job({ 'git', 'reflog', '--date=iso' }, {}),
      sorter = sorters.get_fuzzy_file(),
      attach_mappings = function(_, map)
        ags_mappings.checkout_reflog_entry(map)
        return true
      end,
    }, {})
    :find()
end

M.checkout_reflog_summary = function(bufnr)
  return 'checkout reflog'
end

return M
