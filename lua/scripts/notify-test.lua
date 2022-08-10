local notify      = require('notify')
local notify_warn = function()
  notify(
  -- '~/ghq/github.com/njhoffman/fzfmenu/proto-widgets/fzf-preview/fzf-preview.plugin.zsh',
    '~/ghq/github.com/fzf-preview.plugin.zsh',
    'warn',
    { title = { 'Testing ', 'WARN' }, anchor = 'TL', icon = '' }
  )
end

local render_user_options = function(bufnr, notif, highlights)
  -- [global-opt]
  --   notify_level_show   = debug
  --   notify_level_record = trace
  --   notify_level_log    = trace
  --   lsptagfuncenabled   = true
  --   useroptions_output  = notify
  --   shell               = pwsh
  local namespace = vim.api.nvim_create_namespace("notify")
  local msgs = { notif.message.msg }
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, msgs)
  vim.api.nvim_buf_set_extmark(bufnr, namespace, 0, 0, {
    hl_group = highlights.icon,
    end_line = #msgs - 1,
    end_col = msgs[#msgs][1],
    -- end_col = notif.message[#msg][1],
  })
  -- nvim_buf_add_highlight({buffer}, {ns_id}, {hl_group}, {line}, {col_start},
  --                        {col_end})
end

local notify_user_options = function()
  notify({
    scope   = 'global',
    options = {
      notify_level_show   = 'debug',
      notify_level_record = 'trace',
      useroptions_output  = 'notify'
    },
  },
    'task',
    { title = 'test', render = render_user_options }
  )
end

local notify_test = function(type)
  local notify_type = type or 'warn'
  if notify_type == 'options' then
    notify_user_options()
  elseif notify_type == 'warn' then
    notify_warn()
  end
  -- vim.fn.timer_start(3000, function()
  --   notify.dismiss()
  -- end)
end

-- notify_test('options')
