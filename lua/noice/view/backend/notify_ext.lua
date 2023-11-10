local notif = require('notify')
local utils = require('noice.view.backend.utils')
local state = { active = {} }
local logger = require('logger').init('notify')

-- TODO: have separate notify, noice, and log levels
function _log_file(lvl, content)
  if logger ~= nil then
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
end

function _notify_override(self, msg)
  local curr_crc = utils.get_crc(msg.content)
  local replace_id = nil
  for key, active in pairs(state.active) do
    if active.crc == curr_crc and type(state.active[key]) == 'table' then
      replace_id = key
      self._opts.replace = replace_id
    end
  end

  self:_notify(msg)

  for _, m in ipairs(msg.messages) do
    local id = m.opts.notify_id and m.opts.notify_id.id
    if replace_id ~= nil then
      local count = state.active[replace_id].count + 1
      state.active[id] = {
        count = count,
        crc = curr_crc,
      }
      self._opts.count = count
      state.active[replace_id] = nil
    else
      local notify_lvl = notif._config().level()
      local msg_lvl = msg.level
      if type(msg.level) == 'string' then
        msg_lvl = vim.lsp.log_levels[string.upper(msg.level)]
      elseif msg.level == nil then
        msg_lvl = 2
      end
      _log_file(msg_lvl, msg.content)
      if msg_lvl >= notify_lvl then
        state.active[id] = {
          crc = curr_crc,
          count = 0,
        }
      end
    end
  end
end

function _on_close_override(self, msg)
  self.notif = nil
  for _, m in ipairs(msg.messages) do
    state.active[m.opts.notify_id.id] = nil
    m.opts.notify_id = nil
  end
  self.win = nil
end

return {
  _notify_override = _notify_override,
  _on_close_override = _on_close_override,
}
