local langs = require("configs.treesj.langs")

require("treesj").setup({
  use_default_keymaps = false,
  cursor_behavior = "hold",
  max_join_length = 2000,
  check_syntax_error = true,
  langs = langs,
})

local fallback_log = function(mode, results)
  vim.dbglog("fallback to mini." .. mode, results)
end

local try_treesj = function(mode)
  local node = require("configs.treesj.utils").check_ts_node()
  return node ~= nil and langs[vim.bo.filetype] and (node == mode or mode == "toggle")
end

local split_toggle = function()
  if not try_treesj("toggle") then
    local results = require("mini.splitjoin").toggle()
    fallback_log("toggle", results)
  else
    require("treesj").toggle()
  end
end
vim.api.nvim_create_user_command("SplitToggle", split_toggle, {})

local split_split = function()
  if not try_treesj("split") then
    local results = require("mini.splitjoin").split()
    fallback_log("split", results)
  else
    require("treesj").split()
  end
end
vim.api.nvim_create_user_command("SplitSplit", split_split, {})

local split_join = function()
  if not try_treesj("join") then
    local results = require("mini.splitjoin").join()
    fallback_log("join", results)
  else
    require("treesj").join()
  end
end
vim.api.nvim_create_user_command("SplitJoin", split_join, {})

local split_mapping = function()
  -- TODO: if not toggleable node (node identifier is not configured) go to first parenthesis
  vim.keymap.set("n", "gs", split_toggle, { buffer = false, desc = "split toggle cursor" })
  vim.keymap.set("n", "gJ", split_join, { buffer = false, desc = "split join cursor" })
  vim.keymap.set("n", "gS", split_split, { buffer = false, desc = "split split cursor" })
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
