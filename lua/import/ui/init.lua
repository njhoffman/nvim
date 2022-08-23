local opts = require('import.opts')
local cmds = require('import.commands')
local ui_state = require('import.ui.state')
local detail_lines = require('import.ui.details')
local summary_lines = require('import.ui.summary')
local format_module = require('import.ui.format')

local _init = function(_opts)
  opts.config(_opts)
  vim.cmd [[
    highlight default link ImportSuccessIcon healthSuccess 
    highlight default link ImportInfoIcon DiagnosticInfo  
    highlight default link ImportErrorIcon DiagnosticError
  ]]
end

local _update_main_buffer_line = function(lineno, new_text)
  vim.api.nvim_buf_set_option(ui_state.buf_handle, 'modifiable', true)
  vim.api.nvim_buf_set_lines(ui_state.buf_handle, lineno - 1, lineno, false, { new_text })
  vim.api.nvim_buf_set_option(ui_state.buf_handle, 'modifiable', false)
end

local _selected_module = function(line)
  local module = ui_state._get_module(line)
  if not module then return end
  _update_main_buffer_line(line, "...")
  cmds.reload(module)
  _update_main_buffer_line(line, format_module(module))
end

local _scroll_view_pane_down = function()
  vim.api.nvim_win_call(ui_state.view_win_handle,
    function()
      vim.cmd([[normal!]] .. 1 .. [[]])
    end)
end

local _scroll_view_pane_up = function()
  vim.api.nvim_win_call(ui_state.view_win_handle,
    function()
      vim.cmd([[normal!]] .. 1 .. [[]])
    end)
end

local _close = function()
  ui_state.is_displayed = false
  local bufs = { 'view_buf_handle', 'buf_win_handle', 'view_win_handle', 'buf_handle' }
  for _, buf in pairs(bufs) do
    if ui_state[buf] and
      vim.api.nvim_buf_is_loaded(ui_state[buf]) then
      vim.api.nvim_buf_delete(ui_state[buf], { force = true })
    end
    ui_state[buf] = nil
  end
end

local _assign_keycodes = function()
  vim.api.nvim_buf_set_keymap(ui_state.buf_handle,
    'n', opts.user_opts.keypress_select,
    ':lua require("import.ui")._selected_module(vim.fn.line("."))<CR>',
    { noremap = true, silent = true })

  vim.api.nvim_buf_set_keymap(ui_state.buf_handle,
    'n', opts.user_opts.keypress_close,
    ':lua require("import.ui")._close()<CR>',
    { noremap = true, silent = true })

  vim.api.nvim_buf_set_keymap(ui_state.buf_handle,
    'n', opts.user_opts.keypress_scroll_output_down,
    ':lua require("import.ui")._scroll_view_pane_down()<CR>',
    { noremap = true, silent = true })

  vim.api.nvim_buf_set_keymap(ui_state.buf_handle,
    'n', opts.user_opts.keypress_scroll_output_up,
    ':lua require("import.ui")._scroll_view_pane_up()<CR>',
    { noremap = true, silent = true })
end

local _assign_autocommands = function()
  vim.api.nvim_create_autocmd('BufDelete', {
    buffer = ui_state.buf_handle,
    desc = "Clear out Cache for import UI",
    callback = _close,
    once = true
  })

  vim.api.nvim_create_autocmd('WinClosed', {
    buffer = ui_state.buf_handle,
    desc = "Clear out cache for import UI",
    callback = _close,
    once = true
  })

  vim.api.nvim_create_autocmd('CursorMoved', {
    buffer = ui_state.buf_handle,
    desc = "Loading Details into View Buffer",
    callback = detail_lines
  })
end

