#!/usr/bin/env lua

local v = _VERSION:match('%d+%.%d+')
package.path = 'lua_modules/share/lua/' .. v .. '/?.lua;lua_modules/share/lua/' .. v .. '/?/init.lua;' .. package.path
package.cpath = 'lua_modules/lib/lua/' .. v .. '/?.so;' .. package.cpath

local init_config = require('config')
local inspect = require('inspect')
local utils = require('utils')
local config = init_config(arg[1])

local delimiter = '\t'
local get_line_count = false

local start_time = os.time()
local index = utils.read_index(config)
if not index then
  return
end

local output_entry = function(entry, idx)
  local output = string.format(
    string.rep('%s', 6, delimiter),
    entry.alias or '',
    entry.name or '',
    entry.link or '',
    #(entry.path or ''),
    #(entry.next_path or ''),
    #(entry.line_count or '')
  )
  print(idx .. ': ' .. output)
end

local output_entries = function(aliases)
  for _, alias in ipairs(aliases) do
    local current_entries = index[alias].entries
    for idx, entry in ipairs(current_entries) do
      if idx < #current_entries then
        entry.next_path = current_entries[idx + 1].path
      end
      if get_line_count then
        entry.line_count = #utils.read_entry(entry)
      end
      output_entry(entry, idx)
    end
  end
end

local installed = utils.get_installed(config)
local count = utils.get_count(config, installed)
output_entries(installed)
local time_elapsed = os.time() - start_time
print(inspect(count))
print('Time elapsed: ' .. time_elapsed .. ' seconds')
