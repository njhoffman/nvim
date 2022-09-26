local util = require("vim.lsp.util")
local vim = vim
local api = vim.api
local npcall = vim.F.npcall

local async = require("hover.async")

local providers = require("hover.providers").providers
local get_config = require("hover.config").get

local M = {}

local initialised = false

local function is_enabled(provider)
  if type(provider.enabled == "function") then
    return provider.enabled()
  else
    return provider.enabled
  end
end

local function add_title(winnr, active_provider_id)
  local title = {}

  for _, p in ipairs(providers) do
    if is_enabled(p) then
      local hl = p.id == active_provider_id and "TabLineSel" or "TabLineFill"
      title[#title + 1] = string.format("%%#%s# %s ", hl, p.name)
      title[#title + 1] = "%#Normal# "
    end
  end
  local title_str = table.concat(title, "")
  if string.len(vim.trim(title_str)) > 0 then
    local win_height = vim.api.nvim_win_get_height(winnr)
    vim.api.nvim_win_set_height(winnr, win_height + 1)
  end
  vim.wo[winnr].winbar = title_str
end

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

local function show_hover(provider_id, config, result, opts)
  local _, winnr = util.open_floating_preview(result.lines, result.filetype, opts)
  vim.dbglog("CONFIG", config)
  if config.title then
    add_title(winnr, provider_id)
  end
end

-- Must be called in async context
local function run_provider(provider)
  vim.notify("hover.nvim: Running provider: " .. provider.name, "debug")
  local config = get_config()
  local opts = vim.deepcopy(config.preview_opts)
  opts.focus_id = "hover"

  if opts.focusable ~= false and opts.focus ~= false then
    if focus_or_close_hover() then
      return true
    end
  end

  local result = provider.execute()
  if result then
    async.scheduler()
    show_hover(provider.id, config, result, opts)
    return true
  end

  return false
end

local function init()
  if initialised then
    return
  end
  initialised = true

  local config = get_config()
  if config and type(config.init) == "function" then
    config.init()
  end
end

M.hover = async.void(function()
  init()

  for _, provider in ipairs(providers) do
    async.scheduler()
    if is_enabled(provider) and run_provider(provider) then
      return
    end
  end
  api.nvim_echo({ { "hover.nvim: could not find any hover providers", "WarningMsg" } }, false, {})
end)

M.hover_select = function()
  init()

  -- local enabled_providers = {}
  -- for _, provider in ipairs(providers) do
  --   if is_enabled(provider) then
  --     table.insert(enabled_providers, provider)
  --     return
  --   end
  -- end
  local enabled_providers = providers

  vim.ui.select(enabled_providers, {
    prompt = "Select hover:",
    format_item = function(provider)
      return provider.name
    end,
  }, function(provider)
    if provider then
      async.void(run_provider)(provider)
    end
  end)
end

return M
