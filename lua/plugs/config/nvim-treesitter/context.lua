require('treesitter-context').setup({
  enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
  max_lines = 2, -- How many lines the window should span. Values <= 0 mean no limit.
  trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
  mode = 'topline', -- Line used to calculate context. Choices: 'cursor', 'topline'
  patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
  -- For all filetypes
  default = {
    'class',
    'function',
    'method',
    -- 'for', -- These won't appear in the context
    -- 'while',
    -- 'if',
    -- 'switch',
    -- 'case',
  },
},
      })

