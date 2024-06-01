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
  -- on_attach = function(bufnr)
  --   local winid = vim.fn.bufwinid(bufnr)
  --   vim.api.nvim_set_option_value('winblend', 80, { win = winid })
  -- end,
})

-- keys = {
--   {
--     '<leader>otc',
--     function()
--       local Util = require('utils.inject')
--       local tsc = require('treesitter-context')
--       tsc.toggle()
--       if Util.inject.get_upvalue(tsc.toggle, 'enabled') then
--         vim.notify(
--           'Enabled Treesitter Context',
--           vim.lsp.log_levels.INFO,
--           { title = 'Option' }
--         )
--       else
--         vim.notify(
--           'Disabled Treesitter Context',
--           vim.lsp.log_levels.WARN,
--           { title = 'Option' }
--         )
--       end
--     end,
--     desc = 'Toggle Treesitter Context',
--   },
