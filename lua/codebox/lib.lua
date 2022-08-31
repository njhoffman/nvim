local config = require("codebox.config")
local utils = require("codebox.utils")
local telescope = require("codebox.telescope")

local M = {
  conf = {},
  has_telescope = telescope.has_telescope,
  telescope = telescope.has_telescope and {
    themes = telescope.themes,
  } or nil,
  windows = {},
}

local setup_lib = function(conf)
  M.conf = conf
  utils.logger.debug("lib:", vim.inspect(M.conf))
end

local run_hook_function = function(buffer, new_window)
  local success, result = pcall(M.conf.post_open_hook, buffer, new_window)
  utils.logger.debug("post_open_hook call success:", success, result)
end

local remove_win = function(win)
  local index = utils.table_find(M.windows, win or vim.api.nvim_get_current_win())
  if index then
    table.remove(M.windows, index)
  end
end

local buffer_entered = function()
  local curr_buf = vim.api.nvim_get_current_buf()
  local curr_win = vim.api.nvim_get_current_win()

  local success, result = pcall(vim.api.nvim_win_get_var, curr_win, "is-codebox-window")
  vim.dbglog("buffer entered", curr_buf, curr_win)

  if success and result == 1 then
    utils.logger.debug("buffer_entered was called and will run hook function")
    run_hook_function(curr_buf, curr_win)
  end
end

local setup_aucmds = function()
  vim.api.nvim_create_augroup("codebox-vanish", { clear = true })
  vim.api.nvim_create_augroup("codebox", { clear = true })

  vim.api.nvim_create_autocmd("WinClosed", {
    callback = function(args)
      remove_win(tonumber(args.match))
    end,
    group = "codebox",
    desc = "Sync codebox floating windows with state",
  })

  vim.api.nvim_create_autocmd("BufEnter", {
    callback = function(args)
      buffer_entered(tonumber(args.match))
    end,
    group = "codebox",
    desc = "Run hook functions when entering codebox buffer",
  })
end

local close_if_is_goto_preview = function(win_handle)
  local success, result = pcall(vim.api.nvim_win_get_var, win_handle, "is-codebox-window")
  if success and result == 1 then
    vim.api.nvim_win_close(win_handle, M.conf.force_close)
  end
end

local dismiss_preview = function(winnr)
  if winnr then
    utils.logger.debug("attempting to close ", winnr, M.windows)
    close_if_is_goto_preview(winnr)
  else
    utils.logger.debug("closing all preview windows", M.windows)
    for _, win in ipairs(M.windows) do
      close_if_is_goto_preview(win)
    end
  end
end

local dock_to_edge = function(win, preview)
  local success, result = pcall(vim.api.nvim_win_get_var, preview, "is-codebox-window")
  if success and result == 1 then
    local size = {
      width = vim.api.nvim_win_get_width(win),
      height = vim.api.nvim_win_get_height(win),
    }
    -- vim.api.nvim_win_set_width(preview, new_width)
    -- vim.api.nvim_win_set_height(preview, new_neight)
    vim.api.nvim_clear_autocmds({ group = "codebox-vanish" })

    vim.api.nvim_win_set_config(preview, {
      relative = "win",
      row = size.height,
      col = size.width,
      win = win,
      anchor = "SE",
    })
  end
end

