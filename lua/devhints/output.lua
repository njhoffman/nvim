local utils = require("devhints.utils")
local scan = require("plenary.scandir")

local basepath = vim.fn.stdpath("config") .. "/lua/devhints/cheatsheets"

local outline = function(name, lines)
  local path = basepath .. "/" .. name
  local sections = utils.load_file(path)
  for i, section in ipairs(sections) do
    vim.dbglog((section.category or "") .. ": " .. (section.subcategory or "") .. " " .. #section.lines)
    if lines then
      for n, line in ipairs(section.lines) do
        vim.dbglog("  - " .. line)
      end
    end
  end
end

local all_titles = function()
  local titles = { unparsed = {}, parsed = {} }
  local files = scan.scan_dir(basepath, {
    search_pattern = ".md$",
  })
  for i, file in ipairs(files) do
    local sections = utils.load_file(file)
    if #sections > 0 then
      table.insert(titles.parsed, { #titles.parsed, #sections, sections[1].title, file })
    else
      table.insert(titles.unparsed, { #titles.unparsed, file })
    end
  end
  return titles
end

return { outline = outline, all_titles = all_titles }
