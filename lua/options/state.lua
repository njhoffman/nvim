local log = require("options.log")
local typing = require("options.typing")

local state = {
  registered_options = {},
  current_options = {},
  callbacks = {},
  variable_sync_initialized = false,
  buffer_sync_autocmd_initialized = false
}

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

local function execute_callbacks(option_name)
  if state.callbacks[option_name] == nil then return end
  for _, func in ipairs(state.callbacks[option_name]) do
    func()
  end
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
  if bufnr == 0 then bufnr = vim.api.nvim_get_current_buf() end
  local current_option = state.current_options[name]
  if current_option == nil then return nil end

  local buffers = current_option.buffers
  if buffers == nil then return nil end

  for _, option in ipairs(buffers) do
    if option.bufnr == bufnr then
      return option
    end
  end

  return nil
end

local function get_option_value(name, bufnr)
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
  elseif state.current_options[name] ~= nil and
    state.current_options[name].value ~= nil then
    return state.current_options[name].value
  end

  return state.registered_options[name].default
end

local function is_target_variable_set(variable, bufnr)
  if bufnr == nil then
    return vim.g[variable] ~= nil
  end
  local exists, _ = pcall(vim.api.nvim_buf_get_var, bufnr, variable)
  return exists
end

local function validate_set_option(name, value, bufnr)
  name = name or ""
  if is_option_registered(name) == false then
    log.error("This option is not registered: " .. name, "error")
    return true
  end

  if value == nil then return true end

  local option_info = get_option_info(name)
  if option_info == nil then
    log.error("cannot find option info for key: " .. name)
    return true
  end

  if option_info.buffer_local == true and bufnr == nil then
    log.warning(
      "options",
      "This is only a local option. Use `:Setlocal " .. name .. "` instead."
    )
    return true
  end

  if option_info.buffer_local ~= true and bufnr ~= nil then
    log.warning(
      "options",
      "This is only a global option. Use `:Set " .. name .. "` instead."
    )
    return true
  end

  return false
end

local function set_target_variable(variable, value, bufnr)
  if bufnr == nil then
    vim.g[variable] = value
  else
    vim.api.nvim_buf_set_var(bufnr, variable, value)
  end
end

local function set_option(name, value, bufnr)
  if bufnr == 0 then
    bufnr = vim.api.nvim_get_current_buf()
  end

  if validate_set_option(name, value, bufnr) then
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
      state.current_options[name] = { value = nil, buffers = { {
        bufnr = bufnr, value = converted_value
      } } }
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
      if buffer_option.value == converted_value then return end
      buffer_option.value = converted_value
    elseif buffer_option == nil then
      table.insert(state.current_options[name].buffers,
        { bufnr = bufnr, value = converted_value }
      )
    end
    execute_callbacks(name)
  end

  if option_info.target_variable ~= nil then
    set_target_variable(option_info.target_variable, converted_value, bufnr)
  end
end

local function get_target_variable_value(variable, bufnr)
  if bufnr ~= nil then
    return vim.g[variable] ~= nil
  end

  local exists, value = pcall(vim.api.nvim_buf_get_var, bufnr, variable)
  assert(exists, "Variable doesn't exist: " .. variable)
  return value
end

local function _check_for_global_var_change()
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

local function _check_for_buffer_var_change()
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

local function register_callback(name, func)
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

-- Return the first index with the given value (or nil if not found).
local function init_variable_sync()
  assert(state.buffer_sync_autocmd_initialized == false)
  vim.cmd([[
  augroup options_nvim_var_watch
    autocmd!
    autocmd CmdlineEnter * if v:event.cmdtype == ":" | call luaeval('require"options.state".check_var_change()') | endif
  augroup END
  ]])
end

local function setup_buffer_var_sync()
  assert(state.variable_sync_initialized == false)
  vim.cmd([[
  augroup options_nvim_buffer_var_watch
    autocmd!
    autocmd BufNew * lua require"options.state".sync_buffer_vars(vim.api.nvim_get_current_buf())
  augroup END
  ]])
end

local function register_option(opts)
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
    default         = opts.default,
    type_info       = opts.type_info,
    source          = opts.source,
    buffer_local    = opts.buffer_local,
    global          = opts.global,
    parser          = opts.parser,
    target_variable = opts.target_variable,
    changed         = 0,
    last_changed    = nil
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

local function check_var_change()
  _check_for_global_var_change()
  _check_for_buffer_var_change()
end

local function sync_buffer_vars(bufnr)
  for key, info in pairs(state.registered_options) do
    if info.buffer_local == true and info.target_variable ~= nil then
      if is_target_variable_set(key, bufnr) then
        set_option(key, get_target_variable_value(info.target_variable, bufnr), bufnr)
      else
        set_target_variable(info.target_variable, get_option_value(key, bufnr), bufnr)
      end
    end
  end
end

local function get_state()
  return state
end

return {
  check_var_change   = check_var_change,
  sync_buffer_vars   = sync_buffer_vars,
  _register_callback = register_callback,
  _register_option   = register_option,
  _set_option        = set_option,
  _get_option        = get_option_value,
  _get_option_info   = get_option_info,
  _get_state         = get_state,
}
