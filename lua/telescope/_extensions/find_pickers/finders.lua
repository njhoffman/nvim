local finders = require("telescope.finders")
local builtin_pickers = require("telescope.builtin")
local entry_display = require("telescope.pickers.entry_display")
local extensions_pickers = require("telescope._extensions")
local strings = require("plenary.strings")

local entry_maker = function(widths)
  return function(entry)
    -- TODO: allow title to be a string or { string, highlight } table
    local displayer = entry_display.create({
      separator = " ▏",
      items = {
        { width = widths.name },
        { width = widths.title },
      },
    })

    local function make_display()
      return displayer({ {
        strings.align_str(entry.name, widths.name, true),
        "TelescopeResultsClass",
      }, {
        entry.title,
        "TelescopeResultsComment"
      },
      })
    end

    return {
      value = entry,
      display = make_display,
      ordinal = entry.name,
    }
  end
end

local build_widths = function(results)
  local widths = { title = 0, name = 0 }
  for _, entry in pairs(results) do
    for key, value in pairs(widths) do
      -- TODO: allow title to be a string or { string, highlight } table
      widths[key] = math.max(value, strings.strdisplaywidth(entry[key] or ''))
    end
  end
  return widths
end

local build_builtins = function(results)
  local builtin_list = vim.tbl_keys(builtin_pickers)
  for i, command in ipairs(builtin_list) do
    table.insert(results, i, {
      extension = false,
      name      = command,
      command   = command
    })
  end
end

local build_extensions = function(results)
  for extension_name, commands in pairs(extensions_pickers.manager) do
    -- try to assign default command
    local command = nil
    if commands[extension_name] ~= nil then
      command = extension_name
    elseif #vim.tbl_keys(commands) == 1 then
      command = vim.tbl_keys(commands)[1]
    end
    if command ~= nil then
      local item = {
        extension = extension_name,
        command   = command,
        name      = extension_name,
      }
      table.insert(results, #results + 1, item)
    else
      -- or list each extensions command as a list item
      for cmd, _ in pairs(commands) do
        local item = {
          extension = extension_name,
          command   = cmd,
          name      = extension_name .. '_' .. cmd,
        }
        table.insert(results, #results + 1, item)
      end
    end
  end
end

local build_metadata = function(results, opts)
  -- add additional pickers if defined in 'new_pickers' option
  if type(opts.new_pickers) == 'table' then
    for new_name, new_entry in pairs(opts.new_pickers) do
      new_entry.name = new_name
      table.insert(results, #results + 1, new_entry)
    end
  end

  local parsed = {}
  for _, entry in pairs(results) do
    -- merge values if extension or name exists in 'pickers' option
    if type(opts.pickers[entry.extension]) == 'table' then
      entry = vim.tbl_deep_extend("force", entry, opts.pickers[entry.extension])
    elseif type(opts.pickers[entry.name]) == 'table' then
      entry = vim.tbl_deep_extend("force", entry, opts.pickers[entry.name])
    end

    -- if key assigned to function reassign it to the return value of that function
    if type(entry.hidden) == 'function' then
      entry.hidden = entry.hidden(entry)
    end

    -- build default values
    if entry.extension == false then
      entry.title = 'builtin' .. '.' .. entry.command
    else
      entry.title = entry.extension .. '.' .. entry.command
    end

    if entry.hidden ~= true then
      table.insert(parsed, #parsed + 1, entry)
    end
  end
  return parsed
end

local sort_pickers = function(a, b)
  return a.name < b.name
end

return {
  get_finder = function(opts)
    local result_table = {}
    build_builtins(result_table)
    build_extensions(result_table)
    local parsed_table = build_metadata(result_table, opts)
    table.sort(parsed_table, sort_pickers)
    return finders.new_table({
      results = parsed_table,
      entry_maker = entry_maker(build_widths(parsed_table))
    })
  end
}
