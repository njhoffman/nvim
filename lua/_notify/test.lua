local notify = require("notify").notify
-- local notify = vim.notify

local delay = 2000
local timeout = 2000

local notify_errors = function()
  -- error2 gives eol problem
  local errors = require("notify.examples.errors")
  notify(errors[6], 4, { timeout = timeout })
  -- local delay = 1000
  -- for i, example in pairs(examples) do
  --   vim.defer_fn(function()
  --     notify(example, 4, { timeout = 4000, title = i })
  --   end, delay)
  --   delay = delay + 5000
  -- end
end

local notify_merge = function()
  local level = "info"
  for i = 1, 5 do
    notify("Rendering merge " .. i, level, { timeout = timeout })
  end
  level = "debug"
  for _ = 1, 5 do
    notify("Rendering merge", level, { timeout = timeout })
  end
end

local notify_duplicates = function()
  local level = "info"
  local _delay = 0
  for _ = 1, 8 do
    vim.defer_fn(function()
      notify("Rendering duplicates", level, { timeout = timeout })
    end, _delay)
    _delay = _delay + 200
  end
  local level = "debug"
  for _ = 1, 10 do
    vim.defer_fn(function()
      notify("Rendering duplicates", level, { timeout = timeout })
    end, _delay)
    _delay = _delay + 200
  end
end

local custom_messages = {
  {
    { { "Notify", "Keyword" }, { " " }, { "Custom highlights", "Comment" } },
  },
  {
    {
      { "Notify", "Keyword" },
      { " " },
      { "Custom highlights", "Comment" },
    },
    {
      { "Line 2 Operator", "Operator" },
      { " Normal " },
      { "highlight", "Comment" },
    },
  },
}

local notify_custom_hl = function()
  local _delay = 0
  for _, msg in ipairs(custom_messages) do
    vim.defer_fn(function()
      notify(msg, 2, {
        render = "simple-notitle",
        timeout = timeout,
      })
    end, _delay)
    _delay = _delay + delay
  end
  _delay = _delay + delay
  for _, msg in ipairs(custom_messages) do
    vim.defer_fn(function()
      notify(msg, 1, {
        render = "simple-notitle",
        timeout = timeout,
        title = "custom hl title",
      })
    end, _delay)
    _delay = _delay + delay
  end
end

local notify_long = function()
  local msg =
    "Use parentheses to group and prioritize calculations. For example, <Ctrl>+<R>=3*(4+2) will calculate the result of the expression 3*(4+2)."
end

local notif_levels = function(opts)
  return function()
    local name = opts._name and opts._name .. " " or ""
    local render = opts.render or "default"
    local _delay = 0
    for _, level in ipairs({ "trace", "debug", "info", "warn", "error" }) do
      local msg = "Rendering " .. name .. "(" .. render .. ") level: " .. level
      vim.defer_fn(function()
        notify(msg, level, {
          timeout = timeout,
          render = opts.render,
          title = opts.title,
        })
      end, _delay)
      _delay = _delay + delay
    end
  end
end

-- stylua: ignore
local funcs = {
  -- errors           = notify_errors,
  minimal                = notif_levels({ render = 'minimal' }),
  simple                 = notif_levels({ render = 'simple' }),
  compact                = notif_levels({ render = 'compact' }),
  default                = notif_levels({ render = 'default' }),
  wrapped_minimal        = notif_levels({ render = 'wrapped-minimal' }),
  wrapped_compact        = notif_levels({ render = 'wrapped-compact' }),
  wrapped_default        = notif_levels({ render = 'wrapped-default' }),
  -- title1_simple           = notify({ _name  = 'title1', render = 'simple',          title = 'Simple title1'  }),
  -- title1_compact          = notify({ _name  = 'title1', render = 'compact',         title = 'Compact title1' }),
  -- title1_wrappped_compact = notify({ _name  = 'title1', render = 'wrapped-compact', title = 'Wrapped title1' }),
  -- title1_default          = notify({ _name  = 'title1', render = 'default',         title = 'Default title1' }),
  -- title2_simple           = notify({ _name  = 'title2', render = 'simple',          title = {'Simple title2',  '10:50:32' }}),
  -- title2_compact          = notify({ _name  = 'title2', render = 'compact',         title = {'Compact title2', '10:50:32' }}),
  -- title2_wrappped_compact = notify({ _name  = 'title2', render = 'wrapped-compact', title = {'Wrapped title2', '10:50:32' }}),
  -- title2_default          = notify({ _name  = 'title2', render = 'default',         title = {'Default title2', '10:50:32' }}),

  -- merge            = notify_merge,
  -- duplicates       = notify_duplicates,
  -- custom_hl        = notify_custom_hl,
}

local notify_test = function(category)
  if category ~= nil then
    category = type(category) == "string" and { category } or category
    local _delay = 0
    for _, cat in ipairs(category) do
      if not funcs[cat] then
        vim.dbglog("*** invalid category ***", cat)
      else
        vim.defer_fn(funcs[cat], _delay)
        _delay = _delay + delay * 5
      end
    end
  end
end

-- require('noice').setup({ views = { notify = { level = vim.lsp.log_levels['TRACE'] } } })
require("notify").setup({ level = vim.lsp.log_levels["TRACE"] })
-- vim.dbglog('level', require('notify')._config().level())
-- require('notify.config').setup({ level = vim.lsp.log_levels['INFO'] })
-- require('notify').instance({ level = vim.lsp.log_levels['INFO'] })
notify_test({
  -- 'errors',
  "minimal",
  "simple",
  "compact",
  "default",
  "wrapped_minimal",
  "wrapped_compact",
  "wrapped_default",

  -- "title1_simple",
  -- "title1_compact",
  -- "title1_wrapped_compact",
  -- "title1_default",

  -- "title2_simple",
  -- "title2_compact",
  -- "title2_wrapped_compact",
  -- "title2_default",

  -- 'ml_minimal',
  -- 'ml_simple',
  -- 'ml_simple_notitle',
  -- 'ml_compact',
  -- 'ml_wrapped_compact',
  -- 'ml_default',
  --
  -- 'ml_title1_simple',
  -- 'ml_title1_compact',
  -- 'ml_title1_wrapped_compact',
  -- 'ml_title1_default',
  --
  -- 'ml_title2_simple',
  -- 'ml_title2_compact',
  -- 'ml_title2_wrapped_compact',
  -- 'ml_title2_default',

  -- 'os_width_simple'
  -- 'basic_merge',
  -- 'basic_repeat',
  -- 'custom_hl',
  -- 'custom_hl_raw',
})

-- vim.api.nvim_create_user_command('NotifyTest', notify_test, { desc = 'Notifications renderings' })
