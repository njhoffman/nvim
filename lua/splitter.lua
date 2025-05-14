-- local treesj_langs = require("configs.treesj.langs")
-- local treesj = require("treesj")
-- local MAX_LENGTH = 1000

-- treesj.setup({
--   use_default_keymaps = false,
--   cursor_behavior = "hold",
--   max_join_length = 2000,
--   check_syntax_error = true,
--   notify = false,
--   treesj_langs = treesj_langs,
-- })

-- local fallback_log = function(target, cmd, results)
--   vim.dbglog("fallback to " .. target .. "." .. cmd, results)
-- end

-- local try_treesj = function(cmd)
--   local treesj = TreeSJ.new(tsn_data)
--   treesj:_build_tree()

--   local ok_format, err = pcall(treesj._format, treesj)
--   if not ok_format then
--     notify.warn(err)
--     return
--   end

--   local replacement = treesj:_get_lines()

--   if MODE == JOIN and #replacement[1] > MAX_LENGTH then
--     notify.info(msg.extra_longer:format(MAX_LENGTH))
--     return
--   end

--   return MODE, (er - sr + 1), #replacement
-- end

-- local try_mini = function(cmd)
--   local pos = vim.fn.getpos(".")
--   return require("mini.splitjoin")[cmd]({ line = pos[1], column = pos[2] })
-- end

-- local align_op = function(cmd)
--   local try_node = function()
--     local node = require("configs.treesj.utils").check_ts_node()
--     if node == nil then
--       return false
--     end
--     if treesj_langs[vim.bo.filetype] and (node == cmd or node == "toggle") then
--       return true
--     end
--     return false
--   end

--   return function()
--     if not try_mini(cmd) then
--       -- local mini_results = try_mini(cmd)
--       -- local results = require("mini.splitjoin")[cmd]()
--       local treesj_results = require("treesj")[cmd]()
--       fallback_log("treesj", cmd, treesj_results)
--     end

--     -- if not try_treesj(cmd) then
--     --   local results = require("mini.splitjoin")[cmd]()
--     --   fallback_log(cmd, results)
--     -- else
--     --   require("treesj")[cmd]()
--     -- end
--   end
-- end

-- vim.api.nvim_create_user_command("SplitToggle", align_op("toggle"), {})
-- vim.api.nvim_create_user_command("SplitSplit", align_op("split"), {})
-- vim.api.nvim_create_user_command("SplitJoin", align_op("join"), {})

-- local split_mapping = function()
--   --   H.map('n', maps.toggle, 'v:lua.MiniSplitjoin.operator("toggle") . " "', { expr = true, desc = 'Toggle arguments' })
--   --   H.map('n', maps.split,  'v:lua.MiniSplitjoin.operator("split") . " "',  { expr = true, desc = 'Split arguments' })
--   --   H.map('n', maps.join,   'v:lua.MiniSplitjoin.operator("join") . " "',   { expr = true, desc = 'Join arguments' })
--   --   H.map('x', maps.toggle, ':<C-u>lua MiniSplitjoin.toggle({ region = MiniSplitjoin.get_visual_region() })<CR>', { desc = 'Toggle arguments' })
--   --   H.map('x', maps.split,  ':<C-u>lua MiniSplitjoin.split({ region = MiniSplitjoin.get_visual_region() })<CR>',  { desc = 'Split arguments' })
--   --   H.map('x', maps.join,   ':<C-u>lua MiniSplitjoin.join({ region = MiniSplitjoin.get_visual_region() })<CR>',   { desc = 'Join arguments' })

--   -- TODO: if not toggleable node (node identifier is not configured) go to first parenthesis
--   vim.keymap.set("n", "gs", align_op("toggle"), { buffer = false, desc = "split toggle cursor" })
--   vim.keymap.set("n", "gJ", align_op("join"), { buffer = false, desc = "split join cursor" })
--   vim.keymap.set("n", "gS", align_op("split"), { buffer = false, desc = "split split cursor" })
--   -- TODO: make hover information about node format
--   -- utils.check_ts_node()
-- end

-- split_mapping()

