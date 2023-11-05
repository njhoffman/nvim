-- https://github.com/uga-rosa/cmp-dynamic
local Date = require('cmp_dynamic.utils.date')

require('cmp').setup({
  -- other settings
  sources = {
    { name = 'dynamic' },
  },
})

require('cmp_dynamic').register({
  {
    label = 'today',
    insertText = function()
      return os.date('%Y/%m/%d')
    end,
  },
  {
    label = 'next Monday',
    insertText = function()
      return Date.new():add_date(7):day(1):format('%Y/%m/%d')
    end,
    resolve = true, -- default: false
  },
})
-- Basically, items conforms to LSP's CompletionItem. There is a special key resolve, and functions can be specified for any values.
-- By default, resolve is false. Setting it to true delays to evaluate the functions until it is complete. However, since label is a required field, it is evaluated first regardless of the value of resolve.
-- resolve = true
-- Press <CR>
-- resolve = false
-- Source of nvim-cmp to dynamically generate candidates using Lua functions.
-- Topics
-- nvim-cmp
