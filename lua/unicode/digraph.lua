local names = require("unicode.names")

local M = {}

local digdict = nil

--- Parse the output of :digraphs into a dictionary.
--- @param output string Raw output from :digraphs
--- @return table Dictionary of decimal -> list of raw entries
function M.parse_digraphs(output)
  local dict = {}
  local text = output:gsub("\n", " ")

  -- Split on pattern: 2-char digraph, space, glyph (1-4 chars), space(s), decimal number
  -- Each entry looks like: "ab X  1234"
  local entries = {}
  for entry in text:gmatch("[^\n]*") do
    -- fallback: split the whole text by the end-of-entry decimal pattern
    table.insert(entries, entry)
  end

  -- Better approach: split the concatenated text by matching each digraph entry
  local pos = 1
  local len = #text
  while pos <= len do
    -- Skip leading whitespace
    while pos <= len and text:sub(pos, pos):match("%s") do
      pos = pos + 1
    end
    if pos > len then
      break
    end

    -- Match: two chars, space(s), glyph (possibly multi-byte), space(s), decimal number
    local entry_match = text:match("^(..%s+.-%s+%d+)", pos)
    if entry_match then
      local dig_chars, glyph, dec_str = entry_match:match("^(..)%s+(.-)%s+(%d+)$")
      if dig_chars and dec_str then
        local dec = tonumber(dec_str)
        if dec == 10 and dig_chars == "NU" then
          dec = 0
        end
        if dec then
          if not dict[dec] then
            dict[dec] = {}
          end
          table.insert(dict[dec], entry_match)
        end
      end
      pos = pos + #entry_match
    else
      pos = pos + 1
    end
  end

  return dict
end

--- Get the digraph dictionary, building it on first access.
--- @return table
function M.get_dict()
  if digdict and next(digdict) then
    return digdict
  end

  local result = vim.api.nvim_exec2("digraphs", { output = true })
  local output = result.output or ""
  digdict = M.parse_digraphs(output)
  return digdict
end

--- Clear the cached digraph dictionary (e.g., after DigraphNew).
function M.clear_dict()
  digdict = nil
end

--- Get formatted digraph characters for a decimal codepoint.
--- @param code number Decimal codepoint
--- @return string Formatted digraph string like "(ab cd)" or empty string
function M.get_chars(code)
  local dict = M.get_dict()
  local entries = dict[code]
  if not entries or #entries == 0 then
    return ""
  end

  local chars = {}
  for _, entry in ipairs(entries) do
    local dig = entry:sub(1, 2)
    if dig and not vim.tbl_contains(chars, dig) then
      table.insert(chars, dig)
    end
  end

  if #chars == 0 then
    return ""
  end
  return "(" .. table.concat(chars, " ") .. ")"
end

--- Convert a two-character string into its digraph result.
--- @param char_pair string Exactly 2 characters
--- @return string The digraph character, or empty string if none
function M.digraph(char_pair)
  local c = vim.fn.split(char_pair, [[\zs]])
  if #c ~= 2 then
    vim.notify("UnicodePlugin: Need exactly 2 chars for returning digraphs!", vim.log.levels.WARN)
    return ""
  end

  -- Use the ex command to get the digraph
  local result = ""
  local ok = pcall(function()
    vim.cmd(string.format([[norm! :""\<C-k>%s%s\<C-\>eextend(g:, {'_unicode_dig': getcmdline()})._unicode_dig\n]], c[1], c[2]))
    result = vim.g._unicode_dig or ""
    vim.g._unicode_dig = nil
  end)

  if not ok or result == c[1] or result == c[2] then
    return ""
  end
  return result
end

--- Operator function for converting character pairs to digraphs.
--- @param type string Motion type ("char", "line", "block")
--- @param visual boolean|nil Whether invoked from visual mode
function M.get_digraph(type, visual)
  local sel_save = vim.o.selection
  vim.o.selection = "inclusive"
  local reg_save = { vim.fn.getreg("a"), vim.fn.getregtype("a") }

  if visual then
    vim.cmd('silent normal! `<' .. type .. '`>"ay')
  elseif type == "line" then
    vim.cmd([[silent normal! '[V']"ay]])
  elseif type == "block" then
    vim.cmd([[silent normal! `[\<C-V>`]"ay]])
  else
    vim.cmd([[silent normal! `[v`]"ay]])
  end

  local text = vim.fn.getreg("a")
  local chars = vim.fn.split(text, [[\zs]])
  local s = ""

  local i = 1
  while i <= #chars do
    local char0 = chars[i]
    local nr0 = vim.fn.char2nr(char0)

    -- Skip non-ASCII, control chars, spaces, or last char alone
    if nr0 > 126 or nr0 < 20 or char0 == " " or i == #chars then
      s = s .. char0
      i = i + 1
    else
      local char1 = chars[i + 1]
      if not char1 then
        s = s .. char0
        i = i + 1
      else
        local nr1 = vim.fn.char2nr(char1)
        if nr1 > 126 or nr1 < 20 or char1 == " " then
          s = s .. char0 .. char1
          i = i + 2
        else
          local t = M.digraph(char0 .. char1)
          local nr = vim.fn.char2nr(t)
          if nr == 0 then
            -- No digraph available, try next char
            s = s .. char0
            i = i + 1
          else
            local subset = vim.g.Unicode_ConvertDigraphSubset
            if subset and not vim.tbl_contains(subset, nr) then
              s = s .. char0 .. char1
            else
              s = s .. t
            end
            i = i + 2
          end
        end
      end
    end
  end

  if s ~= text then
    vim.fn.setreg("a", s, type:sub(1, 1))
    vim.cmd('normal! gv"ap')
  end

  vim.o.selection = sel_save
  vim.fn.setreg("a", reg_save[1], reg_save[2])
end

return M
