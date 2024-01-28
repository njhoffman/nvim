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

local yank_selection = function(prompt_bufnr)
  local picker = action_state.get_current_picker(prompt_bufnr)
  local lines = {}
  local multi_targets = picker:get_multi_selection()
  if #multi_targets > 0 then
    for _, target in ipairs(multi_targets) do
      table.insert(lines, target.value or target[1])
    end
  else
    local single_target = action_state.get_selected_entry().value or action_state.get_selected_entry()[1]
    table.insert(lines, single_target)
  end
  local register = '+'
  if vim.o.clipboard == 'unnamed' then
    register = '*'
  end
  vim.fn.setreg(register, vim.fn.join(lines, '\n'))
  actions.close(prompt_bufnr)
  vim.notify('Copied ' .. #lines .. ' lines to register ' .. register, 2)
end

local yank_selection_to_buffer = function(prompt_bufnr)
  local picker = action_state.get_current_picker(prompt_bufnr)
  local lines = {}
  local multi_targets = picker:get_multi_selection()
  if #multi_targets > 0 then
    for _, target in ipairs(multi_targets) do
      table.insert(lines, target.value or target[1])
    end
  else
    local single_target = action_state.get_selected_entry().value or action_state.get_selected_entry()[1]
    table.insert(lines, single_target)
  end
  actions.close(prompt_bufnr)
  create_scratch_win('txt', lines)
end

return {
  yank_selection = yank_selection,
  yank_selection_to_buffer = yank_selection_to_buffer,
}
