function make_entry.gen_from_vimoptions()
  local process_one_opt = function(o)
    local ok, value_origin

    local option = {
      name = "",
      description = "",
      current_value = "",
      default_value = "",
      value_type = "",
      set_by_user = false,
      last_set_from = "",
    }

    local is_global = false
    for _, v in ipairs(o.scope) do
      if v == "global" then
        is_global = true
      end
    end

    if not is_global then
      return
    end

    if is_global then
      option.name = o.full_name

      ok, option.current_value = pcall(vim.api.nvim_get_option, o.full_name)
      if not ok then
        return
      end

      local str_funcname = o.short_desc()
      option.description = assert(loadstring(str_funcname))()
      -- if #option.description > opts.desc_col_length then
      --   opts.desc_col_length = #option.description
      -- end

      if o.defaults ~= nil then
        option.default_value = o.defaults.if_true.vim or o.defaults.if_true.vi
      end

      if type(option.default_value) == "function" then
        option.default_value = "Macro: " .. option.default_value()
      end

      option.value_type = (type(option.current_value) == "boolean" and "bool" or type(option.current_value))

      if option.current_value ~= option.default_value then
        option.set_by_user = true
        value_origin = vim.fn.execute("verbose set " .. o.full_name .. "?")
        if string.match(value_origin, "Last set from") then
          -- TODO: parse file and line number as separate items
          option.last_set_from = value_origin:gsub("^.*Last set from ", "")
        end
      end

      return option
    end
  end

  local displayer = entry_display.create {
    separator = "",
    hl_chars = { ["["] = "TelescopeBorder", ["]"] = "TelescopeBorder" },
    items = {
      { width = 25 },
      { width = 12 },
      { remaining = true },
    },
  }

  local make_display = function(entry)
    return displayer {
      { entry.name, "Keyword" },
      { "[" .. entry.value_type .. "]", "Type" },
      utils.display_termcodes(tostring(entry.current_value)),
      entry.description,
    }
  end

  return function(line)
    local entry = process_one_opt(line)
    if not entry then
      return
    end

    entry.valid = true
    entry.display = make_display
    entry.value = line
    entry.ordinal = line.full_name
    -- entry.raw_value = d.raw_value
    -- entry.last_set_from = d.last_set_from

    return entry
  end
end
