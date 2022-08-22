local predefined = require('watcher.predefined')

local config = {
  interval = 3000,
  log_path = vim.fn.stdpath('data') .. '/inspect.log',
  -- log_level determines what verosity of logging, all other outputs boolean
  log_level = 'debug',
  output = {
    logfile = true,
    notify  = true,
    stdout  = false,
    pane    = false,
  },
  lists = predefined
}

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

return config
