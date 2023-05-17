local entry_display = require('telescope.pickers.entry_display')
local utils = require('telescope._extensions.variables.utils')

local displayer = entry_display.create({
  separator = ' ', --  " ▏",
  hl_chars = { ['['] = 'TelescopeBorder', [']'] = 'TelescopeBorder' },
  items = {
    { width = 25 },
    { width = 4 },
    { width = 2 },
    { remaining = true },
  },
})

local type_icons = {
  ['function'] = '󰊕 ',
  string = ' ',
  number = '󰎠 ',
  table = ' ',
  boolean = '󰆕 ',
  userdata = ' ',
}

local scope_map = {
  buffer = 'b',
  window = 'w',
  global = 'g',
  predef = 'v',
}

local make_display = function(entry)
  local type_icon = type_icons[type(entry.value.value)]
  local value = entry.value.value
  local value_hl = 'TelescopeResultsNormal'
  local scope = '▏' .. scope_map[entry.value.scope] .. ' ▏'
  if type(value) == 'table' then
    value = '(' .. #vim.tbl_keys(value) .. ' keys)'
    value_hl = 'TelescopeResultsComment'
  elseif type(value) == 'function' then
    value = '(function)'
    value_hl = 'TelescopeResultsComment'
  elseif type(value) == 'userdata' then
    value = '(userdata)'
    value_hl = 'TelescopeResultsComment'
  end
  return displayer({
    { entry.value.key, 'TelescopeResultsClass' },
    { scope, 'TelescopeResultsComment' },
    { type_icon, 'TelescopeResultsOperator' },
    { tostring(value), value_hl },
  })
end

local entry_maker = function(var)
  local entry = {
    display = make_display,
    value = var,
    ordinal = string.format('%s %s', var.key, tostring(var.value)),
  }
  return entry
end

return { entry_maker = entry_maker }
