
  local gen_hook = require('mini.splitjoin').gen_hook

-- No need to copy this inside `setup()`. Will be used automatically.
local default_opt = {
  -- Module mappings, normal and visual modes
  mappings = { toggle = 'gS', split = '', join = '' },
  -- Detection options: where split/join should be done
  detect = {
    -- Array of Lua patterns to detect region with arguments.
    -- Default: { '%b()', '%b[]', '%b{}' }
    brackets = nil,

    -- String Lua pattern defining argument separator
    separator = ',',

    -- Array of Lua patterns for sub-regions to exclude separators from.
    -- Enables correct detection in presence of nested brackets and quotes.
    -- Default: { '%b()', '%b[]', '%b{}', '%b""', "%b''" }
    exclude_regions = nil,
  },

  -- Split options
  split = {
    hooks_pre = {},
    hooks_post = {},
  },

  -- Join options
  join = {
    hooks_pre = {},
    hooks_post = {},
  },
}

-- map with treesj and use splitjoin as fallback
local opts = {
  mappings = { toggle = '', split = '', join = '' },
}

require('mini.splitjoin').setup(opts)
