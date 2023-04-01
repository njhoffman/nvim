local keymaps = require("hover.keymaps")
local commands = require("hover.commands")
local providers = require("hover.providers")
local async = require("hover.async")

local handle_win_closed = function(winnr, _)
  vim.api.nvim_create_autocmd("WinClosed", {
    callback = function(ev)
      if ev.match == tostring(winnr) then
        vim.api.nvim_del_augroup_by_name("Hover")
        keymaps.clear()
        commands.clear()
      end
    end,
    group = "Hover",
  })
end

-- local function init(_opts)
--   local config = get_config()
--   local opts = vim.tbl_deep_extend("keep", _opts or {}, config)
--   if initialised then
--     return opts
--   end
--   if config and type(config.init) == "function" then
--     config.init()
--   end
--   initialised = true
--   return opts
-- end

local hover = async.void(function(_opts)
  local opts = _opts or {}
  providers.load(opts)
end)

local hover_sticky = async.void(function(_opts)
  local opts = _opts or {}
  opts.behavior = "sticky"
  providers.load(opts)
end)

local hover_cursor = async.void(function(_opts)
  local opts = _opts or {}
  opts.behavior = "cursor"
  opts.silent = true
  providers.load(opts)
end)

local hover_once = async.void(function(_opts)
  local opts = _opts or {}
  opts.behavior = "once"
  providers.load(opts)
end)

-- open up a select box with all available providers
local hover_select = async.void(function(_opts)
  local enabled_providers = {}
  for _, provider in ipairs(providers.providers) do
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

return {
  hover = hover,
  hover_cursor = hover_cursor,
  hover_sticky = hover_sticky,
  hover_once = hover_once,
  hover_select = hover_select,
}
