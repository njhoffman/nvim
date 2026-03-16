-- https://raw.githubusercontent.com/nvim-telescope/telescope.nvim/master/README.md
local actions = require("telescope.actions")
local actions_layout = require("telescope.actions.layout")
local c_actions = require("configs.telescope.actions")

local send_to_qflist = function(prompt_bufnr)
  -- actions.send_to_qflist(prompt_bufnr)
  -- actions.open_qflist(prompt_bufnr)
  -- actions.center(prompt_bufnr)
  actions.smart_send_to_qflist(prompt_bufnr) -- sends selected, or if none selected, sends all
  vim.cmd.cfirst()
end

local select_default = function(prompt_bufnr)
  actions.select_default(prompt_bufnr)
  actions.center(prompt_bufnr)
end

local logger = require("logger").init("telescope")
local ignore_keys = function(keys)
  local ignore_map = {}
  for _, key in ipairs(keys) do
    -- ignore_map[key] = function(prompt_bufnr)
    --   logger:trace('ignoring ' .. key .. ' for ' .. prompt_bufnr)
    --   return false
    -- end
    ignore_map[key] = "nop"
  end
  return ignore_map
end

local main_maps = {
  -- stylua: ignore
  -- NOTE: have to assign all possible custom keys here and filter later from lazy loading
  i = vim.tbl_extend('force', {
    ["<C-\\>"]      = c_actions.flash,
    ["<C-D>"]       = c_actions.search_reset,
    ["<C-U>"]       = c_actions.search_backspace_word,
    ["<CR>"]        = actions.select_default,
    ["<C-G>"]       = actions.move_to_top,
    ["<M-g>"]       = actions.move_to_bottom,
    ['<C-n>']       = actions.move_selection_next,
    ['<C-p>']       = actions.move_selection_previous,
    ["<Tab>"]       = actions.move_selection_next,
    ["<M-C-Up>"]    = actions.move_selection_previous,
    ["<M-C-Down>"]  = actions.cycle_history_prev,
    ["<Down>"]      = actions.cycle_history_next,
    ["<C-S-Up>"]    = c_actions.preview_scroll_up,
    ["<C-S-Down>"]  = c_actions.preview_scroll_down,
    ["<M-b>"]       = c_actions.preview_page_up,
    ["<M-f>"]       = c_actions.preview_page_down,
    ["<M-w>"]       = c_actions.preview_toggle_wrap,

    ["<M-/>"]       = actions_layout.toggle_preview,
    ["<M-?>"]       = c_actions.toggle_whichkey,
    ["<M-_>"]       = actions.cycle_previewers_next,
    -- ["<M-(>"]       = actions.cycle_previewers_prev, -- Ctrl-Shift-(
    -- ["<M-)>"]       = actions.cycle_previewers_next, -- Ctrl-Shift-)
    -- ["<M-(>"]       = actions.cycle_previewers_prev, -- Ctrl-Shift-(
    -- ["<M-)>"]       = actions.cycle_previewers_next, -- Ctrl-Shift-)
    -- ["<C-B>"]    = c_actions.results_page_up,
    -- ["<C-F>"]    = c_actions.results_page_down,
    ["<C-B>"]       = actions.results_scrolling_up,
    ["<C-F>"]       = actions.results_scrolling_down,
    ["<M-P>"]       = c_actions.results_toggle_up,
    ["<M-n>"]       = c_actions.results_toggle_down,

    ["<M-a>"]       = actions.toggle_all,
    ["<C-c>"]       = actions.drop_all,
    ["<C-Y>"]       = c_actions.yank_selection,
    ["<M-y>"]       = c_actions.yank_selection_to_buffer,
    -- ["<M-g>"]       = c_actions.launch_projects,
    ["<C-e>"]       = c_actions.launch_buffers,
    ["<M-e>"]       = c_actions.launch_live_grep,
    ["<M-u>"]       = c_actions.launch_find_files,
    ["<M-T>"]       = c_actions.launch_find_pickers, -- Ctrl-Shift-T
    ["<M-C-Space>"] = c_actions.launch_find_pickers, -- Ctrl-Shift-Space
    ['<M-C-_>']     = c_actions.toggle_whichkey,     -- Ctrl-Shift-?
    ["<C-^>"]       = c_actions.search_jump_start,
    ["<M-$>"]       = c_actions.search_jump_end,
    ["<M-^>"]       = c_actions.switch_layout,       -- Ctrl-Shift-^
    ["<C-h>"]       = c_actions.search_jump_left,
    ["<C-l>"]       = c_actions.search_jump_right,
    ["<M-,>"]       = c_actions.prev_picker,
    ["<M-.>"]       = c_actions.next_picker,
    ["<Esc>"]       = c_actions.close,
    ["<M-c>"]       = actions.close,
    ["<C-X>"]       = c_actions.close,
    -- ["<M-d>"]    = actions.close,
  }, ignore_keys({
      '<C-Space>',
      "<M-d>",
      '<M-q>',
      "<M-{>",
      "<M-}>",
      -- "<M-k>",
      "<C-,>",
      "<C-.>",
      "<C-L>",
      "<C-K>",
      "<C-T>",
      "<C-V>",
    })
  ),
  n = {
    ["a"] = c_actions.codecompanion_add,
    ["q"] = actions.close,
    ["s"] = c_actions.flash,
  },
  -- [F1-9] = set primary sort if # not set, toggle primary/secondary if set [S-F1-9] = add/remove secondary sort #
  -- [??] = clear sort
}
local fzf_maps = {
  n = {
    ["q"] = actions.close,
    ["down"] = "down",
    ["up"] = "up",
    ["ctrl-c"] = "abort",
    ["ctrl-a"] = "toggle-all",
    ["ctrl-q"] = "select-all+accept",
    ["f3"] = "toggle-preview-wrap",
    ["f4"] = "toggle-preview",
    ["ctrl-d"] = "preview-page-down",
    ["ctrl-u"] = "preview-page-up",
  },
}
local grep_maps = {
  i = {
    -- change directory functionality
    ["<M-{>"] = c_actions.switch_grep_pickers_prev,
    ["<M-}>"] = c_actions.switch_grep_pickers_next,
    ["<M-lt>"] = c_actions.directory_up,
    ["<M->>"] = c_actions.directory_picker,
    ["<CR>"] = c_actions.multi_open,
    -- ['<C-Q>'] = c_actions.multi_to_qflist,
    ["<C-Q>"] = send_to_qflist,
  },
}

