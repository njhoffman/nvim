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
    local display =
      string.format("%-" .. opts.column_len .. "s : %s", module_name, reload_item.basepath)
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
