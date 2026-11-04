local langs = require("configs.treesj.langs")
local treesj = require("treesj")

-- local region = opts.region or H.find_smallest_bracket_region(opts.position, opts.detect.brackets)

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
    local start_time = vim.uv.hrtime()
    local treesj_results = false
    local mini_results = try_mini(cmd)
    if not mini_results then
      -- local results = require("mini.splitjoin")[cmd]()
      treesj_results = require("treesj")[cmd]()
      fallback_log("treesj", cmd, treesj_results)
    end

    local diff_time = (vim.uv.hrtime() - start_time) / 1e6
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
  local map = require("lib.mapper").map
  map("n", "gs", align_op("toggle"), { desc = "split toggle cursor" })
  map("n", "gJ", align_op("join"), { desc = "split join cursor" })
  map("n", "gS", align_op("split"), { desc = "split split cursor" })
  -- utils.check_ts_node()
end

split_mapping()
