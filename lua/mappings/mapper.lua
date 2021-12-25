local keymap = require("mappings.keymap")
local NvimMapper = require("nvim-mapper")
local logger = require("logger").initLogger("init")
local wk = require("which-key")

-- TODO: notify when mapping not found
-- TODO: handle duplicate assignments with suffix

local M = {}

function M.inspect(tbl, depth, n)
	n = n or 2
	depth = depth or 5

	if depth == 0 then
		print(string.rep(" ", n) .. "...")
		return
	end

	if n == 0 then
		print(" ")
	end

	for key, value in pairs(tbl) do
		if key and type(key) == "number" or type(key) == "string" then
			key = string.format('["%s"]', key)

			if type(value) == "table" then
				if next(value) then
					print(string.rep(" ", n) .. key .. " = {")
					M.inspect(value, depth - 1, n + 4)
					print(string.rep(" ", n) .. "},")
				else
					print(string.rep(" ", n) .. key .. " = {},")
				end
			else
				if type(value) == "string" then
					value = string.format('"%s"', value)
				else
					value = tostring(value)
				end

				print(string.rep(" ", n) .. key .. " = " .. value .. ",")
			end
		end
	end

	if n == 0 then
		print(" ")
	end
end

-- OK:   448
-- TODO: 238

M.stats = { normal = 0, insert = 0, command = 0, operator = 0, visual = 0, visual_select = 0  }
M.whichkey_lists = { conflicts = {}, duplicates = {}, ok = {}, todo = {} }
M.whichkey_map = { n = {}, v = {}, c = {}, i = {}, o = {}, x = {} }

M.update_stats = function(mode)
	if mode == "n" then
		M.stats.normal = M.stats.normal + 1
	end
	if mode == "i" then
		M.stats.insert = M.stats.insert + 1
	end
	if mode == "c" then
		M.stats.command = M.stats.command + 1
	end
	if mode == "o" then
		M.stats.operator = M.stats.operator + 1
	end
	if mode == "v" then
		M.stats.visual_select = M.stats.visual_select + 1
    M.stats.visual = M.stats.visual + 1
	end
  if mode == "x" then
    M.stats.visual = M.stats.visual + 1
  end

end

local function walk(cb, node)
	cb(node)
	for _, child in pairs(node.children) do
		walk(cb, child)
	end
end

local function length(T)
	local count = 0
	for _ in pairs(T) do
		count = count + 1
	end
	return count
end

M.whichkey_stats = function()
	local conflicts = {}
  local wk_keys = require("which-key.keys")

  -- print(vim.inspect(wk_keys.mappings))

	-- for _, tree in pairs(wk_keys.mappings) do
	-- 	wk.update_keymaps(tree.mode, tree.buf)
	-- 	tree.tree:walk(function(node)
	-- 		local count = 0
	-- 		for _ in pairs(node.children) do
	-- 			count = count + 1
	-- 		end
	-- 		local auto_prefix = not node.mapping or (node.mapping.group == true and not node.mapping.cmd)
	-- 		if node.prefix ~= "" and count > 0 and not auto_prefix then
	-- 			local cmd = node.mapping.cmd or " "
	-- 			table.insert(conflicts, { mode = tree.mode, lhs = node.mapping.prefix, rhs = cmd })
	-- 		end
	-- 	end)
	-- end
	-- M.whichkey_lists.conflicts = conflicts

	-- local ok = {}
	-- local todo = {}
	-- for _, mapping in pairs(mappings) do
	-- 	local bufnr = mapping.buf
	-- 	if bufnr == nil then
	-- 		bufnr = "root"
	-- 	end
	-- 	walk(function(node)
	-- 		if node.mapping then
	-- 			if node.mapping.label then
	-- 				if type(ok[node.mapping.prefix]) == "nil" then
	-- 					ok[node.mapping.prefix] = {}
	-- 				end
	-- 				table.insert(ok[node.mapping.prefix], bufnr)
	-- 				todo[node.mapping.prefix] = nil
	-- 			elseif not ok[node.mapping.prefix] then
	-- 				if type(todo[node.mapping.prefix]) ~= "nil" then
	-- 					table.insert(todo[node.mapping.prefix].buffers, bufnr)
	-- 				else
	-- 					todo[node.mapping.prefix] = { buffers = { bufnr }, cmd = node.mapping.cmd or "" }
	-- 				end
	-- 			end
	-- 		end
	-- 	end, mapping.tree.root)
	-- end
	-- M.whichkey_lists.todo = todo
	-- M.whichkey_lists.ok = ok

	-- local duplicates = {}

	-- for _, dup in pairs(wk_keys.duplicates) do
	-- 	table.insert(duplicates, {
	-- 		old_rhs = dup.other.rhs,
	-- 		rhs = dup.cmd or "",
	-- 		mode = dup.mode,
	-- 		lhs = dup.prefix,
	-- 		other_buffer = (dup.buf ~= dup.other.buffer),
	-- 	})
	-- end
	-- M.whichkey_lists.duplicates = duplicates

	-- print(vim.inspect(M.whichkey_lists))
end

