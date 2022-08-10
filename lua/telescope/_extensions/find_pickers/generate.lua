local builtin_pickers = require("telescope.builtin")
local extensions_pickers = require("telescope._extensions")

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

return {
  metadata = build_metadata,
  extensions = build_extensions,
  builtins = build_builtins

}
