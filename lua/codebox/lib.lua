local has_telescope = pcall(require, "telescope")

local pickers
local make_entry
local telescope_conf
local finders
local actions
local action_state
local themes

local function init_telescope()
  pickers = require("telescope.pickers")
  make_entry = require("telescope.make_entry")
  telescope_conf = require("telescope.config").values
  finders = require("telescope.finders")
  actions = require("telescope.actions")
  action_state = require("telescope.actions.state")
  themes = require("telescope.themes")
end

if has_telescope then
  init_telescope()
end

local M = {
  conf = {},
  has_telescope = has_telescope,
  telescope = has_telescope and {
    themes = themes,
  } or nil,
}

M.setup_lib = function(conf)
  M.conf = vim.tbl_deep_extend("force", M.conf, conf)
  M.logger.debug("lib:", vim.inspect(M.conf))
end

local function is_floating(window_id)
  return vim.api.nvim_win_get_config(window_id).relative ~= ""
end

local logger = {
  debug = function(...)
    if M.conf.debug then
      -- print("codebox:", ...)
      vim.dbglog("codebox:", ...)
    end
  end,
}

M.logger = logger

local run_hook_function = function(buffer, new_window)
  local success, result = pcall(M.conf.post_open_hook, buffer, new_window)
  logger.debug("post_open_hook call success:", success, result)
end

function M.tablefind(tab, el)
  for index, value in pairs(tab) do
    if value == el then
      return index
    end
  end
end

M.remove_win = function(win)
  vim.dbglog("remove win", win, M.windows)
  local index = M.tablefind(M.windows, win or vim.api.nvim_get_current_win())
  if index then
    vim.dbglog("win index", index)
    table.remove(M.windows, index)
  end
end

M.windows = {}

M.setup_aucmds = function()
  vim.api.nvim_create_augroup("codebox-vanish", { clear = true })
  vim.api.nvim_create_augroup("codebox", { clear = true })

  vim.api.nvim_create_autocmd("WinClosed", {
    callback = function(args)
      vim.dbglog("winclosed: " .. tonumber(args.match), M.windows)
      M.remove_win(tonumber(args.match))
      -- require("codebox").remove_win(tonumber(args.match))
    end,
    group = "codebox",
  })

  vim.api.nvim_create_autocmd("BufEnter", {
    command = "lua require('codebox').buffer_entered()",
    group = "codebox",
  })
end

M.dismiss_preview = function(winnr)
  logger.debug("dismiss_preview", winnr)
  if winnr then
    logger.debug("attempting to close ", winnr, M.windows)
    M.close_if_is_goto_preview(winnr)
  else
    logger.debug("closing all preview windows", M.windows)
    for _, win in ipairs(M.windows) do
      M.close_if_is_goto_preview(win)
    end
  end
end

M.close_if_is_goto_preview = function(win_handle)
  local success, result = pcall(vim.api.nvim_win_get_var, win_handle, "is-codebox-window")
  if success and result == 1 then
    vim.dbglog("is_goto_preview", win_handle)
    vim.api.nvim_win_close(win_handle, M.conf.force_close)
    -- M.remove_win(win_handle)
  else
    vim.dbglog("no preview", win_handle)
  end
end

M.dock_to_edge = function(win, preview)
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

M.open_floating_win = function(target, position, opts)
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

  logger.debug("focus_on_open", enter())
  logger.debug("stack_floating_preview_windows", stack_floating_preview_windows())

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

  if not stack_floating_preview_windows() and is_floating(curr_win) and success and result == 1 then
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

  logger.debug(vim.inspect({
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

  logger.debug("dismiss_on_move", dismiss())
  if dismiss() then
    vim.api.nvim_clear_autocmds({ group = "codebox-vanish" })
    local res = vim.api.nvim_create_autocmd("CursorMoved", {
      callback = function(args)
        vim.dbglog("cursor moved", args.match, preview_window)
        M.dismiss_preview(preview_window)
      end,
      group = "codebox-vanish",
      buffer = vim.api.nvim_win_get_buf(curr_win),
      once = true,
    })
    vim.dbglog("Created autocmd", res, preview_buffer, preview_window, M.windows)
  end

  local dock_cmd = string.format("<cmd>lua require('codebox').dock_to_edge(%d, %d)<CR>", curr_win, preview_window)
  vim.api.nvim_set_keymap("n", "", dock_cmd, { noremap = true })

  -- Set position of the preview buffer equal to the target position so that correct preview position shows
  vim.api.nvim_win_set_cursor(preview_window, position)

  run_hook_function(preview_buffer, preview_window)
end

M.buffer_entered = function()
  local curr_buf = vim.api.nvim_get_current_buf()
  local curr_win = vim.api.nvim_get_current_win()

  local success, result = pcall(vim.api.nvim_win_get_var, curr_win, "is-codebox-window")
  vim.dbglog("buffer entered", curr_buf, curr_win)

  if success and result == 1 then
    logger.debug("buffer_entered was called and will run hook function")
    run_hook_function(curr_buf, curr_win)
  end
end

local function open_references_previewer(prompt_title, items)
  if has_telescope then
    local opts = M.conf.references.telescope
    local entry_maker = make_entry.gen_from_quickfix(opts)
    local previewer = nil

    if not opts.hide_preview then
      previewer = telescope_conf.qflist_previewer(opts)
    end

    pickers
      .new(opts, {
        prompt_title = prompt_title,
        finder = finders.new_table({
          results = items,
          entry_maker = entry_maker,
        }),
        previewer = previewer,
        sorter = telescope_conf.generic_sorter(opts),
        attach_mappings = function(prompt_bufnr)
          actions.select_default:replace(function()
            local selection = action_state.get_selected_entry()
            actions.close(prompt_bufnr)

            local val = selection.value
            M.open_floating_win(vim.uri_from_fname(val.filename), { val.lnum, val.col })
          end)

          return true
        end,
      })
      :find()
  else
    error("goto_preview_references requires Telescope.nvim")
  end
end

local handle = function(result, target, opts)
  if not result then
    return
  end

  local data = result[1] or result

  local _target = nil
  local cursor_position = {}

  if vim.tbl_isempty(data) then
    logger.debug("The LSP returned no results. No preview to display.")
    return
  end

  _target, cursor_position = M.conf.lsp_configs.get_config(data)

  -- opts: focus_on_open, dismiss_on_move, etc.
  M.open_floating_win(_target, cursor_position, opts)
end

local handle_references = function(result)
  if not result then
    return
  end
  local items = {}

  vim.list_extend(items, vim.lsp.util.locations_to_items(result, "utf-8") or {})

  open_references_previewer("References", items)
end

local legacy_handler = function(lsp_call, target, opts)
  return function(_, _, result)
    if lsp_call ~= nil and lsp_call == "textDocument/references" then
      logger.debug("raw result", vim.inspect(result))
      handle_references(result)
    else
      handle(result, target, opts)
    end
  end
end

local handler = function(lsp_call, target, opts)
  return function(_, result, _, _)
    if lsp_call ~= nil and lsp_call == "textDocument/references" then
      logger.debug("raw result", vim.inspect(result))
      handle_references(result)
    else
      handle(result, target, opts)
    end
  end
end

M.get_handler = function(lsp_call, target, opts)
  -- Only really need to check one of the handlers
  if debug.getinfo(vim.lsp.handlers["textDocument/definition"]).nparams == 4 then
    logger.debug("calling new handler")
    return handler(lsp_call, target, opts)
  else
    logger.debug("calling legacy handler")
    return legacy_handler(lsp_call, target, opts)
  end
end

return M