M.parse_params = function(category, mode, keys, cmd_id, mods)
	local params = { mods = { silent = false, noremap = true } }
	local mapped = keymap[category][cmd_id]

	if mapped == nil then
		local msg = "Cannot find mapping - category: " .. category .. " - id: " .. cmd_id;
		-- require("notify")({ "Cannot find mapping: " .. category .. " : ", cmd_id }, "error")
    vim.notify({ msg, { cmd_id, category, mode, keys, mods }}, 'error')
    -- logger:error()
		error({ msg = msg, code = 100 })
	end

	mods = mods or {}
	if mods.silent ~= nil then
		params.mods.silent = mods.silent
	end
	if mods.noremap ~= nil then
		params.mods.noremap = mods.noremap
	end
	if mods.nowait ~= nil then
		params.mods.nowait = mods.nowait
	end

	params.mode = mode
	params.cat = category
	params.desc_long = mapped.long or mapped.short or ""
	params.desc_short = mapped.short or mapped.long or ""
	params.id = category:lower() .. "_" .. cmd_id
	params.keys = keys
	if mapped.cmd then
		params.cmd = mapped.cmd
		params.virtual = false
	else
		params.virtual = true
	end
	return params
end

local wk_default_mods = {
	mode = "n", -- NORMAL mode
	-- prefix: use "<leader>f" for example for mapping everything related to finding files
	-- the prefix is prepended to every mapping part of `mappings`
	prefix = "",
	buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
	noremap = true, -- use `noremap` when creating keymaps
	nowait = false, -- use `nowait` when creating keymaps
}

M.registerWhichkey = function()
	wk.register(M.whichkey_map.n, { mode = "n" })
	wk.register(M.whichkey_map.v, { mode = "v" })
  wk.register(M.whichkey_map.x, { mode = "x" })
	wk.register(M.whichkey_map.c, { mode = "c" })
	wk.register(M.whichkey_map.o, { mode = "o" })
	wk.register(M.whichkey_map.i, { mode = "i" })

	-- print(vim.inspect(M.whichkey_lists))
  wk.load()

  local wk_keys = require("which-key.keys")
  -- vim.logger:debug("REGISTER")
  -- vim.logger:debug(vim.inspect(wk_keys.mappings))
  M.whichkey_stats()
end

-- wk.register({
--   f = {
--     name = "file", -- optional group name
--     f = { "<cmd>Telescope find_files<cr>", "Find File" }, -- create a binding with label
--     r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File", noremap=false, buffer = 123 }, -- additional options for creating the keymap
--     n = { "New File" }, -- just a label. don't create any mapping
--     e = "Edit File", -- same as above
--     ["1"] = "which_key_ignore",  -- special label to hide it in the popup
--     b = { function() print("bar") end, "Foobar" } -- you can also pass functions!
--   },
-- }, { prefix = "<leader>" })
-- ```

-- <details>
-- <summary>Click to see more examples</summary>

-- ```lua
-- -- all of the mappings below are equivalent

-- -- method 2
-- wk.register({
--   ["<leader>"] = {
--     f = {
--       name = "+file",
--       f = { "<cmd>Telescope find_files<cr>", "Find File" },
--       r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
--       n = { "<cmd>enew<cr>", "New File" },
--     },
--   },
-- })

-- -- method 3
-- wk.register({
--   ["<leader>f"] = {
--     name = "+file",
--     f = { "<cmd>Telescope find_files<cr>", "Find File" },
--     r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
--     n = { "<cmd>enew<cr>", "New File" },
--   },
-- })

-- -- method 4
-- wk.register({
--   ["<leader>f"] = { name = "+file" },
--   ["<leader>ff"] = { "<cmd>Telescope find_files<cr>", "Find File" },
--   ["<leader>fr"] = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
--   ["<leader>fn"] = { "<cmd>enew<cr>", "New File" },
-- })
-- ```

M.map = function(category, mode, keys, cmd_id, mods)
  -- TODO: add 'plugin' and 'aucommand' mods
	M.update_stats(mode)
	local params = M.parse_params(category, mode, keys, cmd_id, mods)

  -- print("ADDING " .. params.keys .. '\t' .. params.desc_short)
	M.whichkey_map[params.mode][params.keys] = params.desc_short
  -- wk.register({ [params.keys] = params.desc_short }, { mode = mode })

	if params.virtual then
		NvimMapper.map_virtual(params.mode, params.keys, "", {}, params.cat, params.id, params.desc_long)
	else
		NvimMapper.map(params.mode, params.keys, params.cmd, params.mods, params.cat, params.id, params.desc_long)
	end
  -- Mapper.map_buf(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", {noremap = true, silent = true}, "LSP", "lsp_definitions", "Go to definition")
end


M.prefix = function(prefix, name)
	wk.register({ [prefix] = { name = "+" .. name } })
end


return M

-- ["g"] = { name = "+git",
-- ["l"] = { name = "+lsp",
-- ["i"] = { name = "+nvim internal",
-- ["n"] = { name = "+new",
-- ["g"] = { name = "+go actions",
-- ["gz"] = { name = "+zettelkasten",
-- ["<leader>F"] = { name = "+find",
-- ["<leader>f"] = { name = "+transform",
-- ["s"] = { name = "+surround",
-- ["cl"] = { name = "+conceallevel",
-- ["y"] = { name = "+repl",
-- ["<leader>s"] = { name = "+session",
-- ["yo"] = { name = "+toggle options",
-- ["<leader>b"] = { name = "+breakpoints",
-- ["<leader>d"] = { name = "+dap",

-- :WhichKey " show all mappings
-- :WhichKey <leader> " show all <leader> mappings
-- :WhichKey <leader> v " show all <leader> mappings for VISUAL mode
-- :WhichKey '' v " show ALL mappings for VISUAL mode
