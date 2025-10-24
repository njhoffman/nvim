#!/usr/bin/env lua

local v = _VERSION:match('%d+%.%d+')
package.path = 'lua_modules/share/lua/' .. v .. '/?.lua;lua_modules/share/lua/' .. v .. '/?/init.lua;' .. package.path
package.cpath = 'lua_modules/lib/lua/' .. v .. '/?.so;' .. package.cpath

local IS_DEBUG = os.getenv('DEBUG') == 'true'

local inspect = require('inspect')
local init_config = require('devdocs.config')
local utils = require('devdocs.utils')
local config = init_config()
local targets = arg[1] and utils.split(tostring(arg[1]), ',') or nil

local delimiter = '\t'
local get_line_count = true

local start_time = os.clock()
local index = utils.read_index(config)
if not index then
  return
end

local output_entry = function(entry, idx)
  local output = string.format(
    string.rep('%s', 7, delimiter),
    entry.alias or '',
    entry.type or '',
    entry.name or '',
    entry.line_count or '',
    entry.link or '',
    string.gsub(entry.path or '', '\n', '\\n'),
    string.gsub(entry.next_path or '', '\n', '\\n')
  )
  print(output)
  -- print(inspect(entry))
end

local output_entries = function(aliases)
  for _, alias in ipairs(aliases) do
    local current_entries = index[alias].entries
    for idx, entry in ipairs(current_entries) do
      if idx < #current_entries then
        entry.next_path = current_entries[idx + 1].path
      end
      if get_line_count then
        entry.line_count = 0
        for _ in string.gmatch(entry.path, '\n') do
          entry.line_count = entry.line_count + 1
        end
      end
      entry.alias = alias
      output_entry(entry, idx)
    end
  end
end

local output_debug = function(target_aliases)
  local counts = utils.get_count(config, target_aliases)
  local time_elapsed = (os.clock() - start_time) * 1000 -- This will give you the time in milliseconds.
  print('')
  -- print(inspect(counts))
  print(
    'Time elapsed: '
      .. time_elapsed
      .. ' ms - 龍'
      .. math.floor(counts['*'] / time_elapsed)
      .. ' ('
      .. counts['*']
      .. ' entries)'
  )
end

local installed = utils.get_installed(config)
local target_aliases = {}
if targets ~= nil then
  for _, target_alias in ipairs(targets) do
    if utils.tbl_contains(installed, target_alias) then
      table.insert(target_aliases, target_alias)
    end
  end
end
target_aliases = #target_aliases > 0 and target_aliases or installed

output_entries(target_aliases)

if IS_DEBUG then
  output_debug(target_aliases)
end
