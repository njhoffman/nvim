local api = vim.api
local util = require("notify._render._util")

return function(bufnr, notif, highlights, config)
  api.nvim_buf_set_lines(bufnr, 0, -1, false, notif.message)
  util.highlight_body(bufnr, highlights, notif, 0, 0, #notif.message - 1)
end
