local vim = vim
local log = require('neo-tree.log')

-- Backwards compatibility
table.pack = table.pack or function(...)
  return { n = select('#', ...), ... }
end
table.unpack = table.unpack or unpack

local M = {}

local tracked_functions = {}
M.debounce_strategy = {
  CALL_FIRST_AND_LAST = 0,
  CALL_LAST_ONLY = 1,
}

M.debounce_action = {
  START_NORMAL = 0,
  START_ASYNC_JOB = 1,
  COMPLETE_ASYNC_JOB = 2,
}

local defer_function
-- Part of debounce. Moved out of the function to eliminate memory leaks.
defer_function = function(id, frequency_in_ms, strategy, action)
  tracked_functions[id].in_debounce_period = true
  vim.defer_fn(function()
    local current_data = tracked_functions[id]
    if not current_data then
      return
    end
    if current_data.async_in_progress then
      defer_function(id, frequency_in_ms, strategy, action)
      return
    end
    local _fn = current_data.fn
    current_data.fn = nil
    current_data.in_debounce_period = false
    if _fn ~= nil then
      M.debounce(id, _fn, frequency_in_ms, strategy, action)
    end
  end, frequency_in_ms)
end

---Call fn, but not more than once every x milliseconds.
---@param id string Identifier for the debounce group, such as the function name.
---@param fn function Function to be executed.
---@param frequency_in_ms number Miniumum amount of time between invocations of fn.
---@param strategy number The debounce_strategy to use, determines which calls to fn are not dropped.
M.debounce = function(id, fn, frequency_in_ms, strategy, action)
  local fn_data = tracked_functions[id]

  if fn_data == nil then
    if action == M.debounce_action.COMPLETE_ASYNC_JOB then
      -- original call complete and no further requests have been made
      return
    end
    -- first call for this id
    fn_data = {
      id = id,
      in_debounce_period = false,
      fn = fn,
      frequency_in_ms = frequency_in_ms,
    }
    tracked_functions[id] = fn_data
    if strategy == M.debounce_strategy.CALL_LAST_ONLY then
      defer_function(id, frequency_in_ms, strategy, action)
      return
    end
  else
    fn_data.fn = fn
    fn_data.frequency_in_ms = frequency_in_ms
    if action == M.debounce_action.COMPLETE_ASYNC_JOB then
      fn_data.async_in_progress = false
      return
    elseif fn_data.async_in_progress then
      defer_function(id, frequency_in_ms, strategy, action)
      return
    end
  end

  if fn_data.in_debounce_period then
    -- This id was called recently and can't be executed again yet.
    -- Last one in wins.
    return
  end

  -- Run the requested function normally.
  -- Use a pcall to ensure the debounce period is still respected even if
  -- this call throws an error.
  local success, result = true, nil
  fn_data.in_debounce_period = true
  if type(fn) == 'function' then
    success, result = pcall(fn)
  end
  fn_data.fn = nil
  fn = nil

  if not success then
    vim.notify(vim.inspect({ 'debounce ', id = id, ' error: ', result = result }), 3)
  elseif result and action == M.debounce_action.START_ASYNC_JOB then
    -- This can't fire again until the COMPLETE_ASYNC_JOB signal is sent.
    fn_data.async_in_progress = true
  end

  if strategy == M.debounce_strategy.CALL_LAST_ONLY then
    if fn_data.async_in_progress then
      defer_function(id, frequency_in_ms, strategy, action)
    else
      -- We are done with this debounce
      tracked_functions[id] = nil
    end
  else
    -- Now schedule the next earliest execution.
    -- If there are no calls to run the same function between now
    -- and when this deferred executes, nothing will happen.
    -- If there are several calls, only the last one in will run.
    strategy = M.debounce_strategy.CALL_LAST_ONLY
    defer_function(id, frequency_in_ms, strategy, action)
  end
end

local logger = require('logger').init('hover')
local log_msg = function(level)
  return function(msg, extra)
    if not logger then
      return
    end
    if level == 'trace' then
      logger:trace(msg .. (extra and ' ' .. vim.inspect(extra) or ''))
    elseif level == 'debug' then
      logger:debug(msg .. (extra and ' ' .. vim.inspect(extra) or ''))
    elseif level == 'warn' then
      logger:warn(msg .. (extra and ' ' .. vim.inspect(extra) or ''))
    elseif level == 'error' then
      logger:error(msg .. (extra and ' ' .. vim.inspect(extra) or ''))
    else
      logger:info(msg .. (extra and ' ' .. vim.inspect(extra) or ''))
    end
  end
end

M.logger = function()
  return {
    trace = log_msg('trace'),
    debug = log_msg('debug'),
    info = log_msg('info'),
    warn = log_msg('warn'),
    error = log_msg('error'),
  }
end

M.clear_local_state = function(state)
  for _, provider in ipairs(state.providers) do
    for _, key in ipairs(vim.tbl_keys(provider)) do
      if string.match(key, '^_.*') then
        provider[key] = nil
      end
    end
  end
  state.enabled = {}
  state.curr_idx = 1
  state.bufnr = nil
  state.winnr = nil
end

return M
