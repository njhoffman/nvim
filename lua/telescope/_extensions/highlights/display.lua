local entry_display = require("telescope.pickers.entry_display")

local M = {}

local displayer = entry_display.create({
  separator = " ",
  items = {
    { width = 2 },
    { width = 35 },
    { width = 50 },
    { remaining = true },
  },
})

local function format_attrs(hl)
  if not hl or vim.tbl_isempty(hl) then
    return ""
  end

  if hl.link then
    return "link=" .. hl.link
  end

  local parts = {}

  if hl.fg then
    table.insert(parts, "fg=" .. string.format("#%06x", hl.fg))
  end
  if hl.bg then
    table.insert(parts, "bg=" .. string.format("#%06x", hl.bg))
  end
  if hl.sp then
    table.insert(parts, "sp=" .. string.format("#%06x", hl.sp))
  end

  local bool_attrs = {
    "bold",
    "italic",
    "underline",
    "undercurl",
    "strikethrough",
    "reverse",
    "nocombine",
  }
  for _, attr in ipairs(bool_attrs) do
    if hl[attr] then
      table.insert(parts, attr)
    end
  end

  return table.concat(parts, " ")
end

local function make_display(entry)
  local hl = entry.value.hl or {}
  local swatch_hl = nil

  if hl.fg then
    local hex = string.format("#%06x", hl.fg)
    swatch_hl = "HlPickSwatch_" .. hex:gsub("#", "")
    pcall(vim.api.nvim_set_hl, 0, swatch_hl, { fg = hex })
  end

  local source_tag = entry.value.source and ("[" .. entry.value.source:gsub("%.lua$", "") .. "]") or ""

  return displayer({
    { "██", swatch_hl or "NonText" },
    { entry.value.name, entry.value.name },
    { format_attrs(hl), "Comment" },
    { source_tag, "TelescopeResultsComment" },
  })
end

function M.entry_maker(item)
  return {
    display = make_display,
    value = item,
    ordinal = item.name .. " " .. (item.source or ""),
  }
end

return M
