local vim = vim
local fn = vim.fn
local log = require("utils.options.log")
local typing = require("utils.options.typing")
local display_print = require('utils.options.display.print')
local display_notify = require('utils.options.display.notify')

local M = {}

local s_config = { notify = true }

local state = {
  registered_options = {},
  current_options = {},
  callbacks = {},
  variable_sync_initialized = false,
  buffer_sync_autocmd_initialized = false
}

-- Return the first index with the given value (or nil if not found).
local function init_variable_sync()
  assert(state.buffer_sync_autocmd_initialized == false)

  vim.cmd([[
  augroup options_nvim_var_watch
    autocmd!
    autocmd CmdlineEnter * if v:event.cmdtype == ":" | call luaeval('require"utils.options".check_var_change()') | endif
  augroup END
  ]])
end

local function is_option_registered(name)
  return state.registered_options[name] ~= nil
end

local function get_option_info(name)
  if is_option_registered(name) == false then
    log.error("options", "This option is not registered: " .. name)
    return nil
  end

  return state.registered_options[name]
end

local function get_buffer_option(name, bufnr)
  assert(bufnr ~= nil, "bufnr has to be valid.")

  local current_option = state.current_options[name]
  if current_option == nil then
    return nil
  end

  local buffers = current_option.buffers
  if buffers == nil then
    return nil
  end

  for _, option in ipairs(buffers) do
    if option.bufnr == bufnr then
      return option
    end
  end

  return nil
end

local output_options = function(bufnr)
  if s_config.notify == true then
    return display_notify.notify_options(bufnr, state, get_option_info, get_buffer_option)
  else
    display_print.echo_options(bufnr, state)
  end
end

local function set_target_variable(variable, value, bufnr)
  if bufnr == nil then
    vim.g[variable] = value
  else
    vim.api.nvim_buf_set_var(bufnr, variable, value)
  end
end

local function is_target_variable_set(variable, bufnr)
  if bufnr == nil then
    return vim.g[variable] ~= nil
  end

  local exists, _ = pcall(vim.api.nvim_buf_get_var, bufnr, variable)
  return exists
end

local function setup_buffer_var_sync()
  assert(state.variable_sync_initialized == false)

  vim.cmd([[
  augroup options_nvim_buffer_var_watch
    autocmd!
    autocmd BufNew * lua require"utils.options".sync_buffer_vars(vim.api.nvim_get_current_buf())
  augroup END
  ]])
end

local function get_target_variable_value(variable, bufnr)
  if bufnr ~= nil then
    return vim.g[variable] ~= nil
  end

  local exists, value = pcall(vim.api.nvim_buf_get_var, bufnr, variable)
  assert(exists, "Variable doesn't exist: " .. variable)
  return value
end

local function execute_callbacks(option_name)
  if state.callbacks[option_name] == nil then
    return
  end

  for _, func in ipairs(state.callbacks[option_name]) do
    func()
  end
end

local function split_option_str(option_str)
  local cmps = vim.split(option_str, "=")
  local name = cmps[1]
  local value = nil
  if #cmps == 2 then
    value = cmps[2]
  end

  return { name = name, value = value }
end

local function convert_value(value, option_info)
  local converted_value = nil
  if option_info.type_info == "boolean" then
    converted_value = typing.toboolean(value)
  elseif option_info.type_info == "number" then
    converted_value = tonumber(value)
  elseif option_info.type_info == "string" then
    converted_value = tostring(value)
  elseif option_info.type_info == "table" then
    converted_value = vim.split(tostring(value), ",")
  elseif option_info.parser ~= nil then
    converted_value = option_info.parser(converted_value)
  end

  return converted_value
end

local function pre_process_set_option(name, value, bufnr)
  name = name or ""
  if name == "" then
    -- TODO: only show option_str output
    output_options(bufnr)
    return true
  end

  if is_option_registered(name) == false then
    vim.notify("This option is not registered: " .. name, "error")
    return true
  end

  if value == nil then
    display_print.echo_option(name, bufnr, M.get_option_value, get_option_info)
    return true
  end

  local option_info = get_option_info(name)
  if option_info == nil then
    log.error("cannot find option info for key: " .. name)
    return
  end
  if option_info.buffer_local == true and bufnr == nil then
    log.warning(
      "options",
      "This is only a local option. Use `:Setlocal " .. name .. "` instead."
    )
    return true
  end

  if option_info.buffer_local ~= true and bufnr ~= nil then
    log.warning("options", "This is only a global option. Use `:Set " .. name .. "` instead.")
    return true
  end

  return false
