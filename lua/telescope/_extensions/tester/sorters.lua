local make_entry = require('telescope.make_entry')
local conf = require('telescope.config').values
local sorters = require('telescope.sorters')

local get_sorter = function(opts)
  local sorter_type = opts.sorter_type or 'highlighter'
  local _sorters = {
    substr = sorters.get_substr_matcher(),
    conf_file = conf.file_sorter(opts),
    highlighter = sorters.highlighter_only(opts),
    string = make_entry.gen_from_string(opts),
    generic_fuzzy = sorters.get_generic_fuzzy_sorter(opts),
  }
  return _sorters[sorter_type]
end

return { get_sorter = get_sorter }
