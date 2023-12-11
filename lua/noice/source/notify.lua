local require = require('noice.util.lazy')

local Message = require('noice.message')
local Manager = require('noice.message.manager')
local Router = require('noice.message.router')
local Util = require('noice.util')

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
    return level
  end
  for k, v in pairs(vim.log.levels) do
    if v == level then
      return k:lower()
    end
  end
  return 'info'
end

function M.parse_message(msg, opts)
  local _opts = opts or {}
  local _msg = msg
  if type(msg) == 'table' then
    if vim.tbl_islist(msg) then
      if type(msg[1]) == 'string' then
        _msg = vim.fn.join(msg, '\n')
      elseif type(msg[1]) == 'table' and type(msg[1][1]) == 'table' and type(msg[1][1][1]) == 'string' then
        _msg = ''
        _opts.body_highlights = {}
        for n, line in ipairs(msg) do
          if n > 1 then
            _msg = _msg .. '\n'
          end
          local line_msg = ''
          for _, v in ipairs(line) do
            line_msg = line_msg .. v[1]
            if v[2] then
              table.insert(_opts.body_highlights, { v[2], n - 1, #line_msg - #v[1], #line_msg })
            end
          end
          _msg = _msg .. line_msg
        end
      else
        _opts.filetype = 'lua'
        _msg = vim.inspect(msg)
      end
    else
      _opts.filetype = 'lua'
      _msg = vim.inspect(msg)
    end
  end
  return _msg, _opts
end

---@param msg string
---@param level number|string
---@param opts? table<string, any>
function M.notify(msg, level, opts)
  local _msg, _opts = M.parse_message(msg, opts)

  if vim.in_fast_event() then
    vim.schedule(function()
      level = M.get_level(level)
      M.notify(_msg, level, _opts)
    end)
    return
  end

  level = M.get_level(level)
  local message = Message('notify', level, _msg)
  message.opts = _opts or {}
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

return M
