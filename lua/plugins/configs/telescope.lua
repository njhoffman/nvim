local previewers = require "telescope.previewers"
local telescope = require("telescope")
local actions = require("telescope.actions")
local actions_layout = require "telescope.actions.layout"
local actions_state = require("telescope.actions.state")
local actions_set = require "telescope.actions.set"
local extensions = require("plugins.configs.telescope-extensions")

-- TODO: why can't replicate fuzzy matching behavior of fzf-lua
-- TODO: calculate page length for ctrl-f/ctrl-b

-- splits 'str' into pieces matching 'pat', returns them as an array
function split(str, pat)
  local t = {} -- NOTE: use {n = 0} in Lua-5.0
  local fpat = "(.-)" .. pat
  local last_end = 1
  local s, e, cap = str:find(fpat, 1)
  while s do
    if s ~= 1 or cap ~= "" then
      table.insert(t, cap)
    end
    last_end = e + 1
    s, e, cap = str:find(fpat, last_end)
  end
  if last_end <= #str then
    cap = str:sub(last_end)
    table.insert(t, cap)
  end
  return t
end

local custom_actions = {}
function custom_actions._multiopen(prompt_bufnr, open_cmd)
  local picker = actions_state.get_current_picker(prompt_bufnr)
  local selected_entry = actions_state.get_selected_entry()
  local num_selections = #picker:get_multi_selection()
  if not num_selections or num_selections <= 1 then
    actions.add_selection(prompt_bufnr)
  end
  actions.send_selected_to_qflist(prompt_bufnr)
  vim.cmd("cfdo " .. open_cmd)
end

-- function custom_actions._multiopen(prompt_bufnr, open_cmd)
--   local picker = actions_state.get_current_picker(prompt_bufnr)
--   local num_selections = #picker:get_multi_selection()
--   if num_selections > 1 then
--     local cwd = picker.cwd
--     if cwd == nil then
--       cwd = ""
--     else
--       cwd = string.format("%s/", cwd)
--     end
--     vim.cmd("bw!") -- wipe the prompt buffer
--     for _, entry in ipairs(picker:get_multi_selection()) do
--       vim.cmd(string.format("%s %s%s", open_cmd, cwd, entry.value))
--     end
--     vim.cmd("stopinsert")
--   else
--     if open_cmd == "vsplit" then
--       actions.file_vsplit(prompt_bufnr)
--     elseif open_cmd == "split" then
--       actions.file_split(prompt_bufnr)
--     elseif open_cmd == "tabe" then
--       actions.file_tab(prompt_bufnr)
--     else
--       -- actions.file_edit(prompt_bufnr)
--       actions.select_default(prompt_bufnr)
--     end
--   end
-- end

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
  dir = split(dir, "/")
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
      vim.api.nvim_put({symbol}, "", true, true)
    end
  )
end

