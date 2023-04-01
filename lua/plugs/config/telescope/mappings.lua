-- https://raw.githubusercontent.com/nvim-telescope/telescope.nvim/master/README.md
local actions_layout = require("telescope.actions.layout")
local actions = require("telescope.actions")
local c_actions = require("plugs.config.telescope.actions")

local send_to_qflist = function(prompt_bufnr)
  actions.send_to_qflist(prompt_bufnr)
  actions.open_qflist(prompt_bufnr)
  actions.center(prompt_bufnr)
end

local select_default = function(prompt_bufnr)
  actions.select_default(prompt_bufnr)
  actions.center(prompt_bufnr)
end

local ignore = function(prompt_bufnr)
  vim.notify("ignoring keystroke for " .. prompt_bufnr, 0)
end
local main_maps = {
  -- stylua: ignore
  -- NOTE: have to assign all possible custom keys here and filter later from lazy loading
  i = {
    ["<C-u>"]       = c_actions.backspace_word,
    ["<C-d>"]       = actions.close,
    ["<Esc>"]       = actions.close,
    ["<CR>"]        = select_default,
    ["<C-q>"]       = send_to_qflist,
    ["<C-Up>"]      = actions.cycle_history_prev,
    ["<C-Down>"]    = actions.cycle_history_next,
    ["<Up>"]        = actions.preview_scrolling_up,
    ["<Down>"]      = actions.preview_scrolling_down,
    ["<C-_>"]       = actions_layout.toggle_preview,
    ["<C-b>"]       = c_actions.results_page_up,
    ["<C-f>"]       = c_actions.results_page_down,
    ["<M-p>"]       = c_actions.results_toggle_up,
    ["<M-n>"]       = c_actions.results_toggle_down,
    ["<M-g>"]       = c_actions.launch_projects,
    ["<M-C-Space>"] = c_actions.launch_find_pickers,
    ["<M-e>"]       = c_actions.launch_live_grep,
    ["<M-u>"]       = c_actions.launch_find_files,
    ["<M-/>"]       = c_actions.toggle_whichkey,
    ["<C-^>"]       = c_actions.switch_layout,
    ["<M-}>"]       = ignore,
    ["<M-,>"]       = ignore,
    ["<M-.>"]       = ignore,
    ["<M-a>"]       = ignore,
    -- [F1-9] = set primary sort if # not set, toggle primary/secondary if set
    -- [S-F1-9] = add/remove secondary sort #
    -- [??] = clear sort
  },
  n = {
    ["<Esc>"] = actions.close,
  },
}

local grep_maps = {
  i = {
    -- change directory functionality
    -- ["<C-Space>"] = false,
    -- ["<M-C-Space>"] = false,
    -- ["<M-}>"] = c_actions.switch_grep_pickers,
    ["<M-}>"] = c_actions.switch_grep_pickers,
    ["<M-,>"] = c_actions.directory_up,
    ["<M-.>"] = c_actions.launch_dirpicker,
    ["<CR>"] = c_actions.multi_open,
    ["<M-a>"] = actions.toggle_all,
    ["<M-c>"] = actions.drop_all,
  },
}

local file_picker_maps = {
  i = {
    ["<M-}>"] = c_actions.switch_file_pickers,
    ["<M-,>"] = c_actions.directory_up,
    ["<M-.>"] = c_actions.launch_dirpicker,
    ["<CR>"] = c_actions.multi_open,
    ["<M-a>"] = actions.toggle_all,
    ["<M-c>"] = actions.drop_all,
  },
}

local buffer_maps = {
  i = {
    ["<C-Del>"] = c_actions.buffer_delete,
  },
}

local mappings = {
  grep = grep_maps,
  main = main_maps,
  file_picker = file_picker_maps,
  buffer = buffer_maps,
}
return mappings
