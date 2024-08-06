local logger = require("logger").init("notify")

local find = function(array, key, val)
  for _, v in ipairs(array) do
    if v[key] == val then
      return v
    end
  end
end

local function open_lua_error(bufnr, path, line, orig_map)
  -- vim.api.nvim_set_current_win(currwin)
  -- vim.api.nvim_win_close(notify_win, true)
  local bufname = vim.api.nvim_buf_get_name(bufnr)
  local run_cmd = "edit"
  if bufname ~= path then
    run_cmd = "split"
  end

  if type(orig_map) == "table" and type(orig_map.lhs) == "string" then
    pcall(vim.api.nvim_del_keymap, { "n", "gF" })
    pcall(vim.api.nvim_set_keymap, {
      orig_map.mode,
      orig_map.lhs,
      orig_map.rhs,
      {
        nowait = orig_map.nowait,
        noremap = orig_map.noremap,
        silent = 1,
      },
    })
  end
  vim.cmd(run_cmd .. " +" .. line .. " " .. path)
end

local on_open_old = function(win)
  -- vim.api.nvim_win_set_option(win, 'winblend', 10)
  -- vim.api.nvim_win_set_option(win, 'wrap', false)
  -- vim.api.nvim_win_set_config(win, { zindex = 100 })
  local bufnr = vim.api.nvim_win_get_buf(win)
  local file_ok, notify_file = pcall(vim.api.nvim_buf_get_var, bufnr, "notify_file")
  local _, notify_line = pcall(vim.api.nvim_buf_get_var, bufnr, "notify_line")
  if file_ok and #notify_file > 0 then
    local orig_map = find(vim.api.nvim_get_keymap("n"), "lhs", "gF")
    logger:debug("file assigned (" .. notify_file .. ":" .. notify_line .. ")")
    vim.api.nvim_set_keymap("n", "gF", "", {
      callback = function()
        logger:info("going to error (" .. notify_file .. ":" .. notify_line .. ")")
        open_lua_error(bufnr, notify_file, notify_line, orig_map)
      end,
    })
  end
end

local function resize_window(wid, sizes, interval)
  interval = interval or 5
  local from = sizes.from
  local to = sizes.to
  vim.defer_fn(function()
    local inc = {
      w = to.width > from.width and 1 or to.width < from.width and -1 or 0,
      h = to.height > from.height and 1 or to.height < from.height and -1 or 0,
    }
    from.width = from.width + inc.w
    from.height = from.height + inc.h
    if vim.api.nvim_win_is_valid(wid) then
      vim.api.nvim_win_set_width(wid, from.width)
      vim.api.nvim_win_set_height(wid, from.height)
      if from.width ~= to.width or from.height ~= to.height and vim.api.nvim_win_is_valid(wid) then
        resize_window(wid, sizes)
      end
    end
  end, interval)
end

local on_replace = function(win, prev, next)
  -- _state, _buffer, _config,
  -- _notif.icon/id/level/message[]/filetype/highlights/title/on_open/on_close
  -- highlights.body/border/content/groups/icon/opacity
  local sizes = {
    from = { width = prev._width, height = prev._height },
    to = { width = next._width, height = next._height },
  }
  resize_window(win, sizes)
end

local on_open = function(win, record)
  -- local buf = vim.api.nvim_win_get_buf(win)
  -- local height = #record.message
  -- vim.dbglog('height', height)
  vim.api.nvim_win_set_config(win, { zindex = 200 })
  -- vim.api.nvim_set_option_value('sidescrolloff', 0, { win = win })
  -- local filetype = vim.api.nvim_buf_get_option(buf, 'filetype')
  -- vim.api.nvim_buf_set_option(buf, 'filetype', filetype)
end

return { on_open = on_open, on_replace = on_replace }
