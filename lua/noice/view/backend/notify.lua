local require = require('noice.util.lazy')

local Util = require('noice.util')
local View = require('noice.view')
local Manager = require('noice.message.manager')
local NuiText = require('nui.text')
local extensions = require('noice.view.backend.notify_ext')

---@class NoiceNotifyOptions
---@field title string
---@field level? string|number Message log level
---@field merge boolean Merge messages into one Notification or create separate notifications
---@field replace boolean Replace existing notification or create a new one
---@field render? notify.RenderFun|string
---@field timeout? integer

local defaults = {
  title = 'Notification',
  merge = false,
  level = nil, -- vim.log.levels.INFO,
  replace = false,
}
---@class NotifyInstance
---@field notify fun(msg:string?, level?:string|number, opts?:table): notify.Record}

---@alias notify.RenderFun fun(buf:buffer, notif: Notification, hl: NotifyBufHighlights, config: notify.Config)

---@class NotifyView: NoiceView
---@field win? number
---@field buf? number
---@field notif notify.Record
---@field super NoiceView
---@diagnostic disable-next-line: undefined-field
local NotifyView = View:extend('NotifyView')
function NotifyView.dismiss()
  require('notify').dismiss({ pending = true, silent = true })
end

function NotifyView:is_available()
  return pcall(_G.require, 'notify') == true
end

function NotifyView:update_options()
  self._opts = vim.tbl_deep_extend('force', defaults, self._opts)
end

function NotifyView:update_active()
  self._active = vim.tbl_deep_extend('force', {}, self._active)
end

function NotifyView:plain()
  return function(bufnr, notif)
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, notif.message)
  end
end

---@param config notify.Config
---@param render? notify.RenderFun|string
---@return notify.RenderFun
function NotifyView:get_render(config, render)
  ---@type string|notify.RenderFun
  local ret = render or config.render()
  if type(ret) == 'string' then
    if ret == 'plain' then
      ret = self:plain()
    else
      ---@type notify.RenderFun
      ret = require('notify.render')[ret]
    end
  end
  return ret
end

---@param messages NoiceMessage[]
---@param render? notify.RenderFun|string
---@param content? string
function NotifyView:notify_render(messages, render, content)
  ---@param config notify.Config
  return function(buf, notif, hl, config)
    -- run notify view
    self:get_render(config, render)(buf, notif, hl, config)

    Util.tag(buf, 'notify')

    ---@type string[]
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

    local text = table.concat(lines, '\n')
    local idx = content and text:find(content, 1, true) or nil

    if idx then
      -- we found the offset of the content as a string
      local before = text:sub(1, idx - 1)
      local offset = #vim.split(before, '\n')
      local offset_col = #before:match('[^\n]*$')

      -- in case the content starts in the middle of the line,
      -- we need to add a fake prefix to the first line of the first message
      -- see #375
      if offset_col > 0 then
        messages = vim.deepcopy(messages)
        table.insert(messages[1]._lines[1]._texts, 1, NuiText(string.rep(' ', offset_col)))
      end

      -- do our rendering
      self:render(buf, { offset = offset, highlight = true, messages = messages })
      -- in case we didn't find the offset, we won't highlight anything
    end

    -- resize notification
    local win = vim.fn.bufwinid(buf)
    if win ~= -1 then
      ---@type number
      local width = config.minimum_width()
      for _, line in pairs(lines) do
        width = math.max(width, vim.str_utfindex(line))
      end
      width = math.min(config.max_width() or 1000, width)
      local height = math.min(config.max_height() or 1000, #lines)
      Util.win_apply_config(win, { width = width, height = height })
    end
  end
end

---@alias NotifyMsg {content:string, messages:NoiceMessage[], title?:string, level?:string, opts?: table}

---@param msg NotifyMsg
function NotifyView:_notify(msg)
  local level = msg.level

  local opts = {
    title = msg.title or msg.opts.title or self._opts.title,
    animate = not Util.is_blocking(),
    timeout = msg.opts.timeout or self._opts.timeout,
    body_highlights = msg.opts.body_highlights,
    body_level_highlights = msg.opts.body_level_highlights,
    replace = self._opts.replace and self.notif,
    repeat_count = self._opts.repeat_count,
    keep = function()
      return Util.is_blocking()
    end,
    on_open = function(win)
      self:set_win_options(win)
      if msg.opts.filetype then
        local buf = vim.api.nvim_win_get_buf(win)
        vim.api.nvim_buf_set_option(buf, 'filetype', msg.opts.filetype)
      end
      if self._opts.merge then
        self.win = win
      end
    end,
    on_close = function()
      self:_on_close_override(msg)
    end,
    render = Util.protect(self:notify_render(msg.messages, self._opts.render, msg.content)),
    render_title = msg.opts.render_title or self._opts.render_title or 'default',
  }

  if msg.opts then
    opts = vim.tbl_deep_extend('force', opts, msg.opts)
    if type(msg.opts.replace) == 'table' then
      local m = Manager.get_by_id(msg.opts.replace.id)
      opts.replace = m and m.opts.notify_id or nil
    elseif type(msg.opts.replace) == 'number' then
      local m = Manager.get_by_id(msg.opts.replace)
      opts.replace = m and m.opts.notify_id or nil
    end
  end

  ---@type string?
  local content = msg.content
  if opts.repeat_count then
    content = content .. ' #' .. opts.repeat_count
  end

  if msg.opts and msg.opts.is_nil then
    content = nil
  end

  local notif = require('notify')(content, level, opts)
  self.notif = notif
  for _, m in ipairs(msg.messages) do
    m.opts.notify_id = notif.id
  end
end

function NotifyView:show()
  ---@type NotifyMsg[]
  local todo = {}

  if self._opts.merge then
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
  else
    for _, m in ipairs(self._messages) do
      table.insert(todo, {
        content = m:content(),
        messages = { m },
        title = m.opts.title,
        level = m.level,
        opts = m.opts,
      })
    end
  end
  self:clear()

  for _, msg in ipairs(todo) do
    self:_notify_override(msg)
  end
end

function NotifyView:hide()
  if self.win and vim.api.nvim_win_is_valid(self.win) then
    vim.api.nvim_win_close(self.win, true)
    self.win = nil
  end
end

NotifyView._on_close_override = extensions._on_close_override
NotifyView._on_open_override = extensions._on_open_override
NotifyView._notify_override = extensions._notify_override

return NotifyView
