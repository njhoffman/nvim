local uv = require("luv")
local config = require("registers.config")
local state = require("registers.state")
local highlights = require("registers.highlights")

---@private
---Close the window.
local _close_window = function()
  -- Close the window, this should also close the buffer
  if state._window then
    vim.api.nvim_win_close(state._window, true)
    state._window = nil
  end

  -- But if the buffer is created and interrupted before the window is opened this won't happen
  if state._buffer then
    local ok = pcall(vim.api.nvim_buf_delete, state._buffer, { force = true })
    state._buffer = nil
  end

  -- Clear the namespace if it's on the preview
  if state._preview_buffer then
    vim.api.nvim_buf_clear_namespace(state._preview_buffer, state._namespace, 0, -1)
  end
end

---@private
---Handle the CursorMoved autocmd.
local _cursor_moved = function()
  local cursor = unpack(vim.api.nvim_win_get_cursor(state._window))
  local options = config.get()

  -- Skip horizontal movement
  if state._previous_cursor_line == cursor then
    return
  end
  state._previous_cursor_line = cursor

  -- Trigger the highlight change event
  options.events.on_register_highlighted()
end

---@private
---Fill the window's buffer.
local _fill_window = function()
  local options = config.get()

  -- Don't allow the buffer to be modified
  vim.api.nvim_buf_set_option(state._buffer, "modifiable", true)

  -- Create an array of lines for all the registers
  local lines = {}
  for i = 1, #state._register_values do
    local register = state._register_values[i]

    lines[i] = register.line
  end

  -- Add the empty line
  if options.show_empty then
    lines[#lines + 1] = "Empty: " .. table.concat(state._empty_registers, " ")
  end

  -- Write the lines to the buffer
  vim.api.nvim_buf_set_lines(state._buffer, 0, -1, false, lines)

  -- Create signs and highlights for the register itself
  for i = 1, #state._register_values do
    local register = state._register_values[i]

    local sign_text = register.register
    -- Add the register type symbol if applicable
    if options.show_register_types then
      sign_text = sign_text .. register.type_symbol
    end

    -- Create signs for the register itself, and highlight the line
    vim.api.nvim_buf_set_extmark(state._buffer, state._namespace, i - 1, 0, {
      id = i,
      sign_text = sign_text,
      sign_hl_group = highlights._highlight_for_sign(register.register),
      cursorline_hl_group = options.sign_highlights.cursorline,
    })
  end

  -- Don't allow the buffer to be modified
  vim.api.nvim_buf_set_option(state._buffer, "modifiable", false)
end

---@private
---Create the window and the buffer.
local _create_window = function()
  local utils = require("registers.utils")

  -- Stop when the window is interrupted
  if utils._is_interrupted() then
    return
  end

  -- Handle illegal mode combinations
  if state._mode == "paste" and state._previous_mode == "i" then
    vim.api.nvim_err_writeln(
      "registers.nvim doesn't support `registers.show_window('paste')` being invoked from insert mode"
    )
  elseif
    state._mode == "insert"
    and state._previous_mode ~= "i"
    and state._previous_mode ~= "c"
  then
    vim.api.nvim_err_writeln(
      "registers.nvim doesn't support `registers.show_window('insert')` being invoked from any mode other than insert mode"
    )
    return
  end

  -- Keep track of the buffer from which the window is called
  state._preview_buffer = vim.api.nvim_get_current_buf()
  state._preview_window = vim.api.nvim_get_current_win()

  -- Fill the registers
  utils._read_registers()

  -- Create the buffer the registers will be written to
  state._buffer = vim.api.nvim_create_buf(false, true)

  -- Remove the buffer when the window is closed
  vim.api.nvim_buf_set_option(state._buffer, "bufhidden", "wipe")

  -- Set the filetype
  vim.api.nvim_buf_set_option(state._buffer, "filetype", "registers")

  -- Stop when the window is interrupted
  if utils._is_interrupted() then
    _close_window()
    return
  end

  local options = config.get()

  -- redraw at top
  vim.cmd("normal! zt")

  -- The width is based on the longest line, but it will be truncated if the max width is supplied and is longer
  local window_width
  if options.window.max_width > 0 then
    window_width = math.min(options.window.max_width, utils._longest_register_length())
  else
    -- There is no max width supplied so use the longest registers length as the window size
    window_width = math.min(utils._longest_register_length())
  end

  -- Height is based on the amount of available registers
  local window_height = #state._register_values
  if options.show_empty then
    -- Add an extra line for the Empty: line
    window_height = window_height + 1
  end

  -- Create the floating window
  local default_window_options = {
    -- Place the window next to the cursor
    relative = "cursor",
    -- Remove all window decorations
    style = "minimal",
    -- Width of the window
    width = window_width,
    -- Height of the window
    height = window_height,
    -- Place the new window just under the cursor
    row = 1,
    col = 0,
    -- How the edges are rendered
    border = options.window.border or "rounded",
  }

  local window_options = default_window_options
  if options.layouts and #options.layouts > 0 then
    if type(options.layouts[1]) == "function" then
      state._current_layout = 1
      window_options = options.layouts[1](default_window_options)
    end
  end

  -- Make the window active when the window is not a preview
  state._window = vim.api.nvim_open_win(state._buffer, true, window_options)

  -- Register an autocommand to close the window if focus is lost
  local group = vim.api.nvim_create_augroup("RegistersWindow", {})
  vim.api.nvim_create_autocmd("BufLeave", {
    group = group,
    pattern = "<buffer>",
    callback = _close_window,
  })

  -- TODO: make hover out optional
  -- Register an autocommand to trigger events when the cursor moves
  if type(options.events.on_register_highlighted) == "function" then
    state._previous_cursor_line = nil
    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
      group = group,
      buffer = state._buffer,
      callback = _cursor_moved,
    })
  end

  -- TODO: save source_ft with register
  -- local source_ft = vim.api.nvim_get_option_value("filetype", {
  --   buf = state._preview_buffer,
  -- }) or "registers"
  local source_ft = "registers"

  -- TODO: add option for this
  vim.api.nvim_set_option_value("syntax", source_ft, { buf = state._buffer })

  -- Make the buffer content cut-off instead of starting on new line
  vim.api.nvim_win_set_option(state._window, "wrap", false)

  -- Show a column on the left for the register names
  vim.api.nvim_win_set_option(
    state._window,
    "signcolumn",
    -- Add space for the extra symbol in the sign column depending on whether we should show the register types
    options.show_register_types and "yes:2" or "yes"
  )

  -- Highlight the cursor line
  if options.window.highlight_cursorline then
    vim.api.nvim_win_set_option(state._window, "cursorline", true)
  end

  -- Make the window transparent
  if options.window.transparency then
    vim.api.nvim_win_set_option(state._window, "winblend", options.window.transparency)
  end

  -- Add the colors
  highlights._define_highlights()

  -- Update the buffer
  _fill_window()

  -- Apply the key bindings to the buffer
  local mappings = require("registers.mappings")
  mappings._set_bindings()

  -- Stop when the window is interrupted
  if utils._is_interrupted() then
    _close_window()
    return
  end

  -- The creation of the window can't be interrupted at this point because the keys are already bound
  state._key_interrupt_timer:close()
  state._key_interrupt_timer = nil

  -- Ensure the window shows up
  vim.cmd("redraw!")

  -- Put the window in normal mode when using a visual selection
  if state._previous_mode_is_visual() then
    vim.api.nvim_feedkeys(
      vim.api.nvim_replace_termcodes("<C-\\><C-N>", true, true, true),
      "n",
      true
    )
  end
