-- https://github.com/numToStr/Comment.nvim

require('Comment').setup({
  ignore = '^$',
  toggler = {
    line = 'gcc', -- [count]gcc
    block = 'gcb', -- gbc
  },
  opleader = {
    line = 'gc', -- normal and visual, gc[count]{motion}
    block = 'gb', -- normal and visual, gb[count]{motion}
  },
  extra = { above = 'gcO', below = 'gco', eol = 'gcA' },
  mappings = { basic = true, extra = true },
  -- recognize treesitter pattern of react components and use jsx style comment
  pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
})

local api = require('Comment.api')
local config = require('Comment.config'):get()

-- api.toggle.linewise(motion, config?)
-- api.toggle.linewise.current(motion?, config?)
-- api.toggle.linewise.count(count, config?)

-- api.toggle.blockwise(motion, config?)
-- api.toggle.blockwise.current(motion?, config?)
-- api.toggle.blockwise.count(count, config?)

-- Toggle current line (linewise) using C-/
vim.keymap.set('n', '<C-_>', api.toggle.linewise.current)

-- Toggle current line (blockwise) using C-\
-- vim.keymap.set('n', '<C-\\>', api.toggle.blockwise.current)

-- Toggle lines (linewise) with dot-repeat support
-- Example: <leader>gc3j will comment 4 lines
vim.keymap.set('n', '<leader>gc', api.call('toggle.linewise', 'g@'), { expr = true })

-- Toggle lines (blockwise) with dot-repeat support
-- Example: <leader>gb3j will comment 4 lines
vim.keymap.set('n', '<leader>gb', api.call('toggle.blockwise', 'g@'), { expr = true })

local esc = vim.api.nvim_replace_termcodes('<ESC>', true, false, true)

-- Toggle selection (linewise)
vim.keymap.set('x', '<leader>c', function()
  vim.api.nvim_feedkeys(esc, 'nx', false)
  api.toggle.linewise(vim.fn.visualmode())
end)

-- Toggle selection (blockwise)
vim.keymap.set('x', '<leader>b', function()
  vim.api.nvim_feedkeys(esc, 'nx', false)
  api.toggle.blockwise(vim.fn.visualmode())
end)
