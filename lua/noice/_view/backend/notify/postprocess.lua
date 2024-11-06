local notif = require('notify')
local state = require('noice.view.backend.notify.state')

local handle_open = function(msg, replace_id)
  local count = state.active[replace_id] and state.active[replace_id].count and state.active[replace_id].count + 1 or 1
  if replace_id and msg.opts.notify_id == replace_id then
    state.active[msg.opts.notify_id] = {
      count = count,
      crc = msg._crc,
    }
    msg.opts.replace = replace_id
    msg.opts.repeat_count = count
    state.active[replace_id] = nil
  else
    for _, m in ipairs(msg.messages) do
      local id = m.opts and m.opts.notify_id or m.id
      if replace_id ~= nil then
        state.active[id] = { count = count, crc = msg._crc }
        m.opts.replace = replace_id
        m.opts.repeat_count = count
        state.active[replace_id] = nil
      else
        local notify_lvl = notif._config().level()
        local msg_lvl = msg.level
        if type(msg.level) == 'string' then
          msg_lvl = vim.lsp.log_levels[string.upper(msg.level)]
        end
        if msg_lvl >= notify_lvl then
          state.active[id] = { crc = msg._crc, count = 1 }
        end
      end
    end
  end
end

local handle_close = function(self, msg)
  -- if msg.opts.notify_id then
  --   state.active[msg.opts.notify_id] = nil
  -- end
  self.notif = nil
  if msg.opts.notify_id then
    state.active[msg.opts.notify_id] = nil
    -- m.opts.notify_id = nil
  else
    for _, m in ipairs(msg.messages) do
      if type(m.opts.notify_id) ~= 'number' then
        vim.dbglog('no notify_id', m)
      else
        state.active[m.opts.notify_id] = nil
        m.opts.notify_id = nil
      end
    end
  end
  self.win = nil
end

return {
  handle_open = handle_open,
  handle_close = handle_close,
}
