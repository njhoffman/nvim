-- https://raw.githubusercontent.com/nvim-telescope/telescope.nvim/master/README.md
local actions_layout = require("telescope.actions.layout")
local actions = require("telescope.actions")
local custom = require("plugs.config.telescope.custom")

local send_to_qflist = function(prompt_bufnr)
  actions.send_to_qflist(prompt_bufnr)
  actions.open_qflist(prompt_bufnr)
  actions.center(prompt_bufnr)
end

local select_default = function(prompt_bufnr)
  actions.select_default(prompt_bufnr)
  actions.center(prompt_bufnr)
end

local mainMaps = {
  i = {
    ["<C-u>"] = nil,
    ["<C-d>"] = nil,
    ["<Esc>"] = actions.close,
    ["kj"] = actions.close,
    ["<C-Down>"] = actions.cycle_history_next,
    ["<C-Up>"] = actions.cycle_history_prev,
    ["<Down>"] = actions.preview_scrolling_down,
    ["<Up>"] = actions.preview_scrolling_up,
    ["<C-f>"] = custom.actions.results_page_down,
    ["<C-b>"] = custom.actions.results_page_up,
    ["<M-Down>"] = custom.actions.results_toggle_down,
    ["<M-Up>"] = custom.actions.results_toggle_up,
    ["<C-q>"] = send_to_qflist,
    ["<C-_>"] = actions_layout.toggle_preview,
    ["<M-/>"] = custom.actions.toggle_whichkey,
    ["<M-}>"] = custom.actions.switch_picker,
    ["<C-^>"] = custom.actions.switch_layout,
    ["<M-a>"] = actions.toggle_all,
    ["<C-Space>"] = custom.actions.find_pickers,
    ["<CR>"] = select_default,
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
