-- https://raw.githubusercontent.com/nvim-telescope/telescope.nvim/master/README.md
local actions_layout = require("telescope.actions.layout")
local actions = require("telescope.actions")
local custom = require("plugs.config.telescope-nvim.custom")

local mainMaps = {
  i = {
    ["<C-u>"] = nil,
    ["<C-d>"] = nil,
    ["<Esc>"] = actions.close,
    ["kj"] = actions.close,
    ["<C-f>"] = custom.actions.results_page_down,
    ["<C-b>"] = custom.actions.results_page_up,
    ["<M-Down>"] = custom.actions.results_toggle_down,
    ["<M-Up>"] = custom.actions.results_toggle_up,
    ["<CR>"] = actions.select_default + actions.center,
    ["<C-w>"] = actions.send_selected_to_qflist + actions.open_qflist,
    ["<C-q>"] = actions.send_to_qflist + actions.open_qflist + actions.center,
    ["<C-_>"] = actions_layout.toggle_preview,
    ["<M-/>"] = custom.actions.toggle_whichkey,
    ["<C-Down>"] = actions.cycle_history_next,
    ["<C-Up>"] = actions.cycle_history_prev,
    ["<Down>"] = actions.preview_scrolling_down,
    ["<Up>"] = actions.preview_scrolling_up,
    ["<M-a>"] = actions.toggle_all,
    ["<C-Space>"] = custom.actions.find_pickers,
    ["<M-}>"] = custom.actions.switch_picker,
    ["<C-^>"] = custom.actions.switch_layout,
    -- [F1-9] = set primary sort if # not set, toggle primary/secondary if set
    -- [S-F1-9] = add/remove secondary sort #
    -- [??] = clear sort
  },
  n = {
    ["<Esc>"] = actions.close,
  },
}

local fileMaps = {
  i = {
    -- change directory functionality
    ["<M-U>"] = custom.actions.directory_up,
    ["<CR>"] = custom.actions.multi_open,
  },
}
local mappings = {
  main = mainMaps,
  file_picker = fileMaps,
}
return mappings
