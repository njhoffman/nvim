local previewers = require('telescope.previewers')
local pickers = require('telescope.pickers')
local make_entry = require('telescope.make_entry')
local finders = require('telescope.finders')
local entry_display = require('telescope.pickers.entry_display')
-- local finders = require('telescope._extensions.tester.finders')
local sorters = require('telescope._extensions.tester.sorters')

local displayer = entry_display.create({
  separator = ' ▏',
  items = {
    { width = 5 },
    { remaining = true },
  },
})

local function make_display(entry)
  -- concatenating multiline env values
  return displayer({
    { entry.value[1], 'TelescopeResultsClass' },
    { entry.value[2] },
  })
end

local results = {}

local entry_maker = function(line)
  table.insert(results, line)
  local entry = vim.fn.split(line, ' ')
  return {
    value = entry,
    display = make_display,
    ordinal = string.format('%s %s', entry[1], entry[2]),
  }
end

local function script(opts)
  -- local script = vim.fn.stdpath('config') .. '/lua/gitops/scripts/commits.sh'
  -- local command = { script_file, '--git-dir=/home/nicholas/.cfg', '--work-tree=/home/nicholas' }
  local script_file = vim.fn.stdpath('config') .. '/lua/telescope/_extensions/tester/test.sh'
  local command = { 'bash', script_file }
  opts = opts or {}
  opts.entry_maker = opts.entry_maker or entry_maker
  -- opts.finder_type = 'one_shot_finder' -- one_shot_finder, job_finder, dynamic_job
  -- opts.sorter_type = 'substr'
  local timing = { total = vim.fn.reltime(_, _) }
  pickers
    .new(opts, {
      prompt_title = 'Script Tester',
      finder = finders.new_oneshot_job(command, opts),
      -- previewer = conf.file_previewer(opts),
      sorter = sorters.get_sorter(opts),
      on_complete = {
        function(picker)
          -- processed, displayed, looped, previewed
          -- log_timing(picker.stats.processed)
          vim.dbglog('COMPLETE', picker.stats.processed)
        end,
      },
      -- previewer = previewers.new_buffer_previewer({
      --   define_preview = function(self, entry, status)
      --     -- Execute another command using the highlighted entry
      --     return require('telescope.previewers.utils').job_maker(
      --       { 'terraform', 'state', 'list', entry.value },
      --       self.state.bufnr,
      --       {
      --         callback = function(bufnr, content)
      --           if content ~= nil then
      --             require('telescope.previewers.utils').regex_highlighter(bufnr, 'terraform')
      --           end
      --         end,
      --       }
      --     )
      --   end,
      -- }),
    })
    :find()
end

return script
