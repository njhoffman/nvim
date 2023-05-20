local make_entry = require('telescope.make_entry')
local finders = require('telescope.finders')
local entry_display = require('telescope.pickers.entry_display')
-- local make_entry = require('gitops.make_entry')

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

local get_finder = function(opts, command)
  -- opts.entry_maker = opts.entry_maker or make_entry.gen_from_git_commits(opts)
  opts.entry_maker = opts.entry_maker or entry_maker
  local finder_type = opts.finder_type or 'job_finder'
  local _finders = {
    one_shot_finder = function(_opts)
      return finders.new_oneshot_job(command, _opts)
    end,
    dynamic_finder = function(_opts)
      -- local a = require('plenary.async_lib')
      -- local async = a.async
      -- finder = finders.new_dynamic {
      --     fn = async(function(prompt)
      --       return { prompt }
      --     end),
      --     entry_maker = require("telescope.make_entry").gen_from_string {},
      --   },
      local _results = {}
      _opts.fn = function(prompt)
        -- TODO: attach results cache to on_output
        return _results
      end
      return finders.new_dynamic(opts)
    end,
    static_table = function(_opts)
      local _results = {}
      finders.new_table({
        results = _results,
        entry_maker = opts.entry_maker or make_entry.gen_from_treesitter(_opts),
      })
    end,
    job_finder = function(_opts)
      return finders.new_job(function(prompt)
        return vim.fn.flatten({ command })
      end, _opts.entry_maker, _opts.max_results, _opts.cwd)
    end,
  }
  return _finders[finder_type](opts)
end

return {
  get_finder = get_finder,
}

-- local function get_workspace_symbols_requester(bufnr)
--   local cancel = function() end
--
--   return async(function(prompt)
--     local tx, rx = channel.oneshot()
--     cancel()
--     _, cancel = vim.lsp.buf_request(bufnr, "workspace/symbol", { query = prompt }, tx)
--
--     local err, _, results_lsp = await(rx())
--     assert(not err, err)
--
--     local locations = vim.lsp.util.symbols_to_items(results_lsp or {}, bufnr) or {}
--     return locations
--   end)
-- end

-- finder = finders.new_dynamic {
--   entry_maker = opts.entry_maker or make_entry.gen_from_lsp_symbols(opts),
--   fn = get_workspace_symbols_requester(curr_bufnr),
-- },
