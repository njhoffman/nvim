local state = require('telescope.actions.state')
local builtin = require('telescope.builtin')
local actions = require('telescope.actions')

local finder = require('telescope._extensions.projects.finder')
local history = require('project_nvim.utils.history')
local project = require('project_nvim.project')
local config = require('project_nvim.config')

local run = require('telescope.run')

-- TODO: 'lock project directory' until original bufnr triggers project change
local function change_working_directory(prompt_bufnr)
  local selected_entry = state.get_selected_entry()
  if selected_entry == nil then
    return actions.close(prompt_bufnr)
  end
  -- actions.close(prompt_bufnr)
  local project_path = selected_entry.path
  vim.api.nvim_set_var('project_buf_skip', 1)
  local cd_successful = project.set_pwd(project_path, 'telescope')
  return project_path, cd_successful
end

local function find_project_files(prompt_bufnr)
  local project_path, cd_successful = change_working_directory(prompt_bufnr)
  local opt = {
    cwd = project_path,
    project_path = project_path,
    hidden = config.options.show_hidden,
    mode = 'insert',
  }
  if cd_successful then
    run('builtin', 'find_files', opt)
  end
end

local function browse_project_files(prompt_bufnr)
  local project_path, cd_successful = change_working_directory(prompt_bufnr)
  local opt = {
    cwd = project_path,
    hidden = config.options.show_hidden,
  }
  if cd_successful then
    run('builtin', 'file_browser', opt)
  end
end

local function search_in_project_files(prompt_bufnr)
  local project_path, cd_successful = change_working_directory(prompt_bufnr)
  local opt = {
    cwd = project_path,
    hidden = config.options.show_hidden,
    mode = 'insert',
  }
  if cd_successful then
    run('builtin', 'live_grep', opt)
  end
end

local function recent_project_files(prompt_bufnr)
  local _, cd_successful = change_working_directory(prompt_bufnr)
  local opt = {
    cwd_only = true,
    hidden = config.options.show_hidden,
  }
  if cd_successful then
    run('builtin', 'oldfiles', opt)
  end
end

local function delete_project(prompt_bufnr)
  local selectedEntry = state.get_selected_entry()
  if selectedEntry == nil then
    actions.close(prompt_bufnr)
    return
  end
  local choice = vim.fn.confirm("Delete '" .. selectedEntry.value .. "' from project list?", '&Yes\n&No', 2)

  if choice == 1 then
    history.delete_project(selectedEntry)

    state.get_current_picker(prompt_bufnr):refresh(finder.create(), {
      reset_prompt = true,
    })
  end
end

local function replace_default(prompt_bufnr)
  local on_project_selected = function()
    find_project_files(prompt_bufnr)
  end
  actions.select_default:replace(on_project_selected)
end

return {
  browse_project_files = browse_project_files,
  change_working_directory = change_working_directory,
  delete_project = delete_project,
  find_project_files = find_project_files,
  recent_project_files = recent_project_files,
  replace_default = replace_default,
  search_in_project_files = search_in_project_files,
}
