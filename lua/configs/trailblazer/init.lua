local config = {
  auto_save_trailblazer_state_on_exit = true,
  auto_load_trailblazer_state_on_enter = true,
  custom_session_storage_dir = vim.fn.stdpath('data') .. '/trailblazer',
  trail_options = {
    available_trail_mark_modes = {
      'global_chron_buf_switch_group_chron',
      'buffer_local_line_sorted',
      -- 'custom_ord',
      --    This is a dynamic mode which will only be available and switched to once the trail mark order in any other selection mode has been manually changed from inside the trail mark list.
      -- 'global_chron',
      --    This is the default mode. Marks are traversed globally in chronological order.
      -- 'global_buf_line_sorted',
      --    Marks are sorted by their buffer id and globally traversed from BOF to EOF.
      -- 'global_fpath_line_sorted',
      --    Marks are sorted by their file path and globally traversed from BOF to EOF.
      -- 'global_chron_buf_line_sorted',
      --    Marks are sorted chronologically, then by their buffer id and globally traversed from lowest to highest line number.
      -- 'global_chron_fpath_line_sorted',
      --    Marks are sorted chronologically, then by their file path and globally traversed from lowest to highest line number.
      -- 'global_chron_buf_switch_group_chron',
      --    Marks are sorted chronologically, then by their buffer id and grouped by buffer switch events. Each group switch event is then traversed in chronological order.
      -- 'global_chron_buf_switch_group_line_sorted',
      --    Marks are sorted chronologically, then by their buffer id and grouped by buffer switch events. Each group switch event is then sorted from BOF to EOF within the respective buffer.
      -- 'buffer_local_chron',
      --    Only current buffer marks are traversed chronologically.
      -- 'buffer_local_line_sorted',
      --    Only current buffer marks are traversed from BOF to EOF.
    },
    current_trail_mark_mode = 'global_chron_buf_switch_group_chron',
    verbose_trail_mark_select = true,
    mark_symbol = '•',
    newest_mark_symbol = '',
    cursor_mark_symbol = '',
    next_mark_symbol = 'ﭠ',
    previous_mark_symbol = 'ﭢ',
    multiple_mark_symbol_counters_enabled = true,
    number_line_color_enabled = true,
    symmbol_line_enabled = true,
    trail_mark_in_text_highlights_enabled = true,
    trail_mark_list_rows = 5,
    trail_mark_symbol_line_indicators_enabled = true, -- show indicators for all trail marks in symbol column
    move_to_nearest_before_peek = true,
    move_to_nearest_before_peek_motion_directive_up = 'fpath_up',
    move_to_nearest_before_peek_motion_directive_down = 'fpath_down',
  },
  event_list = {
    'TrailBlazerTrailMarkStackSaved',
    -- "TrailBlazerTrailMarkStackDeleted",
    'TrailBlazerCurrentTrailMarkStackChanged',
    -- "TrailBlazerTrailMarkStackSortModeChanged"
  },
  force_mappings = { -- rename this to "force_mappings" to completely override default mappings
    nv = { -- Mode union: normal & visual mode. Can be extended by adding i, x, ...
      --stylua: ignore
      motions = {
        new_trail_mark                      = '<leader>n', -- '<A-l>',
        track_back                          = '<leader>.', -- '<A-b>',
        -- peek_move_next_down                 = '<leader>mm', -- '<A-J>',
        peek_move_next_down                 = '<C-n>', -- '<A-J>',
        peek_move_previous_up               = '<M-n>', -- '<A-K>',
        move_to_nearest                     = '<leader>m.', -- '<A-n>',
        toggle_trail_mark_list              = '<leader>mt', -- '<A-m>',
      },
      --stylua: ignore
      actions = {
        delete_all_trail_marks              = '<leader>md', -- '<A-L>',
        paste_at_last_trail_mark            = '<leader>mp', -- '<A-p>',
        paste_at_all_trail_marks            = '<leader>mP', -- '<A-P>',
        set_trail_mark_select_mode          = '<leader>mT', -- '<A-t>',
        switch_to_next_trail_mark_stack     = '<leader>m>', -- '<A-.>',
        switch_to_previous_trail_mark_stack = '<leader>m<', -- '<A-,>',
        set_trail_mark_stack_sort_mode      = '<leader>ms', -- '<A-s>',
      },
    },
  },
  -- rename this to "force_quickfix_mappings" to completely override default mappings}
  force_quickfix_mappings = {
    nv = {
      motions = {
        -- Jump to the trail mark under your cursor and set the current trail mark cursor.
        qf_motion_move_trail_mark_stack_cursor = '<CR>',
      },
      actions = {
        -- d	d	Delete the trail mark under your cursor or all trail marks within your selection.
        qf_action_delete_trail_mark_selection = 'd',
        -- v or V	v or V	Enter visual line mode and select multiple trail marks.
        qf_action_save_visual_selection_start_line = 'v',
      },
      alt_actions = {
        qf_action_save_visual_selection_start_line = 'V',
      },
    },
    v = {
      actions = {
        -- Jump to the trail mark under your cursor and set the current trail mark cursor
        qf_action_move_selected_trail_marks_down = '<C-S-Down>',
        -- Ctrl + k	<C-k>	Move trail marks within your selection up the stack.
        qf_action_move_selected_trail_marks_up = '<C-S-Up>jk',
      },
    },
  },
}

config.hl_groups = require('configs.trailblazer.highlights')

require('trailblazer').setup(config)

-- {
--   "<A-l>",
--   function() require("trailblazer").new_trail_mark() end,
--   desc = "Trailblazer: Create a new / toggle existing trail mark",
--   mode = { "n", "v" },
-- },
-- {
--   "<A-b>",
--   function() require("trailblazer").track_back() end,
--   desc = "Trailblazer: Move to the last global trail mark and remove it from the trail mark stack",
--   mode = { "n", "v" },
-- },
-- {
--   "<A-J>",
--   function() require("trailblazer").peek_move_next_down() end,
--   desc = "Trailblazer: Move to the next global trail mark",
--   mode = { "n", "v" },
-- },
-- {
--   "<A-K>",
--   function() require("trailblazer").peek_move_previous_up() end,
--   desc = "Trailblazer: Move to the previous global trail mark",
--   mode = { "n", "v" },
-- },
-- {
--   "<A-m>",
--   function() require("trailblazer").toggle_trail_mark_list() end,
--   desc = "Trailblazer: Toggle a global list of all trail marks",
--   mode = { "n", "v" },
-- },
-- {
--   "<A-S>",
--   function() require("trailblazer").delete_all_trail_marks() end,
--   desc = "Trailblazer: Delete all trail marks globally",
--   mode = { "n", "v" },
-- },
-- {
--   "<A-.>",
--   function() require("trailblazer").switch_to_next_trail_mark_stack() end,
--   desc = "Trailblazer: Switch to the next trail mark stack",
--   mode = { "n", "v" },
-- },
-- {
--   "<A-,>",
--   function() require("trailblazer").switch_to_previous_trail_mark_stack() end,
--   desc = "Trailblazer: Switch to the previous trail mark stack",
--   mode = { "n", "v" },
-- },
-- {
--   "<A-M>",
--   function()
--     vim.ui.input(
--       { prompt = "Stack Name: " },
--       function(input) require("trailblazer").switch_trail_mark_stack(input, false) end
--     )
--   end,
--   desc = "Trailblazer: Add new trail mark stack",
-- },
