local pickers = require('telescope.pickers')
local finders = require('telescope._extensions.tester.finders')
local sorters = require('telescope._extensions.tester.sorters')

local function script(opts)
  -- local command = { 'bash', script }
  -- local script = vim.fn.stdpath('config') .. '/lua/gitops/scripts/commits.sh'
  local script_file = vim.fn.stdpath('config') .. '/lua/telescope/_extensions/tester/test.sh'
  local command = { script_file, '--git-dir=/home/nicholas/.cfg', '--work-tree=/home/nicholas' }
  opts = opts or {}
  opts.finder_type = 'one_shot_finder' -- one_shot_finder, job_finder, dynamic_job
  opts.sorter_type = 'substr'
  local timing = { total = vim.fn.reltime(_, _) }
  pickers
    .new(opts, {
      prompt_title = 'Script Tester',
      -- finder = finders.new_oneshot_job(command, opts),
      finder = finders.get_finder(opts, command),
      -- previewer = conf.file_previewer(opts),
      sorter = sorters.get_sorter(opts),
      on_complete = {
        function(picker)
          -- processed, displayed, looped, previewed
          -- log_timing(picker.stats.processed)
          vim.dbglog('COMPLETE', picker.stats.processed)
        end,
      },
    })
    :find()
end

return script
