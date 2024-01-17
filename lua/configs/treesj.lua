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
  cursor_behavior = 'start',
  max_join_length = 1000,
  check_syntax_error = false,
})

-- bash c cpp css dart go html java javascript json json5 jsonc kotlin lua nix perl
-- php pug python r ruby rust scss sql starlark svelte toml tsx typescript vue yaml

local langs = require('treesj.langs')['presets']
langs['sh'] = vim.deepcopy(langs['bash'])
langs['typescriptreact'] = vim.deepcopy(langs['tsx'])

---Get language for node
---@param node TSNode TSNode instance
---@return string
local function get_node_lang(node)
  local range = { node:range() }
  local buf = vim.api.nvim_get_current_buf()
  local ok, parser = pcall(vim.treesitter.get_parser, buf, vim.treesitter.language.get_lang(vim.bo[buf].ft))
  if not ok then
    return ''
  end
  local current_tree = parser:language_for_range(range)
  return current_tree:lang()
end

---Return the preset for received node.
---If mode passed, return preset for specified mode
---@param tsn_type string TSNode type
---@param lang? string TSNode lang. Requires if `node` is string
---@param mode? string Current mode (split|join)
---@return table|nil
local function get_preset(tsn_type, lang, mode)
  if lang and not langs[lang] then
    return nil
  end

  local presets = langs[lang]
  local preset = presets and presets[tsn_type]

  return preset and (preset[mode] or preset)
end

---Recursively searches for the configured node among the ancestors
---@param node TSNode TSNode instance
---@param lang string Language of TSNode
---@return TSNode|nil, table|nil
local function search_node_up(node, lang)
  if not node then
    return nil
  end

  local preset = get_preset(node:type(), lang)

  if not (node:named() and preset) then
    node = node:parent()
    return search_node_up(node, lang)
  end

  return node, preset
end

---Recursively searches for the configured node among the ancestors
---@param node TSNode TSNode instance
---@param lang string Language of TSNode
---@return TSNode|nil, table|nil
local function search_node_up(node, lang)
  if not node then
    return nil
  end

  local preset = get_preset(node:type(), lang)

  if not (node:named() and preset) then
    node = node:parent()
    return search_node_up(node, lang)
  end

  return node, preset
end

-- treesj.search
local get_configured_node = function(node)
  if not node then
    error(msg.node_not_received, 0)
  end

  local lang = get_node_lang(node)
  if not langs[lang] then
    error(msg.no_configured_lang:format(lang), 0)
  end

  local start_node_type = node:type()
  local data = search_node(node, lang)

  if not data or not data.tsnode then
    error(msg.no_configured_node:format(start_node_type, lang), 0)
  end

  return data
end

local split_toggle = function()
  local results = require('mini.splitjoin').toggle()
  if results == nil and langs[vim.bo.filetype] ~= nil then
    require('treesj').toggle()
  end
end
vim.api.nvim_create_user_command('SplitToggle', split_toggle, {})

local split_split = function()
  local results = require('mini.splitjoin').split()
  if results == nil and langs[vim.bo.filetype] ~= nil then
    require('treesj').split()
  end
end
vim.api.nvim_create_user_command('SplitSplit', split_split, {})

local split_join = function()
  local results = require('mini.splitjoin').join()
  if results == nil and langs[vim.bo.filetype] ~= nil then
    require('treesj').join()
  end
end
vim.api.nvim_create_user_command('SplitJoin', split_join, {})

local split_mapping = function()
  -- TODO: if not toggleable node (node identifier is not configured) go to first parenthesis
  vim.keymap.set('n', 'gs', '<cmd>SplitToggle<cr>', { buffer = true, desc = 'split toggle cursor' })
  vim.keymap.set('n', 'gJ', '<cmd>SplitJoin<cr>', { buffer = true, desc = 'split join cursor' })
  vim.keymap.set('n', 'gS', '<cmd>SplitSplit<cr>', { buffer = true, desc = 'split split cursor' })
end

vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, { pattern = '*', callback = split_mapping })
split_mapping()
