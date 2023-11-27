vim = vim
local utils = {}

function utils.error(modl, message)
  vim.cmd([[echohl ErrorMsg]])
  vim.cmd('echo "[' .. modl .. ']: ' .. message .. '"')
  vim.cmd([[echohl Normal]])
end

function utils.warning(modl, message)
  vim.cmd([[echohl WarningMsg]])
  vim.cmd('echo "[' .. modl .. ']: ' .. message .. '"')
  vim.cmd([[echohl Normal]])
end

function utils.info(modl, message)
  vim.cmd('echo "[' .. modl .. ']: ' .. message .. '"')
end

-- Creating an autocommand in 0.7

-- autocommands
function utils.define_augroups(definitions) -- {{{1
  -- Create autocommand groups based on the passed definitions
  --
  -- The key will be the name of the group, and each definition
  -- within the group should have:
  --    1. Trigger
  --    2. Pattern
  --    3. Text
  -- just like how they would normally be defined from Vim itself
  -- vim.api.nvim_create_autocmd("BufEnter", {
  --     pattern = "*",
  --     callback = function(args)
  --         print("Entered buffer " .. args.buf .. "!")
  --     end,
  --     desc = "Tell me when I enter a buffer",
  -- })

  for group_name, definition in pairs(definitions) do
    -- vim.dbglog(group_name)
    -- vim.api.nvim_create_augroup(group_name, { clear = true })
    -- for _, def in pairs(definition) do
    --   vim.api.nvim_create_autocmd(
    --     def[1],
    --     {
    --       pattern = def[2],
    --       callback = def[3],
    --       desc = def[4]
    --     }
    --   )
    -- end

    vim.cmd('augroup ' .. group_name)
    vim.cmd('autocmd!')
    for _, def in pairs(definition) do
      local command = table.concat(vim.tbl_flatten({ 'autocmd', def }), ' ')
      vim.cmd(command)
    end

    vim.cmd('augroup END')
  end
end

-- local scopes = {o = vim.o, b = vim.bo, w = vim.wo}

function utils.opt(o, v, scopes)
  scopes = scopes or { vim.o }
  for _, s in ipairs(scopes) do
    s[o] = v
  end
end

-- mappings
function utils.map(modes, key, result, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  if type(modes) == 'string' then
    modes = { modes }
  end
  for _, mode in ipairs(modes) do
    vim.api.nvim_set_keymap(mode, key, result, options)
  end
end

-- Terminal
local has_toggleterm, toggleterm = pcall(require, 'toggleterm.terminal')
if has_toggleterm then
  local Terminal = toggleterm.Terminal
  local lazygit = Terminal:new({
    cmd = 'lazygit',
    direction = 'float',
    hidden = true,
  })

  function utils._lazygit_toggle()
    lazygit:toggle()
  end
end

-- virtual text

-- local opts = {
--   end_line = 10,
--   id = 1,
--   virt_text = {{"demo", "IncSearch"}},
--   virt_text_pos = 'overlay',
--   -- virt_text_win_col = 20,
-- }

-- local mark_id = vim.api.nvim_buf_set_extmark(bnr, ns_id, line_num, col_num, opts)

-- local ts_utils = require("nvim-treesitter.ts_utils")
-- utils.find_virtual_text_nodes = function(validator, ft, opts)
--   local result = {}
--   local node = ts_utils.get_node_at_cursor()
--   -- local config = require('nvim_context_vt.config')
--   local config = {}

--   while node ~= nil and not vim.tbl_contains(config.ignore_root_targets, node:type()) do
--     if validator(node, ft, opts) then
--       local target_line = node:end_()
--       if not result[target_line] then
--         result[target_line] = {}
--       end
--       table.insert(result[target_line], node)
--     end

--     node = node:parent()
--   end
--   return result
-- end

-- Telescope
function utils.search_nvim()
  require('telescope.builtin').find_files({
    prompt_title = 'Neovim Config',
    cwd = '$HOME/.config/nvim/profiles/default/lua',
  })
end

-- @param map {{mode, lhs, rhs, opts}, ..}
-- @param mode string 'n' | 'i' | 'v'
-- @param lhs string key to map
-- @param rhs string command to run
utils.keymap = function(map)
  map = map or {}
  local opts = map[4] or {}
  return vim.api.nvim_set_keymap(map[1], map[2], map[3], opts)
end

-- @param maps list of keymaps
utils.keymaps = function(maps)
  for _, m in ipairs(maps) do
    utils.keymap(m)
  end
end

utils.log_to_file = function(logfile)
  return function(log_value)
    local file = io.open(logfile, 'a')
    if not file then
      file:close()
      return
    end

    file:write(log_value .. '\n')
    file:close()
  end
end

utils.find = function(array, key, val)
  for _, v in ipairs(array) do
    if v[key] == val then
      return v
    end
  end
end

-- Iterator that splits a string o a given delimiter
utils.split = function(str, delim)
  delim = delim or '%s'
  return string.gmatch(str, string.format('[^%s]+', delim))
end

utils.ftAbbr = function(lhs, rhs)
  -- TODO update on nvim 0.10
  -- vim.keymap.set("ia", lhs, rhs, { buffer = true })
  vim.cmd.inoreabbrev(('<buffer> %s %s'):format(lhs, rhs))
end

---@param str string
---@param filePath string line(s) to add
---@param mode "w"|"a" -- write or append
---@return string|nil error
---@nodiscard
utils.writeToFile = function(filePath, str, mode)
  local file, error = io.open(filePath, mode)
  if not file then
    return error
  end
  file:write(str .. '\n')
  file:close()
end

---https://www.reddit.com/r/neovim/comments/oxddk9/comment/h7maerh/
---@param name string name of highlight group
---@param key "fg"|"bg"
---@nodiscard
---@return string|nil the value, or nil if hlgroup or key is not available
function utils.getHighlightValue(name, key)
  local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name })
  if not ok then
    return
  end
  local value = hl[key]
  if not value then
    return
  end
  return string.format('#%06x', value)
end

---Adds a component to the lualine after lualine was already set up. Useful for
---lazyloading.
---@param component function|table the component forming the lualine
---@param location "tabline"|"sections" tabline = top, sections = bottom
---@param section "lualine_a"|"lualine_b"|"lualine_c"|"lualine_x"|"lualine_y"|"lualine_z"
utils.addToLuaLine = function(location, section, component)
  local topSeparators = { left = '', right = '' }

  local ok, lualine = pcall(require, 'lualine')
  if not ok then
    return
  end
  local sectionConfig = lualine.get_config()[location][section] or {}

  local componentObj = type(component) == 'table' and component or { component }
  if location == 'tabline' then
    componentObj.section_separators = topSeparators
  end
  table.insert(sectionConfig, componentObj)
  lualine.setup({ [location] = { [section] = sectionConfig } })

  -- Theming needs to be re-applied, since the lualine-styling can change
  require('config.theme-customization').reloadTheming()
end
return utils
