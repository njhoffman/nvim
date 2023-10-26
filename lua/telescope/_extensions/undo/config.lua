-- full list of available config items and their defaults
local default_config = {
  use_delta = true,
  use_custom_command = nil, -- should be in this format: { "bash", "-c", "echo '$DIFF' | delta" }
  side_by_side = false,
  diff_context_lines = vim.o.scrolloff,
  -- entry_format = 'state #$ID, $STAT, $TIME',
  entry_format = '$NODE ($STAT) [$ID] $TIME',
  time_format = '',
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
--│┆         (-1) [18] 
--│┆  │ │    (+23) [17]
--│┆  │ ╶┘    (-5) [16]
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
