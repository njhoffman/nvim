local utils = require("telescope._extensions.devhints.utils")
local scan = require("plenary.scandir")

local basepath = vim.fn.stdpath("data") .. "/devhints"

local filetypes = {
  bash = "bash",
  go = "go",
  js = { "nodejs", "nodejs-fs" },
  lua = "lua",
  sh = "bash",
}

local get_widths = function(part_lines)
  local widths = {}
  for _, line in ipairs(part_lines) do
    for n, part in ipairs(line) do
      if type(widths[n]) == "nil" then
        widths[n] = 0
      end
      if type(part) == "string" and #part > widths[n] then
        widths[n] = #part
      end
    end
  end
  return widths
end

local get_topics = function(name)
  local path = basepath .. "/" .. name
  local sections = utils.load_file(path)
  local entries = {}
  for _, section in ipairs(sections) do
    table.insert(entries, {
      (section.category or ""),
      (section.subcategory or ""),
      tostring(#section.lines),
      section.lines or {},
    })
  end
  local widths = get_widths(entries)
  return entries, widths
end

local get_categories = function()
  local titles = { unparsed = {}, parsed = {} }
  local files = scan.scan_dir(basepath, {
    search_pattern = ".md$",
  })
  for i, file in ipairs(files) do
    local sections = utils.load_file(file)
    if #sections > 0 then
      table.insert(titles.parsed, { #sections, sections[1].title, file })
    else
      table.insert(titles.unparsed, { #titles.unparsed, file })
    end
  end
  return titles
end

return { get_topics = get_topics, get_categories = get_categories }
