local actions = require("telescope.actions")
local actions_state = require("telescope.actions.state")
local H = require("helpers")

local custom_actions = {}

local open_method = "insert"

function custom_actions._open_buffer(open_cmd, prompt_bufnr)
  if open_cmd == "vsplit" then
    actions.file_vsplit(prompt_bufnr)
  elseif open_cmd == "split" then
    actions.file_split(prompt_bufnr)
  elseif open_cmd == "tabe" then
    actions.file_tab(prompt_bufnr)
  else
    -- actions.file_edit(prompt_bufnr)
    actions.select_default(prompt_bufnr)
  end
end

function custom_actions._multi_open_qf(open_cmd, prompt_bufnr)
  actions.send_selected_to_qflist(prompt_bufnr)
  vim.cmd("cfdo " .. open_cmd)
end

function custom_actions._multiopen(prompt_bufnr, open_cmd)
  local picker = actions_state.get_current_picker(prompt_bufnr)
  local selected_entry = actions_state.get_selected_entry()
  local multi_targets = picker:get_multi_selection()
  local num_selections = #multi_targets
  if not num_selections or num_selections <= 1 then
    actions.add_selection(prompt_bufnr)
  elseif (open_method == "quickfix") then
    custom_actions._open_buffer(open_cmd, prompt_bufnr)
  else -- insert method
    local cwd = picker.cwd
    if cwd == nil then
      cwd = ""
    else
      cwd = string.format("%s/", cwd)
    end

    vim.cmd("bw!") -- wipe the prompt buffer
    for _, entry in ipairs(multi_targets) do
      vim.cmd(string.format("%s %s%s", open_cmd, cwd, entry.value))
    end
  end
end

function custom_actions.multi_selection_open_vsplit(prompt_bufnr)
  custom_actions._multiopen(prompt_bufnr, "vsplit")
end

function custom_actions.multi_selection_open_split(prompt_bufnr)
  custom_actions._multiopen(prompt_bufnr, "split")
end

function custom_actions.multi_selection_open_tab(prompt_bufnr)
  custom_actions._multiopen(prompt_bufnr, "tabe")
end

function custom_actions.multi_selection_open(prompt_bufnr)
  custom_actions._multiopen(prompt_bufnr, "edit")
end

function custom_actions.switch_to_frecency(prompt_bufnr)
  actions.close(prompt_bufnr)
  -- local picker = actions_state.get_current_picker(prompt_bufnr)
  local ok = pcall(require "telescope".extensions.frecency.frecency)
  vim.schedule(
    function()
      vim.cmd [[startinsert]]
      -- vim.api.nvim_put({symbol}, "", true, true)
    end
  )
end

function custom_actions.directory_up(prompt_bufnr)
  local selection = actions_state.get_selected_entry()
  local picker = actions_state.get_current_picker(prompt_bufnr)
  local dir = picker.cwd or selection.cwd or vim.fn.getcwd()
  dir = H.split_string(dir, "/")
  table.remove(dir)
  dir = "/" .. table.concat(dir, "/")
  actions.close(prompt_bufnr)
  local opts = {
    results_title = dir,
    find_command = {"rg", "--ignore", "--hidden", "--sort", "path", "--files"},
    cwd = dir,
    follow = true,
    prompt_prefix = "🔍 "
  }

  local ok = pcall(require "telescope.builtin".find_files, opts)
  vim.schedule(
    function()
      vim.cmd [[startinsert]]
      -- vim.api.nvim_put({symbol}, "", true, true)
    end
  )
end

-- splits 'str' into pieces matching 'pat', returns them as an array
-- function custom_actions._multiopen(prompt_bufnr, open_cmd)
--   local picker = actions_state.get_current_picker(prompt_bufnr)
--   local num_selections = #picker:get_multi_selection()
--   if num_selections > 1 then
--     local cwd = picker.cwd
--     if cwd == nil then cwd = ""
--     else cwd = string.format("%s/", cwd) end

--     vim.cmd("bw!") -- wipe the prompt buffer
--     for _, entry in ipairs(picker:get_multi_selection()) do
--       vim.cmd(string.format("%s %s%s", open_cmd, cwd, entry.value))
--     end
--     vim.cmd("stopinsert")
--   else
--   end
-- end

return custom_actions
