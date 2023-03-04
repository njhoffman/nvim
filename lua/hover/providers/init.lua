local async = require("hover.async")
-- local log = require("hover.utils").logger()
local state = require("hover.state")

local M = {}

local providers = {}
M.providers = providers

local id_cnt = 0

function M.is_enabled(provider)
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

function M.register(provider)
  if not provider.execute or type(provider.execute) ~= "function" then
    vim.notify(
      string.format("error: hover provider %s does not provide an execute function", provider.name or "NA"),
      vim.log.levels.ERROR
    )
    return
  end

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

return M
