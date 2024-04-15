local actions = require('commands.ui.actions')
local utils = require('commands.ui.utils')

local setup_keymaps = function()
  vim.keymap.set(
    'n',
    '<C-S-Right>',
    utils.check_nav_split('l'),
    { noremap = true, desc = ' right split or tmux pane' }
  )
  vim.keymap.set(
    'n',
    '<C-S-Left>',
    utils.check_nav_split('h'),
    { noremap = true, desc = ' left split or tmux pane ' }
  )
  vim.keymap.set(
    'n',
    '<C-S-Down>',
    utils.check_nav_split('j'),
    { noremap = true, desc = 'ﰬ down split or tmux pane' }
  )
  vim.keymap.set(
    'n',
    '<C-S-Up>',
    utils.check_nav_split('k'),
    { noremap = true, desc = ' up split or tmux pane' }
  )
end

local setup_commands = function()
  vim.api.nvim_create_user_command(
    'CloseMulti',
    actions.close_multi,
    { desc = 'Close tabpage, window, or buffer in that order' }
  )

  vim.api.nvim_create_user_command(
    'CloseMultiNoPrompt',
    actions.close_multi_no_prompt,
    { desc = 'Close tabpage, window, or buffer in that order' }
  )

  vim.api.nvim_create_user_command(
    'ClosePopups',
    actions.close_popups,
    { desc = 'Format buffer using lsp' }
  )
end

-- vim.keymap.set('n', '<M-l>', ui.check_resize_split('l'), { noremap = true })
-- vim.keymap.set('n', '<M-h>', ui.check_resize_split('h'), { noremap = true })
-- vim.keymap.set('n', '<M-j>', ui.check_resize_split('j'), { noremap = true })
-- vim.keymap.set('n', '<M-k>', ui.check_resize_split('k'), { noremap = true })

-- vim.fn.feedkeys(vim.api.nvim_replace_termcodes('...',true,true,true))
-- TODO: c-s-d , c-s-f, c-s-h,l,j,k, c-s-|, c-s-+
--

local setup = function()
  setup_keymaps()
  setup_commands()
end

return { setup = setup }
