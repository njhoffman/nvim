local previewers = require("telescope.previewers")
local conf = require("telescope.config").values
local pickers = require("telescope.pickers")
local make_entry = require("telescope.make_entry")
local action_state = require("telescope.actions.state")
local finders = require("telescope.finders")
local entry_display = require("telescope.pickers.entry_display")
-- local finders = require('telescope._extensions.tester.finders')
local sorters = require("telescope._extensions.tester.sorters")

local loremSentences = {
  "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
  "Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
  "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip.",
  "Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.",
  "Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
  "Curabitur pretium tincidunt lacus. Nulla gravida orci a odio.",
  "Nullam varius, turpis et commodo pharetra, est eros bibendum elit, nec luctus magna felis sollicitudin mauris.",
  "Integer in mauris eu nibh euismod gravida.",
  "Phasellus fermentum in, dolor. Pellentesque facilisis.",
  "Morbi imperdiet, mauris ac auctor dictum, nisl ligula egestas nulla, et sollicitudin sem purus in lacus.",
}

local displayer = entry_display.create({
  separator = " ▏",
  items = {
    { width = 5 },
    { width = 10 },
    { remaining = true },
  },
})

local function make_display(entry)
  -- concatenating multiline env values
  return displayer({
    { "#" .. entry.idx },
    { entry.value[2] },
    { entry.desc },
  })
end

local entry_maker = function(line)
  local entry = vim.fn.split(line, " ")
  entry[3] = loremSentences[math.random(#loremSentences)]
  return {
    idx = entry[1],
    value = entry,
    desc = entry[3],
    display = make_display,
    ordinal = string.format("%s %s %s", entry[1], entry[2], entry[3]),
  }
end

local make_finder = function(opts)
  local script_file = vim.fn.stdpath("config") .. "/lua/telescope/_extensions/tester/test.sh"
  local finder_type = opts.finder_type or "oneshot" -- one_shot_finder, job_finder, dynamic_job
  -- finders.new_async_job
  -- finders.new_job
  -- finders.new_oneshot_job
  -- finders.new_table
  -- finders.new_dynamic
  if finder_type == "oneshot" then
    local command = { "bash", script_file }
    return finders.new_oneshot_job(command, opts)
  end
end

local function script(opts)
  -- local script = vim.fn.stdpath('config') .. '/lua/gitops/scripts/commits.sh'
  -- local command = { script_file, '--git-dir=/home/nicholas/.cfg', '--work-tree=/home/nicholas' }
  opts = opts or {}
  opts.entry_maker = opts.entry_maker or entry_maker
  --   assert(not opts.results, "`results` should be used with finder.new_table")
  --   assert(not opts.static, "`static` should be used with finder.new_oneshot_job")
  -- opts.sorter_type = 'substr'
  pickers
    .new(opts, {
      prompt_title = "Script Tester",
      finder = make_finder(opts),
      -- previewer = conf.file_previewer(opts),
      -- sorter = sorters.get_sorter(opts),
      sorter = conf.generic_sorter(opts),
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
