local async = require('hover.async')
local state = require('hover.state')
local log = require('hover.utils').logger()

local id_cnt = 0

local function is_enabled(provider)
  local enabled = false
  if type(provider._enabled) ~= 'nil' then
    return provider._enabled
  end

  if type(provider.enabled == 'function') then
    enabled = provider.enabled()
  else
    enabled = provider.enabled
  end
  if enabled then
    table.insert(state.enabled, provider.id)
  end
  for _, p in ipairs(state.providers) do
    if p.id == provider.id then
      p._enabled = enabled
    end
  end
  return enabled
end

local function register(provider)
  if not provider.execute or type(provider.execute) ~= 'function' then
    vim.notify(
      string.format('error: hover provider %s does not provide an execute function', provider.name or 'NA'),
      vim.log.levels.ERROR
    )
    return
  end

  -- utils.debounce("hover", load, 500, utils.debounce_strategy.CALL_FIRST_AND_LAST),
  provider.execute = async.wrap(provider.execute, 1)
  provider.enabled = async.wrap(provider.enabled, 1)
  provider.id = id_cnt
  id_cnt = id_cnt + 1

  if provider.priority then
    for i, p in ipairs(state.providers) do
      if not p.priority or p.priority < provider.priority then
        table.insert(state.providers, i, provider)
        return
      end
    end
    table.insert(state.providers, provider)
  end
end

local function load_provider(provider)
  local ui = require('hover.ui')
  ui.load_hover(provider.id, provider._result)
  ui.add_title()
end

-- Must be called in async context
local function run_provider(provider, _opts)
  local opts = _opts or {}
  local ui = require('hover.ui')

  if opts.focusable ~= false and opts.focus ~= false then
    if ui.focus_or_close_hover() then
      return true
    end
  end

  local result = provider.execute()
  if result then
    for _, p in ipairs(state.providers) do
      if p.id == provider.id then
        p._result = result
      end
    end

    local active_pid = state.enabled[state.curr_idx]
    if provider.id == active_pid then
      async.scheduler()
      ui.create_hover(provider.id, result, opts)
    end
    ui.add_title()
    state.busy = false
    if vim.fn.empty(state.next_job) == 0 then
      state.next_job()
    end
    return true
  end
  return false
end

local function init(_opts)
  local config = require('hover.config').get()
  local opts = vim.tbl_deep_extend('force', config, _opts)
  if state.initialized then
    return opts
  end
  if opts and type(opts.init) == 'function' then
    opts.init()
  end
  state.initialized = true
  return opts
end

local n = 0
local function load(_opts)
  local opts = init(_opts)
  local start_time = vim.fn.reltime()
  local finished = function(provider)
    local load_time = vim.fn.reltimestr(vim.fn.reltime(start_time))
    -- state.provider = provider.name
    provider._n = provider._n and provider._n + 1 or 1
    provider._timing = load_time
    return log.info(load_time .. ' ' .. provider.name)
  end

  if state.busy == true then
    n = n + 1
    state.next_job = function()
      load(_opts)
    end
    return
  end

  state.busy = true

  if type(opts.provider) == 'string' and #opts.provider > 0 then
    for _, provider in ipairs(state.providers) do
      async.scheduler()
      if provider.name == opts.provider and run_provider(provider, opts) then
        finished(provider)
      end
    end
  else
    for _, provider in ipairs(state.providers) do
      async.scheduler()
      if is_enabled(provider) and run_provider(provider, opts) then
        finished(provider)
      end
    end
  end
  if not opts.silent and vim.tbl_isempty(state.enabled) then
    state.busy = false
    vim.api.nvim_echo({ { 'hover.nvim: could not find any hover providers', 'WarningMsg' } }, false, {})
  end
end

return {
  register = register,
  is_enabled = is_enabled,
  load = load,
  load_provider = load_provider,
}
