local notify = require("notify").notify
-- local notify = vim.notify

local delay = 200
local timeout = 3000
local group_timeout = 4000

local reverse_list = function(list)
  local reversed = {}
  for i = #list, 1, -1 do
    table.insert(reversed, list[i])
  end
  return reversed
end

local run_demo = function(groups, opts)
  require("notify").setup({ level = vim.lsp.log_levels["TRACE"] })
  -- require('noice').setup({ views = { notify = { level = vim.lsp.log_levels['TRACE'] } } })
  -- vim.dbglog('level', require('notify')._config().level())
  -- require('notify.config').setup({ level = vim.lsp.log_levels['INFO'] })
  -- require('notify').instance({ level = vim.lsp.log_levels['INFO'] })

  local defaults = {
    opts = {
      levels = { "trace", "debug", "info", "warn", "error" },
      stages = "fade_in_slide_out", -- fade_in_slide_out, fade, slide, static
      renders = {
        "minimal",
        "simple",
        "compact",
        "default",
        "wrapped-minimal",
        "wrapped-compact",
        "wrapped-default",
      },
    },
    groups = require("notify.demo.groups"),
  }

  opts = vim.tbl_extend("force", defaults.opts, opts or {})
  groups = groups or defaults.groups
  local _delay = 0

  vim.api.nvim_buf_set_var(0, "notify_demo_active", true)

  for _, name in ipairs(reverse_list(vim.tbl_keys(groups))) do
    local group = groups[name]
    for _, render in ipairs(opts.renders) do
      for _, level in ipairs(opts.levels) do
        local is_active = vim.api.nvim_buf_get_var(0, "notify_demo_active")
        if not is_active then
          break
        else
          local props = { level = level, name = name, render = render }
          local notify_opts = { timeout = timeout, render = props.render }

          if group.title then
            notify_opts.title = type(group.title) == "function" and group.title(props)
              or group.title
          end

          local default_body = "Rendering " .. name .. " (" .. render .. ") level: " .. level
          local body = type(group.body) == "function" and group.body(props)
            or type(group.body) == "string" and group.body
            or default_body

          vim.defer_fn(function()
            notify(body, level, notify_opts)
          end, _delay)
          _delay = _delay + delay
        end
      end
      _delay = _delay + group_timeout
    end
    _delay = _delay + group_timeout
  end
  _delay = _delay + group_timeout
end

local stop_demo = function()
  vim.api.nvim_buf_set_var(0, "notify_demo_active", false)
  notify("STOPPING NOTIFY DEMO", 2)
end

vim.api.nvim_buf_set_var(0, "notify_demo_active", false)

vim.api.nvim_create_user_command("NotifyDemoStart", run_demo, { desc = "Notifications renderings" })
vim.api.nvim_create_user_command(
  "NotifyDemoStop",
  stop_demo,
  { desc = "Stop Notifications renderings" }
)
