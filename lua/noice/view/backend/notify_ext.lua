local utils = require('noice.view.backend.utils')
local state = { active = {} }

-- if self.win and vim.api.nvim_win_is_valid(self.win) then
--   vim.api.nvim_win_close(self.win, true)
--   self.win = nil
-- end
-- vim.dbglog('PRE', msg)

-- msg = msg. .. ' **'
-- items[tostring(crc_hash)] = item
-- if self.win and vim.api.nvim_win_is_valid(self.win) then
--   vim.api.nvim_win_close(self.win, true)
--   self.win = nil
-- end

-- _opts = {
--     backend = "notify",
--     fallback = "mini",
--     format = "notify",
--     merge = false,
--     render = "minimal",
--     replace = false,
--     title = "Notify",
--     view = "notify"
-- },
-- state.active[self._id] =
-- vim.dbglog('POST', self.notif.messages) --_opts, _view_opts

function _notify_override(self, msg)
  local curr_crc = utils.get_crc(msg.content)
  for _, m in ipairs(msg.messages) do
    if #state.active > 0 then
      vim.dbglog('MADE IT')
      -- msg.content = msg.content .. ' **'
    end
  end
  self:_notify(msg)
  for _, m in ipairs(msg.messages) do
    state.active[m.opts.notify_id.id] = curr_crc
  end
  vim.dbglog('1', self._id, state)
end

function _on_close_override(self, msg)
  vim.dbglog(self.notif)
  self.notif = nil
  for _, m in ipairs(msg.messages) do
    state.active[m.opts.notify_id.id] = nil
    m.opts.notify_id = nil
  end
  self.win = nil
  vim.dbglog('2', state)
end

return {
  _notify_override = _notify_override,
  _on_close_override = _on_close_override,
}
