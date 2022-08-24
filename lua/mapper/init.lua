local wk = require("which-key")
local NvimMapper = require("mapper.nvim-mapper")
local keymap = require('mappings.keymap')

-- OK:   448
-- TODO: 238
-- :nmap  :nnoremap :nunmap    Normal
-- :vmap  :vnoremap :vunmap    Visual and Select
-- :smap  :snoremap :sunmap    Select
-- :xmap  :xnoremap :xunmap    Visual
-- :omap  :onoremap :ounmap    Operator-pending
-- :map!  :noremap! :unmap!    Insert and Command-line
-- :imap  :inoremap :iunmap    Insert
-- :lmap  :lnoremap :lunmap    Insert, Command-line, Lang-Arg
-- :cmap  :cnoremap :cunmap    Command-line
-- :tmap  :tnoremap :tunmap    Terminal

local stats = { normal = 0, insert = 0, command = 0, operator = 0, visual = 0, select = 0, terminal = 0, language = 0 }

local update_stats = function(mode)
  if mode == "n" then stats.normal = stats.normal + 1 end
  if mode == "t" then stats.terminal = stats.terminal + 1 end
  if mode == "i" then stats.insert = stats.insert + 1 end
  if mode == "c" then stats.command = stats.command + 1 end
  if mode == "o" then stats.operator = stats.operator + 1 end
  if mode == "x" then stats.visual = stats.visual + 1 end
  if mode == "v" then
    stats.visual = stats.visual + 1
    stats.select = stats.select + 1
  end
end

local parse_params = function(category, mode, keys, cmd_id, mods)
  update_stats(mode)
  local params = { mods = { silent = false, noremap = true } }
  local mapped = keymap[category][cmd_id]

  if mapped == nil then
    local msg = "Cannot find mapping - category: " .. category .. " - id: " .. cmd_id
    vim.notify({ msg, { cmd_id, category, mode, keys, mods } }, "error")
    -- logger:error()
    error({ msg = msg, code = 100 })
  end

  mods = mods or {}
  if mods.silent ~= nil then params.mods.silent = mods.silent end
  if mods.noremap ~= nil then params.mods.noremap = mods.noremap end
  if mods.nowait ~= nil then params.mods.nowait = mods.nowait end

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

local M = {}
M.mapper_records = NvimMapper.mapper_records
M.whichkey_map = { n = {}, v = {}, c = {}, i = {}, o = {}, x = {}, s = {}, t = {}, m = {}, l = {} }

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
end

M.bufmap = function(bufnr, category, mode, keys, cmd_id, mods)
  local p = parse_params(category, mode, keys, cmd_id, mods)
  -- print("ADDING " .. p.keys .. '\t' .. params.desc_short)
  M.whichkey_map[p.mode][p.keys] = p.desc_short
  -- wk.register({ [p.keys] = params.desc_short }, { mode = mode })

  if p.virtual then
    NvimMapper.map_buf_virtual(bufnr, p.mode, p.keys, "", {}, p.cat, p.id, p.desc_long)
  else
    NvimMapper.map_buf(bufnr, p.mode, p.keys, p.cmd, p.mods, p.cat, p.id, p.desc_long)
  end
end

M.map = function(category, mode, keys, cmd_id, mods)
  -- TODO: add 'plugin' and 'aucommand' mods
  local p = parse_params(category, mode, keys, cmd_id, mods)

  -- print("ADDING " .. p.keys .. '\t' .. params.desc_short)
  M.whichkey_map[p.mode][p.keys] = p.desc_short
  -- wk.register({ [p.keys] = params.desc_short }, { mode = mode })

  if p.virtual then
    NvimMapper.map_virtual(p.mode, p.keys, "", {}, p.cat, p.id, p.desc_long)
  else
    NvimMapper.map(p.mode, p.keys, p.cmd, p.mods, p.cat, p.id, p.desc_long)
  end
end

M.prefix = function(prefix, name)
  wk.register({ [prefix] = { name = "+" .. name } })
end

M.stats = stats

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
