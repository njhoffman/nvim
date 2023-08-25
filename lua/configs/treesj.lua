local defaults = {
  -- Use default keymaps
  -- (<space>m - toggle, <space>j - join, <space>s - split)
  use_default_keymaps = true,

  -- Node with syntax error will not be formatted
  check_syntax_error = true,

  -- If line after join will be longer than max value,
  -- node will not be formatted
  max_join_length = 120,

  -- hold|start|end:
  -- hold - cursor follows the node/place on which it was called
  -- start - cursor jumps to the first symbol of the node being formatted
  -- end - cursor jumps to the last symbol of the node being formatted
  cursor_behavior = 'hold',

  -- Notify about possible problems or not
  notify = true,
  -- langs = langs,
  -- Use `dot` for repeat action
  dot_repeat = true,
}

require('treesj').setup({
  use_default_keymaps = false,
  max_join_length = 1000,
  check_syntax_error = false,
})

local langs = require('treesj.langs')['presets']

vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
  pattern = '*',
  callback = function()
    if langs[vim.bo.filetype] then
      vim.keymap.set('n', 'gs', '<Cmd>TSJToggle<CR>', { buffer = true, desc = 'treesj toggle cursor' })
      vim.keymap.set('n', 'gJ', '<Cmd>TSJJoin<CR>', { buffer = true, desc = 'treesj join cursor' })
      vim.keymap.set('n', 'gS', '<Cmd>TSJSplit<CR>', { buffer = true, desc = 'treesj split cursor' })
    else
      vim.keymap.set('n', 'gs', "require('mini.splitjoin').toggle", { buffer = true, desc = 'mini.sj toggle cursor' })
      vim.keymap.set('n', 'gJ', "require('mini.splitjoin').join_at", { buffer = true, desc = 'mini.sj join cursor' })
      vim.keymap.set('n', 'gS', "require('mini.splitjoin').split_at", { buffer = true, desc = 'mini.sj split cursor' })
    end
  end,
})
