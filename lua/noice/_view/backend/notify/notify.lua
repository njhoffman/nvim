local require = require("noice.util.lazy")

local View = require("noice.view")
local preprocess = require("noice.view.backend.notify.preprocess")
local postprocess = require("noice.view.backend.notify.postprocess")
local display = require("noice.view.backend.notify.display")

local defaults = {
  title = "Notification",
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
local NotifyView = View:extend("NotifyView")
function NotifyView.dismiss()
  require("notify").dismiss({ pending = true, silent = true })
end

function NotifyView:is_available()
  return pcall(_G.require, "notify") == true
end

function NotifyView:update_options()
  self._opts = vim.tbl_deep_extend("force", defaults, self._opts)
end

function NotifyView:update_active()
  self._active = vim.tbl_deep_extend("force", {}, self._active)
end

function NotifyView:_notify(msg, opts)
  ---@type string?
  local level = msg.level
  local content = vim.trim(msg.content)

  local notif = require("notify")(content, level, opts)
  self.notif = notif
  for _, m in ipairs(msg.messages) do
    m.opts = m.opts or {}
    m.opts.notify_id = notif and notif.id
  end
end

function NotifyView:show()
  ---@type NotifyMsg[]
  local todo = {}
  if self._opts.merge then
    todo = preprocess.handle_merge(self)
  else
    todo = preprocess.handle_default(self)
  end
  self:clear()
  for _, msg in ipairs(todo) do
    local replace_id = nil
    -- replace_id = preprocess.get_replacement(self, msg)
    local opts = preprocess.build_options(self, msg, replace_id)
    display.logfile(msg.level, msg.content)
    self:_notify(msg, opts)
  end
end

function NotifyView:hide()
  if self.win and vim.api.nvim_win_is_valid(self.win) then
    vim.api.nvim_win_close(self.win, true)
    self.win = nil
  end
end

return NotifyView
