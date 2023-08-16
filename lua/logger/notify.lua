local logutils = require('debuglog.utils')
local logparsers = require('logger.parsers')
local get_opt = require('utils.options').get_option_value
local traceback = require('debuglog.parsers.traceback')

-- Error running notification service: ...e/pack/packer/start/nvim-notify/lua/notify/util/init.lua:78:
--  'relative' requires 'row'/'col' or 'bufpos'

local pending = {}

local M = {}

M.notify = function(message, level, ...)
  if level == 5 or (type(level) == 'string' and string.lower(level) == 'off') then
    return
  end
  local args = ... or {}
  local tb = traceback()
  -- TODO: pull msg strings out, vim.inspect rest of keyed objects

  local notif_time = vim.fn.strftime('%H:%M')
  if type(level) == 'number' then
    level = logutils.log_level_name(level)
  else
    level = level and string.lower(level) or 'info'
  end

  local level_n = logutils.log_level_number(level)
  local cols = math.floor(vim.opt.columns:get() / 3)
  if level_n >= 4 then
    cols = math.floor(vim.opt.columns:get() / 2)
  end

  local msg = logparsers.parse_message(message)
  local notify_msg = logparsers.notify_parse_message(message, cols)

  local min_log_level = logutils.log_level_number(get_opt('notify_level_log'))
  -- local min_show_level = logutils.log_level_number(get_opt("notify_level_show"))

  local logger = require('logger').init('notify')

  if level_n >= min_log_level and logger ~= nil then
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

  local notify_ok, notify = pcall(require, 'notify')
  if not notify_ok and logger ~= nil then
    logger:warn('notifications not ready yet')
    return
  end

  local timeout = 2000
  local defaultRender = 'minimal'
  -- select renderType that displays title
  if type(args.title) ~= 'nil' and type(args.renderType) ~= '' then
    if level_n > 4 then
      defaultRender = 'default'
    else
      defaultRender = 'compact'
    end
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
  args.render = args.render or defaultRender
  args.hide_from_history = args.hide_from_history or false

  if vim.v.did_enter == 1 then
    notify.notify(notify_msg, level, args)
  else
    table.insert(pending, { notify_msg, level, args })
  end
end

vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    for _, notify_obj in ipairs(pending) do
      local args = notify_obj[3]
      args.title = args.title and args.title or '::prestart::'
      if type(args.title) == 'table' then
        args.title[2] = '::prestart::'
      end
      args.render = 'default'
      M.notify(notify_obj[1], notify_obj[2], args)
    end
  end,
})

return M
