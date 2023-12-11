local base = require('notify.render.base')

return function(bufnr, notif, highlights)
  local namespace = base.namespace()
  local icon = vim.fn.trim(notif.icon or '')
  local title = vim.fn.trim(notif.title[1] or '')

  local prefix = ''
  local display_message = vim.fn.deepcopy(notif.message)
  if type(title) == 'string' and #title > 0 then
    prefix = string.format('%s | %s:', icon, title)
  else
    prefix = string.format('%s |', icon)
  end
  display_message[1] = string.format('%s %s', prefix, display_message[1])

  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, display_message)

  local icon_length = icon and vim.str_utfindex(icon) or 0
  local prefix_length = vim.str_utfindex(prefix)

  vim.api.nvim_buf_set_extmark(bufnr, namespace, 0, 0, {
    hl_group = highlights.icon,
    end_col = icon_length + 1,
    priority = 50,
  })
  vim.api.nvim_buf_set_extmark(bufnr, namespace, 0, icon_length + 1, {
    hl_group = highlights.title,
    end_col = prefix_length + 1,
    priority = 50,
  })

  if notif.body_highlights then
    base.content_hl(bufnr, highlights, notif, 0, prefix_length + 1)
  else
    base.body_hl(bufnr, highlights, notif, 0, prefix_length + 1, #display_message)
  end
end
