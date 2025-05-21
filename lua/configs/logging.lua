local require = require("noice.util.lazy")
local logger = require("logger").init("notify")

local Manager = require("noice.message.manager")
local Message = require("noice.message")
local Router = require("noice.message.router")
local Util = require("noice.util")

local M = {}

local parse_message = require("notify.gen-highlights")

local pattern_filter = function(name, level, msg)
  -- additional filtering based on scope and pattern
  local skip = false
  local lvl_patterns = require("logger.levels").patterns
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
local backlog = {}

function M.get_level(level)
  if type(level) == "string" then
    return level
  end
  for k, v in pairs(vim.log.levels) do
    if v == level then
      return k:lower()
    end
  end
  return "info"
end

---@param msg string
---@param level? number|string
---@param opts? table<string, any>
function M.notify(msg, level, opts)
  if vim.in_fast_event() then
    vim.schedule(function()
      M.notify(msg, level, opts)
    end)
    return
  end
  if msg ~= nil and type(msg) ~= "string" then
    msg = tostring(msg)
  end

  level = M.get_level(level)
  local message = Message("notify", level, msg)
  message.opts = opts or {}
  message.level = level

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
if #backlog % 20 == 0 then
  logger:debug("notify backlog:", #backlog)
end
return M
