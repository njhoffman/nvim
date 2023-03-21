-- https://raw.githubusercontent.com/nvim-telescope/telescope.nvim/master/README.md
local actions_layout = require("telescope.actions.layout")
local actions = require("telescope.actions")
local c_actions = require("plugs.config.telescope.custom").actions

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
  -- stylua: ignore
  i = {
    ["<M-.>"]     = false,
    ["<M-,>"]     = false,
    ["<C-u>"]     = c_actions.backspace_word,
    ["<C-d>"]     = actions.close,
    ["<Esc>"]     = actions.close,
    ["<C-Down>"]  = actions.cycle_history_next,
    ["<C-Up>"]    = actions.cycle_history_prev,
    ["<Down>"]    = actions.preview_scrolling_down,
    ["<Up>"]      = actions.preview_scrolling_up,
    ["<C-f>"]     = c_actions.results_page_down,
    ["<C-b>"]     = c_actions.results_page_up,
    ["<M-n>"]     = c_actions.results_toggle_down,
    ["<M-p>"]     = c_actions.results_toggle_up,
    ["<C-q>"]     = send_to_qflist,
    ["<C-_>"]     = actions_layout.toggle_preview,
    ["<M-g>"]     = c_actions.launch_projects,
    ["<M-/>"]     = c_actions.toggle_whichkey,
    ["<M-}>"]     = c_actions.switch_picker,
    ["<C-^>"]     = c_actions.switch_layout,
    ["<M-a>"]     = actions.toggle_all,
    ["<C-Space>"] = c_actions.find_pickers,
    ["<CR>"]      = select_default,
    -- [F1-9] = set primary sort if # not set, toggle primary/secondary if set
    -- [S-F1-9] = add/remove secondary sort #
    -- [??] = clear sort
  },
  n = {
    ["<Esc>"] = actions.close,
  },
}

local grepMaps = {
  i = {
    -- change directory functionality
    ["<C-Space>"] = false,
    ["<M-C-Space>"] = false,
  },
}

local fileMaps = {
  i = {
    -- change directory functionality
    ["<M-.>"] = c_actions.launch_dirpicker,
    ["<M-,>"] = c_actions.directory_up,
    ["<CR>"] = c_actions.multi_open,
  },
}

local mappings = {
  grep = grepMaps,
  main = mainMaps,
  file_picker = fileMaps,
}
return mappings
