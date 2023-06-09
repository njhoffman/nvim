local builtin_pickers = require('telescope.builtin')
local extensions_pickers = require('telescope._extensions')

local build_builtins = function(results)
  local builtin_list = vim.tbl_keys(builtin_pickers)
  for i, command in ipairs(builtin_list) do
    table.insert(results, i, {
      extension = false,
      name = command,
      command = command,
    })
  end
end

local build_extensions = function(results)
  for ext_name, commands in pairs(extensions_pickers.manager) do
    -- try to assign default command
    local command = nil
    if commands[ext_name] ~= nil then
      command = ext_name
    elseif #vim.tbl_keys(commands) == 1 then
      command = vim.tbl_keys(commands)[1]
    end

    if command ~= nil then
      local item = {
        extension = ext_name,
        command = command,
        name = ext_name,
      }
      table.insert(results, #results + 1, item)
    end
    -- or list each extensions command as a list item, don't duplicate primary command
    for cmd, _ in pairs(commands) do
      local item = {
        extension = ext_name,
        command = cmd,
        name = ext_name .. '_' .. cmd,
      }
      if command == nil or command ~= cmd then
        table.insert(results, #results + 1, item)
      end
    end
  end
  return results
end

local build_metadata = function(results, opts)
  -- add additional pickers if defined in 'new_pickers' option
  for new_name, new_entry in pairs(opts.additional) do
    new_entry.name = new_name
    table.insert(results, #results + 1, new_entry)
  end

  local parsed = {}
  for _, entry in pairs(results) do
    local skip = #opts.include_only > 0 and not vim.tbl_contains(opts.include_only, entry.name)
      or vim.tbl_contains(opts.exclude, entry.name)
    if not skip then
      if entry.extension == false then
        entry.title = 'builtin' .. '.' .. entry.command
      else
        entry.title = entry.extension .. '.' .. entry.command
      end
      table.insert(parsed, #parsed + 1, entry)
    end
  end
  return parsed
end

return {
  metadata = build_metadata,
  extensions = build_extensions,
  builtins = build_builtins,
}