end

local function set_option(name, value, bufnr)
  if bufnr == 0 then
    bufnr = vim.api.nvim_get_current_buf()
  end

  if pre_process_set_option(name, value, bufnr) then
    return
  end

  local option_info = get_option_info(name)
  if option_info == nil then
    log.error("cannot find option info for key: " .. name)
    return
  end

  local converted_value = convert_value(value, option_info)
  if converted_value == nil then
    log.error("options", "Cannot convert `" .. value .. "` to " .. option_info.type_info .. ".")
    return
  end

  local current_option = state.current_options[name]
  if current_option == nil then
    if bufnr ~= nil then
      state.current_options[name] = {
        value = nil,
        buffers = { { bufnr = bufnr, value = converted_value } },
      }
    else
      state.current_options[name] = { value = converted_value, buffers = {} }
    end
    current_option = state.current_options[name]
    execute_callbacks(name)
  elseif bufnr == nil and current_option.value ~= converted_value then
    current_option.value = converted_value
    execute_callbacks(name)
  elseif bufnr ~= nil then
    local buffer_option = get_buffer_option(name, bufnr)
    if buffer_option ~= nil then
      if buffer_option.value == converted_value then
        return
      end
      buffer_option.value = converted_value
    elseif buffer_option == nil then
      table.insert(
        state.current_options[name].buffers,
        { bufnr = bufnr, value = converted_value }
      )
    end
    execute_callbacks(name)
  end

  if option_info.target_variable ~= nil then
    set_target_variable(option_info.target_variable, converted_value, bufnr)
  end
end

local function check_for_global_var_change()
  local cmd_line = fn.getreg(":")
  if string.match(cmd_line, "let g:") == nil then
    return
  end

  local var_name = string.match(cmd_line, "g:[^%s.=]+")
  var_name = string.gsub(var_name, "g:", "")
  for name, info in pairs(state.registered_options) do
    if info.target_variable == var_name then
      set_option(name, get_target_variable_value(var_name))
      break
    end
  end
end

local function check_for_buffer_var_change()
  local cmd_line = fn.getreg(":")
  if string.match(cmd_line, "let b:") == nil then
    return
  end

  local var_name = string.match(cmd_line, "b:[^%s.=]+")
  var_name = string.gsub(var_name, "b:", "")
  local bufnr = vim.api.nvim_get_current_buf()
  for name, info in pairs(state.registered_options) do
    if info.target_variable == var_name then
      set_option(name, get_target_variable_value(var_name), bufnr)
      break
    end
  end
end

function M.get_option_value(name, bufnr)
  if is_option_registered(name) == false then
    log.error("options", "This option is not registered: " .. name)
    return nil
  end

  local buffer_option = nil
  if bufnr ~= nil then
    buffer_option = get_buffer_option(name, bufnr)
  end

  if buffer_option ~= nil then
    return buffer_option.value
  elseif state.current_options[name] ~= nil and state.current_options[name].value ~= nil then
    return state.current_options[name].value
  end

  return state.registered_options[name].default
end

function M.register_option(opts)
  if is_option_registered(opts.name) then
    log.error("options", "This option is already registered: " .. opts.name)
    return
  end

  assert(not (opts.type_info == nil or opts.type_info == ""), "type_info is a required field.")

  assert(
    type(opts.default) == opts.type_info,
    "Type of the default value does not match type_info: "
    .. type(opts.default)
    .. " != "
    .. opts.type_info
  )

  opts.buffer_local = opts.buffer_local or false
  opts.global = opts.global or not opts.buffer_local
  opts.source = opts.source or ""

  if opts.buffer_local
    and opts.target_variable ~= nil
    and not state.variable_sync_initialized
  then
    setup_buffer_var_sync()
    state.variable_sync_initialized = true
  end

  state.registered_options[opts.name] = {
    default = opts.default,
    type_info = opts.type_info,
    source = opts.source,
    buffer_local = opts.buffer_local,
    global = opts.global,
    parser = opts.parser,
    target_variable = opts.target_variable,
    changed = 0,
    last_changed = nil
  }

  if opts.target_variable ~= nil and state.buffer_sync_autocmd_initialized == false then
    init_variable_sync()
  end

  if opts.target_variable ~= nil
    and opts.global
    and is_target_variable_set(opts.target_variable)
  then
    set_option(opts.name, get_target_variable_value(opts.target_variable))
  elseif opts.target_variable ~= nil
    and opts.global
    and not is_target_variable_set(opts.target_variable)
  then
    set_target_variable(opts.target_variable, opts.default)
  end
