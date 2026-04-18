---@class state
---@field private _namespace string
---@field private _window? integer
---@field private _preview_buffer? integer
---@field private _preview_window? integer
---@field private _mappings table<string, function>
---@field private _buffer? integer
---@field private _mode string
---@field private _interrupted_by? string
---@field private _previous_mode string
---@field private _previous_cursor_line? integer
---@field private _register_values { regcontents: string, line: string, register: string, type_symbol?: string, regtype: string }[]
---@field private _empty_registers string[]
---@field private _operator_count integer
---@field private _key_interrupt_timer? userdata
---@field private _current_layout? integer
---@field private _has_determined_register boolean
---@field private _keys_to_press_at_the_very_end string

local state = {
  _mode = nil,
  _previous_mode = nil,
  _namespace = nil,
  _buffer = nil,
  _preview_buffer = nil,
  _preview_window = nil,
  _window = nil,
  _mappings = nil,
  _interrupted_by = nil,
  _previous_cursor_line = nil,
  _register_values = nil,
  _empty_registers = nil,
  _operator_count = nil,
  _key_interrupt_timer = nil,
  _current_layout = nil,
  _has_determined_register = false,
  _keys_to_press_at_the_very_end = "",
}

---@private
---Whether the previous mode is any of the visual selections.
---@return boolean is_visual Whether the previous mode is a visual selection.
state._previous_mode_is_visual = function()
  return state._previous_mode == "v"
    or state._previous_mode == "^V"
    or state._previous_mode == "V"
    or state._previous_mode == "\22"
end

return state
