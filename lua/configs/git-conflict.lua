local cfg = {
  default_mappings = true, -- disable buffer local mapping created by this plugin
  default_commands = true, -- disable commands created by this plugin
  disable_diagnostics = true, -- This will disable the diagnostics in a buffer whilst it is conflicted
  highlights = { -- They must have background color, otherwise the default color will be used
    incoming = 'GitConflictIncoming',
    current = 'GitConflictCurrent',
    ancestor = 'GitConflictAncestor',
  },
}

require('git-conflict').setup(cfg)

-- GitConflictChooseOurs — Select the current changes.
-- GitConflictChooseTheirs — Select the incoming changes.
-- GitConflictChooseBoth — Select both changes.
-- GitConflictChooseNone — Select none of the changes.
-- GitConflictNextConflict — Move to the next conflict.
-- GitConflictPrevConflict — Move to the previous conflict.
-- GitConflictListQf — Get all conflict to quickfix

vim.api.nvim_create_autocmd('User', {
  pattern = 'GitConflictDetected',
  callback = function(keys)
    vim.notify('Conflict detected in ' .. keys.file)
    local map = require("mapper").map
    map('n', '[[', '<Plug>(git-conflict-prev-conflict)', { buffer = keys.buf, desc = "Previous git conflict" })
    map('n', '[c', '<Plug>(git-conflict-prev-conflict)', { buffer = keys.buf, desc = "Previous git conflict" })
    map('n', ']]', '<Plug>(git-conflict-next-conflict)', { buffer = keys.buf, desc = "Next git conflict" })
    map('n', ']c', '<Plug>(git-conflict-next-conflict)', { buffer = keys.buf, desc = "Next git conflict" })
  end,
})

vim.api.nvim_create_autocmd({ 'BufEnter' }, {
  command = 'GitConflictRefresh',
})
