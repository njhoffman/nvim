local utils = require("tracker.utils")
local state = require("tracker.state")
local config = require("tracker.config")
local diff = require("tracker.diff")
local out = require("tracker.output")

local providers = {}
local function init_provider(provider_cfg)
  local provider = require(provider_cfg.provider)(provider_cfg)
  provider = config.assign_defaults(provider, "provider")
  if type(provider.parse_data) ~= "function" then
    provider.parse_data = diff.parse_data
  end
  if type(provider.output_diff) ~= "function" then
    provider.output_diff = out.output_diff
  end
  return provider
end

local function add_history(provider, delta)
  local prov_state = state.metrics[provider.name]
  local hist_item = utils.unpack_indices(provider, { "name", "id_field", "interval", "label" })
  local state_item = utils.unpack_indices(prov_state, { "time_diff", "time_get" })
  hist_item = vim.tbl_deep_extend("keep", hist_item, { delta = delta, count = #prov_state.prev_items }, state_item)
  table.insert(state.history, hist_item)
end

local function check_diffs()
  local i = 0
  return function()
    for name, provider in pairs(providers) do
      if tonumber(i % provider.interval) == 0 then
        local delta = diff.check_diff(provider, state.metrics[name])
        delta = vim.tbl_extend("keep", delta or {}, { added = {}, removed = {} })
        -- vim.dbglog("tick: " .. i, delta)
        local prov_state = state.metrics[provider.name]
        state.totals.get = prov_state.time_get + state.totals.get
        state.totals.diff = prov_state.time_diff + state.totals.diff
        if #delta.added > 0 or #delta.removed > 0 then
          provider.output_diff(provider, delta)
          add_history(provider, delta)
        end
      end
      i = i + 1
    end
    if state.totals.diff > 0 or state.totals.get > 0 then
      table.insert(state.timings, state.totals)
    end
    state.totals = { get = 0, diff = 0 }
  end
end

local function start_timer()
  state.timer = vim.fn.timer_start(1000, check_diffs(), { ["repeat"] = -1 })
end

return {
  start = start_timer,
  providers = providers,
  init = function(name, provider_cfg)
    providers[name] = init_provider(provider_cfg)
    state.metrics[name] = config.assign_defaults({ name = name }, "provider_state")
  end,
}