local open_floating_win = function(target, position, opts)
  local preview_buffer = type(target) == "string" and vim.uri_to_bufnr(target) or target
  local bufpos = { vim.fn.line(".") - 1, vim.fn.col(".") } -- FOR relative='win'
  local zindex = vim.tbl_isempty(M.windows) and 1 or #M.windows + 1

  opts = opts or {}
  local enter = function()
    if opts.focus_on_open ~= nil then
      return opts.focus_on_open
    else
      return M.conf.focus_on_open
    end
  end

  local stack_floating_preview_windows = function()
    if opts.stack_floating_preview_windows ~= nil then
      return opts.stack_floating_preview_windows
    else
      return M.conf.stack_floating_preview_windows
    end
  end

  utils.logger.debug("focus_on_open", enter())
  utils.logger.debug("stack_floating_preview_windows", stack_floating_preview_windows())

  local preview_window = {}
  local curr_win = vim.api.nvim_get_current_win()
  local success, result = pcall(vim.api.nvim_win_get_var, curr_win, "is-codebox-window")

  local width = opts.width or M.conf.width
  local height = opts.height or M.conf.height

  if string.find(tostring(width), "%%") then
    local pct = string.match(tostring(width), "([0-9]+)%%")
    local currwidth = vim.api.nvim_win_get_width(curr_win)
    width = math.floor(currwidth * pct / 100)
    vim.dbglog("new width", width, currwidth, pct)
  end

  if not stack_floating_preview_windows() and
    utils.is_floating(curr_win) and success and result == 1 then
    preview_window = curr_win
    vim.api.nvim_win_set_config(preview_window, {
      width = width,
      height = height,
      border = M.conf.border,
    })
    vim.api.nvim_win_set_buf(preview_window, preview_buffer)
  else
    preview_window = vim.api.nvim_open_win(preview_buffer, enter(), {
      relative = "win",
      width = width,
      height = height,
      border = M.conf.border,
      bufpos = bufpos,
      zindex = zindex,
      win = vim.api.nvim_get_current_win(),
    })

    table.insert(M.windows, preview_window)
  end

  vim.api.nvim_win_set_option(preview_window, "number", false)
  vim.api.nvim_win_set_option(preview_window, "relativenumber", false)
  if M.conf.opacity then
    vim.api.nvim_win_set_option(preview_window, "winblend", M.conf.opacity)
  end

  if vim.api.nvim_get_current_buf() ~= preview_buffer then
    vim.diagnostic.disable(preview_buffer)
    vim.api.nvim_buf_set_option(preview_buffer, "modifiable", false)
    vim.api.nvim_buf_set_option(preview_buffer, "modified", false)
    vim.api.nvim_buf_set_option(preview_buffer, "readonly", true)
    vim.api.nvim_buf_set_option(preview_buffer, "bufhidden", M.conf.bufhidden)
  end

  vim.api.nvim_win_set_var(preview_window, "is-codebox-window", 1)

  utils.logger.debug(vim.inspect({
    curr_window = curr_win,
    preview_window = preview_window,
    bufpos = bufpos,
    get_config = vim.api.nvim_win_get_config(preview_window),
    get_current_line = vim.api.nvim_get_current_line(),
    windows = M.windows,
  }))

  local dismiss = function()
    if opts.dismiss_on_move ~= nil then
      return opts.dismiss_on_move
    else
      return M.conf.dismiss_on_move
    end
  end

  utils.logger.debug("dismiss_on_move", dismiss())
  if dismiss() then
    vim.api.nvim_clear_autocmds({ group = "codebox-vanish" })
    local res = vim.api.nvim_create_autocmd("CursorMoved", {
      callback = function()
        dismiss_preview(preview_window)
      end,
      group = "codebox-vanish",
      buffer = vim.api.nvim_win_get_buf(curr_win),
      once = true,
    })
  end

  local dock_cmd = string.format("<cmd>lua require('codebox').dock_to_edge(%d, %d)<CR>", curr_win, preview_window)
  vim.api.nvim_set_keymap("n", "", dock_cmd, { noremap = true })

  -- Set position of the preview buffer equal to the target position so that correct preview position shows
  vim.api.nvim_win_set_cursor(preview_window, position)

  run_hook_function(preview_buffer, preview_window)
end


return {
  open_floating_win        = open_floating_win,
  close_if_is_goto_preview = close_if_is_goto_preview,
  dock_to_edge             = dock_to_edge,
  dismiss_preview          = dismiss_preview,
  buffer_entered           = buffer_entered,
  remove_win               = remove_win,
  setup_lib                = setup_lib,
  setup_aucmds             = setup_aucmds,
}
