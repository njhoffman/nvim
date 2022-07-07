-- local display = require("telescope._extensions.gotofile.display")
-- local entry_display = require("telescope.pickers.entry_display")

local entry_maker = function(entry)
  -- TODO: allow title to be a string or { string, highlight } table
  -- local displayer = entry_display.create({
  --   separator = " ▏",
  --   items = {
  --     { width = widths.name },
  --     { width = widths.title },
  --   },
  -- })

  -- local function make_display()
  --   return displayer({ {
  --     strings.align_str(entry.name, widths.name, true),
  --     "TelescopeResultsClass",
  --   }, {
  --     entry.title,
  --     "TelescopeResultsComment"
  --   },
  --   })
  -- end

  return {
    value = entry.path,
    display = entry.path,
    ordinal = entry.path,
    path = entry.path,
    lnum = entry.lnum,
    col = entry.col,
  }
end

return { entry_maker = entry_maker }
