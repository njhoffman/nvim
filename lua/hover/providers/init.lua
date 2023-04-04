local async = require("hover.async")
local state = require("hover.state")
local log = require("hover.utils").logger()
local utils = require("hover.utils")

local providers = {}

local id_cnt = 0

local function is_enabled(provider)
  local enabled = false
  if type(provider.enabled == "function") then
    enabled = provider.enabled()
  else
    enabled = provider.enabled
  end
  if enabled then
    state.enabled[provider.id] = provider
  else
    table.remove(state.enabled, provider.id)
  end
  return enabled
end

local function register(provider)
  if not provider.execute or type(provider.execute) ~= "function" then
    vim.notify(
      string.format("error: hover provider %s does not provide an execute function", provider.name or "NA"),
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
    for i, p in ipairs(providers) do
      if not p.priority or p.priority < provider.priority then
        table.insert(providers, i, provider)
        return
      end
    end
  end
  providers[#providers + 1] = provider
end

-- Must be called in async context
local function run_provider(provider, _opts)
  local opts = _opts or {}
  local ui = require("hover.ui")

  local config = require("hover.config").get()

  if opts.focusable ~= false and opts.focus ~= false then
    if ui.focus_or_close_hover() then
      return true
    end
  end

  local result = provider.execute()
  if result then
    async.scheduler()
    -- show_hover(provider.id, config, result, opts)
    ui.show_hover_new(provider.id, config, result, opts)
    return true
  end

  return false
end

local function init(_opts)
  local config = require("hover.config").get()
  local opts = vim.tbl_deep_extend("force", config, _opts)
  if state.initialised then
    return opts
  end
  if opts and type(opts.init) == "function" then
    opts.init()
  end
  state.initialised = true
  return opts
end

local n = 0
local function load(_opts)
  local opts = init(_opts)
  ---@diagnostic disable-next-line: missing-parameter
  local start_time = vim.fn.reltime()
  local finished = function(provider)
    ---@diagnostic disable-next-line: param-type-mismatch, missing-parameter
    local load_time = vim.fn.reltimestr(vim.fn.reltime(start_time))
    state.provider = provider.name
    state.time = load_time
    return log.info(provider.name .. ": " .. load_time)
  end

  -- if state.busy == true then
  --   n = n + 1
  --   state.next_job = function()
  --     load(_opts)
  --   end
  --   return
  -- end

  state.busy = true

  if type(opts.provider) == "string" and #opts.provider > 0 then
    for _, provider in ipairs(providers) do
      async.scheduler()
      if provider.name == opts.provider and run_provider(provider, opts) then
        return finished(provider)
      end
    end
  else
    for _, provider in ipairs(providers) do
      async.scheduler()
      if is_enabled(provider) and run_provider(provider, opts) then
        return finished(provider)
      end
    end
  end
  if not opts.silent then
    state.busy = false
    vim.api.nvim_echo({ { "hover.nvim: could not find any hover providers", "WarningMsg" } }, false, {})
  end
end

return {
  register = register,
  providers = providers,
  is_enabled = is_enabled,
  load = load,
}
