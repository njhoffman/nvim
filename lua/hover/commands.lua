local cmd = vim.api.nvim_create_user_command
local state = require('hover.state')
local providers = require('hover.providers')
local async = require('hover.async')

local handle_command = function(behavior)
  return async.void(function(input)
    local opts = { behavior = behavior }
    if input.args and input.args ~= '' then
      opts.args = input.args
    end
    providers.load(opts)
  end)
end

-- open up a select box with all available providers
local hover_select = async.void(function(_opts)
  local enabled_providers = {}
  for _, provider in ipairs(state.providers) do
    if provider.is_enabled(provider) then
      table.insert(enabled_providers, provider)
    end
  end

  -- vim.ui.select(enabled_providers, {
  --   prompt = "Select hover:",
  --   format_item = function(provider)
  --     return provider.desc
  --   end,
  -- }, function(provider)
  --   if provider then
  --     async.void(run_provider)(provider)
  --     local load_time = vim.fn.reltimestr(vim.fn.reltime(start_time))
  --     state.provider = provider.name
  --     state.time = load_time
  --     return log.info(provider.name .. ": " .. load_time)
  --   end
  -- end)
end)

local init = function()
  vim.api.nvim_create_augroup('Hover', { clear = true })
  cmd('HoverClose', function()
    if type(state.winnr) == 'number' and vim.api.nvim_win_is_valid(state.winnr) then
      vim.api.nvim_win_close(state.winnr, true)
    end
  end, { desc = 'Close hover window' })

  cmd('Hover', handle_command('once'), { desc = 'Open hover window once' })
  cmd('HoverSticky', handle_command('sticky'), { desc = 'Open hover window sticky' })
  cmd('HoverCursor', handle_command('cursor'), { desc = 'Open hover select menu' })
  -- cmd('HoverSelect', handle_command(handle_command('once')), { desc = 'Open hover select menu' })
end

return { init = init, handle_command = handle_command }
