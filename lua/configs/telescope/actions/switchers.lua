local themes = require("configs.telescope.themes")
local config = require("telescope.config")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local run = require("configs.telescope.launcher")

local M = {}

M.switch_layout = function(prompt_bufnr, _opts)
  local opts = _opts or {}
  local picker = action_state.get_current_picker(prompt_bufnr)
  if picker.layout_strategy == "bottom_pane" then
    opts = themes.get_theme("dropdown_preview")
  elseif picker.layout_strategy == "center" then
    opts.layout_config = config.values.layout_config
    opts.layout_strategy = "flex"
  elseif picker.layout_strategy == "flex" then
    opts = themes.get_theme("cursor")
  elseif picker.layout_strategy == "cursor" then
    opts = themes.get_theme("ivy")
  end
  opts.results_title = picker.results_title
  actions.close(prompt_bufnr)

  vim.api.nvim_set_var("project_buf_skip", 1)
  run("builtin", "resume", opts)
end

M.switch_file_pickers_prev = function(prompt_bufnr)
  local picker = action_state.get_current_picker(prompt_bufnr)
  local opts = { default_text = picker:_get_prompt() }

  vim.api.nvim_set_var("project_buf_skip", 1)
  if picker.prompt_title == "Frecency" then
    run("builtin", "find_files", opts)
  elseif picker.prompt_title == "Find Files" then
    run("oldfiles", "oldfiles", opts)
  else
    run("frecency", "frecency", opts)
  end
end

M.switch_file_pickers_next = function(prompt_bufnr)
  local picker = action_state.get_current_picker(prompt_bufnr)
  local opts = { default_text = picker:_get_prompt() }

  vim.api.nvim_set_var("project_buf_skip", 1)
  if picker.prompt_title == "Frecency" then
    run("oldfiles", "oldfiles", opts)
  elseif picker.prompt_title == "Find Files" then
    run("frecency", "frecency", opts)
  else
    run("builtin", "find_files", opts)
  end
end

M.switch_grep_pickers_prev = function(prompt_bufnr)
  local picker = action_state.get_current_picker(prompt_bufnr)
  local opts = { default_text = picker:_get_prompt() }

  local bufnr = vim.api.nvim_win_get_buf(picker.original_win_id)
  local bufparts = vim.split(vim.api.nvim_buf_get_name(bufnr), "/")
  table.remove(bufparts)

  local is_grep_project = string.match(picker.prompt_title, "Live Grep Project")
    or picker.prompt_title == "Live Grep"
  local is_grep_buffer = string.match(picker.prompt_title, "Live Grep Buffers")
  local is_grep_cwd = string.match(picker.prompt_title, "Live Grep CWD")

  if is_grep_project then
    opts.cwd = vim.fn.join(bufparts, "/")
  elseif is_grep_buffer then
    opts.grep_open_files = false
  elseif is_grep_cwd then
    opts.grep_open_files = true
  end
  vim.api.nvim_set_var("project_buf_skip", 1)
  run("egrepify", "egrepify", opts)
end

M.switch_grep_pickers_next = function(prompt_bufnr)
  local picker = action_state.get_current_picker(prompt_bufnr)
  local opts = { default_text = picker:_get_prompt() }

  local bufnr = vim.api.nvim_win_get_buf(picker.original_win_id)
  local bufparts = vim.split(vim.api.nvim_buf_get_name(bufnr), "/")
  table.remove(bufparts)

  local is_grep_project = string.match(picker.prompt_title, "Live Grep Project")
    or picker.prompt_title == "Live Grep"
  local is_grep_buffer = string.match(picker.prompt_title, "Live Grep Buffers")
  local is_grep_cwd = string.match(picker.prompt_title, "Live Grep CWD")

  if is_grep_project then
    opts.grep_open_files = true
  elseif is_grep_buffer then
    opts.cwd = vim.fn.join(bufparts, "/")
  elseif is_grep_cwd then
    opts.grep_open_files = false
  end
  vim.api.nvim_set_var("project_buf_skip", 1)
  run("egrepify", "egrepify", opts)
end

M.launch_find_pickers = function()
  vim.api.nvim_set_var("project_buf_skip", 1)
  run("find_pickers", "find_pickers", {})
end

M.launch_buffers = function()
  vim.api.nvim_set_var("project_buf_skip", 1)
  run("leaderf", { theme = "dropdown" })
end

M.launch_find_files = function(prompt_bufnr)
  local picker = action_state.get_current_picker(prompt_bufnr)
  local opts = { default_text = picker:_get_prompt(), cwd = picker.cwd }
  vim.api.nvim_set_var("project_buf_skip", 1)
  run("builtin", "find_files", opts)
end

M.launch_live_grep = function(prompt_bufnr)
  local picker = action_state.get_current_picker(prompt_bufnr)
  local opts = { default_text = picker:_get_prompt(), cwd = picker.cwd }
  vim.api.nvim_set_var("project_buf_skip", 1)
  run("egrepify", "egrepify", opts)
end

return M
