local noice_util = require('noice.util')
local manager = require('noice.message.manager')
local utils = require('noice.view.backend.notify.utils')
local display = require('noice.view.backend.notify.display')
-- local logfile = require('noice.view.backend.logfile')

---@class NoiceNotifyOptions
---@field title string
---@field level? string|number Message log level
---@field merge boolean Merge messages into one Notification or create separate notifications
---@field replace boolean Replace existing notification or create a new one
---@field render? notify.RenderFun|string
---@field timeout? integer
---@alias NotifyMsg {content:string, messages:NoiceMessage[], title?:string, level?:string, opts?: table}
---@param msg NotifyMsg
local build_options = function(self, msg, replace_id)
  local opts = {
    title = msg.title or msg.opts.title or self._opts.title,
    animate = not noice_util.is_blocking(),
    timeout = msg.opts.timeout or self._opts.timeout,
    highlights = msg.opts.highlights,
    replace = self._opts.replace and self.notif,
    -- replace = msg.opts.replace,
    repeat_count = msg.opts.repeat_count,
    keep = function()
      return noice_util.is_blocking()
    end,
    on_open = function(win)
      self:set_win_options(win)
      if self._opts.merge then
        self.win = win
      end
      -- require('noice.view.backend.postprocess').handle_open(self, msg)
      -- if type(msg.opts.on_open) == 'function' then
      --   msg.opts.on_open(win)
      -- end
    end,
    on_close = function(win)
      -- require('noice.view.backend.postprocess').handle_close(self, msg)
      self.notif = nil
      for _, m in ipairs(msg.messages) do
        m.opts.notify_id = nil
      end
      self.win = nil
    end,
    render = noice_util.protect(display.notify_render(self, msg.messages, self._opts.render, msg.content)),
    -- render = noice_util.protect(self:notify_render(msg.messages, self._opts.render, msg.content)),
  }

  if msg.opts then
    opts = vim.tbl_deep_extend('force', opts, msg.opts)
    if type(msg.opts.replace) == 'table' then
      local m = manager.get_by_id(msg.opts.replace.id)
      opts.replace = m and m.opts.notify_id or nil
    elseif type(msg.opts.replace) == 'number' then
      local m = manager.get_by_id(msg.opts.replace)
      opts.replace = m and m.opts.notify_id or nil
    end
  end
  return opts
end

-- see if any existing notifications have same content as new notification
local get_replacement = function(self, msg)
  msg._crc = utils.get_crc(msg.level .. ' ' .. msg.content)
  local replace_id = nil
  -- for key, active in pairs(state.active) do
  --   if not manager.get_by_id(key) then
  --     state.active[key] = nil
  --   else
  --     if active.crc == msg._crc and type(state.active[key]) == 'table' then
  --       replace_id = key
  --       -- self._opts.replace = replace_id
  --       -- self._opts.repeat_count = active.count + 1
  --       msg.opts.replace = replace_id
  --       msg.opts.repeat_count = active.count + 1
  --     end
  --   end
  -- end
  return replace_id
end

local handle_merge = function(self)
  local todo = {}
  local groups = {}
  -- loop from 0 to 5
  for i = 0, 5 do
    local messages = {}
    local content = {}
    for _, m in ipairs(self._messages) do
      local lvl_num = m.level or 1
      if type(lvl_num) == 'string' then
        lvl_num = vim.lsp.log_levels[string.upper(lvl_num)]
      end
      if lvl_num == i then
        table.insert(messages, m)
        table.insert(content, m:content())
      end
    end
    if #messages > 0 or #content > 0 then
      groups[i] = groups[i]
        or {
          content = {},
          messages = {},
          title = nil,
          timeout = nil,
        }
    end
    for _, msg in ipairs(messages) do
      if msg.opts then
        if groups[i].opts ~= nil and table.concat(msg.opts) ~= table.concat(groups[i].opts) then
          vim.dbglog('**NOTIFY VIEW**', 'opts mismatch', groups[i].opts, msg.opts)
        end
        groups[i].opts = msg.opts
      end
      if msg.opts.title then
        if groups[i].title ~= nil and msg.opts.title ~= groups[i].title then
          vim.dbglog('**NOTIFY VIEW**', 'title mismatch', groups[i].title, msg.opts.title)
        end
        groups[i].title = msg.opts.title
      end
      table.insert(groups[i].messages, msg)
    end
    for _, line in ipairs(content) do
      table.insert(groups[i].content, line)
    end
  end
  for lvl, group in pairs(groups) do
    table.insert(todo, {
      content = vim.fn.join(group.content, '\n'),
      messages = group.messages,
      level = lvl,
      title = group.title,
      opts = group.opts,
    })
  end
  return todo
end

local handle_default = function(self)
  local todo = {}
  for _, m in ipairs(self._messages) do
    table.insert(todo, {
      content = m:content(),
      messages = { m },
      title = m.opts.title,
      level = m.level,
      opts = m.opts,
    })
  end
  return todo
end

return {
  build_options = build_options,
  get_replacement = get_replacement,
  handle_merge = handle_merge,
  handle_default = handle_default,
}
