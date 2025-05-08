-- ignore_keys({ '<C-Space>', "<M-d>", '<M-q>', "<M-{>", "<M-}>", "<M-k>",
-- "<C-,>", "<C-.>", "<C-L>", "<C-K>", "<C-T>", "<C-V>" })

-- ["<C-c>"]       = actions.drop_all,
-- ["<C-Y>"]       = yank_selection,
-- ["<M-y>"]       = yank_selection_to_buffer,
-- ["<M-g>"]       = launch_projects,
-- ["<C-e>"]       = launch_buffers,
-- ["<M-e>"]       = launch_live_grep,
-- ["<M-u>"]       = launch_find_files,
-- ["<M-T>"]       = launch_find_pickers, -- Ctrl-Shift-T
-- ["<M-C-Space>"] = launch_find_pickers, -- Ctrl-Shift-Space
-- ['<M-C-_>']     = toggle_whichkey,     -- Ctrl-Shift-?
-- ["<C-^>"]       = search_jump_start,
-- ["<M-$>"]       = search_jump_end,
-- ["<M-^>"]       = switch_layout,       -- Ctrl-Shift-^
-- ["<M-,>"]       = prev_picker,
-- ["<M-.>"]       = next_picker,
-- ["<C-\\>"]      = flash,
-- ["<C-D>"]       = search_reset,
-- ["<C-U>"]       = search_backspace_word,
-- ["<M-w>"]       = preview_toggle_wrap,

-- local grep_maps = {
--   i = {
--     -- change directory functionality
--     ["<M-{>"] = c_actions.switch_grep_pickers_prev,
--     ["<M-}>"] = c_actions.switch_grep_pickers_next,
--     ["<M-lt>"] = c_actions.directory_up,
--     ["<M->>"] = c_actions.directory_picker,
--     ["<CR>"] = c_actions.multi_open,
--     -- ['<C-Q>'] = c_actions.multi_to_qflist,
--     ["<C-Q>"] = send_to_qflist,
--   },
-- }

