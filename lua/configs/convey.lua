local logger = require("logger").init("convey")
local c_log = function(level)
  return function(msg)
    if logger and logger[level] ~= nil then
      msg = msg or ""
      if string.sub(msg, 1, 10) == "[convey] " then
        msg = string.sub(msg, 11)
      end
      logger[level](logger, msg)
    end
  end
end
local c_logger = {}
for _, level in ipairs({ "error", "warn", "info", "debug", "trace" }) do
  c_logger[level] = c_log(level)
end

---Check if MiniAnimate is available and enabled
---@return boolean
local function has_mini_animate()
  return type(MiniAnimate) == "table" and MiniAnimate.config and MiniAnimate.config.scroll
end

---Execute callback after scroll animation completes (or immediately if no MiniAnimate)
---@param callback function
local function after_scroll(callback)
  if has_mini_animate() then
    MiniAnimate.execute_after("scroll", function()
      vim.defer_fn(callback, 100)
    end)
  else
    vim.schedule(callback)
  end
end

require("convey").setup({
  on_navigate = function(provider_cb)
    after_scroll(function()
      provider_cb()
    end)
  end,
  logger = c_logger,
  providers = {
    changes = {
      cycle = true,
    },
    visual = {
      on_navigate = function(pos)
        if pos.end_lnum and pos.end_col then
          vim.fn.setpos("'<", { pos.bufnr, pos.lnum, pos.col + 1, 0 })
          vim.fn.setpos("'>", { pos.bufnr, pos.end_lnum, pos.end_col, 0 })
          vim.cmd("normal! gv")
        end
      end,
    },
  },
})
