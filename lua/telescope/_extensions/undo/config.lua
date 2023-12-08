-- full list of available config items and their defaults
local default_config = {
  use_delta = true,
  use_custom_command = nil, -- should be in this format: { "bash", "-c", "echo '$DIFF' | delta" }
  side_by_side = false, -- TODO: turn into a function
  diff_context_lines = vim.o.scrolloff,
  time_format = '',
  -- entry_format = 'state #$ID, $STAT, $TIME',
  entry_format_center = '$NODE',
  entry_format_right = '$STAT_ADDED $STAT_DELETED [$ID] $TIME',
  -- entry_format_right = '($STAT_ADDED\1$STAT_DELETED) \r[$ID] $TIME',
  -- entry_format_funcs = { [1] = function(fields) return fields.stat_deleted and ' ' or '' }
  graph_type = 'graph', -- plain, graph
  direction = 'descending', -- ascending, descending
  mappings = {
    i = {
      ['<cr>'] = require('telescope._extensions.undo.actions').yank_additions,
      ['<S-cr>'] = require('telescope._extensions.undo.actions').yank_deletions,
      ['<C-cr>'] = require('telescope._extensions.undo.actions').restore,
    },
    n = {
      ['y'] = require('telescope._extensions.undo.actions').yank_additions,
      ['Y'] = require('telescope._extensions.undo.actions').yank_deletions,
      ['u'] = require('telescope._extensions.undo.actions').restore,
    },
  },
}

--│┆  
--│┆            (-1) [18] 3 hrs ago
--│┆  │ │    (+23 -4) [17] 4 hrs ago
--│┆  │ ╶┘       (-5) [16] 4 hrs ago
--│┆  ╶┘
-- 
-- ├─
-- ┆ ├─
-- ┆ └─
-- └─   ┃ │ ┊ ┊ ╯ ╮ 󰕡 󰓁 󰜘 󰘬 󰿟 󰤃 󰤂 󰺕 󰕞     󰤂  󰤂 ● ○ 󰺕
--  ﱣ    喙 כּ   ⭘         
-- the following prefix should work out to this graph structure:
-- state #1
-- └─state #2
-- state #3
-- ├─state #4
-- └─state #5
-- state #6
-- ├─state #7
-- ┆ ├─state #8
-- ┆ └─state #9
-- └─state #10

return default_config