local custom_actions = {
  toggle_preview_wrap = function(picker)
    if picker.preview.win:valid() then
      vim.dbglog(picker.preview.win.wo)
    end
  end,
}
local picker_cfg = {
  prompt = " ",
  -- sources = {},
  -- focus = "input",
  -- layout = {
  --   cycle = true,
  --   --- Use the default layout or vertical if the window is too narrow
  --   preset = function()
  --     return vim.o.columns >= 120 and "default" or "vertical"
  --   end,
  -- },
  -- matcher = { sort_empty = false, filename_bonus = true, file_pos = true,
  --   cwd_bonus = false, frecency = false, history_bonus = false, }
  -- toggles = { follow = "f", hidden = "h", ignored = "i", modified = "m",
  -- regex = { icon = "R", value = false } },
  -- jump = {
  --   jumplist = true, -- save the current position in the jumplist
  --   tagstack = false, -- save the current position in the tagstack
  --   reuse_win = false, -- reuse an existing window if the buffer is already open
  --   close = true, -- close the picker when jumping/editing to a location (defaults to true)
  --   match = false, -- jump to the first match position. (useful for `lines`)
  -- },
  win = {
    -- input window
    input = {
      keys = {
        ["<Esc>"] = "close",
        -- ["<Esc>"] = { "close", mode = { "n", "i" } },
        ["<M-/>"] = { "toggle_preview", mode = { "i", "n" } },
        ["<M-?>"] = { "toggle_help_list", mode = { "i", "n" } },
        ["<c-f>"] = { "list_scroll_down", mode = { "i", "n" } },
        ["<c-b>"] = { "list_scroll_up", mode = { "i", "n" } },
        ["<M-b>"] = { "preview_scroll_up", mode = { "i", "n" } },
        ["<M-f>"] = { "preview_scroll_down", mode = { "i", "n" } },
        ["<M-P>"] = { "select_and_prev", mode = { "i", "n" } },
        ["<M-n>"] = { "select_and_next", mode = { "i", "n" } },
        ["<M-a>"] = { "select_all", mode = { "n", "i" } },
        ["<C-G>"] = { "list_scroll_top", mode = { "n", "i" } },
        ["<C-Space>"] = { "toggle_live", mode = { "i", "n" } },
        ["<C-Tab>"] = { "cycle_win", mode = { "i", "n" } },
        ["<M-C-H>"] = { "layout_left", mode = { "n", "i" } },
        ["<M-C-L>"] = { "layout_right", mode = { "n", "i" } },
        ["<M-NL>"] = { "layout_bottom", mode = { "n", "i" } },
        ["<M-C-K>"] = { "layout_top", mode = { "n", "i" } },
        ["<M-C-O>"] = { "toggle_maximize", mode = { "i", "n" } },
        ["<C-u>"] = { "<c-s-w>", mode = { "i" }, expr = true, desc = "delete word" },
        -- ["<a-d>"] = "inspect",
        -- ["/"] = "toggle_focus",
        -- ["<C-Down>"] = { "history_forward", mode = { "i", "n" } },
        -- ["<C-Up>"] = { "history_back", mode = { "i", "n" } },
        -- ["<C-c>"] = { "cancel", mode = "i" },
        -- ["<CR>"] = { "confirm", mode = { "n", "i" } },
        -- ["<Down>"] = { "list_down", mode = { "i", "n" } },
        -- ["<S-CR>"] = { { "pick_win", "jump" }, mode = { "n", "i" } },
        -- ["<Up>"] = { "list_up", mode = { "i", "n" } },
        -- ["<a-d>"] = { "inspect", mode = { "n", "i" } },
        -- ["<a-f>"] = { "toggle_follow", mode = { "i", "n" } },
        -- ["<a-h>"] = { i"toggle_hidden", mode = { "i", "n" } },
        -- ["<a-i>"] = { "toggle_ignored", mode = { "i", "n" } },
        -- ["<a-m>"] = { "toggle_maximize", mode = { "i", "n" } },
        -- ["<a-w>"] = { "cycle_win", mode = { "i", "n" } },
        -- ["<c-g>"] = { "toggle_live", mode = { "i", "n" } },
        -- ["<c-j>"] = { "list_down", mode = { "i", "n" } },
        -- ["<c-k>"] = { "list_up", mode = { "i", "n" } },
        -- ["<c-n>"] = { "list_down", mode = { "i", "n" } },
        -- ["<c-p>"] = { "list_up", mode = { "i", "n" } },
        -- ["<c-q>"] = { "qflist", mode = { "i", "n" } },
        -- ["<c-s>"] = { "edit_split", mode = { "i", "n" } },
        -- ["<c-v>"] = { "edit_vsplit", mode = { "i", "n" } },
        -- ["<c-t>"] = { "tab", mode = { "n", "i" } },
        -- ["<c-w>H"] = "layout_left",
        -- ["<c-w>J"] = "layout_bottom",
        -- ["<c-w>K"] = "layout_top",
        -- ["<c-w>L"] = "layout_right",
        -- ["?"] = "toggle_help_input",
        -- ["G"] = "list_bottom",
        -- ["gg"] = "list_top",
        -- ["j"] = "list_down",
        -- ["k"] = "list_up",
        -- ["q"] = "close",
      },
      b = {
        minipairs_disable = true,
      },
    },
    -- result list window
    list = {
      keys = {
        ["<M-C-H>"] = { "layout_left" },
        ["<M-C-L>"] = { "layout_right" },
        ["<M-NL>"] = { "layout_bottom" },
        ["<M-C-K>"] = { "layout_top" },
        ["<M-C-O>"] = { "toggle_maximize" },
        ["<c-f>"] = "list_scroll_down",
        ["<c-b>"] = "list_scroll_up",
        ["<M-/>"] = "toggle_preview",
        ["<M-?>"] = "toggle_help_list",
        -- ["i"] = "focus_input",
        -- ["/"] = "toggle_focus",
        -- ["<S-CR>"] = { { "pick_win", "jump" } },
        -- ["<S-Tab>"] = { "select_and_prev", mode = { "n", "x" } },
        -- ["<Tab>"] = { "select_and_next", mode = { "n", "x" } },
        -- ["<a-d>"] = "inspect",
        -- ["<c-t>"] = "tab",
        -- ["?"] = "toggle_help_list",
        -- ["G"] = "list_bottom",
        -- ["gg"] = "list_top",
      },
      wo = {
        conceallevel = 2,
        concealcursor = "nvc",
      },
    },
    preview = {
      keys = {
        ["<Esc>"] = "cancel",
        -- ["q"] = "close",
        -- ["i"] = "focus_input",
        -- ["<ScrollWheelDown>"] = "list_scroll_wheel_down",
        -- ["<ScrollWheelUp>"] = "list_scroll_wheel_up",
        -- ["<a-w>"] = "cycle_win",
      },
    },
  },
}

return picker_cfg
