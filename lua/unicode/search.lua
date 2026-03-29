local config = require("unicode.config")
local data = require("unicode.data")
local digraph = require("unicode.digraph")
local names = require("unicode.names")

local M = {}

local html = nil
local nerds = nil

local function get_html()
  if not html then
    html = require("unicode.html_entities")
  end
  return html
end

local function get_nerds()
  if not nerds then
    nerds = require("unicode.nerd_chars")
  end
  return nerds
end

--- Get HTML entity string(s) for a codepoint.
--- @param hex number Decimal codepoint value
--- @param all boolean If true, return all entities joined; otherwise first only
--- @return string
function M.get_html_entity(hex, all)
  local list = get_html()[hex] or {}
  local entity = all and table.concat(list, " ") or (list[1] or "")

  if entity == "" then
    -- Generate numeric entity for valid ranges
    local valid = (hex > 31 or hex == 9 or hex == 10 or hex == 13)
      and (hex < 127 or hex > 159)
      and (hex < 55296 or hex > 57343)
    if valid then
      entity = string.format("&#x%X;", hex)
    end
  end
  return entity
end

--- Find unicode characters by name, decimal, or hex codepoint.
--- @param match string Search pattern
--- @return table List of result dicts with keys: name, glyph, dec, hex, info, dig, html
function M.find_unicode_by(match)
  if not match or match == "" then
    vim.notify("UnicodePlugin: Argument is empty or unspecified", vim.log.levels.ERROR)
    return {}
  end

  local uni_dict = data.get()
  local unidict = {}

  -- Check if input is a literal codepoint
  if match:match("^%d+$") then
    local digit = tonumber(match, 10)
    for k, v in pairs(uni_dict) do
      if k == digit then
        unidict[k] = v
      end
    end
  elseif match:match("^U%+%x+$") then
    local digit = tonumber(match:sub(3), 16)
    for k, v in pairs(uni_dict) do
      if k == digit then
        unidict[k] = v
      end
    end
  else
    -- Name-based search (case-insensitive)
    local pattern = match:lower()
    for k, v in pairs(uni_dict) do
      if v:lower():find(pattern, 1, true) then
        unidict[k] = v
      end
    end
  end

  local output = {}
  for dec, name in pairs(unidict) do
    local dchar = digraph.get_chars(dec)
    local entity = M.get_html_entity(dec, true)
    local entry = {
      name = name,
      glyph = vim.fn.nr2char(dec),
      dec = dec,
      hex = string.format("0x%02X", dec),
      info = config.extra_info[dec] or "",
    }
    if dchar ~= "" then
      entry.dig = dchar
    end
    if entity ~= "" then
      entry.html = entity
    end
    output[#output + 1] = entry
  end

  table.sort(output, function(a, b)
    return (tonumber(a.dec) or 0) < (tonumber(b.dec) or 0)
  end)

  return output
end

--- Find digraphs matching a pattern.
--- @param match string Search pattern (character, name, or decimal number)
--- @return table List of result dicts
function M.find_digraph_by(match)
  local outlist = {}
  local digit = tonumber(match) or 0
  local search_name = ""
  local unidict = {}

  if #match == 1 then
    -- Single character: treat as very nomagic
    match = vim.fn.escape(match, "\\")
  elseif #match > 1 and digit == 0 then
    -- Try to match by unicode name
    local uni_dict = data.get()
    search_name = match
    local pattern = match:lower()
    for k, v in pairs(uni_dict) do
      if v:lower():find(pattern, 1, true) then
        unidict[k] = v
      end
    end
  end

  local res = digraph.get_dict()

  for dec_key, dig_entries in pairs(res) do
    local entry_text = table.concat(dig_entries, " ")

    -- Check match conditions
    local matches = false
    if digit > 0 then
      matches = (tonumber(dec_key) == digit)
    elseif search_name ~= "" and next(unidict) then
      matches = unidict[tonumber(dec_key)] ~= nil
    else
      matches = entry_text:find(match, 1, true) ~= nil
    end

    if not matches then
      goto continue
    end

    -- Parse the first entry to get digraph chars
    local first = dig_entries[1] or ""
    local dig_chars = first:sub(1, 2)
    local dec = tonumber(first:match("%d+$")) or 0

    if digit > 0 and dec ~= digit then
      goto continue
    end
    if search_name ~= "" and next(unidict) and not unidict[dec] then
      goto continue
    end

    local glyph = dec ~= 32 and vim.fn.nr2char(dec) or " "
    local dict = {
      glyph = glyph,
      dig = digraph.get_chars(dec),
      dec = dec,
      hex = string.format("0x%02X", dec),
      name = names.resolve(dec, data.get()),
    }
    outlist[#outlist + 1] = dict

    ::continue::
  end

  table.sort(outlist, function(a, b)
    return (tonumber(a.dec) or 0) < (tonumber(b.dec) or 0)
  end)

  return outlist
end

return M
