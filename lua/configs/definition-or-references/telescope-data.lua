local function filter_entries(results)
  local function should_include_entry(entry)
    -- if entry is closing tag - just before it there is a closing tag syntax '</'
    if entry.col > 2 and entry.text:sub(entry.col - 2, entry.col - 1) == '</' then
      return false
    end

    return true
  end

  return vim.tbl_filter(should_include_entry, vim.nonnil(results, {}))
end

--- @return table
local function add_metadata_to_locations(locations)
  return vim.tbl_map(function(location)
    if string.find(location.text, '^import') then
      location.is_inside_import = true
    end

    location.display_path = require('telescope.utils').path_smart(location.filename)

    if string.find(location.filename, '.spec.') or string.find(location.filename, 'TestBuilder') then
      location.is_test_file = true
    end

    return location
  end, locations)
end

local get_data = function(result)
  local locations = vim.lsp.util.locations_to_items(result, 'utf-16')
  local filtered_entries = filter_entries(locations)
  return add_metadata_to_locations(filtered_entries)
end

return { get_data = get_data }
