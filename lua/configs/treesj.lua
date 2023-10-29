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

-- bash c cpp css dart go html java javascript json json5 jsonc kotlin lua nix perl
-- php pug python r ruby rust scss sql starlark svelte toml tsx typescript vue yaml

local langs = require('treesj.langs')['presets']
langs['sh'] = vim.deepcopy(langs['bash'])
langs['typescriptreact'] = vim.deepcopy(langs['tsx'])

local split_mapping = function()
  if langs[vim.bo.filetype] then
    -- TODO: if not toggleable node (node identifier is not configured) go to first parenthesis
    vim.keymap.set('n', 'gs', '<cmd>TSJToggle<cr>', { buffer = true, desc = 'treesj toggle cursor' })
    vim.keymap.set('n', 'gJ', '<cmd>TSJJoin<cr>', { buffer = true, desc = 'treesj join cursor' })
    vim.keymap.set('n', 'gS', '<cmd>TSJSplit<cr>', { buffer = true, desc = 'treesj split cursor' })
  else
    vim.keymap.set(
      'n',
      'gs',
      "<cmd>lua require('mini.splitjoin').toggle()<cr>",
      { buffer = true, desc = 'mini.sj toggle cursor' }
    )
    vim.keymap.set(
      'n',
      'gJ',
      "<cmd>lua require('mini.splitjoin').join_at()<cr>",
      { buffer = true, desc = 'mini.sj join cursor' }
    )
    vim.keymap.set(
      'n',
      'gS',
      "<cmd>lua require('mini.splitjoin').split_at()<cr>",
      { buffer = true, desc = 'mini.sj split cursor' }
    )
  end
end

vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, { pattern = '*', callback = split_mapping })
split_mapping()
