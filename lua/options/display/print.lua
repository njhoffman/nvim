local log = require("options.log")

local function index_of(array, value)
  for i, v in ipairs(array) do
    if v == value then
      return i
    end
  end
  return nil
end

local function serialize_options(bufnr, state)
  local processed = {}
  local buffer_options = {}
  local global_options = {}

  for key, info in pairs(state.current_options) do
    local value = nil
    local buffer_option = nil
    local option_info = state.get_option_info(key)
    if option_info == nil then
      log.error("cannot find option info for key: " .. key)
      return
    end

    if bufnr ~= nil and option_info.buffer_local then
      buffer_option = get_buffer_option(key, bufnr)
    end

    if buffer_option ~= nil then
      value = buffer_option.value
    elseif bufnr == nil and option_info.global == true then
      value = info.value
    end

    if value ~= nil then
      local val_str = ""
      if type(value) == "table" then
        val_str = table.concat(value, ",")
      else
        val_str = tostring(value)
      end

      local message = string.rep(" ", 2)
        .. key .. "=" .. val_str .. " "
        .. "[source: " .. option_info.source .. "]"

      table.insert(processed, key)
      if option_info.buffer_local then
        table.insert(buffer_options, message)
      else
        table.insert(global_options, message)
      end
    end
  end

  for key, info in pairs(state.registered_options) do
    local can_echo = false

    if index_of(processed, key) == nil then
      if bufnr ~= nil and info.buffer_local == true then
        can_echo = true
      elseif bufnr == nil and info.global == true then
        can_echo = true
      end

      if can_echo then
        local option_info = state.get_option_info(key)
        if option_info == nil then
          log.error("cannot find option info for key: " .. key)
          return
        end

        local val_str = ""
        if type(info.default) == "table" then
          val_str = table.concat(info.default, ",")
        else
          val_str = tostring(info.default)
        end

        local message = string.rep(" ", 2)
          .. key .. "=" .. val_str .. " "
          .. "[source: " .. option_info.source .. "]"

        table.insert(processed, key)
        if option_info.buffer_local then
          table.insert(buffer_options, message)
        else
          table.insert(global_options, message)
        end
      end
    end
  end
  return { buffer = buffer_options, global = global_options }
end

local notify_option = function(name, bufnr)
  local option_info = state.get_option_info(name)
  local value = state.get_option_value(name, bufnr)
  if option_info == nil then
    log.error("cannot find option info for key: " .. name)
    return
  end
  if type(value) == "table" then
    value = table.concat(value, ",")
  end
  if option_info.buffer_local == true then
    log.info(option_info.source .. "-buflocal", name .. "=" .. tostring(value))
  else
    log.info(option_info.source, name .. "=" .. tostring(value))
  end
end

local function print_options(bufnr, state)
  local serialized = serialize_options(bufnr, state)
  if #serialized.global > 0 then
    log.log("options", "global-options")
    for _, line in pairs(serialized.global) do
      if string.find(line, "= [source", 1, true) == nil then
        log.info(nil, line)
      else
        log.debug(nil, line)
      end
    end
  end

  if #serialized.buffer > 0 then
    log.log("options", "buffer-options")
    for _, line in pairs(serialized.buffer) do
      if string.find(line, "= [source", 1, true) ~= nil then
        log.debug(nil, line)
      else
        log.info(nil, line)
      end
    end
  end
end

return print_options
