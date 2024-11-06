local base = require('notify.render.base')

vim.cmd([[
  highlight default link NotifyListCol1 Constant
  highlight default link NotifyListCol2 Comment
  highlight default link NotifyListDiv Function
]])

-- highlights: .icon, .body, .border,  .title, .groups={ 'NotifyINFOBody30' = { foreground = 36672 }}
local render_extmarks = function(bufnr, notif, highlights, config)
  local namespace = base.namespace()
  local msg = notif.message[1]
  local hls = notif.message[2]
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, msg)

  vim.api.nvim_buf_set_extmark(bufnr, namespace, 0, 0, {
    hl_group = highlights.icon,
    end_line = #msg - 1,
    end_col = #msg[#msg],
    priority = 50,
  })

  local line_start = 0

  for i, hl_line in ipairs(hls) do
    for j, hl in ipairs(hl_line) do
      local opt = { hl_group = hl[1], end_col = hl[4] }
      vim.api.nvim_buf_set_extmark(bufnr, namespace, hl[2] + line_start, hl[3], opt)
    end
  end
end

return render_extmarks