end

---@mod callbacks Bindable functions

---`require("registers").show_window({...})`
---@class show_window_options
---@field delay number How long, in seconds, to wait before applying the function. Default is `0`.
---@field mode? register_mode How the registers window should handle the selection of registers. Default is `"motion"`.

---Popup the registers window.
---@param options? show_window_options Options for firing the callback.
---@return function callback Function that can be used to pass to configuration options with callbacks.
---@usage [[
----- Disable all key bindings
---require("registers").setup({ bind_keys = false })
---
----- Define a custom for opening the register window when pressing "r"
---vim.api.nvim_set_keymap("n", "r", "", {
---    -- The "paste" argument means that when a register is selected it will automatically be pasted
---    callback = require("registers").show_window({ mode = "paste" }),
---    -- This is required for the registers window to function
---    expr = true
---})
---@usage ]]
local show_window = function(options)
  options = vim.tbl_deep_extend("keep", options or {}, {
    delay = 0,
    mode = "motion",
  })

  return function()
    -- Reset the interruption check
    state._interrupted_by = nil

    -- Reset the one-time keystroke guard
    state._has_determined_register = false

    -- Keeps subsequent non-register keys that are pressed before the window closes
    state._keys_to_press_at_the_very_end = ""

    -- Do a quick check if a key is not pressed already while calling this function
    local key = vim.fn.getchar(false)
    if key ~= 0 then
      state._interrupted_by = key
    else
      -- Check whether a key is pressed in between waiting for the window to open
      state._key_interrupt_timer = uv.new_timer()
      -- The interval of 200ms is based on the default value for vim.wait
      state._key_interrupt_timer:start(0, 200, function()
        -- Schedule the function because we can't run viml functions in a libuv loop
        vim.schedule(function()
          key = vim.fn.getchar(false)
          if key ~= 0 then
            -- Stop the timer
            if state._key_interrupt_timer then
              state._key_interrupt_timer:close()
              state._key_interrupt_timer = nil
            end

            -- Set the interrupted boolean so the creation of the window can be cancelled
            state._interrupted_by = key
          end
        end)
      end)
    end

    -- Wait for the delay, this will also add a tiny interval for processing key combinations
    vim.wait(options.delay * 1000, function()
      return state._interrupted_by ~= nil
    end, nil, false)

    -- Mode before opening the popup window
    state._previous_mode = vim.api.nvim_get_mode().mode

    -- Open the window when another key hasn't been pressed in the meantime
    if state._interrupted_by == nil then
      -- Keep track of the count that's used to invoke the window so it can be applied again
      state._operator_count = vim.api.nvim_get_vvar("count")

      -- Store the mode which defaults to motion
      state._mode = options.mode

      -- The timeout was not interrupted by a key press, open a buffer
      -- Must be scheduled so the window can be created at the right moment
      vim.schedule(function()
        _create_window()
      end)
    else
      -- While in a motion mode is shown simulate the pressing of the key depending on the mode
      local charstr = vim.fn.nr2char(state._interrupted_by)
      if state._previous_mode == "n" or state._previous_mode == "v" then
        return '"' .. charstr
      else
        return vim.api.nvim_replace_termcodes("<C-R>", true, true, true) .. charstr
      end
    end
  end
