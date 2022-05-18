local NvimMapper = require("nvim-mapper")
local logger = require("logger").initLogger("init")
local wk = require("which-key")

local logger = require("logger").initLogger("mapper")
local M = {}
local keymap = {}


-- TODO: notify when mapping not found
-- TODO: handle duplicate assignments with suffix


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

local function length(T)
  local count = 0
  for _ in pairs(T) do
    count = count + 1
  end
  return count
end

local function load_module(file_name)
  local ok, mod = pcall(require, 'mappings.' .. file_name)
  if not ok then
    local msg = "failed loading: " .. file_name .. "\n " .. vim.inspect(mod)
    vim.notify(msg, "error")
    logger:error({ msg, mod })
  else
    local mod_name = file_name:gsub("^%l", string.upper)
    if mod_name == "Lsp" then mod_name = "LSP" end
    keymap[mod_name] = mod
    -- logger:trace(mod_name .. " keymap loaded")
  end
end

M.stats = { normal = 0, insert = 0, command = 0, operator = 0, visual = 0, select = 0, terminal = 0, language = 0 }
M.whichkey_map = { n = {}, v = {}, c = {}, i = {}, o = {}, x = {}, s = {}, t = {}, m = {}, l = {} }

M.update_stats = function(mode)
  if mode == "n" then M.stats.normal = M.stats.normal + 1 end
  if mode == "t" then M.stats.terminal = M.stats.terminal + 1 end
  if mode == "i" then M.stats.insert = M.stats.insert + 1 end
  if mode == "c" then M.stats.command = M.stats.command + 1 end
  if mode == "o" then M.stats.operator = M.stats.operator + 1 end
  if mode == "v" then
    M.stats.visual = M.stats.visual + 1
    M.stats.select = M.stats.select + 1
  end
  if mode == "x" then M.stats.visual = M.stats.visual + 1 end
end

M.parse_params = function(category, mode, keys, cmd_id, mods)
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
end

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


local mapfiles = {
  "debug",
  "format",
  "git",
  "interface",
  "lsp",
  "markdown",
  "movement",
  "navigation",
  "pickers",
  "search",
  "system",
  "unimpaired",
  "window",
  "zettel",
}

for _, mod_name in ipairs(mapfiles) do
  load_module(mod_name)
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
