local api = vim.api
local base = require('notify.render.base')

return function(bufnr, notif, highlights)
  local namespace = base.namespace()
  api.nvim_buf_set_lines(bufnr, 0, -1, false, notif.message)

  if notif.body_highlights then
    base.content_hl(bufnr, 0, 0, highlights, notif)
  else
    base.body_hl(bufnr, 0, 0, highlights.icon, #notif.message - 1, #notif.message[#notif.message])
  end
end
