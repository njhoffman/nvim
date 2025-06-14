-- @tex @HerringtonDarkholme I found that the issue is as follows: when I input a keyword, for example, '$', Telescope spawns a process with the command sg -p '$' --json=stream. Subsequently, Telescope suspends the coroutine, waiting for 'sg' to output results to stdout. During this period, any additional keywords entered do not terminate the process until 'sg' produces output in stdout. On the other hand, other pickers like 'live_grep' use 'rg' (ripgrep), which seems to print results while searching, avoiding this issue. Therefore, I believe either 'sg' should address this problem, or it can be disregarded altogether."
-- https://github.com/nvim-telescope/telescope.nvim/pull/2834

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local sorters = require("telescope.sorters")
local startime
local prompt_bufnr

local picker = function(opts)
  opts = opts or {}
  local lookup_keys = {
    display = 1,
    ordinal = 1,
    value = 1,
  }

  local function gen_from_string(opts)
    local mt_string_entry = {
      __index = function(t, k)
        return rawget(t, rawget(lookup_keys, k))
      end,
    }

    return function(line)
      local endtime = vim.loop.hrtime()
      return setmetatable({
        line .. tostring((endtime - startime) / 1e9),
      }, mt_string_entry)
    end
  end

  -- spawn a bash shell in which echo after 5s
  local p = pickers.new(opts, {
    prompt_title = "test",
    finder = finders.new_job(function(prompt)
      return { "bash", "-c", 'sleep 5; echo input: "' .. prompt .. '" cost:' }
    end, gen_from_string()),
    sorter = sorters.highlighter_only(),
  })

  function p:_next_find_id()
    local find_id = self._find_id + 1
    self._find_id = find_id

    startime = vim.loop.hrtime()
    prompt_bufnr = self.prompt_bufnr
    return find_id
  end

  p:find()
end

picker()
vim.defer_fn(function()
  vim.api.nvim_buf_set_lines(prompt_bufnr, 1, -1, 0, { "123" })
end, 1000)

-- The result should be around 5 seconds; it was about 10 seconds in the original version
