-- luarocks install lua-digest-crc32lua
local M = {}
local type = type
local require = require
local setmetatable = setmetatable

--[[
   Requires the first module listed that exists, else raises like `require`.
   If a non-string is encountered, it is returned.
   Second return value is module name loaded (or '').
   --]]

local function requireany(...)
  local errs = {}
  for _, name in ipairs({ ... }) do
    if type(name) ~= "string" then
      return name, ""
    end
    local ok, mod = pcall(require, name)
    if ok then
      return mod, name
    end
    errs[#errs + 1] = mod
  end
  error(table.concat(errs, "\n"), 2)
end

local bit, _ = requireany("bit32", "bit", "bit.numberlua")

local bxor = bit.bxor
local bnot = bit.bnot
local band = bit.band
local rshift = bit.rshift

-- CRC-32-IEEE 802.3 (V.42)
local POLY = 0xEDB88320

-- Memoize function pattern (like http://lua-users.org/wiki/FuncTables ).
local function memoize(f)
  local mt = {}
  local t = setmetatable({}, mt)
  function mt:__index(k)
    local v = f(k)
    t[k] = v
    return v
  end

  return t
end

-- CRC table.
local crc_table = memoize(function(i)
  local crc = i
  for _ = 1, 8 do
    local b = band(crc, 1)
    crc = rshift(crc, 1)
    if b == 1 then
      crc = bxor(crc, POLY)
    end
  end
  return crc
end)

function M.crc32_byte(byte, crc)
  crc = bnot(crc or 0)
  local v1 = rshift(crc, 8)
  local v2 = crc_table[bxor(crc % 256, byte)]
  return bnot(bxor(v1, v2))
end

local M_crc32_byte = M.crc32_byte

function M.crc32_string(s, crc)
  crc = crc or 0
  for i = 1, #s do
    crc = M_crc32_byte(s:byte(i), crc)
  end
  return crc
end

local M_crc32_string = M.crc32_string

function M.crc32(s, crc)
  if type(s) == "string" then
    return M_crc32_string(s, crc)
  else
    return M_crc32_byte(s, crc)
  end
end

M.bit = bit -- bit library used

return {
  get_crc = M.crc32_string
}
