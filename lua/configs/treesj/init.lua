local langs = require('configs.treesj.langs')

require('treesj').setup({
  use_default_keymaps = false,
  cursor_behavior = 'hold',
  max_join_length = 1000,
  check_syntax_error = true,
  langs = langs,
})

local fallback_log = function(mode, results)
  vim.dbglog('fallback to mini.' .. mode, results[1])
end

local split_toggle = function()
  if langs[vim.bo.filetype] ~= nil then
    local node = require('configs.treesj.utils').check_ts_node()
    -- vim.dbglog('node', node)
    require('treesj').toggle()
  else
    local results = require('mini.splitjoin').toggle()
    fallback_log('toggle', results)
  end
end
vim.api.nvim_create_user_command('SplitToggle', split_toggle, {})

local split_split = function()
  if langs[vim.bo.filetype] ~= nil then
    require('treesj').split({ split = { recursive = true } })
  else
    local results = require('mini.splitjoin').split()
    fallback_log('split', results)
  end
end
vim.api.nvim_create_user_command('SplitSplit', split_split, {})

local split_join = function()
  if langs[vim.bo.filetype] ~= nil then
    require('treesj').join()
  else
    local results = require('mini.splitjoin').join()
    fallback_log('join', results)
  end
end
vim.api.nvim_create_user_command('SplitJoin', split_join, {})

local split_mapping = function()
  -- TODO: if not toggleable node (node identifier is not configured) go to first parenthesis
  vim.keymap.set(
    'n',
    'gs',
    '<cmd>SplitToggle<cr>',
    { buffer = false, desc = 'split toggle cursor' }
  )
  vim.keymap.set('n', 'gJ', '<cmd>SplitJoin<cr>', { buffer = false, desc = 'split join cursor' })
  vim.keymap.set('n', 'gS', '<cmd>SplitSplit<cr>', { buffer = false, desc = 'split split cursor' })
  -- TODO: make hover information about node format
  -- utils.check_ts_node()
end

-- vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, { pattern = '*', callback = split_mapping })
split_mapping()

--   H.map('n', maps.toggle, 'v:lua.MiniSplitjoin.operator("toggle") . " "', { expr = true, desc = 'Toggle arguments' })
--   H.map('n', maps.split,  'v:lua.MiniSplitjoin.operator("split") . " "',  { expr = true, desc = 'Split arguments' })
--   H.map('n', maps.join,   'v:lua.MiniSplitjoin.operator("join") . " "',   { expr = true, desc = 'Join arguments' })
--
--   H.map('x', maps.toggle, ':<C-u>lua MiniSplitjoin.toggle({ region = MiniSplitjoin.get_visual_region() })<CR>', { desc = 'Toggle arguments' })
--   H.map('x', maps.split,  ':<C-u>lua MiniSplitjoin.split({ region = MiniSplitjoin.get_visual_region() })<CR>',  { desc = 'Split arguments' })
--   H.map('x', maps.join,   ':<C-u>lua MiniSplitjoin.join({ region = MiniSplitjoin.get_visual_region() })<CR>',   { desc = 'Join arguments' })
