#!/usr/bin/env lua

local v = _VERSION:match('%d+%.%d+')
package.path = 'lua_modules/share/lua/' .. v .. '/?.lua;lua_modules/share/lua/' .. v .. '/?/init.lua;' .. package.path
package.cpath = 'lua_modules/lib/lua/' .. v .. '/?.so;' .. package.cpath

local inspect = require('inspect')
local init_config = require('config')
local utils = require('utils')
local config = init_config(arg[1])

local installed = utils.get_installed(config)
local counts = utils.get_count(config, installed)
print(inspect(counts))