local _assign_window_props = function()
  vim.api.nvim_buf_set_option(ui_state.buf_handle, 'modifiable', true)
  vim.api.nvim_buf_set_option(ui_state.buf_handle, 'modifiable', false)
  vim.api.nvim_buf_set_option(ui_state.buf_handle, 'filetype', "ImportManager")
  vim.api.nvim_buf_set_option(ui_state.buf_handle, 'modified', false)
  vim.api.nvim_buf_set_option(ui_state.view_buf_handle, 'modifiable', false)
  vim.api.nvim_buf_set_option(ui_state.view_buf_handle, 'filetype', "ImportManager")
  vim.api.nvim_buf_set_option(ui_state.view_buf_handle, 'modified', false)
  vim.api.nvim_set_option_value('wrap', true, { scope = 'local' })
end

local display = function(_opts)
  -- Short circuit if we are already displayed
  if ui_state.is_displayed then return end

  _init(_opts)

  if not ui_state.buf_handle or not vim.api.nvim_buf_is_loaded(ui_state.buf_handle) then
    ui_state.buf_handle = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_name(ui_state.buf_handle, "ImportManager")
  end

  if not ui_state.view_buf_handle or not vim.api.nvim_buf_is_loaded(ui_state.view_buf_handle) then
    ui_state.view_buf_handle = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_name(ui_state.view_buf_handle, "ImportManager_Viewer")
  end

  local cur_ui = vim.api.nvim_list_uis()[1]

  local float_height = math.floor(cur_ui.height * .9)
  local float_width = math.floor(cur_ui.width * .9)
  local view_height = nil
  local view_width = nil
  local float_col = nil
  local float_row = nil
  local view_col = nil
  local view_row = nil

  if opts.user_opts.output_split_type == 'horizontal' then
    view_height  = math.floor(float_height * .3)
    view_width   = float_width
    float_height = float_height - view_height
    float_col    = (cur_ui.width / 2) - (float_width / 2)
    float_row    = (cur_ui.height / 2) - (float_height / 2) - (view_height / 2)
    view_col     = (cur_ui.width / 2) - (view_width / 2)
    view_row     = (cur_ui.height / 2) - (view_height / 2) + (float_height / 2)
  else
    view_height = float_height
    view_width  = math.floor(float_width * .6)
    float_width = float_width - view_width
    float_col   = (cur_ui.width / 2) - (float_width / 2) - (view_width / 2)
    float_row   = (cur_ui.height / 2) - (float_height / 2)
    view_col    = (cur_ui.width / 2) - (view_width / 2) + (float_width / 2)
    view_row    = (cur_ui.height / 2) - (view_height / 2)
  end

  local float_opts = {
    relative = 'editor',
    border   = 'double',
    width    = float_width,
    height   = float_height,
    col      = float_col,
    row      = float_row,
    style    = 'minimal'
  }

  local view_opts = {
    relative = 'editor',
    border   = 'rounded',
    width    = view_width,
    height   = view_height,
    col      = view_col,
    row      = view_row,
    style    = 'minimal'
  }

  local imported = { failures = {}, successes = {}, details = {}, time = 0 }
  for _, module in ipairs(cmds.get_all_modules()) do
    local details = cmds.get_status(module)
    imported.details[module] = details
    imported.time = imported.time + details.import_time
    if details.imported then
      table.insert(imported.successes, module)
    else
      table.insert(imported.failures, module)
    end
  end

  local lines = summary_lines(imported, view_width)
  vim.api.nvim_buf_set_lines(ui_state.buf_handle, 0, -1, false, lines)

  _assign_window_props()
  _assign_keycodes()
  _assign_autocommands()

  ui_state.view_win_handle = vim.api.nvim_open_win(ui_state.view_buf_handle, 1, view_opts)
  ui_state.buf_win_handle = vim.api.nvim_open_win(ui_state.buf_handle, 1, float_opts)
end

return {
  _selected_module       = _selected_module,
  _scroll_view_pane_down = _scroll_view_pane_down,
  _scroll_view_pane_up   = _scroll_view_pane_up,
  _close                 = _close,
  display                = display
}
