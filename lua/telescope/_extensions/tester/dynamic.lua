local pickers = require("telescope.pickers")
local sorters = require("telescope._extensions.tester.sorters")
local finders = require("telescope.finders")
local make_entry = require("telescope.make_entry")

local logger = require("lib.logger").init("teletester")

local async_job = require("telescope.async_job")

local timer = vim.uv.new_timer()
local fn = function(opts)
  local entry_maker = opts.entry_maker or make_entry.gen_from_string(opts)
  return function(_, prompt, process_result, process_complete)
    -- if not timer or (timer and timer:is_closing()) then
    --   timer = vim.loop.new_timer()
    -- end
    local line_num = 0
  --stylua: ignore
  timer:start(3000, 100,
    vim.schedule(function()
      line_num = line_num + 1
      local entry = entry_maker(vim.fn.join({'Tick tock:', tostring(timer.id), tostring(line_num), tostring(os.time()) }, ' '))
      if entry then
        entry.index = line_num
      end
      -- if process_result(entry) then
      --   return
      -- end
      -- callback()
    end))
  end
end

-- local a = require('plenary.async_lib')
-- local async = a.async
local function dynamic_picker(opts)
  opts = opts or {}
  local finder = finders.new_dynamic({
    fn = fn(opts),
    entry_maker = opts.entry_maker or make_entry.gen_from_string(opts),
  })
  pickers
    .new(opts, {
      prompt_title = "Dynamic Async Tester",
      finder = finder,
      sorter = sorters.get_sorter(opts),
      on_complete = {
        function(picker)
          logger:info("COMPLETE", picker.stats.processed)
        end,
      },
    })
    :find()
end
-- dynamic_picker()
-- return dynamic_picker
