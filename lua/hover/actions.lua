local vim = vim
local api = vim.api
local npcall = vim.F.npcall
local async = require("hover.async")
local ui = require("hover.ui")
local log = require("hover.utils").logger()
local state = require("hover.state")

local providers = require("hover.providers").providers
local is_enabled = require("hover.providers").is_enabled
local get_config = require("hover.config").get

local M = {}

local initialised = false

local function find_window_by_var(name, value)
  for _, win in ipairs(api.nvim_list_wins()) do
    if npcall(api.nvim_win_get_var, win, name) == value then
      return win
    end
  end
end

local function focus_or_close_hover()
  local bufnr = api.nvim_get_current_buf()
  local winnr = api.nvim_get_current_win()

  -- Go back to previous window if we are in a focusable one
  if npcall(api.nvim_win_get_var, winnr, "hover") then
    api.nvim_command("wincmd p")
    return true
  end
  local win = find_window_by_var("hover", bufnr)
  if win and api.nvim_win_is_valid(win) and vim.fn.pumvisible() == 0 then
    -- focus and return the existing buf, win
    api.nvim_set_current_win(win)
    api.nvim_command("stopinsert")
    return true
  end
  return false
end

-- Must be called in async context
local function run_provider(provider, _opts)
  local opts = _opts or {}

  local config = get_config()
  if opts.focusable ~= false and opts.focus ~= false then
    if focus_or_close_hover() then
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
  local config = get_config()
  local opts = vim.tbl_deep_extend("keep", _opts or {}, config)
  if initialised then
    return opts
  end
  if config and type(config.init) == "function" then
    config.init()
  end
  initialised = true
  return opts
end

local function load_popup(_opts)
  local opts = init(_opts)
  ---@diagnostic disable-next-line: missing-parameter
  local start_time = vim.fn.reltime()
  local finished = function(provider)
    local load_time = vim.fn.reltimestr(vim.fn.reltime(start_time))
    state.provider = provider.name
    state.time = load_time
    return log.info(provider.name .. ": " .. load_time)
  end
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
    api.nvim_echo({ { "hover.nvim: could not find any hover providers", "WarningMsg" } }, false, {})
  end
end

M.hover = async.void(function(_opts)
  local opts = _opts or {}
  load_popup(opts)
end)

M.hover_sticky = async.void(function(_opts)
  local opts = _opts or {}
  opts.behavior = "sticky"
  vim.dbglog(opts)
  load_popup(opts)
end)

M.hover_cursor = async.void(function(_opts)
  local opts = _opts or {}
  opts.behavior = "cursor"
  opts.silent = true
  load_popup(opts)
end)

M.hover_once = async.void(function(_opts)
  local opts = _opts or {}
  opts.behavior = "once"
  load_popup(opts)
end)

-- open up a select box with all available providers
M.hover_select = async.void(function(_opts)
  local opts = init(_opts)
  local enabled_providers = {}
  for _, provider in ipairs(providers) do
    if is_enabled(provider) then
      table.insert(enabled_providers, provider)
    end
  end

  vim.ui.select(enabled_providers, {
    prompt = "Select hover:",
    format_item = function(provider)
      return provider.desc
    end,
  }, function(provider)
    if provider then
      async.void(run_provider)(provider)
      local load_time = vim.fn.reltimestr(vim.fn.reltime(start_time))
      state.provider = provider.name
      state.time = load_time
      return log.info(provider.name .. ": " .. load_time)
    end
  end)
end)

return M
