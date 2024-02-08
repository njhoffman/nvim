-- https://github.com/numToStr/Comment.nvim

-- local api = require('Comment.api')
-- vim.keymap.set(
--     'n', 'gc', api.call('toggle.linewise', 'g@'),
--     { expr = true }
-- )
-- vim.keymap.set(
--     'n', 'gcc', api.call('toggle.linewise.current', 'g@$'),
--     { expr = true }
-- )
require('Comment').setup({
  toggler = {
    block = 'gcb',
  },
  mappings = {
    extended = true,
  },
  -- recognize treesitter pattern of react components and use jsx style comment
  pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
})
