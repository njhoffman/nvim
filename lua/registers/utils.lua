local config = require('registers.config')
local state = require('registers.state')

---@private
---Fill the arrays with the register values.
local _read_registers = function()
  state._register_values = {}
  state._empty_registers = {}

  local options = config.get()

  -- Read all register information
  local show = options.show
  for i = 1, #show do
    -- Get the register character from the array
    local register = show:sub(i, i)

    -- Get the register information
    local register_info = vim.fn.getreginfo(register)

    -- Ignore empty registers
    if
      register_info
      and register_info.regcontents
      and type(register_info.regcontents) == 'table'
      and register_info.regcontents[1]
    then
      register_info.register = register

      -- The register contents as a single line
      local line = table.concat(register_info.regcontents, '\n')
      local hide = false
      -- Check whether the register should be hidden due to being empty
      if line and options.hide_only_whitespace then
        hide = #(line:match('^%s*(.-)%s*$')) == 0
      end

      if hide then
        -- Place it in the empty registers
        state._empty_registers[#state._empty_registers + 1] = register
      elseif line and type(line) == 'string' then
        -- Trim the whitespace if applicable
        if options.trim_whitespace then
          line = line:match('^%s*(.-)%s*$')
        end

        line = line
          -- Replace newline characters (win)
          :gsub('\r\n', options.symbols.newline)
          -- Replace newline characters (unix)
          :gsub('\n', options.symbols.newline)
          -- Replace newline characters (mac)
          :gsub('\r', options.symbols.newline)
          -- Replace tab characters
          :gsub('\t', options.symbols.tab)
          -- Replace space characters
          :gsub(' ', options.symbols.space)

        register_info.line = line
        -- Convert the sign types
        if options.show_register_types then
          if register_info.regtype == 'v' then
            register_info.type_symbol = options.symbols.register_type_charwise
          elseif register_info.regtype == 'V' then
            register_info.type_symbol = options.symbols.register_type_linewise
          else
            register_info.type_symbol = options.symbols.register_type_blockwise
          end
        end

        state._register_values[#state._register_values + 1] = register_info
      end
    else
      -- Place it in the empty registers
      state._empty_registers[#state._empty_registers + 1] = register
    end
  end
end

---@private
---Get the register or when it's `nil` the selected register from the cursor.
---@param register? string Register to look up, if nothing is passed the current line will be used
---@return? string The register or the current line, if applicable
---@nodiscard
local _register_symbol = function(register)
  if register == nil then
    -- A register is selected by the cursor, get it based on the current line
    local cursor = unpack(vim.api.nvim_win_get_cursor(state._window))

    if #state._register_values < cursor then
      -- The empty section has been chosen, it doesn't select anything
      return nil
    end

    return state._register_values[cursor].register
  else
    -- Use the already set value
    return register
  end
end

---@private
---Handle the calling of the callback function based on the options, so things like delays can be added.
---@param options? callback_options Options to apply to the callback function.
---@param cb function Callback function to trigger.
---@return function callback Wrapped callback function applying the options.
---@nodiscard
local _handle_callback_options = function(options, cb)
  -- Process the table arguments
  local delay = (options and options.delay) or 0
  local if_mode = (options and options.if_mode) or { 'paste', 'insert', 'motion' }
  -- Ensure it's always a table
  if type(if_mode) ~= 'table' then
    if_mode = { if_mode }
  end
  local after = (options and options.after) or function() end

  -- Create the callback that's called with all checks and events
  local full_cb = function(...)
    -- Do nothing if we are not in the proper mode
    if not vim.tbl_contains(if_mode, state._mode) then
      return
    end

    -- Call the original callback
    cb(...)

    -- If we need to call a function after the callback also call that
    after()
  end

  if delay == 0 then
    -- Return the callback so it can be immediately called without any defer
    return full_cb
  else
    return function(...)
      -- Pass the arguments to the function
      local args = { ... }

      -- Sleep for delay before calling the function
      vim.defer_fn(function()
        full_cb(unpack(args))
      end, delay * 1000)
    end
  end
end

---@private
---Get the length of the longest register.
---@return integer The length of the longest register
---@nodiscard
local _longest_register_length = function()
  local longest = 0
  for i = 1, #state._register_values do
    local register = state._register_values[i]

    if #register.line > longest then
      longest = #register.line
    end
  end

  return longest
end

---@private
---Whether the opening of the registers window is interrupted by a keypress.
---Also handles the pressing of the proper key when that's the case.
---@return boolean is_interrupted Whether to handle the case where a key is pressed.
local _is_interrupted = function()
  if state._interrupted_by == nil then
    return false
  end

  -- Press the key that's interrupted again
  vim.api.nvim_feedkeys(state._interrupted_by, 'n', true)
  return true
end

---Empty the register on which the cursor resides in the window.
---@param options? callback_options Options for firing the callback.
---@return function callback Function that can be used to pass to configuration options with callbacks.
local clear_highlighted_register = function(options)
  local ui = require('registers.ui')
  return _handle_callback_options(options --[[@as callback_options]], function()
    -- Get the register contents for the current line as a table
    local register_info = _register_info()

    -- Do nothing when an invalid line is selected
    if type(register_info) ~= 'table' then
      return
    end

    -- Clear the register
    vim.fn.setreg(register_info.register, '')

    -- Fill the registers again
    _read_registers()

    -- Update the buffer
    ui._fill_window()
  end)
  ---@field private _buffer? integer
end

---@private
---Apply the register and close the window.
---@param register? string Which register to apply or the current line.
---@param keep_open_until_keypress? boolean Keep the window open until a key is pressed.
local _apply_register = function(register, keep_open_until_keypress)
  local ui = require('registers.ui')
  -- Get the register symbol also when selecting it manually
  register = _register_symbol(register)

  -- Do nothing if no valid register is chosen
  if not register then
    return
  end

  local key_to_press_at_the_end
  if state._mode == 'paste' then
    -- "Press" the 'p' key at the end so the selected register gets pasted
    key_to_press_at_the_end = 'p'
  elseif keep_open_until_keypress and state._mode == 'motion' then
    -- Handle the special case when the window needs to be open until a key is pressed
    key_to_press_at_the_end = vim.fn.getcharstr()
  end

  -- Close the window
  ui._close_window()

  -- Handle the different modes
  if state._mode == 'insert' then
    -- Get the proper keycode for <C-R>
    local key = vim.api.nvim_replace_termcodes('<C-R>', true, true, true)

    if register == '=' then
      -- Apply <C-R>= again so the user can enter their query
      vim.api.nvim_feedkeys(key .. '=', 'n', true)
    else
      -- Insert the other keys

      -- Capture the contents of the "=" register so it can be reset later
      local old_expr_content = vim.fn.getreg('=', 1)

      -- <CR> key
      local submit = vim.api.nvim_replace_termcodes('<CR>', true, true, true)

      -- Execute the selected register content using "=" register and insert the result
      vim.api.nvim_feedkeys(key .. '=@' .. register .. submit, 'n', true)

      -- Recover the "=" register with a delay otherwise it doesn't get applied
      vim.schedule(function()
        vim.fn.setreg('=', old_expr_content)
      end)
    end
  elseif state._previous_mode == 'n' or state._previous_mode_is_visual() then
    -- Simulate the keypresses require to perform the next actions
    vim.schedule(function()
      local keys = ''

      -- Go to previous visual selection if applicable
      if state._previous_mode_is_visual() then
        keys = keys .. 'gv'
      end

      -- Select the register if applicable
      if state._mode == 'motion' or state._mode == 'paste' then
        -- Push the operator count back if applicable
        if state._operator_count > 0 then
          keys = keys .. state._operator_count
        end

        keys = keys .. '"' .. register
      end

      -- Handle the key that might needs to be pressed
      if key_to_press_at_the_end then
        keys = keys .. key_to_press_at_the_end
      end

      vim.api.nvim_feedkeys(keys, 'n', true)
    end)
  end

  local options = config.get()
  -- Copy the selected register to the system clipboard if applicable
  if options.system_clipboard then
    if vim.fn.has('clipboard') == 1 then
      vim.cmd('let @+=@' .. register)
    else
      vim.api.nvim_err_writeln('No clipboard available')
    end
  end
end

---`require("registers").apply_register({...})`
---@class apply_register_options
---@field mode? register_mode How the register should be applied. If `nil` then the mode in which the window is opened is used.
---@field keep_open_until_keypress? boolean If `true`, keep the window open until another key is pressed, only applicable when the mode is `"motion"`.

---Apply the specified register.
---@param options? callback_options|apply_register_options Options for firing the callback.
---@return function callback Function that can be used to pass to configuration options with callbacks.
---@usage [[
---require("registers").setup({
---    bind_keys = {
---        -- Always paste the register when selecting with Enter
---        ["<CR>"] = require("registers").apply_register({ mode = "paste" }),
---    }
---})
---
---require("registers").setup({
---    bind_keys = {
---        -- When pressing a key of the register, wait for another key press before closing the window
---        registers = require("registers").apply_register({ keep_open_until_keypress = true }),
---    }
---})
---@usage ]]
local apply_register = function(options)
  return _handle_callback_options(options --[[@as callback_options]], function(register, mode)
    -- When the current line needs to be selected a window also needs to be open
    if register == nil and state._window == nil then
      vim.api.nvim_err_writeln("registers window isn't open, can't apply register")
      return
    end

    -- Overwrite the mode
    if options and options.mode then
      state._mode = options.mode --[[@as register_mode]]
    elseif mode then
      state._mode = mode
    end

    _apply_register(register, options and options.keep_open_until_keypress)
  end)
end

return {
  apply_register = apply_register,
  clear_highlighted_register = clear_highlighted_register,
  _handle_callback_options = _handle_callback_options,
  _is_interrupted = _is_interrupted,
  _longest_register_length = _longest_register_length,
  _read_registers = _read_registers,
}
