-- Actions that an action line in a tailed file can trigger.

local actions = {}
actions.truncate = function(args)
  vim.dbglog("running truncate", args)
end

return actions
