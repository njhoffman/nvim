local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local conf = require('telescope.config').values

-- opts.file needs to have spaces scaped, for example:
-- :Telescope locate file=*/Vulkan\ *
-- is similar to: locate "*/Vulkan *"
local function locate(opts)
  opts = opts or {}
  if not opts.file then
    opts.file = '.'
  end
  pickers
    .new(opts, {
      prompt_title = 'Locate',
      finder = finders.new_oneshot_job({ 'locate', opts.file }, opts),
      previewer = conf.file_previewer(opts),
      sorter = conf.file_sorter(opts),
    })
    :find()
end

return locate
-- return locate()
