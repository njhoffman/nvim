local entry_display = require("telescope.pickers.entry_display")
local make_entry = require("telescope.make_entry")

local format_path = function(path)
  local p = vim.fn.fnamemodify(path, ":~:.")
  return string.gsub(p, "^~/.local/share/nvim/lazy", "~/lazy")
end

local function gen_from_packages(opts, reload_list)
  opts = opts or {}

  local make_display = function(reload_item)
    local module_name = reload_item.name
    reload_item.basepath = format_path(reload_item.filepath)
    -- get last modified date
    reload_item.last_modified = vim.fn.strftime("%c", vim.fn.getftime(reload_item.filepath))
    reload_item.reload_count = 0
    -- local path = vim.fn.fnamemodify(reload_item.filepath, ":~:.")
    local display =
      string.format("%-" .. opts.column_len .. "s : %s", module_name, reload_item.basepath)

    -- local displayer = entry_display.create({
    --   separator = opts.separator,
    --   items = displayer_items,
    -- })

    --   local displayer_items = {
    --     { width = opts.mode_width },
    --     { width = opts.keybind_width },
    --     { width = opts.name_width },
    --   }
    --
    --   if opts.only_show_current_mode then
    --     opts.mode_width = 0
    --     displayer_items = {
    --       { width = opts.keybind_width },
    --       { width = opts.name_width },
    --     }
    --   end
    --
    -- return displayer({
    --   { mapping.mode, vim.F.if_nil(opts.mode_hl, mode_hl) },
    --   { mapping.keybind, vim.F.if_nil(opts.keybind_hl, bind_hl) },
    --   { mapping.name, vim.F.if_nil(opts.name_hl, name_hl) },
    -- })
    return display
  end

  return function(reload_item)
    local module_name = reload_item.name
    return make_entry.set_default_entry_mt({
      valid = module_name ~= "",
      value = reload_item,
      ordinal = module_name,
      display = make_display(reload_item),
    }, opts)
  end
end

return gen_from_packages
