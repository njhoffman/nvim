-- TODO: have separate notify, noice, and log levels
local logfile = function(lvl, content)
  lvl = lvl or 1
  local logger = require("logger").init("notify")
  content = vim.trim(content:gsub("\n$", ""))
  -- strip all new lines
  if lvl == 0 or lvl == "trace" then
    logger:trace(content)
  elseif lvl == 1 or lvl == "debug" then
    logger:debug(content)
  elseif lvl == 2 or lvl == "info" then
    logger:info(content)
  elseif lvl == 3 or lvl == "warn" then
    logger:warn(content)
  else
    logger:error(content)
  end
end

return logfile