end
---`require("registers").apply_register({...})`
---@class apply_register_options
---@field mode? register_mode How the register should be applied. If `nil` then the mode in which the window is opened is used.
---@field keep_open_until_keypress? boolean If `true`, keep the window open until another key is pressed, only applicable when the mode is `"motion"`.

---Apply the specified register.
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
  local utils = require("registers.utils")
  return utils._handle_callback_options(options --[[@as callback_options]], function(register, mode)
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

    utils._apply_register(register, options and options.keep_open_until_keypress)
  end)
end

---Move the cursor up in the window.
---@param options? callback_options Options for firing the callback.
---@return function callback Function that can be used to pass to configuration options with callbacks.
local move_cursor_up = function(options)
  local utils = require("registers.utils")
  return utils._handle_callback_options(options, function()
    if state._window == nil then
      vim.api.nvim_err_writeln("registers window isn't open, can't move cursor")
      return
    end

    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Up>", true, true, true), "n", true)
  end)
end

---Move the cursor down in the window.
---@param options? callback_options Options for firing the callback.
---@return function callback Function that can be used to pass to configuration options with callbacks.
local move_cursor_down = function(options)
  local utils = require("registers.utils")
  return utils._handle_callback_options(options, function()
    if state._window == nil then
      vim.api.nvim_err_writeln("registers window isn't open, can't move cursor")
      return
    end

    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Down>", true, true, true), "n", true)
  end)
end

---@private
---Move the cursor to the specified register.
---@param register string The register to move to, if it can't be found nothing is done.
local _move_cursor_to_register = function(register)
  if state._window == nil then
    vim.api.nvim_err_writeln("registers window isn't open, can't move cursor")
    return
  end

  -- Find the matching register so we know where to put the cursor
  for i = 1, #state._register_values do
    local register_info = state._register_values[i]
    if register_info.register == register then
      -- Move the cursor
      vim.api.nvim_win_set_cursor(state._window, { i, 0 })

      -- Redraw the line so it gets highlighted
      vim.api.nvim_command("silent! redraw")

      return
    end
  end
end

---`require("registers").move_cursor_to_register({...})`
---@class move_cursor_to_register_options
---@field register string Which register to move the cursor to.

---Move the cursor to the specified register.
---@param options callback_options|move_cursor_to_register_options Options for firing the callback.
---@return function callback Function that can be used to pass to configuration options with callbacks.
local move_cursor_to_register = function(options)
  local utils = require("registers.utils")
  if not options.register then
    error("a register must be passed to `registers.move_cursor_to_register`")
  end

  return utils._handle_callback_options(options --[[@as callback_options]], function()
    _move_cursor_to_register(options.register --[[@as string]])
  end)
end

---`require("registers")...({...})`
---@class callback_options
---@field delay number How long, in seconds, to wait before applying the function. Default is `0`.
---@field after? function Callback function that can be chained after the current one.
---@field if_mode register_mode|[register_mode] Will only be triggered when the registers mode matches it. Default: `{ "paste", "insert", "motion" }`.

---Close the window.
---@param options? callback_options Options for firing the callback.
---@return function callback Function that can be used to pass to configuration options with callbacks.
---@usage [[
---require("registers").setup({
---    bind_keys = {
---        -- Don't apply the register when selecting with Enter but close the window
---        ["<CR>"] = require("registers").close_window(),
---    }
---})
---@usage ]]
local close_window = function(options)
  local utils = require("registers.utils")
  return utils._handle_callback_options(options, _close_window)
end

local switch_layout = function() end

-- stylua: ignore
return {
  _close_window            = _close_window,
  _fill_window             = _fill_window,
  _move_cursor_to_register = _move_cursor_to_register,
  apply_register           = apply_register,
  close_window             = close_window,
  switch_layout            = switch_layout,
  show_window              = show_window,
  move_cursor_up           = move_cursor_up,
  move_cursor_down         = move_cursor_down,
  move_cursor_to_register  = move_cursor_to_register,
}
