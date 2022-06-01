local config = require("config")
local logutils = require("logger.utils")
local logparsers = require("logger.parsers")

local M = {}
M.renderFunc = function(renderType)
  return function(bufnr, notif, highlights)
    return require("notify.render." .. renderType)(bufnr, notif, highlights)
  end
end

M.notify = function(message, level, ...)
  local args = ... or {}
  local tb = logutils.traceback()
  vim.defer_fn(
    function()
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

      local min_log_level = logutils.log_level_number(config.Logging.log_level)
      local min_notify_level = logutils.log_level_number(config.Logging.notify_level)

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
      if level_n < min_notify_level then
        skip_render = true
      elseif winnr ~= 1000 then
        skip_render = true
        logger:warn("skipping winnr: " .. winnr .. " -- (" .. notify_msg .. ")")
      end

      local ok, notify = pcall(require, "notify")
      if not ok then
        return
      end
      if skip_render == false and ok then
        local timeout = 2000
        local renderType = "minimal"
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
        if level_n <= 3 then
          timeout = 3000
        elseif level_n == 4 then
          timeout = 5000
        elseif level_n == 5 then
          timeout = 8000
          -- args.keep = function() return true end
        end

        args.timeout = args.timeout or timeout
        args.render = args.render or M.renderFunc(renderType)
        notify(notify_msg, level, args)
      end
    end,
    0
  )
end

return M
-- FIXME: lua vim.notify(vim.inspect(vim.fn.getbufinfo(1)), "warn")
