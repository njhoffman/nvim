local M = {}

--- Get all highlight groups with their current definitions and source info.
--- @return table List of { name, hl, source }
function M.get_highlights()
  local persistence = require("commands.colors.persistence")
  local source_index = persistence.build_source_index()

  local all_hls = vim.api.nvim_get_hl(0, {})
  local results = {}

  for name, hl in pairs(all_hls) do
    local source_info = source_index[name]
    table.insert(results, {
      name = name,
      hl = hl,
      source = source_info and source_info.file or nil,
    })
  end

  table.sort(results, function(a, b)
    return a.name < b.name
  end)

  return results
end

--- Get only highlights defined in colorscheme source files.
--- @return table
function M.get_colorscheme_highlights()
  local persistence = require("commands.colors.persistence")
  local source_index = persistence.build_source_index()
  local results = {}

  for name, info in pairs(source_index) do
    local hl = vim.api.nvim_get_hl(0, { name = name, link = true })
    table.insert(results, {
      name = name,
      hl = hl,
      source = info.file,
    })
  end

  table.sort(results, function(a, b)
    return a.name < b.name
  end)

  return results
end

return M
