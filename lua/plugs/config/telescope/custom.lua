local previewers = require("telescope.previewers")
local builtin = require("telescope.builtin")
local actions = require("telescope.actions")
local config = require("telescope.config")
local action_state = require("telescope.actions.state")
local actions_set = require("telescope.actions.set")
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
  local picker = action_state.get_current_picker(prompt_bufnr)
  local multi_targets = picker:get_multi_selection()
  local num_selections = #multi_targets
  if not num_selections or num_selections <= 1 then
    -- actions.add_selection(prompt_bufnr)
    actions.select_default(prompt_bufnr)
  elseif open_method == "quickfix" then
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

M.actions.find_pickers = function(prompt_bufnr)
  local opts = {}
  local _ = pcall(require("telescope").extensions.find_pickers.find_pickers, opts)
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
    keybind_width = 9,
    -- keybind_width = 5,
    name_width = 25,
    winblend = 25,
    -- name_width = 30,
    -- line_padding = 1,
    -- close_with_action = true,
    -- mode_hl = "",
    name_hl = "TelescopeWhichKeyName",
    keybind_hl = "TelescopeWhichKeyKey",
    normal_hl = "TelescopeWhichKeyNormal",
    border_hl = "TelescopeWhichKeyBorder",
    -- normal_hl = "TelescopePrompt",
    -- border_hl = "TelescopePromptBorder",
    -- winblend = 15, --  config.values.winblend,
  }
  actions.which_key(prompt_bufnr, whichkey_opts)
end

M.actions.switch_layout = function(prompt_bufnr)
  local opts = {}
  local picker = action_state.get_current_picker(prompt_bufnr)

  if picker.layout_strategy == "bottom_pane" then
    opts = require("telescope.themes").get_dropdown()
  elseif picker.layout_strategy == "center" then
    opts.layout_config = config.values.layout_config
    opts.layout_strategy = "flex"
  elseif picker.layout_strategy == "flex" then
    opts = require("telescope.themes").get_cursor()
  elseif picker.layout_strategy == "cursor" then
    opts = require("telescope.themes").get_ivy()
  end
  opts.results_title = picker.results_title
  actions.close(prompt_bufnr)
  pcall(require("telescope.builtin").resume, opts)
end

M.actions.switch_picker = function(prompt_bufnr)
  local picker = action_state.get_current_picker(prompt_bufnr)
  local prompt_text = picker:_get_prompt()

  actions.close(prompt_bufnr)

  local opts = {
    default_text = prompt_text,
  }
  local run = require("telescope.run")
  if picker.prompt_title == "Frecency" then
    run("builtin", "oldfiles", opts)
  elseif picker.prompt_title == "Find Files" then
    run("frecency", "frecency", opts)
  elseif picker.prompt_title == "Oldfiles" then
    opts.prompt_text = opts.prompt_text or ""
    run("builtin", "live_grep", opts)
  else
    run("builtin", "find_files", opts)
  end
end

M.actions.directory_up = function(prompt_bufnr)
  local selection = action_state.get_selected_entry()
  local picker = action_state.get_current_picker(prompt_bufnr)
  local prompt_prefix = picker.prompt_prefix
  local dir = picker.cwd or vim.fn.getcwd() or selection.cwd

  if not string.match(dir, "^/") then
    dir = vim.fn.getcwd() .. "/" .. picker.cwd
  end

  if dir ~= "/" then
    local dir_split = H.split_string(dir, "/")
    table.remove(dir_split)
    dir = "/" .. table.concat(dir_split, "/")
    dir = dir:gsub(vim.fn.getenv("HOME"), "~")

    local opts = {
      results_title = dir,
      cwd = dir,
      follow = true,
      prompt_prefix = prompt_prefix,
    }

    actions.close(prompt_bufnr)
    -- picker:refresh(finders.new_oneshot_job(cmd, opts), {})
    local _ = pcall(require("telescope.builtin").find_files, opts)
  end
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
        "git",
        "-c",
        "core.pager=delta",
        "-c",
        "delta.pager=less -R",
        "diff",
        entry.value,
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

M.previewers.git_bcommits = previewers.new_termopen_previewer({
  get_command = function(entry)
    return {
      "git",
      "-c",
      "core.pager=delta",
      "-c",
      "delta.pager=less -R",
      "show",
      entry.value,
    }
  end,
})

M.previewers.delta = previewers.new_termopen_previewer({
  get_command = function(entry)
    if entry.status == "??" or "A " then
      return { "git", "diff", entry.value }
    end
    return { "git", "diff", entry.value .. "^!" }
  end,
})

return M

-- splits 'str' into pieces matching 'pat', returns them as an array
-- function custom_actions._multiopen(prompt_bufnr, open_cmd)
--   local picker = action_state.get_current_picker(prompt_bufnr)
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
