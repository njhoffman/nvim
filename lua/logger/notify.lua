local config = require("config")
local logutils = require("logger.utils")
local logparsers = require("logger.parsers")
local get_opt = require("utils.options").get_option_value

-- Error running notification service: ...e/pack/packer/start/nvim-notify/lua/notify/util/init.lua:78:
--  'relative' requires 'row'/'col' or 'bufpos'

local M = {}

M.notify = function(message, level, ...)
  if level == 5 or (type(level) == "string" and string.lower(level) == "off") then
    return
  end
  local args = ... or {}
  local tb = logutils.traceback()
  vim.defer_fn(function()
    -- TODO: pull msg strings out, vim.inspect rest of keyed objects

    local notif_time = vim.fn.strftime("%H:%M")
    if type(level) == "number" then
      level = logutils.log_level_name(level)
    else
      level = level and string.lower(level) or "info"
    end

    local level_n = logutils.log_level_number(level)
    local cols = math.floor(vim.opt.columns:get() / 3)
    if level_n >= 4 then
      cols = math.floor(vim.opt.columns:get() / 2)
    end

    local msg = logparsers.parse_message(message)
    local notify_msg = logparsers.notify_parse_message(message, cols)

    -- TODO: interate through visible windows to detect if telescope is open
    local bufnr = vim.api.nvim_get_current_buf()
    local winnr = vim.api.nvim_get_current_win()
    local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")

    local min_log_level = logutils.log_level_number(get_opt("notify_level_log"))
    local min_show_level = logutils.log_level_number(get_opt("notify_level_show"))

    local logger = require("logger").init("notify")

    if level_n >= min_log_level then
      if level_n == 1 then
        logger:trace(msg)
      elseif level_n == 2 then
        logger:debug(msg)
      elseif level_n == 3 then
        logger:info(msg)
      elseif level_n == 4 then
        logger:warn(msg)
      elseif level_n == 5 then
        logger:info(vim.inspect(tb))
        logger:error(msg)
      end
    end

    local skip_render = false
    -- NOTE: quick hack to see if other windows open on start
    if level_n < min_show_level then
      skip_render = true
      -- logger:warn("skipping min_show_level: " .. min_show_level)
    elseif false and winnr ~= 1000 then
      skip_render = true
      -- logger:warn("skipping winnr: " .. winnr .. " -- (" .. notify_msg .. ")")
    end

    local ok, notify = pcall(require, "notify")
    if not ok then
      logger:warn("notifications not ready yet")
      return
    end
    if skip_render == false and ok then
      local timeout = 2000
      local renderType = "simple-min"
      if type(args.title) == "nil" then
        if level_n == 4 then
          args.title = "WARN"
        elseif level_n == 5 then
          args.title = { "ERROR", notif_time }
        end
      end
      -- select renderType that displays title
      if type(args.title) ~= "nil" then
        renderType = "default"
      end
      if level_n <= 0 then
        timeout = 1000
      elseif level_n <= 3 then
        timeout = 2000
      elseif level_n == 4 then
        timeout = 3000
      elseif level_n == 5 then
        timeout = 5000
        -- args.keep = function() return true end
      end
      args.timeout = args.timeout or timeout
      args.render = args.render or renderType
      args.hide_from_history = args.hide_from_history or false

      notify.notify(notify_msg, level, args)
    end
  end, 0)
end

return M
-- FIXME: lua vim.notify(vim.inspect(vim.fn.getbufinfo(1)), "warn")
