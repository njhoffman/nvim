-- No need to copy this inside `setup()`. Will be used automatically.
local default = {
  -- Module mappings. Use `''` (empty string) to disable one.
  mappings = {
    start = 'ga',
    start_with_preview = 'gA',
  },

  -- Modifiers changing alignment steps and/or options
  modifiers = {
    --   -- Main option modifiers
    --   ['s'] = --<function: enter split pattern>,
    --   ['j'] = --<function: choose justify side>,
    --   ['m'] = --<function: enter merge delimiter>,
    --
    --   -- Modifiers adding pre-steps
    --   ['f'] = --<function: filter parts by entering Lua expression>,
    --   ['i'] = --<function: ignore some split matches>,
    --   ['p'] = --<function: pair parts>,
    --   ['t'] = --<function: trim parts>,
    --
    --   -- Delete some last pre-step
    --   ['<BS>'] = --<function: delete some last pre-step>,
    --
    --   -- Special configurations for common splits
    --   ['='] = --<function: enhanced setup for '='>,
    --   [','] = --<function: enhanced setup for ','>,
    --   [' '] = --<function: enhanced setup for ' '>,
  },

  -- Default options controlling alignment process
  options = {
    split_pattern = '',
    justify_side = 'left',
    merge_delimiter = '',
  },

  -- Default steps performing alignment (if `nil`, default is used)
  steps = {
    pre_split = {},
    split = nil,
    pre_justify = {},
    justify = nil,
    pre_merge = {},
    merge = nil,
  },

  -- Whether to disable showing non-error feedback
  silent = false,
}

local opts = {
  mappings = {
    start = 'ga',
    start_with_preview = 'gA',
  },
}

require('mini.align').setup(opts)

-- Press s to enter split Lua pattern.
-- Press j to choose justification side from available ones ("left", "center", "right", "none").
-- Press m to enter merge delimiter.
-- Press f to enter filter Lua expression to configure which parts will be affected (like "align only first column").
-- Press i to ignore some commonly unwanted split matches.
-- Press p to pair neighboring parts so they be aligned together.
-- Press t to trim whitespace from parts.
-- Press <BS> (backspace) to delete some last pre-step.

-- ## Modifiers ~
--
-- `MiniAlign.config.modifiers` is used to define interactive user experience
-- of managing alignment process. It is a table with single character keys and
-- modifier function values.
--
-- Each modifier function:
-- - Is called when corresponding modifier key is pressed.
-- - Has signature `(steps, opts)` and should modify any of its input in place.
--
-- Examples:
-- - Modifier function used for default 'i' modifier:
-- >
--   function(steps, _)
--     table.insert(steps.pre_split, MiniAlign.gen_step.ignore_split())
--   end
-- <
-- - Tweak 't' modifier to use highest indentation instead of keeping it:
-- >
--   require('mini.align').setup({
--     t = function(steps, _)
--       table.insert(steps.pre_justify, MiniAlign.gen_step.trim('both', 'high'))
--     end
--   })
-- <
-- - Tweak `j` modifier to cycle through available "justify_side" option
--   values (like in 'junegunn/vim-easy-align'):
-- >
--   require('mini.align').setup({
--     modifiers = {
--       j = function(_, opts)
--         local next_option = ({
--           left = 'center', center = 'right', right = 'none', none = 'left',
--         })[opts.justify_side]
--         opts.justify_side = next_option or 'left'
--       end,
--     },
--   })
