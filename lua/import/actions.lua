local ui_state = require("import.ui.state")
local format_mod = require("import.ui.format").module
local cmds = require("import.commands")

local _update_main_buffer_line = function(lineno, new_text)
  vim.api.nvim_set_option_value("modifiable", true, { buf = ui_state.buf_handle })
  vim.api.nvim_buf_set_lines(ui_state.buf_handle, lineno - 1, lineno, false, { new_text })
  vim.api.nvim_set_option_value("modifiable", false, { buf = ui_state.buf_handle })
end

local _selected_module = function(line)
  local module = ui_state._get_module(line)
  if not module then
    return
  end
  _update_main_buffer_line(line, "...")
  cmds.reload(module)
  _update_main_buffer_line(line, format_mod(module))
end

local _close = function()
  ui_state.is_displayed = false
  local bufs = { "view_buf_handle", "buf_win_handle", "view_win_handle", "buf_handle" }
  for _, buf in pairs(bufs) do
    local bufnr = ui_state[buf] and tonumber(ui_state[buf])
    if bufnr and vim.api.nvim_buf_is_loaded(bufnr) then
      vim.api.nvim_buf_delete(bufnr, { force = true })
    end
    ui_state[buf] = nil
  end
end

local _scroll_view_pane_down = function()
  vim.api.nvim_win_call(ui_state.view_win_handle, function()
    vim.cmd([[normal!]] .. 1 .. [[]])
  end)
end

local _scroll_view_pane_up = function()
  vim.api.nvim_win_call(ui_state.view_win_handle, function()
    vim.cmd([[normal!]] .. 1 .. [[]])
  end)
end

return {
  scroll_view_pane_up = _scroll_view_pane_up,
  scroll_view_pane_down = _scroll_view_pane_down,
  close = _close,
  selected_module = _selected_module,
}
