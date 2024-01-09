local require = require('noice.util.lazy')

local Message = require('noice.message')
local Manager = require('noice.message.manager')
local Router = require('noice.message.router')
local Util = require('noice.util')

local parse_message = require('notify.gen-highlights')

local pattern_filter = function(name, level, msg)
  -- additional filtering based on scope and pattern
  local skip = false
  local lvl_patterns = require('logger.levels').patterns
  for scope, filter in pairs(lvl_patterns) do
    local pattern, scope_lvl = filter[1], filter[2]
    vim.dbglog(level, scope_lvl, string.match(msg, pattern))
    if name == scope and string.match(msg, pattern) and level <= scope_lvl then
      skip = true
    end
  end
  return skip
end

local M = {}

---@alias NotifyEvent "notify"
---@alias NotifyLevel "trace"|"debug"|"info"|"warn"|"error"|"off"

M._orig = nil

function M.enable()
  if vim.notify ~= M.notify then
    M._orig = vim.notify
    vim.notify = M.notify
  end
end

function M.disable()
  if M._orig then
    vim.notify = M._orig
    M._orig = nil
  end
end

function M.get_level(level)
  if type(level) == 'string' then
    return level:lower()
  end
  for k, v in pairs(vim.log.levels) do
    if v == level then
      return k:lower()
    end
  end
  return 'info'
end

---@param msg string
---@param level number|string
---@param opts? table<string, any>
function M.notify(msg, level, opts)
  if pattern_filter('notify', level, msg) then
    return false
  end

  local _msg, _opts = parse_message(msg, opts)

  if vim.in_fast_event() then
    vim.schedule(function()
      M.notify(msg, level, opts)
    end)
    return
  end

  local message = Message('notify', level, _msg)
  message.opts = _opts or {}
  message.level = M.get_level(level)

  if msg == nil then
    -- special case for some destinations like nvim-notify
    message.opts.is_nil = true
  end

  Manager.add(message)
  if Util.is_blocking() then
    Router.update()
  end
  return { id = message.id }
end

return M
