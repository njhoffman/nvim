local actions = require("telescope.actions")
local config = require("telescope.config")
local action_state = require("telescope.actions.state")
local actions_set = require("telescope.actions.set")
local H = require("helpers")

local telethemes = require("telescope.telethemes")
local dirpicker = require("plugs.config.telescope.dirpicker")

local M = {}

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
      local edit_cmd = string.format("%s %s%s", open_cmd, cwd, entry.value)
      if entry.filename then
        edit_cmd = string.format("%s %s%s", open_cmd, cwd, entry.filename)
      end
      vim.cmd(edit_cmd)
    end
  end
end

M.multi_open_vsplit = function(prompt_bufnr)
  _multiopen(prompt_bufnr, "vsplit")
end

M.multi_open_split = function(prompt_bufnr)
  _multiopen(prompt_bufnr, "split")
end

M.multi_open_tab = function(prompt_bufnr)
  _multiopen(prompt_bufnr, "tabe")
end

M.multi_open = function(prompt_bufnr)
  _multiopen(prompt_bufnr, "edit")
end

M.results_toggle_down = function(prompt_bufnr)
  actions.toggle_selection(prompt_bufnr)
  actions.move_selection_next(prompt_bufnr, 1)
end

M.results_toggle_up = function(prompt_bufnr)
  actions.toggle_selection(prompt_bufnr)
  actions.move_selection_previous(prompt_bufnr, -1)
end

M.results_page_up = function(prompt_bufnr)
  -- actions_set.scroll_results(prompt_bufnr, 1)
  actions_set.shift_selection(prompt_bufnr, -15)
end

M.results_page_down = function(prompt_bufnr)
  -- actions_set.scroll_results(prompt_bufnr, 1)
  actions_set.shift_selection(prompt_bufnr, 15)
end

M.toggle_whichkey = function(prompt_bufnr)
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

M.switch_layout = function(prompt_bufnr)
  local opts = {}
  local picker = action_state.get_current_picker(prompt_bufnr)

  if picker.layout_strategy == "bottom_pane" then
    opts = telethemes.get_theme("dropdown")
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
  require("telescope.run")("builtin", "resume", opts)
end

M.switch_file_pickers = function(prompt_bufnr)
  -- TODO: apply cwd to find_files and live_grep
  local picker = action_state.get_current_picker(prompt_bufnr)
  local prompt_text = picker:_get_prompt()
  -- local state = require("telescope.actions.state")
  actions.close(prompt_bufnr)

  local opts = {
    default_text = prompt_text,
  }

  local run = require("telescope.run")
  if picker.prompt_title == "Frecency" then
    run("builtin", "oldfiles", opts)
  elseif picker.prompt_title == "Find Files" then
    run("frecency", "frecency", opts)
  else
    run("builtin", "find_files", opts)
  end
end

M.switch_grep_pickers = function(prompt_bufnr)
  -- TODO: apply cwd to find_files and live_grep
  local picker = action_state.get_current_picker(prompt_bufnr)
  local prompt_text = picker:_get_prompt()
  -- local state = require("telescope.actions.state")
  actions.close(prompt_bufnr)

  local cwd = vim.fn.getcwd()
  local bufnr = vim.api.nvim_win_get_buf(picker.original_win_id)
  local bufparts = vim.split(vim.api.nvim_buf_get_name(bufnr), "/")
  table.remove(bufparts)
  local bufdir = vim.fn.join(bufparts, "/")

  local is_grep_buffer = string.match(picker.results_title, "Buffers %([0-9]+%)")
  local is_dir_buffer = bufdir == picker.cwd and true or false

  local opts = {
    default_text = prompt_text,
  }
  if is_grep_buffer == nil and is_dir_buffer == false then
    opts.grep_open_files = true
  elseif is_grep_buffer ~= nil and is_dir_buffer == false then
    opts.cwd = bufdir
  elseif is_grep_buffer == nil and is_dir_buffer == true then
    opts.grep_open_files = false
  end

  local run = require("telescope.run")
  run("builtin", "live_grep", opts)
end

M.launch_find_pickers = function(prompt_bufnr)
  actions.close(prompt_bufnr)
  local run = require("telescope.run")
  run("find_pickers", "find_pickers", {})
end

M.launch_projects = function(prompt_bufnr)
  actions.close(prompt_bufnr)
  local run = require("telescope.run")
  run("projects", "projects", {})
end

M.launch_find_files = function(prompt_bufnr)
  actions.close(prompt_bufnr)
  local run = require("telescope.run")
  run("builtin", "find_files")
end

M.launch_live_grep = function(prompt_bufnr)
  actions.close(prompt_bufnr)
  local run = require("telescope.run")
  run("builtin", "live_grep")
end

M.launch_dirpicker = function(bufnr)
  local current_picker = action_state.get_current_picker(bufnr) -- picker state
  local picker_title = current_picker.prompt_title

  local opts = {}
  opts.result_title = "Choose Directory"
  local dirpicker_mappings = {
    default = function(directory)
      opts.cwd = directory
      opts.results_title = string.gsub(directory, os.getenv("HOME") or "", "~")
      if picker_title == "Find Files" then
        pcall(require("telescope.builtin").find_files, opts)
      elseif string.find(picker_title, "%^Grep") then
        pcall(require("telescope.builtin").live_grep, opts)
      else
        vim.notify("Error: don't know what picker to open: " .. picker_title)
      end
    end,
  }

  opts.mappings = dirpicker_mappings
  pcall(dirpicker.run, opts)
end

M.directory_up = function(prompt_bufnr)
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
    require("telescope.run")("builtin", "find_files", opts)
  end
end

M.backspace_word = function()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-w>", true, true, true), "i", true)
end

M.buffer_delete = function(prompt_bufnr)
  -- picker.cache_picker.limit_entries, picker.__scrolling_limit, picker.max_results,
  local selection = action_state.get_selected_entry()
  local opts = {
    -- show_all_buffers = true,
    -- sort_mru = true,
    -- mappings = mappings.buffer,
    -- ignore_current_buffer = false,
    -- only_cwd = false,
  }
  vim.cmd("BufferDelete " .. selection.value)
  actions.close(prompt_bufnr)
  require("telescope.run")("leaderf", opts)
  -- local picker = action_state.get_current_picker(prompt_bufnr)
  -- picker:refresh(finders.new_oneshot_job(cmd, opts), {})
  vim.notify("Closed  " .. selection.file_name, 1)
end

M.refresh = function(prompt_bufnr)
  local finders = require("telescope.finders")
  local make_entry = require("telescope.make_entry")

  local opts = {}
  opts.entry_maker = make_entry.gen_from_file(opts)

  local cmd = { "fd", "--type", "f", "--hidden" }
  local current_picker = action_state.get_current_picker(prompt_bufnr)
  current_picker:refresh(finders.new_oneshot_job(cmd, opts), {})
end

return M