local telescopeConfig = {
  defaults = {
    vimgrep_arguments = {
      "rg",
      -- "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--hidden",
      "--column",
      "--smart-case",
      "--vimgrep"
    },
    find_command = {"rg", "--ignore", "--hidden", "--files"},
    hidden = true,
    no_ignore = false,
    multi_icon = "◆ ",
    layout_config = {
      bottom_pane = {height = 25, preview_cutoff = 100, prompt_position = "top"},
      center = {preview_height = 0.5, height = 0.4, preview_cutoff = 40, prompt_position = "top", width = 0.5},
      cursor = {height = 0.9, preview_cutoff = 40, width = 0.8},
      horizontal = {height = 0.9, prompt_position = "top", width = 0.8, preview_cutoff = 80, preview_width = 0.5},
      vertical = {
        height = 0.9,
        preview_cutoff = 40,
        width = 0.8,
        prompt_position = "top",
        mirror = true,
        preview_height = 0.5
      },
      flex = {flip_columns = 130}
    },
    dynamic_preview_title = true,
    -- prompt_prefix = "λ ",
    prompt_prefix = " 🔍 ",
    selection_caret = "▶ ",
    selection_strategy = "reset", -- follow, reset, row
    sorting_strategy = "ascending",
    layout_strategy = "flex", -- flex, horizontal, veritical, center
    scroll_strategy = "cycle",
    color_devicons = true,
    winblend = 15,
    mappings = {
      i = {
        ["<esc>"] = actions.close,
        ["<c-f>"] = function(prompt_bufnr)
          actions_set.shift_selection(prompt_bufnr, 15)
        end,
        ["<c-b>"] = function(prompt_bufnr)
          actions_set.shift_selection(prompt_bufnr, -15)
        end,
        ["<c-u>"] = false,
        ["<a-n>"] = actions.toggle_selection + actions.move_selection_next,
        ["<a-p>"] = actions.toggle_selection + actions.move_selection_previous,
        ["<cr>"] = actions.select_default + actions.center,
        ["<c-w>"] = actions.send_selected_to_qflist + actions.open_qflist,
        ["<c-q>"] = actions.send_to_qflist + actions.open_qflist + actions.center,
        ["<c-_>"] = function(prompt_bufnr)
          actions_layout.toggle_preview(prompt_bufnr)
        end,
        ["<M-/>"] = actions.which_key,
        ["<C-DOWN>"] = require("telescope.actions").cycle_history_next,
        ["<C-UP>"] = require("telescope.actions").cycle_history_prev
        -- ["<tab>"] = actions.toggle_selection + actions.move_selection_next,
        -- ["<s-tab>"] = actions.toggle_selection + actions.move_selection_previous,
        -- ["<C-h>"] = actions.goto_file_selection_split,
        -- ["<C-v>"] = actions.goto_file_selection_vsplit
        -- ["<c-v>"] = custom_actions.multi_selection_open_vsplit,
        -- ["<c-s>"] = custom_actions.multi_selection_open_split,
        -- ["<c-t>"] = custom_actions.multi_selection_open_tab,
        -- ['<A- >'] = actions.toggle,
      },
      n = {
        ["<esc>"] = actions.close
        -- ["<c-j>"] = actions.move_selection_next,
        -- ["<c-k>"] = actions.move_selection_previous,
        -- ["<C-w>"] = actions.send_selected_to_qflist,
        -- ["<C-q>"] = actions.send_to_qflist,
        -- ["<c-f>"] = function(prompt_bufnr) action_set.shift_selection(prompt_bufnr, 15) end,
        -- ["<c-b>"] = function(prompt_bufnr) action_set.shift_selection(prompt_bufnr, -15) end,
        -- ["<tab>"] = actions.toggle_selection + actions.move_selection_next,
        -- ["<s-tab>"] = actions.toggle_selection + actions.move_selection_previous,
        -- ["<cr>"] = custom_actions.multi_selection_open,
        -- ["<c-v>"] = custom_actions.multi_selection_open_vsplit,
        -- ["<c-s>"] = custom_actions.multi_selection_open_split,
        -- ["<c-t>"] = custom_actions.multi_selection_open_tab,
        -- ["<tab>"] = actions.toggle_selection + actions.move_selection_next,
        -- ["<s-tab>"] = actions.toggle_selection + actions.move_selection_previous,
      }
    },
    file_sorter = require "telescope.sorters".get_fuzzy_file,
    -- file_previewer = previewers.vim_buffer_cat.new,
    generic_sorter = require "telescope.sorters".get_generic_fuzzy_sorter,
    -- generic_sorter = require"telescope.sorters".generic_sorter,
    grep_previewer = previewers.vim_buffer_vimgrep.new,
    qflist_previewer = previewers.vim_buffer_qflist.new,
    include_extensions = true,
    path_display = {"absolute"}, -- tail, hidden, absolute, shorten
    file_ignore_patterns = {},
    preview = {
      check_mime_type = true,
      filesize_limit = 25,
      timeout = 500, -- default 250
      treesitter = true,
      msg_bg_fillchar = "╱",
      hide_on_startup = false
    }
  },
  pickers = {
    find_files = {
      find_command = {"rg", "--ignore", "--hidden", "--sort", "path", "--files"},
      -- find_command = {"fd", "--type", "f", "--strip-cwd-prefix"},
      mappings = {
        i = {
          -- change directory functionality
          [":bd"] = custom_actions.directory_up,
          ["<C-g>"] = custom_actions.directory_up,
          ["<A-U>"] = custom_actions.switch_to_frecency,
          ["<cr>"] = custom_actions.multi_selection_open
        }
      }
    }
  },
  extensions = extensions.telescope_configs()
}

telescope.setup(telescopeConfig)

extensions.load_extensions(telescope)
