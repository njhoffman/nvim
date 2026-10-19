local entry_display = require("telescope.pickers.entry_display")

local make_display = function(mapping, opts)
  local displayer_items = {
    { width = opts.mode_width },
    { width = opts.keybind_width },
    { width = opts.name_width },
  }

  if opts.only_show_current_mode then
    opts.mode_width = 0
    displayer_items = {
      { width = opts.keybind_width },
      { width = opts.name_width },
    }
  end

  local displayer = entry_display.create({
    separator = opts.separator,
    items = displayer_items,
  })

  local mode_hl = mapping.custom and "TelescopeWhichKeyModeCustom" or "TelescopeWhichKeyMode"
  local bind_hl = mapping.custom and "TelescopeWhichKeyBindCustom" or "TelescopeWhichKeyBind"
  local name_hl = mapping.custom and "TelescopeWhichKeyNameCustom" or "TelescopeWhichKeyName"
  if opts.only_show_current_mode then
    return displayer({
      { mapping.keybind, vim.nonnil(opts.keybind_hl, bind_hl) },
      { mapping.name, vim.nonnil(opts.name_hl, name_hl) },
    })
  end
  return displayer({
    { mapping.mode, vim.nonnil(opts.mode_hl, mode_hl) },
    { mapping.keybind, vim.nonnil(opts.keybind_hl, bind_hl) },
    { mapping.name, vim.nonnil(opts.name_hl, name_hl) },
  })
end

return { make_display = make_display }
