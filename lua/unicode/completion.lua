local config = require("unicode.config")
local data = require("unicode.data")
local digraph = require("unicode.digraph")
local names = require("unicode.names")
local search = require("unicode.search")

local M = {}

--- Build completion entries for unicode characters.
--- @param dict table Dictionary of decimal -> name
--- @return table List of completion items
local function add_complete_entries(dict)
  local compl = {}
  local prev_fmt = "  Codept\tHTML\t\tName\n%s U+%04X\t%s\t%s"
  local starttime = os.time()

  local keys = {}
  for k in pairs(dict) do
    keys[#keys + 1] = k
  end
  table.sort(keys)

  for _, value in ipairs(keys) do
    if value == 0 then
      goto continue
    end

    local name = dict[value]
    local html = search.get_html_entity(value, false)
    local dg_char = digraph.get_chars(value)
    local fstring = string.format("U+%04X\t%s%s %s '%s'", value, name, dg_char, html, vim.fn.nr2char(value))

    local entry
    if config.complete_name then
      entry = { word = string.format("%s (U+%04X)", name, value), abbr = fstring }
    else
      entry = { word = vim.fn.nr2char(value), abbr = fstring }
    end

    if config.show_preview_window or (vim.o.completeopt or ""):find("popup") then
      entry.info = string.format(prev_fmt, vim.fn.nr2char(value), value, html, name)
    end

    compl[#compl + 1] = entry

    -- Break if search takes too long
    if os.time() - starttime > 2 then
      vim.notify("UnicodePlugin: Completing takes too long, stopping now...", vim.log.levels.WARN)
      break
    end

    ::continue::
  end

  return compl
end

--- Build completion entries for digraphs.
--- @param dlist table List of digraph entry lists
--- @return table List of completion items
local function add_digraph_complete_entries(dlist)
  local list = {}
  local prev_fmt = "Abbrev\tGlyph\tCodepoint\tName\n%s\t%s\tU+%04X\t\t%s"

  for _, args in ipairs(dlist) do
    for _, item in ipairs(args) do
      local dig_chars, glyph, dec_str = item:match("^(..)%s+(.-)%s+(%d+)$")
      if dig_chars then
        local dec = tonumber(dec_str) or 0
        local name = names.resolve(dec, data.get())
        local format = string.format("'%s' %s U+%04X %s", dig_chars, glyph, dec, name)

        if dec == 0 then
          dec = 10
        end

        list[#list + 1] = {
          word = vim.fn.nr2char(dec),
          abbr = format,
          dec = dec,
          info = string.format(prev_fmt, dig_chars, glyph, dec, name),
        }
      end
    end
  end

  table.sort(list, function(a, b)
    return (a.dec or 0) < (b.dec or 0)
  end)

  return list
end

--- Build completion entries for HTML entities.
--- @param entity_list table Filtered HTML entity dict
--- @param base string The search base text
--- @return table List of completion items
local function add_html_complete_entries(entity_list, base)
  local list = {}
  local prev_fmt = "Entity\tGlyph\tCodepoint\tName\n%s\t%s\t\tU+%04X\t\t%s"

  local keys = {}
  for k in pairs(entity_list) do
    keys[#keys + 1] = k
  end
  table.sort(keys)

  for _, value in ipairs(keys) do
    local name = names.resolve(value, data.get())
    local entities = entity_list[value]

    -- Find the entity matching the base
    local entity = entities[1] or ""
    for _, e in ipairs(entities) do
      if e:find(base, 1, true) then
        entity = e
        break
      end
    end

    local glyph = vim.fn.nr2char(value)
    local format = string.format("'%s'\t%s U+%04X (%s)", glyph, entity, value, name)

    list[#list + 1] = {
      word = entity,
      abbr = format,
      dec = value,
      info = string.format(prev_fmt, entity, glyph, value, name),
    }
  end

  return list
end

--- Insert-mode completion for Unicode characters.
--- @return string Always returns empty string (for <C-R>= mapping)
function M.complete_unicode()
  local uni_dict = data.get()
  local complete_list = {}

  local line = vim.fn.getline(".")
  local start = vim.fn.col(".") - 1

  while start > 0 and not line:sub(start, start):match("%s") do
    start = start - 1
  end

  local type_info = {}
  if line:sub(start + 1, start + 1) == "U" and line:sub(start + 2, start + 2) == "+" and vim.fn.col(".") - 1 >= start + 2 then
    type_info.numeric = true
  elseif line:sub(start + 1, start + 1) == "&" then
    type_info.entity = true
  end

  local base = line:sub(start + 1, vim.fn.col(".") - 1):gsub("%s+$", "")

  if base == "" then
    complete_list = uni_dict
    vim.cmd('echom "(Checking all Unicode Names... this might be slow)"')
  else
    if not type_info.numeric and not type_info.entity then
      -- Name-based completion, prefer match at start
      local html_entities = require("unicode.html_entities")
      local list1, list2, list3 = {}, {}, {}
      local pattern = base:lower()
      for k, v in pairs(uni_dict) do
        local lower_v = v:lower()
        if lower_v:sub(1, #pattern) == pattern then
          list1[k] = v
        elseif lower_v:find("%f[%w]" .. vim.pesc(pattern)) then
          list2[k] = v
        elseif lower_v:find(pattern, 1, true) then
          list3[k] = v
        end
      end
      local compl = add_complete_entries(list1)
      local seen = {}
      for _, e in ipairs(compl) do
        seen[e.word] = true
      end
      for _, dict in ipairs({ list2, list3 }) do
        for _, e in ipairs(add_complete_entries(dict)) do
          if not seen[e.word] then
            compl[#compl + 1] = e
            seen[e.word] = true
          end
        end
      end
      vim.fn.complete(start + 1, compl)
      return ""
    elseif type_info.numeric then
      local hex_base = base:sub(3):upper()
      for k, v in pairs(uni_dict) do
        local hex = string.format("%04X", k)
        if hex:sub(1, #hex_base) == hex_base then
          complete_list[k] = v
        end
      end
    elseif type_info.entity then
      local html_entities = require("unicode.html_entities")
      for k, entities in pairs(html_entities) do
        for _, entity in ipairs(entities) do
          if entity:find(base, 1, true) then
            complete_list[k] = uni_dict[k] or ""
            break
          end
        end
      end
    end
    vim.cmd(string.format('echom "(Checking Unicode Names for \\"%s\\"... this might be slow)"', base))
  end

  local compl = add_complete_entries(complete_list)
  vim.fn.complete(start + 1, compl)
  return ""
end

--- Insert-mode completion for HTML entities.
--- @return string
function M.complete_html_entity()
  local html_entities = require("unicode.html_entities")
  local line = vim.fn.getline(".")
  local start = vim.fn.col(".") - 1

  while start > 0 and not line:sub(start, start):match("%s") do
    start = start - 1
  end

  local base = line:sub(start + 1, vim.fn.col(".") - 1):gsub("%s+$", "")

  local filtered = {}
  for k, entities in pairs(html_entities) do
    for _, entity in ipairs(entities) do
      if entity:find(base, 1, true) then
        filtered[k] = entities
        break
      end
    end
  end

  local compl = add_html_complete_entries(filtered, base)
  vim.fn.complete(start + 1, compl)
  return ""
end

--- Insert-mode completion for digraphs.
--- @return string
function M.complete_digraph()
  local line = vim.fn.getline(".")
  local col = vim.fn.col(".")
  local prevchar = line:sub(col - 2, col - 2) or ""
  local prevchar1 = line:sub(col - 3, col - 3) or ""

  local dlist = vim.tbl_values(digraph.get_dict())

  if prevchar ~= "" and not prevchar:match("%s") then
    -- Filter digraphs matching previous characters
    local filtered = {}
    for _, entries in ipairs(dlist) do
      local text = table.concat(entries, " ")
      if text:find(prevchar1 .. prevchar, 1, true) then
        filtered[#filtered + 1] = entries
      end
    end

    if #filtered == 0 then
      -- Fallback: match either character
      for _, entries in ipairs(dlist) do
        local text = table.concat(entries, " ")
        if text:find(prevchar1, 1, true) or text:find(prevchar, 1, true) then
          filtered[#filtered + 1] = entries
        end
      end
      col = col - 1
    else
      col = col - (prevchar1 == "" and 1 or 2)
    end
    dlist = filtered
  end

  local compl = add_digraph_complete_entries(dlist)
  vim.fn.complete(col, compl)
  return ""
end

return M
