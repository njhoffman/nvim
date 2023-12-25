local co = coroutine

local async_thread = {
  threads = {},
}

function async_thread.inside()
  local id = string.format('%p', co.running())
  return async_thread.threads[id]
end

function async_thread.create(fn)
  local thread = co.create(fn)
  local id = string.format('%p', thread)
  async_thread.threads[id] = true
  return thread
end

function async_thread.finished(x)
  if co.status(x) == 'dead' then
    local id = string.format('%p', x)
    async_thread.threads[id] = nil
    return true
  end
  return false
end

local function execute(async_fn, ...)
  local thread = async_thread.create(async_fn)
  local id = string.format('%p', thread)

  local function step(...)
    if co.status(thread) == 'dead' then
      async_thread.threads[id] = nil
    else
      local ret = { co.resume(thread, ...) }
      local stat, err_or_fn, nargs = unpack(ret)

      if not stat then
        error(string.format('The coroutine failed with this message: %s\n%s', err_or_fn, debug.traceback(thread)))
      end

      if async_thread.finished(thread) then
        return
      end

      assert(type(err_or_fn) == 'function', 'type error :: expected func')

      local ret_fn = err_or_fn
      local args = { select(4, unpack(ret)) }
      args[nargs] = step
      ret_fn(unpack(args, 1, nargs))
    end
  end

  step(...)
end

local M = {}

--- Debounces a function on the trailing edge. Automatically
--- `schedule_wrap()`s.
---
-- @param fn (function) Function to debounce
-- @param timeout (number) Timeout in ms
-- @param first (boolean, optional) Whether to use the arguments of the first
---call to `fn` within the timeframe. Default: Use arguments of the last call.
-- @returns (function, timer) Debounced function and timer. Remember to call
---`timer:close()` at the end or you will leak memory!
function M.debounce_trailing(fn, ms, first)
  local timer = vim.loop.new_timer()
  local wrapped_fn

  if not first then
    function wrapped_fn(...)
      local argv = { ... }
      local argc = select('#', ...)

      timer:start(ms, 0, function()
        pcall(vim.schedule_wrap(fn), unpack(argv, 1, argc))
      end)
    end
  else
    local argv, argc
    function wrapped_fn(...)
      argv = argv or { ... }
      argc = argc or select('#', ...)

      timer:start(ms, 0, function()
        pcall(vim.schedule_wrap(fn), unpack(argv, 1, argc))
      end)
    end
  end
  return wrapped_fn, timer
end

function M.wrap(func, argc)
  return function(...)
    if not async_thread.inside() then
      return func(...)
    end
    return co.yield(func, argc, ...)
  end
end

function M.void(func)
  return function(...)
    if async_thread.inside() then
      return func(...)
    end
    execute(func, ...)
  end
end

M.scheduler = M.wrap(vim.schedule, 1)

return M