end

function M.set(name, value)
  set_option(name, value)
end

function M.set_local(name, value, bufnr)
  if bufnr == nil then
    log.error("options", "bufnr is required for local options.")
  end

  set_option(name, value, bufnr)
end

function M.list_options(arg_lead, buffer_local)
  local options = {}

  for key, info in pairs(state.registered_options) do
    arg_lead = arg_lead or "."
    if buffer_local == true and info.buffer_local == true then
      if string.match(key, "^" .. arg_lead) then
        table.insert(options, key)
      end
    elseif buffer_local ~= true and info.global == true then
      if string.match(key, "^" .. arg_lead) then
        table.insert(options, key)
      end
    end
  end
  return options
end

function M.enable_nvim_colorizer(bufnr)
  require("colorizer").setup()
  vim.cmd("augroup nvim_colorizer_buf_" .. bufnr)
  vim.cmd([[ ColorizerAttachToBuffer | au! ]])
  vim.cmd("autocmd FileType <buffer=" .. bufnr .. "> lua require'colorizer'.setup()")
  vim.cmd([[
    augroup END
    command! -buffer DisableNvimColorizer :lua require"vimrc".disable_nvim_colorizer(vim.api.nvim_get_current_buf())
  ]])
end

function M.disable_nvim_colorizer(bufnr)
  vim.cmd("augroup nvim_colorizer_buf_" .. bufnr)
  vim.cmd([[ 
    au!  | augroup END
    delcommand DisableNvimColorizer
    ColorizerDetachFromBuffer
  ]])
end

function M.register_callback(name, func)
  if is_option_registered(name) == false then
    log.error("options", "Cannot register callback for unregistered option: " .. name)
    return
  end

  if state.callbacks[name] == nil then
    state.callbacks[name] = { func }
  else
    table.insert(state.callbacks[name], func)
  end
end

function M.set_modeline(bufnr)
  local last_linenr = fn.line("$")
  if last_linenr == 1 then
    return
  end

  local last_line = vim.api.nvim_buf_get_lines(bufnr, last_linenr - 1, last_linenr, true)[1]

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
    M.run_set_cmd(opt, bufnr)
  end
end

function M.check_var_change()
  check_for_global_var_change()
  check_for_buffer_var_change()
end

function M.sync_buffer_vars(bufnr)
  for key, info in pairs(state.registered_options) do
    if info.buffer_local == true and info.target_variable ~= nil then
      if is_target_variable_set(key, bufnr) then
        set_option(key, get_target_variable_value(info.target_variable, bufnr), bufnr)
      else
        set_target_variable(info.target_variable, M.get_option_value(key, bufnr), bufnr)
      end
    end
  end
end

function M.run_set_cmd(option_str, bufnr)
  if option_str == nil or option_str == '' then
    output_options(bufnr)
  elseif not string.match(option_str, '=') then
    -- TODO: only show option_str output
    output_options(bufnr)
    -- display_print.echo_option(bufnr, option_str)
  else
    local opt = split_option_str(option_str)
    set_option(opt.name, opt.value, bufnr)
  end
end

vim.cmd([[
"  autocmd BufReadPost modeline_test.yaml :lua require"utils.options".set_modeline(vim.api.nvim_get_current_buf())
  command! -nargs=* -complete=customlist,options#complete Set :lua require'utils.options'.run_set_cmd(<q-args>, nil)
  command! -nargs=* -complete=customlist,options#complete_buf_local Setlocal :lua require'utils.options'.run_set_cmd(<q-args>, vim.api.nvim_get_current_buf())
]])

function M.get_state()
  return state
end

return M
