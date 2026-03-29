local map = require("mapper").map
local opts = require("import.opts")
local ui_state = require("import.ui.state")

local _assign_keycodes = function()
  map(
    "n",
    opts.user_opts.keypress_select,
    ':lua require("import.ui")._selected_module(vim.fn.line("."))<CR>',
    { buffer = ui_state.buf_handle }
  )

  map(
    "n",
    opts.user_opts.keypress_close,
    ':lua require("import.ui")._close()<CR>',
    { buffer = ui_state.buf_handle }
  )

  map(
    "n",
    opts.user_opts.keypress_scroll_output_down,
    ':lua require("import.ui")._scroll_view_pane_down()<CR>',
    { buffer = ui_state.buf_handle }
  )

  map(
    "n",
    opts.user_opts.keypress_scroll_output_up,
    ':lua require("import.ui")._scroll_view_pane_up()<CR>',
    { buffer = ui_state.buf_handle }
  )
end
return _assign_keycodes
