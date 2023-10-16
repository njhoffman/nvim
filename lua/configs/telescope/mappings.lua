-- https://raw.githubusercontent.com/nvim-telescope/telescope.nvim/master/README.md
local actions_layout = require('telescope.actions.layout')
local actions = require('telescope.actions')
local c_actions = require('configs.telescope.actions')

local send_to_qflist = function(prompt_bufnr)
  actions.send_to_qflist(prompt_bufnr)
  actions.open_qflist(prompt_bufnr)
  actions.center(prompt_bufnr)
end

local select_default = function(prompt_bufnr)
  actions.select_default(prompt_bufnr)
  actions.center(prompt_bufnr)
end

-- local ignore = function(prompt_bufnr)
--   vim.notify('ignoring keystroke for ' .. prompt_bufnr, 0)
-- end

local ignore = false
local main_maps = {
  -- stylua: ignore
  -- NOTE: have to assign all possible custom keys here and filter later from lazy loading
  i = {
    ["<C-D>"]       = c_actions.search_reset,
    ["<C-U>"]       = c_actions.search_backspace_word,
    ["<Esc>"]       = actions.close,
    -- ["<M-d>"]       = actions.close,
    ["<CR>"]        = select_default,
    ["<C-Up>"]      = actions.cycle_history_prev,
    ["<C-Down>"]    = actions.cycle_history_next,
    ["<Up>"]        = actions.preview_scrolling_up,
    ["<Down>"]      = actions.preview_scrolling_down,
    ["<M-b>"]       = actions.preview_scrolling_up,
    ["<M-f>"]       = actions.preview_scrolling_down,
    ["<M-/>"]       = actions_layout.toggle_preview,
    ["<M-->"]       = actions.cycle_previewers_prev, -- Ctrl-Alt -
    ["<M-=>"]       = actions.cycle_previewers_next, -- Ctrl-Alt =
    ["<C-G>"]       = actions.move_to_top,
    ["<C-B>"]       = c_actions.results_page_up,
    ["<C-F>"]       = c_actions.results_page_down,
    ["<M-p>"]       = c_actions.results_toggle_up,
    ["<M-n>"]       = c_actions.results_toggle_down,
    ["<M-a>"]       = actions.toggle_all,
    ["<M-c>"]       = actions.drop_all,
    ["<C-Y>"]       = c_actions.yank_selection,
    ["<M-y>"]       = c_actions.yank_selection_to_buffer,
    ["<M-g>"]       = c_actions.launch_projects,
    ["<M-e>"]       = c_actions.launch_live_grep,
    ["<M-u>"]       = c_actions.launch_find_files,
    ['<M-C-_>']     = c_actions.toggle_whichkey,
    ["<C-^>"]       = c_actions.switch_layout,
    ["<M-C-Space>"] = c_actions.resume_picker_prev,
    ['<C-n>']       = actions.move_selection_next,
    ['<C-p>']       = actions.move_selection_previous,
    ["<S-Tab>"]     = actions.move_selection_previous,
    ["<Tab>"]       = actions.move_selection_next,
    -- ["<S-Tab>"]     = ignore, -- c_actions.results_toggle_up,
    -- ["<Tab>"]       = ignore, -- c_actions.results_toggle_down,
    ["<PageUp>"]    = ignore, -- actions.results_scrolling_up,
    ["<PageDown>"]  = ignore, -- actions.results_scrolling_down,
    ["<M-q>"]       = ignore,
    ["<M-{>"]       = ignore,
    ["<M-}>"]       = ignore,
    ["<M-,>"]       = ignore,
    ["<M-.>"]       = ignore,
    ["<M-k>"]       = ignore,
    ["<C-C>"]       = ignore,
    ["<C-L>"]       = ignore,
    ["<C-K>"]       = ignore,
    ["<C-X>"]       = ignore,
    ["<C-T>"]       = ignore,
    ["<C-V>"]       = ignore,
    -- [F1-9] = set primary sort if # not set, toggle primary/secondary if set
    -- [S-F1-9] = add/remove secondary sort #
    -- [??] = clear sort
  },
  n = {
    ['<Esc>'] = actions.close,
  },
}

