local vim = vim
local fn = vim.fn
local log = require("options.log")
local state = require('options.state')
-- local output = require('options.output')
local config = require('options.config')
local print_options = require('options.display.print')
local notify_options = require('options.display.notify')
local list_options = require('options.display.list')

local function split_option_str(option_str)
  local cmps = vim.split(option_str, "=")
  local name = cmps[1]
  local value = nil
  if #cmps == 2 then
    value = cmps[2]
  end
  return { name = name, value = value }
end

local function set_cmd(option_str, bufnr)
  local arg_lead = option_str or ''
  bufnr = bufnr or 0
  if not string.match(arg_lead, '=') then
    local _config = config
    _config.arg_lead = arg_lead
    notify_options(bufnr, config)
  else
    local opt = split_option_str(arg_lead)
    state._set_option(opt.name, opt.value, bufnr)
  end
end

local function set_modeline(bufnr)
  local last_linenr = fn.line("$")
  if last_linenr == 1 then
    return
  end

  local last_line = vim.api.nvim_buf_get_lines(
    bufnr,
    last_linenr - 1,
    last_linenr,
    true
  )[1]

  if string.match(last_line, "nvim-options:") == nil then
    return
  end

  local start_index = string.find(last_line, "Setlocal")
  if start_index == nil then
    log.error("options", "Only Setlocal is supported.")
    return
  end

  local modeline = string.sub(last_line, start_index, #last_line)
  modeline = vim.split(string.gsub(modeline, "Setlocal ", ""), " ")
  for _, opt in ipairs(modeline) do
    set_option(bufnr, opt)
  end
end

vim.cmd([[
"  autocmd BufReadPost modeline_test.yaml :lua require"utils.options".set_modeline(vim.api.nvim_get_current_buf())
  command! -nargs=* -complete=customlist,options#complete Set :lua require'options'.set_cmd(<q-args>, nil)
  command! -nargs=* -complete=customlist,options#complete_buf_local Setlocal :lua require'options'.set_cmd(<q-args>, vim.api.nvim_get_current_buf())
]])

local set_option = function(...)
  -- set local or global option based on if bufnr provided
  -- Set            | Set indent             | Set indent=2
  -- Setlocal       | Setlocal indent        | Setlocal indent=2
  -- set()          | set('indent')          | set('indent', 2)
  --                | set(0, 'indent')       | set(0, 'indent', 2)
  -- set_local()    | set_local('indent')    | set_local('indent', 2)
  --                | set_local(0, 'indent') | set_local(0, 'indent', 2)
  local args = { ... }
  if type(args[1]) == 'number' then
    state._set_option(args[2], args[3], args[1])
  else
    state._set_option(args[1], args[2])
  end
end

local set_option_local = function(...)
  local args = { ... }
  if type(args[1]) ~= 'number' then
    table.insert(args, 1, 0)
  end
  set_option(unpack(args))
end

local get_option = function(...)
  -- get local or global option based on if bufnr provided
  -- get()          | get('indent')
  -- get_local()    | get_local('indent')
  -- get_local()    | get_local(0, 'indent')
  --                | get(0, 'indent')
  local args = { ... }
  if type(args[1]) == 'number' then
    return state._get_option(args[2], args[1])
  else
    return state._get_option(args[1])
  end
end

local get_option_local = function(...)
  local args = { ... }
  if type(args[1]) ~= 'number' then
    table.insert(args, 1, 0)
  end
  return get_option(unpack(args))
end


local display_options = function(...)
  -- display option values (all if no bufnr provided)
  -- display_options()
  -- display_options(0)
  -- display_options(0, config)
  -- display_options(config)
  local args = { ... }
  local bufnr = 0
  local _config = config

  if type(args[1]) == 'number' then
    bufnr = args[1]
  elseif type(args[1]) == 'table' then
    _config = args[1]
  elseif type(args[2]) == 'table' then
    _config = args[2]
  end

  if (_config.output == 'print') then
    print_options(_config, bufnr)
  else
    notify_options(_config, bufnr)
  end
end

return {
  set_modeline      = set_modeline,
  set_cmd           = set_cmd,
  set               = set_option,
  get               = get_option,
  set_local         = set_option_local,
  get_local         = get_option_local,
  display           = display_options,
  list              = list_options,
  register_callback = state._register_callback,
  register_option   = state._register_option,
  get_state         = state._get_state,
}
