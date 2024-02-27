local state = require('neoscroll.state')

-- local events = {}
local events = { 'WinScrolled', 'CursorMoved' }
local ts_ctx = require('treesitter-context')

local hooks = {}
hooks.pre_hook = function(info, params)
  state.params = params
  state.start = vim.fn.reltime()

  vim.opt.eventignore:append(events)
  ts_ctx.disable()
end

hooks.steps_hook = function(...)
  local new_entry = { n = #state.steps + 1, ... }
  table.insert(state.steps, new_entry)
end

hooks.post_hook = function(info)
  -- vim.defer_fn(function()
  --   require('neoscroll').zz(zz_time_ms, easing)
  -- end, defer_time_ms)
  -- if info == 'centercursor' then
  --   vim.cmd('normal zz')
  -- end

  local stats_mod = require('configs.neoscroll.stats')
  vim.opt.eventignore:remove(events)
  ts_ctx.enable()
  if #state.steps > 0 then
    local stats = stats_mod.summarize_scroll(state.steps, state.params)
    table.insert(stats_mod.history, {
      n = #stats_mod.history + 1,
      info = info,
      duration = vim.fn.reltimestr(vim.fn.reltime(state.start)),
      stats = vim.fn.deepcopy(stats),
      params = vim.fn.deepcopy(state.params),
    })
  end
end

return hooks
