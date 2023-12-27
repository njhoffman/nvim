local has_telescope, telescope = pcall(require, 'telescope')
if not has_telescope then
  error('This plugin requires nvim-telescope/telescope.nvim')
end

local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local conf = require('telescope.config').values

local function test(opts)
  opts = opts or {}
  local entry_maker = function(entry)
    return make_entry.set_default_entry_mt({
      value = entry,
      text = entry.text,
      display = entry.text,
      ordinal = entry.text,
      filename = entry.filename,
    }, opts)
  end
  pickers
    .new(opts, {
      prompt_title = 'Locate',
      finder = finders.new_oneshot_job(command, opts),
      previewer = conf.file_previewer(opts),
      sorter = conf.file_sorter(opts),
    })
    :find()
end

telescope.register_extension({
  exports = {
    test = test,
  },
})
test()
