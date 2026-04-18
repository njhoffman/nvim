local notify = require("notify").notify
local reverse_list = function(list)
  local reversed = {}
  for i = #list, 1, -1 do
    table.insert(reversed, list[i])
  end
  return reversed
end

local run_demo = function(cfg)
  require("notify").setup({ level = vim.lsp.log_levels["TRACE"] })
  -- require('noice').setup({ views = { notify = { level = vim.lsp.log_levels['TRACE'] } } })
  -- vim.dbglog('level', require('notify')._config().level())
  -- require('notify.config').setup({ level = vim.lsp.log_levels['INFO'] })
  -- require('notify').instance({ level = vim.lsp.log_levels['INFO'] })

  local _delay = 0

  vim.api.nvim_buf_set_var(0, "notify_demo_active", true)

  for _, name in ipairs(reverse_list(vim.tbl_keys(cfg.variants))) do
    local variant = cfg.variants[name]
    for _, render in ipairs(cfg.opts.renders) do
      for _, level in ipairs(cfg.opts.levels) do
        local is_active = vim.api.nvim_buf_get_var(0, "notify_demo_active")
        if not is_active then
          break
        else
          local props = { level = level, name = name, render = render }
          local notify_opts = { timeout = cfg.opts.notify_timeout, render = props.render }

          if variant.title then
            notify_opts.title = type(variant.title) == "function" and variant.title(props)
              or variant.title
          end

          local default_body = "Rendering " .. name .. " (" .. render .. ") level: " .. level
          local body = type(variant.body) == "function" and variant.body(props)
            or type(variant.body) == "string" and variant.body
            or default_body

          vim.defer_fn(function()
            notify(body, level, notify_opts)
          end, _delay)
          _delay = _delay + opts.delay
        end
      end
      _delay = _delay + opts.group_timeout
    end
    _delay = _delay + opts.group_timeout
  end
  _delay = _delay + opts.group_timeout
end

local stop_demo = function()
  vim.api.nvim_buf_set_var(0, "notify_demo_active", false)
  notify("STOPPING NOTIFY DEMO", 2)
end

vim.api.nvim_buf_set_var(0, "notify_demo_active", false)

return {
  run = run_demo,
  stop = stop_demo,
}
