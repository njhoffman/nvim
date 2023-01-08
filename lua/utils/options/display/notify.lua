local log = require("utils.options.log")

local function index_of(array, value)
  for i, v in ipairs(array) do
    if v == value then
      return i
    end
  end
  return nil
end

local function serialize_options(bufnr, state, get_option_info, get_buffer_option)
  local processed = {}
  local buffer_options = {}
  local global_options = {}

  for key, info in pairs(state.current_options) do
    local value = nil
    local buffer_option = nil
    local option_info = get_option_info(key)
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
        local option_info = get_option_info(key)
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

local function notify_options(bufnr, state, get_option_info, get_buffer_option)
  local serialized = serialize_options(bufnr, state, get_option_info, get_buffer_option)
  local notify_msg = ""
  if #serialized.global > 0 then
    notify_msg = notify_msg .. "[global-opt]"
    for _, line in pairs(serialized.global) do
      if string.find(line, "= [source", 1, true) == nil then
        notify_msg = notify_msg .. "\n" .. line
      else
        notify_msg = notify_msg .. "\n" .. line
      end
    end
  end

  if #serialized.buffer > 0 then
    notify_msg = notify_msg .. "[buffer-opt]\n"
    for _, line in pairs(serialized.buffer) do
      if string.find(line, "= [source", 1, true) == nil then
        notify_msg = notify_msg .. "\n" .. line
      else
        notify_msg = notify_msg .. "\n" .. line
      end
    end
  end
  vim.notify(notify_msg)
end

return {
  notify_options = notify_options,
}
