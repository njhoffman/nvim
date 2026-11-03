local M = {}

-- Special Unicode ranges that aren't in UnicodeData.txt individually
local ranges = {
  { 0x3400, 0x4DB5, "Ideograph Extension A" },
  { 0x4E00, 0x9FFF, "CJK Ideograph" },
  { 0xAC00, 0xD7AF, "Hangul Syllable" },
  { 0xD800, 0xDB7F, "Non-Private Use High Surrogates" },
  { 0xDB80, 0xDBFF, "Private Use High Surrogates" },
  { 0xDC00, 0xDFFF, "Low Surrogates" },
  { 0xE000, 0xF8FF, "Private Use Zone" },
  { 0xFDD0, 0xFDEF, "<No Character>" },
  { 0x17000, 0x187EC, "Tangut Ideograph" },
  { 0x20000, 0x2A6D6, "Ideograph Extension B" },
  { 0x2A700, 0x2B73F, "Ideograph Extension C" },
  { 0xF0000, 0xFFFFD, "Character from Plane 15 for private use" },
  { 0x100000, 0x10FFFD, "Character from Plane 16 for private use" },
}

-- Exact codepoints with special names
local exact = {
  [0xFFFE] = "<No Character (BOM)>",
  [0xFFFF] = "<No Character>",
}

-- Plane boundaries that are <No Character>
local no_char_boundaries = {
  0x1FFFE, 0x1FFFF, 0x2FFFE, 0x2FFFF, 0x3FFFE, 0x3FFFF,
  0x4FFFE, 0x4FFFF, 0x5FFFE, 0x5FFFF, 0x6FFFE, 0x6FFFF,
  0x7FFFE, 0x7FFFF, 0x8FFFE, 0x8FFFF, 0x9FFFE, 0x9FFFF,
  0xAFFFE, 0xAFFFF, 0xBFFFE, 0xBFFFF, 0xCFFFE, 0xCFFFF,
  0xDFFFE, 0xDFFFF, 0xEFFFE, 0xEFFFF, 0xFFFFE, 0xFFFFF,
  0x10FFFE, 0x10FFFF,
}

local no_char_set = {}
for _, v in ipairs(no_char_boundaries) do
  no_char_set[v] = true
end

--- Resolve a Unicode name for a decimal codepoint, using special range fallbacks.
--- @param dec number Decimal codepoint value
--- @param uni_dict table|nil The loaded unicode dictionary (decimal -> name)
--- @return string
function M.resolve(dec, uni_dict)
  if uni_dict then
    local name = uni_dict[dec]
    if name and name ~= "" then
      return name
    end
  end

  if exact[dec] then
    return exact[dec]
  end

  if no_char_set[dec] then
    return "<No Character>"
  end

  for _, range in ipairs(ranges) do
    if dec >= range[1] and dec <= range[2] then
      return range[3]
    end
  end

  return "Character not found"
end

return M
