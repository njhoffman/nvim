local finders = require("telescope.finders")
local display = require("telescope._extensions.find_pickers.display")
local generate = require("telescope._extensions.find_pickers.generate")

local sort_pickers = function(a, b)
  return a.name < b.name
end

return {
  get_finder = function(opts)
    local result_table = {}
    generate.builtins(result_table)
    generate.extensions(result_table)
    local parsed_table = generate.metadata(result_table, opts)
    table.sort(parsed_table, sort_pickers)
    return finders.new_table({
      results = parsed_table,
      entry_maker = display.entry_maker(parsed_table)
    })
  end
}
