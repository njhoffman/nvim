---@diagnostic disable-next-line: unused-local
local defaults = {
  ---Add a space b/w comment and the line
  padding = true,
  ---Whether the cursor should stay at its position
  sticky = true,
  ---Lines to be ignored while (un)comment
  ignore = nil,
  ---LHS of toggle mappings in NORMAL mode
  toggler = {
    ---Line-comment toggle keymap
    line = 'gcc',
    ---Block-comment toggle keymap
    block = 'gbc',
  },
  ---LHS of operator-pending mappings in NORMAL and VISUAL mode
  opleader = {
    ---Line-comment keymap
    line = 'gc',
    ---Block-comment keymap
    block = 'gb',
  },
  ---LHS of extra mappings
  extra = {
    ---Add comment on the line above
    above = 'gcO',
    ---Add comment on the line below
    below = 'gco',
    ---Add comment at the end of line
    eol = 'gcA',
  },
  ---Enable keybindings
  ---NOTE: If given `false` then the plugin won't create any mappings
  mappings = {
    ---Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
    basic = true,
    ---Extra mapping; `gco`, `gcO`, `gcA`
    extra = true,
  },
  ---Function to call before (un)comment
  pre_hook = nil,
  ---Function to call after (un)comment
  post_hook = nil,
}

-- vim.keymap.set('n', 'gcc', function()
--     return vim.v.count == 0
--         and '<Plug>(comment_toggle_linewise_current)'
--         or '<Plug>(comment_toggle_linewise_count)'
-- end, { expr = true })
--
-- -- Toggle in Op-pending mode
-- vim.keymap.set('n', 'gc', '<Plug>(comment_toggle_linewise)')
--
-- -- Toggle in VISUAL mode
-- vim.keymap.set('x', 'gc', '<Plug>(comment_toggle_linewise_visual)')

-- -- Toggle current line (linewise) using C-/
-- vim.keymap.set('n', '<C-_>', api.toggle.linewise.current)
--
-- -- Toggle current line (blockwise) using C-\
-- vim.keymap.set('n', '<C-\\>', api.toggle.blockwise.current)
--
-- -- Toggle lines (linewise) with dot-repeat support
-- -- Example: <leader>gc3j will comment 4 lines
-- vim.keymap.set(
--     'n', '<leader>gc', api.call('toggle.linewise', 'g@'),
--     { expr = true }
-- )
--
-- -- Toggle lines (blockwise) with dot-repeat support
-- -- Example: <leader>gb3j will comment 4 lines
-- vim.keymap.set(
--     'n', '<leader>gb', api.call('toggle.blockwise', 'g@'),
--     { expr = true }
-- )
--
-- local esc = vim.api.nvim_replace_termcodes(
--     '<ESC>', true, false, true
-- )
--
-- -- Toggle selection (linewise)
-- vim.keymap.set('x', '<leader>c', function()
--     vim.api.nvim_feedkeys(esc, 'nx', false)
--     api.toggle.linewise(vim.fn.visualmode())
-- end)
--
-- -- Toggle selection (blockwise)
-- vim.keymap.set('x', '<leader>b', function()
--     vim.api.nvim_feedkeys(esc, 'nx', false)
--     api.toggle.blockwise(vim.fn.visualmode())
-- end)
-- local api = require('Comment.api')
--
-- vim.keymap.set(
--     'n', '<leader>c', api.locked('toggle.linewise.current')
-- )
--
-- local esc = vim.api.nvim_replace_termcodes(
--     '<ESC>', true, false, true
-- )
-- vim.keymap.set('x', '<leader>c', function()
--     vim.api.nvim_feedkeys(esc, 'nx', false)
--     api.locked('toggle.linewise')(vim.fn.visualmode())
-- end)
-- vim.keymap.set(
--     'n', 'gc', api.call('toggle.linewise', 'g@'),
--     { expr = true }
-- )
-- vim.keymap.set(
--     'n', 'gcc', api.call('toggle.linewise.current', 'g@$'),
--     { expr = true }
-- )