local grep_maps = {
  i = {
    -- change directory functionality
    -- ["<C-Space>"] = false,
    -- ["<M-C-Space>"] = false,
    ['<M-{>'] = c_actions.switch_grep_pickers_prev,
    ['<M-}>'] = c_actions.switch_grep_pickers_next,
    ['<M-,>'] = c_actions.directory_up,
    ['<M-.>'] = c_actions.directory_picker,
    ['<CR>'] = c_actions.multi_open,
    ['<C-Q>'] = c_actions.multi_to_qflist,
  },
}

local file_picker_maps = {
  i = {
    ['<M-{>'] = c_actions.switch_file_pickers_prev,
    ['<M-}>'] = c_actions.switch_file_pickers_next,
    ['<M-,>'] = c_actions.directory_up,
    ['<M-.>'] = c_actions.directory_picker,
    ['<CR>'] = c_actions.multi_open,
    ['<C-Q>'] = c_actions.multi_to_qflist,
  },
}

local buffer_maps = {
  i = {
    ['<C-Del>'] = c_actions.buffer_delete,
  },
}

local mappings = {
  grep = grep_maps,
  main = main_maps,
  file_picker = file_picker_maps,
  buffer = buffer_maps,
}
return mappings

-- { "<leader>,", "<cmd>Telescope buffers show_all_buffers=true<cr>", desc = "Switch Buffer" },
-- { "<leader>/", Util.telescope("live_grep"), desc = "Find in Files (Grep)" },
-- { "<leader>:", "<cmd>Telescope command_history<cr>", desc = "Command History" },
-- { "<leader><space>", Util.telescope("files"), desc = "Find Files (root dir)" },
-- -- find
-- { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
-- { "<leader>ff", Util.telescope("files"), desc = "Find Files (root dir)" },
-- { "<leader>fF", Util.telescope("files", { cwd = false }), desc = "Find Files (cwd)" },
-- { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent" },
-- -- git
-- { "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "commits" },
-- { "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "status" },
-- -- search
-- { "<leader>sa", "<cmd>Telescope autocommands<cr>", desc = "Auto Commands" },
-- { "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Buffer" },
-- { "<leader>sc", "<cmd>Telescope command_history<cr>", desc = "Command History" },
-- { "<leader>sC", "<cmd>Telescope commands<cr>", desc = "Commands" },
-- { "<leader>sd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
-- { "<leader>sg", Util.telescope("live_grep"), desc = "Grep (root dir)" },
-- { "<leader>sG", Util.telescope("live_grep", { cwd = false }), desc = "Grep (cwd)" },
-- { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Help Pages" },
-- { "<leader>sH", "<cmd>Telescope highlights<cr>", desc = "Search Highlight Groups" },
-- { "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Key Maps" },
-- { "<leader>sM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
-- { "<leader>sm", "<cmd>Telescope marks<cr>", desc = "Jump to Mark" },
-- { "<leader>so", "<cmd>Telescope vim_options<cr>", desc = "Options" },
-- { "<leader>sR", "<cmd>Telescope resume<cr>", desc = "Resume" },
-- { "<leader>sw", Util.telescope("grep_string"), desc = "Word (root dir)" },
-- { "<leader>sW", Util.telescope("grep_string", { cwd = false }), desc = "Word (cwd)" },
-- { "<leader>uC", Util.telescope("colorscheme", { enable_preview = true }), desc = "Colorscheme with preview" },
-- {
--   "<leader>ss",
--   Util.telescope("lsp_document_symbols", {
--     symbols = {
--       "Class",
--       "Function",
--       "Method",
--       "Constructor",
--       "Interface",
--       "Module",
--       "Struct",
--       "Trait",
--       "Field",
--       "Property",
--     },
--   }),
--   desc = "Goto Symbol",
-- },
-- {
--   "<leader>sS",
--   Util.telescope("lsp_workspace_symbols", {
--     symbols = {
--       "Class",
--       "Function",
--       "Method",
--       "Constructor",
--       "Interface",
--       "Module",
--       "Struct",
--       "Trait",
--       "Field",
--       "Property",
--     },
--   }),
--   desc = "Goto Symbol (Workspace)",
-- },
