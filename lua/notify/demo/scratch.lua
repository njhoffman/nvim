local notify = require("notify").notify

local timeout = 8000

local notify_errors = function(idx)
  -- error2 gives eol problem
  local errors = require("notify.demo.errors")
  if type(idx) == "number" then
    notify(errors[idx], 4, { timeout = timeout })
  end
  -- local delay = 1000
  -- for i, example in pairs(examples) do
  --   vim.defer_fn(function()
  --     notify(example, 4, { timeout = 4000, title = i })
  --   end, delay)
  --   delay = delay + 5000
  -- end
end

notify_errors(3)
