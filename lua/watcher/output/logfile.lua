local config = require('watcher.opts')

-- text -> integer if necessary, determines message level meets config level
-- 0: trace, 1: debug, 2: info, 3: warn, 4: error, 5: off
local check_level = function(config_lvl, msg_lvl)
  local lsp_levels = vim.lsp.log_levels
  config_lvl = config_lvl or 'info'
  if type(config_lvl) == 'string' then
    config_lvl = lsp_levels[config_lvl:upper()]
  end
  msg_lvl = msg_lvl or 'info'
  if type(msg_lvl) == 'string' then
    msg_lvl = lsp_levels[msg_lvl:upper()]
  end
  return config_lvl <= msg_lvl
end

local handle_log = function(msg_level, list, ...)
  local msgs = { ... }
  local user_level = config.log_level or 'info'
  if config.output.logfile and
    check_level(user_level, msg_level) then
    vim.logger:info(list.name, msgs)
  end
end

local handle_diff = function(difflist)
  for key, val in pairs(difflist.added) do
    vim.dbglog('added: ' .. key .. ' ' .. val)
  end
  for key, val in pairs(difflist.removed) do
    vim.dbglog('removed: ' .. key .. ' ' .. val)
  end
  for key, val in pairs(difflist.changed) do
    vim.dbglog('changed: ' .. key .. ' from ' .. val[1] .. ' to ' .. val[2])
  end
end

return {
  handle_diff = handle_diff,
  handle_log = handle_log
}
