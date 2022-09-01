local config = require("codebox.config")
local log = require("logger").init("logger")

local function is_floating(window_id)
  return vim.api.nvim_win_get_config(window_id).relative ~= ""
end

local lines_width = function(lines)
  return math.max(math.max(unpack(vim.tbl_map(function(line)
    return vim.fn.strchars(string.gsub(line, "^%s+", ""))
  end, lines))))
end

local logger = {
  debug = function(...)
    -- log:debug(...)
    vim.dbglog(...)
  end,
  info = function(...)
    log:info(...)
  end,
}

local table_find = function(tab, el)
  for index, value in pairs(tab) do
    if value == el then
      return index
    end
  end
end

local array_find = function(tab, el)
  for index, value in ipairs(tab) do
    if value == el then
      return index
    end
  end
end

local function is_anchored(window_id)
  return array_find(config.anchored, window_id)
end

return {
  lines_width = lines_width,
  table_find = table_find,
  array_find = array_find,
  logger = logger,
  is_floating = is_floating,
  is_anchored = is_anchored,
}
