-- TODO: attach to 'alternate' service

local timeago = require("commands.timeago")
local devicons = require("nvim-web-devicons")
local smoothie = require("commands.buffer.smoothie")

smoothie.setup_aucmds()
smoothie.setup_keymaps()

local Path = require("plenary.path")
local popup = require("plenary.popup")

local state = require("commands.buffer.state")

local function to_relative_path(path)
  return Path:new(path):make_relative(vim.loop.cwd())
end

local M = {}
M.push = function()
  local winid = vim.api.nvim_get_current_win()
  local bufnr = vim.api.nvim_get_current_buf()
  local bufnm = to_relative_path(vim.api.nvim_buf_get_name(bufnr))
  if not state.histories[winid] then
    state.histories[winid] = { index = 0, bufs = {} }
  end
  local h = state.histories[winid]
  if state.ignores[vim.bo.filetype] then
    return
  end

  local buf = h.bufs[h.index]
  if buf and buf.nr == bufnr then
    return
  end

  if h.index ~= #h.bufs then
    for i = #h.bufs, h.index + 1, -1 do
      table.remove(h.bufs, i)
    end
  end

  table.insert(h.bufs, { nr = bufnr, nm = bufnm, time = os.time(), ft = vim.bo.filetype })
  h.index = #h.bufs
end

M.back = function()
  local winid = vim.api.nvim_get_current_win()
  local h = state.histories[winid] or { index = 0 }
  local num_bufs = h and vim.isarray(h.bufs) and #h.bufs or 0
  if h.index > 1 then
    h.index = h.index - 1
    vim.api.nvim_set_current_buf(h.bufs[h.index].nr)
    vim.notify("buffer back: " .. h.index .. "/" .. num_bufs)
  else
    vim.notify("no more back history: " .. h.index .. "/" .. num_bufs)
  end
end

M.forward = function()
  local winid = vim.api.nvim_get_current_win()
  local h = state.histories[winid] or { index = 0 }
  local num_bufs = h and vim.isarray(h.bufs) and #h.bufs or 0
  if h.index < num_bufs then
    h.index = h.index + 1
    vim.api.nvim_set_current_buf(h.bufs[h.index].nr)
    vim.notify("buffer forward: " .. h.index .. "/" .. num_bufs)
  else
    vim.notify("no more forward history: " .. h.index .. "/" .. num_bufs)
  end
end

M.select_file_in_history = function()
  local index = vim.api.nvim_win_get_cursor(state.popup_winid)[1]
  M.toggle_popup()
  local winid = vim.api.nvim_get_current_win()
  vim.api.nvim_set_current_buf(vim.fn.reverse(state.histories[winid].bufs)[index].nr)
end

M.close_popup = function()
  if state.popup_winid and vim.api.nvim_win_is_valid(state.popup_winid) then
    vim.api.nvim_win_close(state.popup_winid, true)
    state.popup_winid = nil
    return true
  end
  return false
end

M.open_popup = function()
  if state.ignores[vim.bo.filetype] then
    return false
  end
  local winid = vim.api.nvim_get_current_win()
  local h = state.histories[winid]
  if not h then
    return false
  end

  local width = 0
  for _, buf in ipairs(h.bufs) do
    width = math.max(width, vim.fn.strdisplaywidth(buf.nm))
  end

  local contents = {}
  local line_width = 0
  for _, buf in ipairs(h.bufs) do
    -- local timeago = os.date("%H:%M", os.time() - buf.time)
    local buf_time = timeago(buf.time, { include_suffix = false, language = "short" })
    local line =
      string.format("%s %-" .. width .. "s %s", devicons.get_icon(buf.ft), buf.nm, buf_time)
    line_width = math.max(line_width, vim.fn.strdisplaywidth(line) + 4)
    table.insert(contents, line)
  end

  state.popup_winid = popup.create(vim.fn.reverse(contents), {
    title = state.popup_title or "History",
    borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    width = state.popup_width
      or math.min(line_width, math.max(vim.api.nvim_win_get_width(winid) / 2, 50)),
  })
  local bufnr = vim.api.nvim_win_get_buf(state.popup_winid)
  vim.api.nvim_set_option_value("modifiable", false, { buf = bufnr })
  vim.api.nvim_buf_set_keymap(
    bufnr,
    "n",
    "<CR>",
    "<Cmd> lua require('commands.buffer').select_file_in_history()<CR>",
    {}
  )
  vim.api.nvim_buf_add_highlight(bufnr, 0, "Identifier", #h.bufs - h.index, 0, -1)
  vim.api.nvim_set_option_value(
    "winhl",
    "CursorLineNr:Search,CursorLine:Search",
    { win = state.popup_winid }
  )
  vim.api.nvim_set_option_value("number", true, { win = state.popup_winid })
  vim.api.nvim_set_option_value("cursorline", true, { win = state.popup_winid })
  vim.api.nvim_win_set_cursor(state.popup_winid, { #h.bufs - h.index + 1, 0 })
  vim.api.nvim_create_autocmd("BufLeave", {
    buffer = bufnr,
    nested = true,
    once = true,
    callback = M.toggle_popup,
  })
  return true
end

M.toggle_popup = function()
  if M.close_popup() then
    return
  end

  M.open_popup()
end

M.setup = function(opts)
  if not opts then
    opts = {}
  end
  if not opts.keybinds then
    opts.keybinds = {}
  end

  if opts.popup_title then
    state.popup_title = opts.popup_title
  end
  if opts.popup_width then
    state.popup_width = opts.popup_width
  end
  if opts.set_keybinds ~= false then
    opts.set_keybinds = true
  end

  opts.popup_title = opts.popup_title or "History"
  -- opts.set_keybinds = opts.set_keybinds or true

  local history_nvim = vim.api.nvim_create_augroup("history_nvim", {
    clear = true,
  })

  vim.api.nvim_create_autocmd("BufEnter", {
    group = history_nvim,
    callback = M.push,
  })

  vim.api.nvim_create_user_command("BufferForward", M.forward, { desc = "󰃰 forward history" })
  vim.api.nvim_create_user_command("BufferBack", M.back, { desc = "󰃰 back history" })
  vim.api.nvim_create_user_command("BufferHistory", M.toggle_popup, { desc = "󰃰 view history" })
end

M.setup({})

return M