local file_maps = {
  i = {
    ["<M-{>"] = c_actions.switch_file_pickers_prev,
    ["<M-}>"] = c_actions.switch_file_pickers_next,
    ["<M-lt>"] = c_actions.directory_up,
    ["<M->>"] = c_actions.directory_picker,
    ["<CR>"] = c_actions.multi_open,
    -- ['<C-Q>'] = c_actions.multi_to_qflist,
    ["<C-Q>"] = send_to_qflist,
  },
}

local buffer_maps = {
  i = {
    ["<C-Del>"] = c_actions.delete_buffer,
    ["<M-d>"] = c_actions.delete_buffer,
    -- ['<C-Del>'] = 'delete_buffer',
    -- ['<M-d>'] = 'delete_buffer',
  },
}

local help_maps = {
  i = {
    ["<CR>"] = actions.select_vertical,
  },
}

local keymaps_maps = {
  i = {
    ["<C-Y>"] = c_actions.yank_keymaps,
    ["<M-y>"] = c_actions.yank_keymaps_to_buffer,
    ["<CR>"] = actions.select_vertical,
  },
}

local highlights_maps = {
  i = {
    ["<C-Y>"] = c_actions.yank_selection,
    ["<M-y>"] = c_actions.yank_selection_to_buffer,
    ["<CR>"] = c_actions.select_highlights,
  },
}

local mappings = {
  help = help_maps,
  grep = grep_maps,
  main = main_maps,
  file = file_maps,
  buffer = buffer_maps,
  highlights = highlights_maps,
  keymaps = keymaps_maps,
}

return mappings
