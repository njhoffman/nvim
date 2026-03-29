--- Performance benchmarking for bars.nvim statusline.
--- Measures render time and displays results in a floating window.

local M = {}

--- Run N iterations of statusline render and collect timing data.
---@param iterations? integer Number of iterations (default 1000)
---@return table results { avg_ns, min_ns, max_ns, p95_ns, total_ns, iterations }
function M.measure(iterations)
  iterations = iterations or 1000

  local statusline = require("bars.statusline")
  local hrtime = vim.uv.hrtime

  -- Warm up
  for _ = 1, 10 do
    statusline:render()
  end

  local times = {}
  for i = 1, iterations do
    local start = hrtime()
    statusline:render()
    times[i] = hrtime() - start
  end

  table.sort(times)

  local total = 0
  for _, t in ipairs(times) do
    total = total + t
  end

  return {
    avg_ns = total / iterations,
    min_ns = times[1],
    max_ns = times[iterations],
    p95_ns = times[math.ceil(iterations * 0.95)],
    total_ns = total,
    iterations = iterations,
  }
end

--- Measure memory impact of a single render.
---@return table { before_kb, after_kb, delta_kb }
function M.measure_memory()
  collectgarbage("collect")
  local before = collectgarbage("count")
  local statusline = require("bars.statusline")
  for _ = 1, 100 do
    statusline:render()
  end
  local after = collectgarbage("count")
  return {
    before_kb = before,
    after_kb = after,
    delta_kb = (after - before) / 100,
  }
end

--- Format nanoseconds as a human-readable string.
---@param ns number
---@return string
local function fmt_time(ns)
  if ns >= 1e6 then
    return string.format("%.2f ms", ns / 1e6)
  elseif ns >= 1e3 then
    return string.format("%.2f us", ns / 1e3)
  else
    return string.format("%.0f ns", ns)
  end
end

--- Run benchmark and display results in a floating window.
---@param iterations? integer
function M.show(iterations)
  local results = M.measure(iterations)
  local mem = M.measure_memory()

  local lines = {
    "Bars.nvim Statusline Benchmark",
    string.rep("-", 40),
    string.format("Iterations:  %d", results.iterations),
    string.format("Total:       %s", fmt_time(results.total_ns)),
    "",
    "Render Time:",
    string.format("  Average:   %s", fmt_time(results.avg_ns)),
    string.format("  Min:       %s", fmt_time(results.min_ns)),
    string.format("  Max:       %s", fmt_time(results.max_ns)),
    string.format("  P95:       %s", fmt_time(results.p95_ns)),
    "",
    "Memory (per render):",
    string.format("  Delta:     %.4f KB", mem.delta_kb),
    "",
    results.avg_ns < 1e6 and "Status: PASS (< 1ms avg)" or "Status: SLOW (> 1ms avg)",
  }

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false
  vim.bo[buf].bufhidden = "wipe"

  local width = 44
  local height = #lines
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    col = math.floor((vim.o.columns - width) / 2),
    row = math.floor((vim.o.lines - height) / 2),
    style = "minimal",
    border = "rounded",
    title = " Benchmark ",
    title_pos = "center",
  })

  require("mapper").map("n", "q", function()
    vim.api.nvim_win_close(win, true)
  end, { buffer = buf, desc = "close benchmark" })
end

--- Register the benchmark command.
function M.setup_commands()
  vim.api.nvim_create_user_command("BarsStatuslineBenchmark", function(opts)
    local n = tonumber(opts.args) or 1000
    M.show(n)
  end, {
    nargs = "?",
    desc = "Benchmark bars.nvim statusline render performance",
  })
end

return M
