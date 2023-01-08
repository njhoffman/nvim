local entry_display = require("telescope.pickers.entry_display")
local utils = require("telescope._extensions.options.utils")

local displayer = entry_display.create {
  separator = "",
  hl_chars = { ["["] = "TelescopeBorder", ["]"] = "TelescopeBorder" },
  items = {
    { width = 25 },
    { width = 12 },
    { width = 11 },
    { remaining = true },
  },
}

local make_display = function(entry)
  return displayer {
    { entry.value.name, "Keyword" },
    { "[" .. entry.value.type .. "]", "Type" },
    { "[" .. entry.value.scope .. "]", "Identifier" },
    utils.display_termcodes(tostring(entry.value.value)),
  }
end

local entry_maker = function(opt)
  local entry = {
    display = make_display,
    value = {
      name = opt.name,
      value = opt.default,
      type = opt.type,
      scope = opt.scope,
    },
    ordinal = string.format("%s %s %s", opt.name, opt.type, opt.scope),
  }

  local ok, value = pcall(vim.api.nvim_get_option, opt.name)
  if ok then
    entry.value.value = value
    entry.ordinal = entry.ordinal .. " " .. utils.display_termcodes(tostring(value))
  else
    entry.ordinal = entry.ordinal .. " " .. utils.display_termcodes(tostring(opt.default))
  end
  return entry
end

return { entry_maker = entry_maker }
