local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local actions_set = require("telescope.actions.set")

local M = {}

M.search_backspace_word = function(_)
  local backspace_key = vim.api.nvim_replace_termcodes("<C-w>", true, true, true)
  vim.api.nvim_feedkeys(backspace_key, "i", true)
end

M.search_jump_start = function(_)
  -- local home_key = vim.api.nvim_replace_termcodes("<Home>", true, true, true)
  local home_key = vim.api.nvim_replace_termcodes("<S-Left>", true, true, true)
  vim.api.nvim_feedkeys(home_key, "i", true)
end

M.search_jump_end = function(_)
  local end_key = vim.api.nvim_replace_termcodes("<End>", true, true, true)
  vim.api.nvim_feedkeys(end_key, "i", true)
end

M.search_jump_left = function(_)
  -- local home_key = vim.api.nvim_replace_termcodes("<Home>", true, true, true)
  local home_key = vim.api.nvim_replace_termcodes("L", true, true, true)
  vim.api.nvim_feedkeys(home_key, "i", true)
end

M.search_jump_right = function(_)
  local end_key = vim.api.nvim_replace_termcodes("H", true, true, true)
  vim.api.nvim_feedkeys(end_key, "i", true)
end

M.results_toggle_up = function(prompt_bufnr)
  actions.toggle_selection(prompt_bufnr)
  actions.move_selection_previous(prompt_bufnr)
end

M.results_toggle_down = function(prompt_bufnr)
  actions.toggle_selection(prompt_bufnr)
  actions.move_selection_next(prompt_bufnr)
end

-- TODO: smooth scroll results list
-- action_set.shift_selection = function(prompt_bufnr, change)
--   local count = vim.v.count
--   count = count == 0 and 1 or count
--   count = a.nvim_get_mode().mode == "n" and count or 1
--   action_state.get_current_picker(prompt_bufnr):move_selection(change * count)
-- end

M.results_page_up = function(prompt_bufnr)
  local picker = action_state.get_current_picker(prompt_bufnr)
  local results_height = vim.api.nvim_win_get_height(picker.results_win)
  actions_set.shift_selection(prompt_bufnr, -results_height - 1)
end

M.results_page_down = function(prompt_bufnr)
  local picker = action_state.get_current_picker(prompt_bufnr)
  local results_height = vim.api.nvim_win_get_height(picker.results_win)
  actions_set.shift_selection(prompt_bufnr, results_height - 1)
end

return M
