local keys = require('movement.flash.keys')
local definitions = require('movement.flash.definitions')

local map_funcs = {
  misc = require('movement.flash.keybinds.misc'),
  lsp = require('movement.flash.keybinds.lsp'),
  lask = require('movement.flash.keybinds.asterisk'),
  jumps = require('movement.flash.keybinds.jump'),
  treesitter = require('movement.flash.keybinds.treesitter'),
}

local build_mapping = function(name, defs)
  local map = {}
  for id, def in pairs(defs) do
    local modes, desc = def[1], def[2]
    local key = keys[id]
    local func = map_funcs[name][id]
    map[id] = { key, modes, desc, func }
  end
  return map
end

local mappings = {}
for name, defs in pairs(definitions) do
  local mapping = build_mapping(name, defs)
  mappings = vim.tbl_deep_extend('force', mappings, mapping)
end

return mappings
