local api = vim.api
local base = require('notify.render.base')

return function(bufnr, notif, highlights, config)
  local namespace = base.namespace()
  api.nvim_buf_set_lines(bufnr, 0, -1, false, notif.message)

  notif.body_hl_group = 'icon'
  base.content_hl(bufnr, highlights, notif, 0, 0, #notif.message - 1)
  -- base.content_hl(bufnr, highlights, notif, 0, 0)
  -- base.body_hl(bufnr, highlights, notif, 0, 0, #notif.message - 1, #notif.message[#notif.message])
end
