local action_state = require('telescope.actions.state')
local actions = require('telescope.actions')

local function create_scratch_win(filetype, lines)
  local buf, win
  filetype = (filetype == nil and 'result') or filetype
  vim.api.nvim_command('enew')
  win = vim.api.nvim_get_current_win()
  -- buf = vim.api.nvim_create_buf(true, true)
  buf = vim.api.nvim_win_get_buf(win)

  vim.api.nvim_buf_set_name(0, 'telecope-out #' .. buf)
  vim.api.nvim_buf_set_option(0, 'buftype', 'nofile')
  vim.api.nvim_buf_set_option(0, 'swapfile', false)
  vim.api.nvim_buf_set_option(0, 'filetype', filetype)
  vim.api.nvim_buf_set_option(0, 'bufhidden', 'wipe')

  vim.api.nvim_command('setlocal wrap')
  vim.api.nvim_command('setlocal cursorline')
  -- vim.api.nvim_win_set_buf(win, buf)
  vim.api.nvim_buf_set_lines(buf, 0, #lines, false, lines)
end

local get_yank_lines = function(picker)
  local lines = {}
  local multi_targets = picker:get_multi_selection()

  local add_line = function(target)
    local value = type(target.value) ~= 'nil' and target.value
      or type(target[1]) ~= 'nil' and target[1]
      or nil
    if value == nil then
      vim.notify('No value to yank\n' .. vim.inspect(target), 2)
    else
      table.insert(lines, tostring(value))
    end
  end

  if #multi_targets > 0 then
    for _, target in ipairs(multi_targets) do
      add_line(target)
    end
  else
    add_line(action_state.get_selected_entry())
  end
  return lines
end

local yank_selection = function(prompt_bufnr, opts)
  local picker = action_state.get_current_picker(prompt_bufnr)
  local lines = get_yank_lines(picker)
  if opts and type(opts.fn_yank) == 'function' then
    lines = opts.fn_yank(lines)
    return lines
  end

  local register = '+'
  if vim.o.clipboard == 'unnamed' then
    register = '*'
  end

  vim.fn.setreg(register, vim.fn.join(lines, '\n'))
  vim.notify('Copied ' .. #lines .. ' lines to register ' .. register, 2)
end

local yank_selection_to_buffer = function(prompt_bufnr)
  local picker = action_state.get_current_picker(prompt_bufnr)
  local lines = get_yank_lines(picker)
  actions.close(prompt_bufnr)
  create_scratch_win('txt', lines)
end

return {
  yank_selection = yank_selection,
  yank_selection_to_buffer = yank_selection_to_buffer,
}
