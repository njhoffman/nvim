local pickers = require('telescope.pickers')
local sorters = require('telescope._extensions.tester.sorters')
local finders = require('telescope.finders')
local make_entry = require('telescope.make_entry')

local logger = require('logger').init('teletester')

local async_job = require('telescope._')

-- finders.new_dynamic = function(opts)
--   return DynamicFinder:new(opts)
-- end
-- return async_oneshot_finder {
--   entry_maker = opts.entry_maker or make_entry.gen_from_string(opts),
--
--   cwd = opts.cwd,
--   maximum_results = opts.maximum_results,
--
--   fn_command = function()
--     return {
--       command = command,
--       args = command_list,
--     }
--   end,
-- }
-- local dynamic_finder = function(opts)
--   logger:trace('Creating async_job:', opts)
--   return {
--     entry_maker = entry_maker,
--     finder = --       )
--       process_complete()
--     end,
--   }
-- end

-- local requester = function()
--   return function(prompt)
--     if not opts.prompt and utils.is_blank(prompt) then
--       return {}
--     end
--     if type(opts.prompt) == "string" then
--       opts.prompt = { opts.prompt }
--     end
--     local results = {}
--     for _, val in ipairs(opts.prompt) do
--       local _prompt = prompt
--       if val then
--         _prompt = string.format("%s %s", val, _prompt)
--       end
--       local query = graphql("search_query", _prompt)
--       local output = gh.run {
--         args = { "api", "graphql", "-f", string.format("query=%s", query) },
--         mode = "sync",
--       }
--       if output then
--         local resp = vim.fn.json_decode(output)
--         for _, issue in ipairs(resp.data.search.nodes) do
--           table.insert(results, issue)
--         end
--       end
--     end
--     return results
--   end

local timer = vim.loop.new_timer()
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
      prompt_title = 'Dynamic Async Tester',
      finder = finder,
      -- finder = finders.new_dynamic({
      --   -- fn = async(function(prompt)
      --   --   return { prompt }
      --   -- end),
      --   fn = async(function(prompt)
      --     local results = {}
      --     for i = 1, 100 do
      --       table.insert(results, prompt .. i)
      --     end
      --     return results
      --   end),
      --   entry_maker = require('telescope.make_entry').gen_from_string({}),
      -- }),
      sorter = sorters.get_sorter(opts),
      on_complete = {
        function(picker)
          logger:info('COMPLETE', picker.stats.processed)
        end,
      },
    })
    :find()
end
-- dynamic_picker()
-- return dynamic_picker
