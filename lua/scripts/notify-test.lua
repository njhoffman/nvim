local notify = require('notify')

local render_options = function(bufnr, notif, highlights)
  local notify = require('notify')
  local namespace = vim.api.nvim_create_namespace("notify")
  -- icon = "",
  -- id = 2,
  -- level = "WARN",
  -- message = { "test message" },
  -- render = <function 1>,
  -- time = 1657933850,
  -- title = { "test title", "20:10" },
  local icon = notif.message[2].icon
  local msg = notif.message[1]
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, msg)
  vim.api.nvim_buf_set_extmark(bufnr, namespace, 0, 0, {
    hl_group = highlights.icon,
    end_line = #msg - 1,
    end_col = #notif.message[#msg][1],
  })
end

local notify_test = function()
  notify({
    { '~/.config/nvim/lua/colorschemes/lush-themes/nord-nvim.lua' },
    { icon = '' }
  }, 'task', {
    render = render_options,
  })

  vim.fn.timer_start(3000, function()
    notify.dismiss()
    notify({
      { '~/ghq/github.com/njhoffman/fzfmenu/proto-widgets/fzf-preview/fzf-preview.plugin.zsh' },
      { icon = '' }
    }, 'task', {
      render = render_options,
      anchor = 'TC'
    })
  end)
end
