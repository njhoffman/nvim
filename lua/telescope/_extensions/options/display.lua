local entry_display = require('telescope.pickers.entry_display')
local utils = require('telescope._extensions.options.utils')

local type_icons = {
  ['function'] = '󰊕 ',
  string = ' ',
  number = '󰎠 ',
  table = ' ',
  boolean = '󰆕 ',
  userdata = ' ',
}

local scope_map = {
  buf = 'b',
  win = 'w',
  global = 'g',
}

local displayer = entry_display.create({
  separator = ' ', --  " ▏",
  hl_chars = { ['['] = 'TelescopeBorder', [']'] = 'TelescopeBorder' },
  items = {
    { width = 20 },
    { width = 4 },
    { width = 2 },
    { remaining = true },
  },
})

local make_display = function(entry)
  local scope = '▏' .. scope_map[entry.value.scope] .. ' ▏'
  local type_icon = type_icons[type(entry.value.value)]

  local hl_value = entry.value.value ~= entry.value.default and 'TelescopeResultsNormal' or 'TelescopeResultsComment'
  return displayer({
    { entry.value.name, 'TelescopeResultsClass' },
    { scope, 'TelescopeResultsComment' },
    { type_icon, 'TelescopeResultsOperator' },
    { utils.display_termcodes(tostring(entry.value.value)), hl_value },
  })
end

local entry_maker = function(opt)
  local entry = {
    display = make_display,
    value = {
      name = opt.name,
      value = opt.value,
      default = opt.default,
      type = opt.type,
      scope = opt.scope,
    },
    ordinal = string.format('%s %s %s', opt.name, opt.type, opt.scope),
  }

  local ok, value = pcall(vim.api.nvim_get_option, opt.name)
  if ok then
    entry.value.value = value
    entry.ordinal = entry.ordinal .. ' ' .. utils.display_termcodes(tostring(value))
  else
    entry.ordinal = entry.ordinal .. ' ' .. utils.display_termcodes(tostring(opt.default))
  end
  return entry
end

return { entry_maker = entry_maker }
