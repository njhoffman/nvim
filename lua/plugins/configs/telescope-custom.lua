local previewers = require("telescope.previewers")
local builtin = require("telescope.builtin")
local actions = require("telescope.actions")
local actions_state = require("telescope.actions.state")
local actions_set = require "telescope.actions.set"
local H = require("helpers")

local M = {}
M.previewers = {}
M.actions = {}

local open_method = "insert"

local _open_buffer = function(open_cmd, prompt_bufnr)
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

local _multi_open_qf = function(open_cmd, prompt_bufnr)
  actions.send_selected_to_qflist(prompt_bufnr)
  vim.cmd("cfdo " .. open_cmd)
end

local _multiopen = function(prompt_bufnr, open_cmd)
  local picker = actions_state.get_current_picker(prompt_bufnr)
  local selected_entry = actions_state.get_selected_entry()
  local multi_targets = picker:get_multi_selection()
  local num_selections = #multi_targets
  if not num_selections or num_selections <= 1 then
    -- actions.add_selection(prompt_bufnr)
    actions.select_default(prompt_bufnr)
  elseif (open_method == "quickfix") then
    _open_buffer(open_cmd, prompt_bufnr)
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

M.actions.multi_open_vsplit = function(prompt_bufnr)
  _multiopen(prompt_bufnr, "vsplit")
end

M.actions.multi_open_split = function(prompt_bufnr)
  _multiopen(prompt_bufnr, "split")
end

M.actions.multi_open_tab = function(prompt_bufnr)
  _multiopen(prompt_bufnr, "tabe")
end

M.actions.multi_open = function(prompt_bufnr)
  _multiopen(prompt_bufnr, "edit")
end

-- TODO: add special highglight for project
-- if self.prompt_prefix ~= "" then
--   vim.api.nvim_buf_add_highlight(
--     self.prompt_bufnr,
--     ns_telescope_prompt_prefix,
--     self._current_prefix_hl_group or "TelescopePromptPrefix",
--     0,
--     0,
--     #self.prompt_prefix
--   )
-- end
-- end

M.actions.switch_layout = function(prompt_bufnr)
  local opts = {}
  local _ = pcall(require "telescope".extensions.find_pickers.find_pickers, opts)
end

M.actions.find_pickers = function(prompt_bufnr)
  local opts = {}
  local _ = pcall(require "telescope".extensions.find_pickers.find_pickers, opts)
end

M.actions.results_toggle_down = function(prompt_bufnr)
  actions.toggle_selection(prompt_bufnr)
  actions.move_selection_next(prompt_bufnr, 1)
end

M.actions.results_toggle_up = function(prompt_bufnr)
  actions.toggle_selection(prompt_bufnr)
  actions.move_selection_previous(prompt_bufnr, -1)
end

M.actions.results_page_up = function(prompt_bufnr)
  -- actions_set.scroll_results(prompt_bufnr, 1)
  actions_set.shift_selection(prompt_bufnr, -15)
end
M.actions.results_page_down = function(prompt_bufnr)
  -- actions_set.scroll_results(prompt_bufnr, 1)
  actions_set.shift_selection(prompt_bufnr, 15)
end

M.actions.toggle_whichkey = function(prompt_bufnr)
  local whichkey_opts = {
    separator = " ➜ ",
    -- separator = " -> ",
    column_padding = " ",
    -- column_padding = "  "
    -- max_height = 0.4,
    -- only_show_current_mode = true,
    keybind_width = 6,
    -- keybind_width = 5,
    name_width = 20,
    -- name_width = 30,
    -- line_padding = 1,
    -- close_with_action = true,
    -- normal_hl = "TelescopePrompt",
    -- border_hl = "TelescopePromptBorder",
    -- winblend = 15, --  config.values.winblend,
  }
  actions.which_key(prompt_bufnr, whichkey_opts)
end

M.actions.switch_picker = function(prompt_bufnr)
  local picker = actions_state.get_current_picker(prompt_bufnr)
  local prompt_text = picker:_get_prompt()
  actions.close(prompt_bufnr)

  local opts = {
    default_text = prompt_text,
    -- results_title =
  }
  if picker.prompt_title == "Frecency" then
    local _ = pcall(require "telescope.builtin".oldfiles, opts)
  elseif picker.prompt_title == "Find Files" then
    local _ = pcall(require "telescope".extensions.frecency.frecency, opts)
  else
    local _ = pcall(require "telescope.builtin".find_files, opts)
  end
end

M.actions.directory_up = function(prompt_bufnr)
  local selection = actions_state.get_selected_entry()
  local picker = actions_state.get_current_picker(prompt_bufnr)
  local prompt_prefix = picker.prompt_prefix
  local dir = picker.cwd or vim.fn.getcwd() or selection.cwd

  if not string.match(dir, "^/") then
    dir = vim.fn.getcwd() .. "/" .. picker.cwd
  end

  if dir ~= "/" then
    dir = H.split_string(dir, "/")
    table.remove(dir)

    dir = "/" .. table.concat(dir, "/")
    dir = dir:gsub(vim.fn.getenv("HOME"), "~")
    actions.close(prompt_bufnr)

    local opts = {
      results_title = dir,
      find_command = { "rg", "--ignore", "--hidden", "--sort", "path", "--files" },
      cwd = dir,
      follow = true,
      prompt_prefix = prompt_prefix
    }
    local _ = pcall(require "telescope.builtin".find_files, opts)
  end
end

M.previewers.git_bcommits = function(opts)
  opts = opts or {}
  opts.previewer = previewers.new_termopen_previewer({
    get_command = function(entry)
      return {
        "git", "-c", "core.pager=delta", "-c", "delta.pager=less -R", "show", entry.value,
      }
    end,
  })

  builtin.git_bcommits(opts)
end

M.actions.git_status = function(opts)
  opts = opts or {}
  opts.previewer = previewers.new_termopen_previewer({
    get_command = function(entry)
      if entry.status == "D " then
        return { "git", "show", "HEAD:" .. entry.value }
      elseif entry.status == "??" then
        return { "bat", "--style=plain", entry.value }
      end
      return {
        "git", "-c", "core.pager=delta", "-c", "delta.pager=less -R", "diff", entry.value,
      }
    end,
  })

  -- Use icons that resemble the `git status` command line.
  opts.git_icons = {
    added = "A",
    changed = "M",
    copied = "C",
    deleted = "-",
    renamed = "R",
    unmerged = "U",
    untracked = "?",
  }

  builtin.git_status(opts)
end

return M

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