-- -- local check_action = function(node)
-- --   -- =require('treesj.treesj').new(require('treesj.search').get_configured_node((require('treesj.format').get_node_at_cursor(vim.treesitter.get_parser(0)))))
-- --   --
-- --   local tu = require("treesj.treesj.utils")
-- --   if p and not p.format_empty_node then
-- --     if not p.non_bracket_node and tu.is_empty_node(node, p) then
-- --       return
-- --     end
-- --   end

-- --   if settings.check_syntax_error and node:has_error() then
-- --     notify.warn(msg.contains_error, node:type(), MODE)
-- --     return
-- --   end

-- --   if search.has_disabled_descendants(node, MODE, lang) then
-- --     local no_format_with = p and vim.inspect(p.no_format_with) or ""
-- --     notify.info(msg.no_format_with, MODE, node:type(), no_format_with)
-- --     return
-- --   end

-- --   tsn_data.mode = MODE
-- --   local treesj = TreeSJ.new(tsn_data)
-- --   treesj:_build_tree()

-- --   local ok_format, err = pcall(treesj._format, treesj)
-- --   if not ok_format then
-- --     notify.warn(err)
-- --     return
-- --   end

-- --   local replacement = treesj:_get_lines()
-- -- end
-- -- treesj.split({ fallback = check_action })

-- local _check_format = function(mode, override)
--   -- Tree reparsing is required, otherwise the tree may not be updated
--   -- and each node will be processed only once (until
--   -- the tree is updated). See issue #118
--   local ok_ts, parser = pcall(vim.treesitter.get_parser, 0)
--   if not ok_ts then
--     notify.error(msg.no_ts_parser)
--     return
--   end
--   parser:parse(true)

--   local start_node = M.get_node_at_cursor(parser)
--   if not start_node then
--     notify.info(msg.no_detect_node)
--     return
--   end

--   local found, tsn_data, node, p, sr, sc, er, ec, MODE, lang
--   local viewed = {}

--   -- If the node is marked as "disabled", continue searching from its parent.
--   while true do
--     found, tsn_data = pcall(search.get_configured_node, start_node)
--     if not found then
--       notify.warn(tsn_data)
--       return
--     end

--     -- If the found node has already been rejected, then finish
--     if vim.tbl_contains(viewed, tsn_data.tsnode) then
--       notify.info(msg.node_is_disable, MODE, node:type())
--       return
--     end

--     -- Required to create an independent copy of the preset
--     override = override or {}
--     tsn_data.preset = vim.tbl_deep_extend("force", tsn_data.preset, override)

--     node = tsn_data.tsnode
--     p = tsn_data.preset
--     lang = tsn_data.lang
--     sr, sc, er, ec = search.range(node, p)
--     MODE = mode or sr == er and SPLIT or JOIN
--     p = p[MODE]

--     local enable
--     if type(p.enable) == "function" then
--       enable = p.enable(node)
--     else
--       enable = p.enable
--     end

--     if not enable then
--       table.insert(viewed, node)
--       start_node = node:parent()
--     else
--       -- Need to use a copy of the preset so that it can be updated on the fly
--       tsn_data.preset = vim.tbl_deep_extend("force", {}, tsn_data.preset)
--       break
--     end
--   end

--   if type(p.fallback) == "function" then
--     p.fallback(tsn_data.tsnode)
--     return
--   end

--   if p and not p.format_empty_node then
--     if not p.non_bracket_node and tu.is_empty_node(node, p) then
--       return
--     end
--   end

--   if settings.check_syntax_error and node:has_error() then
--     notify.warn(msg.contains_error, node:type(), MODE)
--     return
--   end

--   if search.has_disabled_descendants(node, MODE, lang) then
--     local no_format_with = p and vim.inspect(p.no_format_with) or ""
--     notify.info(msg.no_format_with, MODE, node:type(), no_format_with)
--     return
--   end

--   tsn_data.mode = MODE
--   local treesj = TreeSJ.new(tsn_data)
--   treesj:_build_tree()

--   local ok_format, err = pcall(treesj._format, treesj)
--   if not ok_format then
--     notify.warn(err)
--     return
--   end

--   local replacement = treesj:_get_lines()

--   if MODE == JOIN and #replacement[1] > MAX_LENGTH then
--     notify.info(msg.extra_longer:format(MAX_LENGTH))
--     return
--   end
-- end
