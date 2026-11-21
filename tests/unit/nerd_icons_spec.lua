-- Nerd Fonts v3 dropped the v2 Material Design range (U+F500-U+FD46): those
-- icons draw blank, or as whatever font fontconfig falls back to. They were
-- migrated to the v3 md- positions (U+F0000+) in v0.37.2. Octicons legitimately
-- use U+F400-U+F533 in v3, so only U+F534-U+FD46 is checked. Comments may keep
-- old icons (sample lists, notes on a plugin's defaults); the data tables
-- listing every codepoint are skipped.

local ROOT = vim.fn.stdpath("config")
local SKIP = {
  ["lua/modules/unicode/nerd_chars.lua"] = true, -- describes v2 and v3 codepoints
  ["lua/nerdy/icons.lua"] = true, -- v3 icon list
}

local function old_icons_in_code(path)
  local found = {}
  local lnum = 0
  for line in io.lines(path) do
    lnum = lnum + 1
    local code = line:gsub("%-%-.*$", "") -- drop a trailing comment
    for _, cp in ipairs(vim.fn.str2list(code)) do
      if cp >= 0xF534 and cp <= 0xFD46 then
        table.insert(found, string.format("%s:%d U+%04X", path:sub(#ROOT + 2), lnum, cp))
      end
    end
  end
  return found
end

describe("nerd font icons", function()
  it("uses no Nerd Fonts v2-only icons in code", function()
    local found = {}
    for _, path in ipairs(vim.fn.globpath(ROOT, "lua/**/*.lua", false, true)) do
      if not SKIP[path:sub(#ROOT + 2)] then
        vim.list_extend(found, old_icons_in_code(path))
      end
    end
    assert.are.same({}, found)
  end)

  it("the check finds an old icon in code but not in a comment", function()
    local tmp = vim.fn.tempname() .. ".lua"
    local f = assert(io.open(tmp, "w"))
    f:write("local a = '\u{fa7d}' -- volume\n-- sample: \u{f64f}\n")
    f:close()
    local found = old_icons_in_code(tmp)
    os.remove(tmp)
    assert.are.equal(1, #found)
    assert.truthy(found[1]:find("U%+FA7D"))
  end)
end)
