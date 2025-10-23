local langs = require("configs.treesj.langs")
local treesj = require("treesj")

-- local region = opts.region or H.find_smallest_bracket_region(opts.position, opts.detect.brackets)

-- orig_split_at = vim.fn.deepcopy(MiniSplitjoin.split_at)
-- MiniSplitjoin.split_at = function(positions)
--   vim.dbglog("🪚 split positions: ", positions)
--   -- orig_split_at(positions)
-- end

-- orig_join_at = vim.fn.deepcopy(MiniSplitjoin.join_at)
-- MiniSplitjoin.join_at = function(positions)
--   vim.dbglog("🪚 join positions: ", positions)
--   -- orig_join_at(positions)
-- end

treesj.setup({
  use_default_keymaps = false,
  cursor_behavior = "hold",
  max_join_length = 2000,
  check_syntax_error = true,
  notify = false,
  langs = langs,
})

local fallback_log = function(target, cmd, results)
  vim.dbglog("fallback to " .. target .. "." .. cmd, results)
end

local try_treesj = function(cmd)
  local node = require("configs.treesj.utils").check_ts_node()
  return node ~= nil and langs[vim.bo.filetype] and (node == cmd or node == "toggle")
end

local try_mini = function(cmd)
  local pos = vim.fn.getpos(".")

  return require("mini.splitjoin")[cmd]({
    line = pos[1],
    column = pos[2],
  })
end

local align_op = function(cmd)
  return function()
    local start_time = vim.loop.hrtime()
    local treesj_results = false
    local mini_results = try_mini(cmd)
    if not mini_results then
      -- local results = require("mini.splitjoin")[cmd]()
      treesj_results = require("treesj")[cmd]()
      fallback_log("treesj", cmd, treesj_results)
    end

    -- if not try_treesj(cmd) then
    --   local results = require("mini.splitjoin")[cmd]()
    --   fallback_log(cmd, results)
    -- else
    --   require("treesj")[cmd]()
    -- end
    -- calculate diff time in ms
    local diff_time = (vim.loop.hrtime() - start_time) / 1e6
    vim.dbglog(
      diff_time,
      "mini: " .. vim.fn.empty(mini_results) and "false"
        or #mini_results .. ", " .. "treesj: " .. vim.fn.empty(treesj_results) and "false"
        or #treesj_results
    )
  end
end

vim.api.nvim_create_user_command("SplitToggle", align_op("toggle"), {})
vim.api.nvim_create_user_command("SplitSplit", align_op("split"), {})
vim.api.nvim_create_user_command("SplitJoin", align_op("join"), {})

local split_mapping = function()
  --   H.map('n', maps.toggle, 'v:lua.MiniSplitjoin.operator("toggle") . " "', { expr = true, desc = 'Toggle arguments' })
  --   H.map('n', maps.split,  'v:lua.MiniSplitjoin.operator("split") . " "',  { expr = true, desc = 'Split arguments' })
  --   H.map('n', maps.join,   'v:lua.MiniSplitjoin.operator("join") . " "',   { expr = true, desc = 'Join arguments' })
  --   H.map('x', maps.toggle, ':<C-u>lua MiniSplitjoin.toggle({ region = MiniSplitjoin.get_visual_region() })<CR>', { desc = 'Toggle arguments' })
  --   H.map('x', maps.split,  ':<C-u>lua MiniSplitjoin.split({ region = MiniSplitjoin.get_visual_region() })<CR>',  { desc = 'Split arguments' })
  --   H.map('x', maps.join,   ':<C-u>lua MiniSplitjoin.join({ region = MiniSplitjoin.get_visual_region() })<CR>',   { desc = 'Join arguments' })

  -- TODO: if not toggleable node (node identifier is not configured) go to first parenthesis
  vim.keymap.set("n", "gs", align_op("toggle"), { buffer = false, desc = "split toggle cursor" })
  vim.keymap.set("n", "gJ", align_op("join"), { buffer = false, desc = "split join cursor" })
  vim.keymap.set("n", "gS", align_op("split"), { buffer = false, desc = "split split cursor" })
  -- TODO: make hover information about node format
  -- utils.check_ts_node()
end

split_mapping()
