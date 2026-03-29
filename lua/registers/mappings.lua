local map = require("mapper").map
local state = require("registers.state")
local config = require("registers.config")
local ui = require("registers.ui")

---@private
---Whether a key should be bound.
---@param option string Which item from bind_keys should be checked
---@return boolean Whether the key should be bound
---@nodiscard
local _key_should_be_bound = function(option)
  local options = config.get()
  if type(options.bind_keys) == "boolean" then
    return options.bind_keys --[[@as boolean]]
  else
    return options.bind_keys[option]
  end
end

---@private
---Set the key bindings for the window.
local _set_bindings = function()
  local options = config.get()

  -- Helper function for setting the keymap for all buffer modes
  local set_keymap_all_modes = function(key, callback)
    local map_options = {
      nowait = true,
      buffer = state._buffer,
    }

    map("n", key, callback, map_options)
    map("i", key, callback, map_options)
    map("x", key, callback, map_options)
  end

  -- Map all register keys
  if _key_should_be_bound("registers") then
    for key, callback in pairs(state._mappings) do
      set_keymap_all_modes(key, callback)
    end
  end

  -- TODO: fix this in configuration
  -- Map the keys for moving up and down
  if _key_should_be_bound("k") then
    set_keymap_all_modes("k", options.bind_keys.ctrl_k)
  end
  if _key_should_be_bound("j") then
    set_keymap_all_modes("j", options.bind_keys.ctrl_j)
  end
  if _key_should_be_bound("ctrl_p") then
    set_keymap_all_modes("<c-p>", options.bind_keys.ctrl_p)
  end
  if _key_should_be_bound("ctrl_n") then
    set_keymap_all_modes("<c-n>", options.bind_keys.ctrl_n)
  end
end

local _bind_global_key = function(index, key, mode)
  if _key_should_be_bound(index) then
    map(mode, key, function()
      -- Don't open the registers window in a telescope prompt or in a non-modifiable buffer
      if
        not vim.bo.modifiable
        or vim.bo.filetype == "TelescopePrompt"
        or vim.bo.filetype == "DressingInput"
      then
        return vim.api.nvim_replace_termcodes(key, true, true, true)
      else
        -- Call the callback function passed to the options
        return options.bind_keys[index]()
      end
    end, { expr = true })
  end
end

---@private
---Create a map for global key binding with a callback function.
---@param index string Key of the function in the `bind_keys` table.
---@param key string Which key to press.
---@param mode register_mode Which mode to register the key.
local _bind_global_key = function(index, key, mode)
  local options = config.get()

  if _key_should_be_bound(index) then
    map(mode, key, function()
      -- Don't open the registers window in a telescope prompt or in a non-modifiable buffer
      if
        not vim.bo.modifiable
        or vim.bo.filetype == "TelescopePrompt"
        or vim.bo.filetype == "DressingInput"
      then
        return vim.api.nvim_replace_termcodes(key, true, true, true)
      else
        -- Call the callback function passed to the options
        return options.bind_keys[index]()
      end
    end, { expr = true })
  end
end

--stylua: ignore
---@private
---All available registers.
local _all_registers = {
  '*', '+', '"', '-', '/', '_', '=', '#', '%', '.',
  '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
  'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', -- 'j', 'k',
  'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't',
  'u', 'v', 'w', 'x', 'y', 'z', ':'
}

---@private
---Pre-fill the key mappings.
local _fill_mappings = function()
  local options = config.get()
  --  Don't map the keys when `false` is passed to bind_keys
  if not options.bind_keys then
    return
  end

  -- Add the other user-defined keys to the map
  local reserved_keys = {
    j = true,
    k = true,
    normal = true,
    visual = true,
    insert = true,
    registers = true,
    return_key = true,
    escape = true,
    ctrl_n = true,
    ctrl_p = true,
    ctrl_j = true,
    ctrl_k = true,
    delete = true,
    backspace = true,
  }

  -- Create the mappings to call the function specified in the options
  state._mappings = {}
  for key, func in pairs(options.bind_keys) do
    -- Don't bind the reserved keys, that doesn't make any sense
    if not reserved_keys[key] then
      state._mappings[key] = function()
        func(nil, state._mode)
      end
    end
  end

  -- Create mappings for the register keys
  for _, register in ipairs(_all_registers) do
    -- Pressing the character of a register will also apply it
    state._mappings[register] = function()
      -- Always move the cursor to the selected line in case there's a delay, unfortunately there's no way to know if that's the case at this time so it's quite inefficient when there's no delay
      ui._move_cursor_to_register(register)

      -- Apply the mapping
      options.bind_keys.registers(register, state._mode)
    end

    -- Also map uppercase registers if applicable
    if register:upper() ~= register then
      state._mappings[register:upper()] = function()
        -- Always move the cursor to the selected line in case there's a delay, unfortunately there's no way to know if that's the case at this time so it's quite inefficient when there's no delay
        ui._move_cursor_to_register(register)

        -- Apply the mapping
        options.bind_keys.registers(register:upper(), state._mode)
      end
    end
  end
end

local setup = function()
  -- Pre-fill the key mappings
  _fill_mappings()
  -- Bind the keys if applicable
  _bind_global_key("normal", '"', "n")
  _bind_global_key("visual", '"', "x")
  _bind_global_key("insert", "<C-R>", "i")
end

return {
  _set_bindings = _set_bindings,
  setup = setup,
}