-- Basic mappings
-- These mappings are enabled by default. (config: mappings.basic)

-- NORMAL mode
-- `gcc` - Toggles the current line using linewise comment
-- `gbc` - Toggles the current line using blockwise comment
-- `[count]gcc` - Toggles the number of line given as a prefix-count using linewise
-- `[count]gbc` - Toggles the number of line given as a prefix-count using blockwise
-- `gc[count]{motion}` - (Op-pending) Toggles the region using linewise comment
-- `gb[count]{motion}` - (Op-pending) Toggles the region using blockwise comment
-- VISUAL mode
-- `gc` - Toggles the region using linewise comment
-- `gb` - Toggles the region using blockwise comment

-- Extra mappings
-- These mappings are enabled by default. (config: mappings.extra)

-- NORMAL mode
-- `gco` - Insert comment to the next line and enters INSERT mode
-- `gcO` - Insert comment to the previous line and enters INSERT mode
-- `gcA` - Insert comment to end of the current line and enters INSERT mode

-- Extended mappings
-- These mappings are disabled by default. (config: mappings.extended)

-- NORMAL mode

-- `g>[count]{motion}` - (Op-pending) Comments the region using linewise comment
-- `g>c` - Comments the current line using linewise comment
-- `g>b` - Comments the current line using blockwise comment
-- `g<[count]{motion}` - (Op-pending) Uncomments the region using linewise comment
-- `g<c` - Uncomments the current line using linewise comment
-- `g<b`- Uncomments the current line using blockwise comment
-- VISUAL mode

-- `g>` - Comments the region using single line
-- `g<` - Unomments the region using single line
-- Examples

-- # Linewise

-- `gcw` - Toggle from the current cursor position to the next word
-- `gc$` - Toggle from the current cursor position to the end of line
-- `gc}` - Toggle until the next blank line
-- `gc5j` - Toggle 5 lines after the current cursor position
-- `gc8k` - Toggle 8 lines before the current cursor position
-- `gcip` - Toggle inside of paragraph
-- `gca}` - Toggle around curly brackets

-- # Blockwise

-- `gb2}` - Toggle until the 2 next blank line
-- `gbaf` - Toggle comment around a function (w/ LSP/treesitter support)
-- `gbac` - Toggle comment around a class (w/ LSP/treesitter support)

-- if cfg.mappings.basic then
--           -- NORMAL mode mappings
--           K('n', cfg.opleader.line, '<Plug>(comment_toggle_linewise)', { desc = 'Comment toggle linewise' })
--           K('n', cfg.opleader.block, '<Plug>(comment_toggle_blockwise)', { desc = 'Comment toggle blockwise' })
--
--           K('n', cfg.toggler.line, function()
--               return vvar('count') == 0 and '<Plug>(comment_toggle_linewise_current)'
--                   or '<Plug>(comment_toggle_linewise_count)'
--           end, { expr = true, desc = 'Comment toggle current line' })
--           K('n', cfg.toggler.block, function()
--               return vvar('count') == 0 and '<Plug>(comment_toggle_blockwise_current)'
--                   or '<Plug>(comment_toggle_blockwise_count)'
--           end, { expr = true, desc = 'Comment toggle current block' })
--
--           -- VISUAL mode mappings
--           K(
--               'x',
--               cfg.opleader.line,
--               '<Plug>(comment_toggle_linewise_visual)',
--               { desc = 'Comment toggle linewise (visual)' }
--           )
--           K(
--               'x',
--               cfg.opleader.block,
--               '<Plug>(comment_toggle_blockwise_visual)',
--               { desc = 'Comment toggle blockwise (visual)' }
--           )
--       end
--
--       -- Extra Mappings
--       if cfg.mappings.extra then
--           K('n', cfg.extra.below, api.insert.linewise.below, { desc = 'Comment insert below' })
--           K('n', cfg.extra.above, api.insert.linewise.above, { desc = 'Comment insert above' })
--           K('n', cfg.extra.eol, api.locked('insert.linewise.eol'), { desc = 'Comment insert end of line' })
--       end
--   end
