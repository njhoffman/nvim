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

-- notif = notify("Test debug ********", 1, { title = "DEBUG" })
-- vim.defer_fn(function()
--   notif = notify("Test info", 2, { title = "INFO", replace = notif.id })
--   vim.defer_fn(function()
--     notif = notify("Test warn **********", 3, { title = "WARN", replace = notif.id })
--     vim.defer_fn(function()
--       notif = notify("Test error", 4, { title = "ERROR", replace = notif.id })
--     end, 2000)
--   end, 2000)
-- end, 2000)

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
