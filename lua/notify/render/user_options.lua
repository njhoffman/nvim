local notify = require('notify')
local base = require('notify.render.base')
local render_user_options = function(bufnr, notif, highlights)
  -- [global-opt]
  --   notify_level_show   = debug
  --   notify_level_record = trace
  --   notify_level_log    = trace
  --   lsptagfuncenabled   = true
  --   useroptions_output  = notify
  --   shell               = pwsh
  local namespace = base.namespace()
  local msgs = { notif.message.msg }
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, msgs)
  vim.api.nvim_buf_set_extmark(bufnr, namespace, 0, 0, {
    hl_group = highlights.icon,
    end_line = #msgs - 1,
    -- end_col = msgs[#msgs][1],
    -- end_col = notif.message[#msg][1],
  })
  -- nvim_buf_add_highlight({buffer}, {ns_id}, {hl_group}, {line}, {col_start},
  --                        {col_end})
end

return render_user_options
