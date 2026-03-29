local popup = {}

local create_buffer
local create_window
local handle_window
local determine_win_size
local scroll

function popup.open(choices, selection_callback)
  local bufnr = create_buffer(choices)
  local winid = create_window(bufnr, determine_win_size(choices))
  handle_window(bufnr, winid, selection_callback)
end

function create_buffer(choices)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, choices)
  vim.bo[buf].modifiable = false
  vim.bo[buf].modified = false
  return buf
end

function create_window(bufnr, height, width)
  local anchor = 'NW'

  local winid = vim.api.nvim_open_win(bufnr, true, {
    relative = 'win',
    row = 0,
    col = 0,
    anchor = anchor,
    width = width,
    height = height,
    style = 'minimal',
    float_opts = {
      -- row, col, height, width, relative, and anchor should not be
      -- overridden
      border = 'rounded',
      style = 'minimal',
      focusable = false,
      noautocmd = true,
    },
    focusable = true,
    noautocmd = true,
  })
  vim.wo[winid].cursorline = true
  vim.wo[winid].winhl = 'NormalFloat:TelescopePromptNormal,FloatBorder:TelescopePromptBorder'
  vim.api.nvim_exec('stopinsert', true)
  return winid
end

function handle_window(bufnr, winid, selection_callback)
  local map = require("mapper").map
  vim.api.nvim_create_autocmd({ 'BufEnter', 'BufLeave', 'FocusLost' }, {
    buffer = bufnr,
    callback = function()
      vim.api.nvim_win_close(winid, true)
      vim.api.nvim_buf_delete(bufnr, { force = true })
    end,
  })
  for _, k in ipairs({ '<Esc>', 'q' }) do
    map('', k, function()
      vim.api.nvim_exec_autocmds('FocusLost', { buffer = bufnr })
    end, { buffer = bufnr })
  end

  map('', '<Tab>', function()
    scroll(bufnr, winid, false)
  end, { buffer = bufnr })
  map('', '<S-Tab>', function()
    scroll(bufnr, winid, true)
  end, { buffer = bufnr })

  map('', '<CR>', function()
    local line = vim.api.nvim_get_current_line()
    vim.api.nvim_exec_autocmds('FocusLost', { buffer = bufnr })
    selection_callback(line)
  end, {
    buffer = bufnr,
  })
end

function determine_win_size(choices)
  local height = math.max(#choices, 1)
  local padding = 1
  local width = 5
  for _, s in ipairs(choices) do
    if s:len() + padding > width then
      width = s:len() + padding
    end
  end
  return height, width
end

function scroll(bufnr, winid, up)
  local cursor = vim.api.nvim_win_get_cursor(winid)
  local linenr = cursor[1]
  local lines = vim.api.nvim_buf_line_count(bufnr)

  local new_line = up and linenr - 1 or linenr + 1
  if new_line < 1 then
    new_line = lines
  elseif new_line > lines then
    new_line = 1
  end

  vim.api.nvim_win_set_cursor(winid, { new_line, 0 })
end

return popup
