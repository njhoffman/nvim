local miniclue = require('mini.clue')
local mapper_clues = require('mapper').clues or {}
local clues = vim.tbl_flatten({
  miniclue.gen_clues.builtin_completion(),
  miniclue.gen_clues.g(),
  miniclue.gen_clues.marks(),
  -- miniclue.gen_clues.registers(),
  miniclue.gen_clues.windows(),
  miniclue.gen_clues.z(),
})
for _, clue_item in ipairs(mapper_clues) do
  table.insert(clues, clue_item)
end

miniclue.setup({
  triggers = {
    -- Leader triggers
    { mode = 'n', keys = '<leader>' },
    { mode = 'x', keys = '<leader>' },

    -- Built-in completion
    { mode = 'i', keys = '<C-x>' },

    -- `g` key
    { mode = 'n', keys = 'g' },
    { mode = 'x', keys = 'g' },

    -- Marks
    { mode = 'n', keys = "'" },
    { mode = 'n', keys = '`' },
    { mode = 'x', keys = "'" },
    { mode = 'x', keys = '`' },

    -- Registers
    -- { mode = 'n', keys = '"' },
    -- { mode = 'x', keys = '"' },
    { mode = 'i', keys = '<C-r>' },
    { mode = 'c', keys = '<C-r>' },

    -- Window commands
    { mode = 'n', keys = '<C-w>' },

    -- `z` key
    { mode = 'n', keys = 'z' },
    { mode = 'x', keys = 'z' },
  },
  clues = clues,
  window = {
    -- Floating window config
    config = {},

    -- Delay before showing clue window
    delay = 300,

    -- Keys to scroll inside the clue window
    scroll_down = '<M-f>',
    scroll_up = '<M-b>',
  },
})
