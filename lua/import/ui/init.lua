local opts = require("import.opts")
local cmds = require("import.commands")
local ui_state = require("import.ui.state")
local actions = require("import.actions")
local assign_keycodes = require("import.keycodes")
local assign_autocommands = require("import.autocommands")
local summary_lines = require("import.ui.summary")

local _init = function(_opts)
  opts.config(_opts)
  ---Create highlights.
  vim.api.nvim_set_hl(0, "ImportFailedIcon", { link = "Error" })
  vim.api.nvim_set_hl(0, "ImportFailedModule", { link = "ModeMsg" })
  vim.api.nvim_set_hl(0, "ImportFailedMessage", { link = "Normal" })
  vim.api.nvim_set_hl(0, "ImportFailedTime", { link = "Comment" })
  vim.api.nvim_set_hl(0, "ImportSuccessIcon", { link = "healthSuccess" })
  vim.api.nvim_set_hl(0, "ImportSuccessModule", { link = "Normal" })
  vim.api.nvim_set_hl(0, "ImportSuccessMessage", { link = "DebugMsg" })
  vim.api.nvim_set_hl(0, "ImportSuccessTime", { link = "Comment" })
end

local _get_sizes = function()
  local cur_ui = vim.api.nvim_list_uis()[1]
  local sizes = {
    float_height = math.floor(cur_ui.height * 0.9),
    float_width = math.floor(cur_ui.width * 0.9),
  }

  if opts.user_opts.output_split_type == "horizontal" then
    sizes.view_height = math.floor(sizes.float_height * 0.3)
    sizes.view_width = sizes.float_width
    sizes.float_height = sizes.float_height - sizes.view_height
    sizes.float_col = (cur_ui.width / 2) - (sizes.float_width / 2)
    sizes.float_row = (cur_ui.height / 2) - (sizes.float_height / 2) - (sizes.view_height / 2)
    sizes.view_col = (cur_ui.width / 2) - (sizes.view_width / 2)
    sizes.view_row = (cur_ui.height / 2) - (sizes.view_height / 2) + (sizes.float_height / 2)
  else
    sizes.view_height = sizes.float_height
    sizes.view_width = math.floor(sizes.float_width * 0.6)
    sizes.float_width = sizes.float_width - sizes.view_width
    sizes.float_col = (cur_ui.width / 2) - (sizes.float_width / 2) - (sizes.view_width / 2)
    sizes.float_row = (cur_ui.height / 2) - (sizes.float_height / 2)
    sizes.view_col = (cur_ui.width / 2) - (sizes.view_width / 2) + (sizes.float_width / 2)
    sizes.view_row = (cur_ui.height / 2) - (sizes.view_height / 2)
  end
  return sizes
end

local display = function(_opts)
  -- Short circuit if we are already displayed
  if ui_state.is_displayed then
    return
  end

  _init(_opts)

  if not ui_state.buf_handle or not vim.api.nvim_buf_is_loaded(ui_state.buf_handle) then
    ui_state.buf_handle = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_name(ui_state.buf_handle, "ImportManager")
  end

  if not ui_state.view_buf_handle or not vim.api.nvim_buf_is_loaded(ui_state.view_buf_handle) then
    ui_state.view_buf_handle = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_name(ui_state.view_buf_handle, "ImportManager_Viewer")
  end

  local sizes = _get_sizes()

  local float_opts = {
    relative = "editor",
    border = "rounded",
    width = sizes.float_width,
    height = sizes.float_height,
    col = sizes.float_col,
    row = sizes.float_row,
    style = "minimal",
  }

  local view_opts = {
    relative = "editor",
    border = "rounded",
    width = sizes.view_width,
    height = sizes.view_height,
    col = sizes.view_col,
    row = sizes.view_row,
    style = "minimal",
  }

  local debuglog = require("debuglog")

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

  assign_keycodes()
  assign_autocommands()
  summary_lines(imported, sizes.view_width)

  vim.api.nvim_buf_set_option(ui_state.buf_handle, "modifiable", false)
  vim.api.nvim_buf_set_option(ui_state.buf_handle, "modified", false)
  vim.api.nvim_buf_set_option(ui_state.view_buf_handle, "modifiable", false)
  vim.api.nvim_buf_set_option(ui_state.view_buf_handle, "modified", false)
  ui_state.view_win_handle = vim.api.nvim_open_win(ui_state.view_buf_handle, 1, view_opts)
  ui_state.buf_win_handle = vim.api.nvim_open_win(ui_state.buf_handle, 1, float_opts)
  vim.api.nvim_set_option_value("wrap", true, { buf = ui_state.view_buf_handle })
end

return {
  _selected_module = actions.selected_module,
  _scroll_view_pane_down = actions.scroll_view_pane_down,
  _scroll_view_pane_up = actions.scroll_view_pane_up,
  _close = actions.close,
  display = display,
}
