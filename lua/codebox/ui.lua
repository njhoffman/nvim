local utils = require("codebox.utils")
local config = require("codebox.config")

local run_hook_function = function(buffer, new_window)
  local success, result = pcall(config.conf.post_open_hook, buffer, new_window)
  utils.logger.debug({ "post_open_hook call success:", success, result })
end

local buffer_entered = function()
  local curr_buf = vim.api.nvim_get_current_buf()
  local curr_win = vim.api.nvim_get_current_win()

  local success, result = pcall(vim.api.nvim_win_get_var, curr_win, "is-codebox-window")

  if success and result == 1 then
    utils.logger.debug("buffer_entered was called and will run hook function")
    run_hook_function(curr_buf, curr_win)
  end
end
local remove_win = function(win)
  local index = utils.table_find(config.windows, win or vim.api.nvim_get_current_win())
  if index then
    table.remove(config.windows, index)
    table.remove(config.anchored, index)
  end
  return M
end

local close_if_is_goto_preview = function(win_handle)
  local success, result = pcall(vim.api.nvim_win_get_var, win_handle, "is-codebox-window")
  if success and result == 1 then
    vim.api.nvim_win_close(win_handle, config.conf.force_close)
    -- NOTE: must be triggered manually, autocmd not doing it
    remove_win(win_handle)
  end
end

local close_all_win = function()
  local windows = vim.api.nvim_tabpage_list_wins(0)
  for _, win in pairs(windows) do
    local index = utils.table_find(config.windows, win)
    table.remove(config.windows, index)
    pcall(close_if_is_goto_preview, win)
  end
end

local dismiss_preview = function(winnr)
  if winnr then
    utils.logger.debug("attempting to close ", winnr, config.windows)
    close_if_is_goto_preview(winnr)
  else
    utils.logger.debug("closing all preview windows", config.windows)
    for _, win in ipairs(config.windows) do
      close_if_is_goto_preview(win)
    end
  end
end

local toggle_dock = function()
  local winnr = vim.api.nvim_get_current_win()
  local preview_window = config.windows[1]

  local success, result = pcall(vim.api.nvim_win_get_var, preview_window, "is-codebox-window")
  if success and result == 1 then
    if utils.is_anchored(preview_window) then
      vim.api.nvim_clear_autocmds({ group = "codebox-vanish" })
      return dismiss_preview(preview_window)
    end

    local size = {
      width = vim.api.nvim_win_get_width(winnr),
      height = vim.api.nvim_win_get_height(winnr),
    }
    -- vim.api.nvim_win_set_width(preview, new_width)
    -- vim.api.nvim_win_set_height(preview, new_neight)

    -- vim.cmd([[ highlight NormalFloat guibg=#060a1a ]])
    table.insert(config.anchored, preview_window)

    vim.api.nvim_win_set_config(preview_window, {
      relative = "win",
      row = size.height,
      col = size.width,
      win = winnr,
      anchor = "SE",
    })
  end
end

local open_floating_win = function(preview_buffer, position, opts)
  local bufpos = { vim.fn.line(".") - 1, vim.fn.col(".") } -- FOR relative='win'
  local zindex = vim.tbl_isempty(config.windows) and 1 or #config.windows + 1

  local preview_window = {}
  local curr_win = vim.api.nvim_get_current_win()
  local success, result = pcall(vim.api.nvim_win_get_var, curr_win, "is-codebox-window")

  local width = opts.width or config.conf.width
  local height = opts.height or config.conf.height

  if string.find(tostring(width), "%%") then
    local pct = string.match(tostring(width), "([0-9]+)%%")
    local currwidth = vim.api.nvim_win_get_width(curr_win)
    width = math.floor(currwidth * pct / 100)
  end

  if not config.conf.stack_floating_preview_windows and #config.windows > 0 then
    preview_window = config.windows[1]
    if utils.is_floating(curr_win) and success and result == 1 then
      preview_window = curr_win
    end
    vim.api.nvim_win_set_config(preview_window, {
      width = width,
      height = height,
      border = config.conf.border,
    })
    vim.api.nvim_win_set_buf(preview_window, preview_buffer)
  else
    preview_window = vim.api.nvim_open_win(preview_buffer, config.conf.focus_on_open, {
      relative = "win",
      width = width,
      height = height,
      border = config.conf.border,
      bufpos = bufpos,
      zindex = zindex,
      win = vim.api.nvim_get_current_win(),
    })
    table.insert(config.windows, preview_window)

    if config.conf.dismiss_on_move then
      vim.api.nvim_clear_autocmds({ group = "codebox-vanish" })
      vim.api.nvim_create_autocmd("CursorMoved", {
        callback = function()
          if not utils.is_anchored(preview_window) then
            dismiss_preview(preview_window)
          end
        end,
        group = "codebox-vanish",
        buffer = vim.api.nvim_win_get_buf(curr_win),
        once = true,
      })
    end

    vim.cmd([[ highlight NormalFloat guibg=none ]])
  end

  vim.api.nvim_win_set_var(preview_window, "is-codebox-window", 1)

  if config.conf.opacity then
    vim.api.nvim_win_set_option(preview_window, "winblend", config.conf.opacity)
  end

  utils.logger.debug(vim.inspect({
    curr_window = curr_win,
    preview_window = preview_window,
    bufpos = bufpos,
    get_config = vim.api.nvim_win_get_config(preview_window),
    get_current_line = vim.api.nvim_get_current_line(),
    windows = config.windows,
  }))

  -- Set position of the preview buffer equal to the target position so that correct preview position shows
  vim.diagnostic.disable(preview_buffer)
  vim.api.nvim_win_set_option(preview_window, "relativenumber", false)
  vim.api.nvim_win_set_option(preview_window, "number", false)
  vim.api.nvim_win_set_option(preview_window, "signcolumn", "no")
  vim.api.nvim_win_set_cursor(preview_window, position)

  run_hook_function(preview_buffer, preview_window)
end

return {
  toggle_dock = toggle_dock,
  remove_win = remove_win,
  buffer_entered = buffer_entered,
  open_floating_win = open_floating_win,
  close_all_win = close_all_win,
}
