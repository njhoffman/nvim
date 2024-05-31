local noice_util = require('noice.util')
local NuiText = require('nui.text')

-- TODO: have separate notify, noice, and log levels
local logfile = function(lvl, content)
  local logger = require('logger').init('notify')
  content = vim.trim(content:gsub('\n$', ''))
  -- strip all new lines
  if lvl == 0 then
    logger:trace(content)
  elseif lvl == 1 then
    logger:debug(content)
  elseif lvl == 2 then
    logger:info(content)
  elseif lvl == 3 then
    logger:warn(content)
  else
    logger:error(content)
  end
end

-- function NotifyView:plain()
local render_plain = function()
  return function(bufnr, notif)
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, notif.message)
  end
end

---@param config notify.Config
---@param render? notify.RenderFun|string
---@return notify.RenderFun
local get_render = function(config, render)
  ---@type string|notify.RenderFun
  local ret = render or config.render()
  if type(ret) == 'string' then
    if ret == 'plain' then
      ret = render_plain()
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
-- function NotifyView:notify_render(messages, render, content)
local notify_render = function(self, messages, render, content)
  ---@param config notify.Config
  return function(buf, notif, hl, config)
    -- run notify view
    get_render(config, render)(buf, notif, hl, config)

    noice_util.tag(buf, 'notify')

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
      noice_util.win_apply_config(win, { width = width, height = height })
    end
  end
end

return {
  notify_render = notify_render,
  logfile = logfile,
}
