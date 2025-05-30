local state = require("configs.neoscroll.state")

-- local events = {}
local events = { "WinScrolled", "CursorMoved" }
local ts_ctx = require("treesitter-context")

local hooks = {}
hooks.pre_hook = function(info, params)
  vim.dbglog("prehook")
  state.params = params
  state.start = vim.fn.reltime()

  vim.opt.eventignore:append(events)
  ts_ctx.disable()
  vim.b.minianimate_disable = true
end

hooks.steps_hook = function(...)
  local new_entry = { n = #state.steps + 1, ... }
  table.insert(state.steps, new_entry)
end

hooks.post_hook = function(info)
  -- post_hook = function(info)
  --   if info == 'centercursor' then
  --     vim.cmd('normal! zz')
  --   end
  -- end,
  -- vim.defer_fn(function()
  --   require('neoscroll').zz(zz_time_ms, easing)
  -- end, defer_time_ms)
  -- if info == 'centercursor' then
  --   vim.cmd('normal zz')
  -- end

  local stats_mod = require("configs.neoscroll.stats")
  if #state.steps > 0 then
    local stats = stats_mod.summarize_scroll(state.steps, state.params)
    table.insert(stats_mod.history, {
      n = #stats_mod.history + 1,
      info = info,
      duration = vim.fn.reltimestr(vim.fn.reltime(state.start)),
      stats = vim.fn.deepcopy(stats),
      params = vim.fn.deepcopy(state.params),
    })
  else
    vim.defer_fn(function()
      vim.opt.eventignore:remove(events)
      vim.b.minianimate_disable = false
      ts_ctx.enable()
    end, 200)
  end
end

return hooks
