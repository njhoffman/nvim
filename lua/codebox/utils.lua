local config = require("codebox.config")

local function is_floating(window_id)
  return vim.api.nvim_win_get_config(window_id).relative ~= ""
end

local logger = {
  debug = function(...)
    if config.conf.debug then
      -- print("codebox:", ...)
      vim.dbglog("codebox:", ...)
    end
  end,
  info = function(...)
    vim.logger:info("codebox:", ...)
  end,
}

local table_find = function(tab, el)
  for index, value in pairs(tab) do
    if value == el then
      return index
    end
  end
end

return {
  table_find = table_find,
  logger = logger,
  is_floating = is_floating,
}
