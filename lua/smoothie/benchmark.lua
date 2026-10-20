---@class SmoothieBenchmark
local M = {}

---@class BenchmarkData
---@field enabled boolean
---@field operations BenchmarkOperation[]
---@field current_op BenchmarkOperation|nil
---@field stats BenchmarkStats
local data = {
  enabled = false,
  operations = {},
  current_op = nil,
  stats = {
    total_lines = 0,
    total_time_ms = 0,
    operation_count = 0,
    turbulence_events = 0,
  },
}

---@class BenchmarkOperation
---@field type string Operation type (scroll/cursor)
---@field start_time number Start time (hrtime)
---@field end_time number|nil End time (hrtime)
---@field start_line number Starting line number
---@field end_line number|nil Ending line number
---@field target_lines number Target lines to scroll
---@field actual_lines number|nil Actual lines scrolled
---@field frames BenchmarkFrame[]
---@field frame_count number
---@field turbulence_score number
---@field duration_ms number|nil
---@field avg_speed_lps number|nil

---@class BenchmarkFrame
---@field time number Frame timestamp (hrtime)
---@field line number Line number at frame
---@field interval_ms number|nil Time since last frame

---@class BenchmarkStats
---@field total_lines number
---@field total_time_ms number
---@field operation_count number
---@field turbulence_events number

---Enable benchmarking
function M.enable()
  data.enabled = true
  vim.notify("Smoothie benchmarking enabled", vim.log.levels.INFO)
end

---Disable benchmarking
function M.disable()
  data.enabled = false
  vim.notify("Smoothie benchmarking disabled", vim.log.levels.INFO)
end

---Toggle benchmarking
function M.toggle()
  if data.enabled then
    M.disable()
  else
    M.enable()
  end
end

---Reset benchmark data
function M.reset()
  data.operations = {}
  data.current_op = nil
  data.stats = {
    total_lines = 0,
    total_time_ms = 0,
    operation_count = 0,
    turbulence_events = 0,
  }
  vim.notify("Smoothie benchmark data reset", vim.log.levels.INFO)
end

---Start tracking an operation
---@param operation_type string
---@param target_lines number
function M.start_op(operation_type, target_lines)
  if not data.enabled then
    return
  end

  data.current_op = {
    type = operation_type,
    start_time = vim.uv.hrtime(),
    start_line = vim.fn.line("."),
    target_lines = target_lines,
    frames = {},
    frame_count = 0,
    turbulence_score = 0.0,
  }
end

---Record a frame during animation
function M.record_frame()
  if not data.enabled or not data.current_op then
    return
  end

  local now = vim.uv.hrtime()
  local current_line = vim.fn.line(".")

  ---@type BenchmarkFrame
  local frame = {
    time = now,
    line = current_line,
  }

  -- Calculate interval from previous frame
  if #data.current_op.frames > 0 then
    local prev_frame = data.current_op.frames[#data.current_op.frames]
    local interval_ns = now - prev_frame.time
    local interval_ms = interval_ns / 1000000.0 -- Convert ns to ms
    frame.interval_ms = interval_ms

    -- Detect turbulence (50% deviation threshold)
    local smoothie = require("smoothie")
    local expected_interval = smoothie.config.update_interval
    local deviation = math.abs(interval_ms - expected_interval)
    local turbulence_threshold = expected_interval * 0.5

    if deviation > turbulence_threshold then
      data.current_op.turbulence_score = data.current_op.turbulence_score + deviation
      data.stats.turbulence_events = data.stats.turbulence_events + 1
    end
  end

  table.insert(data.current_op.frames, frame)
  data.current_op.frame_count = data.current_op.frame_count + 1
end

---End tracking an operation
function M.end_op()
  if not data.enabled or not data.current_op then
    return
  end

  data.current_op.end_time = vim.uv.hrtime()
  data.current_op.end_line = vim.fn.line(".")

  -- Calculate actual lines scrolled
  local actual_lines = math.abs(data.current_op.end_line - data.current_op.start_line)
  data.current_op.actual_lines = actual_lines

  -- Calculate duration
  local duration_ns = data.current_op.end_time - data.current_op.start_time
  local duration_ms = duration_ns / 1000000.0
  data.current_op.duration_ms = duration_ms

  -- Calculate average speed (lines per second)
  if duration_ms > 0 then
    data.current_op.avg_speed_lps = (actual_lines / duration_ms) * 1000.0
  else
    data.current_op.avg_speed_lps = 0
  end

  -- Normalize turbulence score
  if data.current_op.frame_count > 0 then
    data.current_op.turbulence_score = data.current_op.turbulence_score / data.current_op.frame_count
  end

  -- Update aggregate stats
  data.stats.total_lines = data.stats.total_lines + actual_lines
  data.stats.total_time_ms = data.stats.total_time_ms + duration_ms
  data.stats.operation_count = data.stats.operation_count + 1

  -- Store completed operation
  table.insert(data.operations, data.current_op)
  data.current_op = nil
end

---Get benchmark data
---@return BenchmarkData
function M.get_data()
  return data
end

---Calculate statistics
---@return table|nil
function M.calculate_stats()
  if data.stats.operation_count == 0 then
    return {
      error = "No operations recorded",
    }
  end

  -- Calculate average lines per minute
  local avg_lpm = 0
  if data.stats.total_time_ms > 0 then
    avg_lpm = (data.stats.total_lines / data.stats.total_time_ms) * 60000.0
  end

  -- Collect speeds and turbulence scores
  local speeds = {}
  local turbulence_scores = {}

  for _, op in ipairs(data.operations) do
    table.insert(speeds, op.avg_speed_lps)
    table.insert(turbulence_scores, op.turbulence_score)
  end

  -- Calculate min, max, mean
  local min_speed = math.min(unpack(speeds))
  local max_speed = math.max(unpack(speeds))

  local sum_speed = 0
  for _, speed in ipairs(speeds) do
    sum_speed = sum_speed + speed
  end
  local mean_speed = sum_speed / #speeds

  -- Calculate standard deviation
  local variance_sum = 0
  for _, speed in ipairs(speeds) do
    local diff = speed - mean_speed
    variance_sum = variance_sum + (diff * diff)
  end
  local stddev = math.sqrt(variance_sum / #speeds)

  -- Average turbulence
  local sum_turbulence = 0
  for _, score in ipairs(turbulence_scores) do
    sum_turbulence = sum_turbulence + score
  end
  local avg_turbulence = sum_turbulence / #turbulence_scores

  -- Consistency score (100% = perfectly consistent)
  local consistency_score = 100.0 - (stddev / mean_speed * 100.0)

  return {
    operation_count = data.stats.operation_count,
    total_lines = data.stats.total_lines,
    total_time_ms = data.stats.total_time_ms,
    avg_lines_per_minute = avg_lpm,
    avg_speed_lps = mean_speed,
    min_speed_lps = min_speed,
    max_speed_lps = max_speed,
    speed_stddev = stddev,
    turbulence_events = data.stats.turbulence_events,
    avg_turbulence = avg_turbulence,
    consistency_score = consistency_score,
  }
end

---Format stats for display
---@return string[]
function M.format_stats()
  local stats = M.calculate_stats()

  if stats.error then
    return { stats.error }
  end

  local lines = {}
  table.insert(lines, "╔═══════════════════════════════════════════════════╗")
  table.insert(lines, "║         SMOOTHIE BENCHMARK STATISTICS (Lua)       ║")
  table.insert(lines, "╠═══════════════════════════════════════════════════╣")
  table.insert(lines, string.format("║ Operations:                             %9d ║", stats.operation_count))
  table.insert(lines, string.format("║ Total Lines Scrolled:                   %9d ║", stats.total_lines))
  table.insert(lines, string.format("║ Total Time:                          %9.2f ms ║", stats.total_time_ms))
  table.insert(lines, "╠═══════════════════════════════════════════════════╣")
  table.insert(lines, "║                 SPEED METRICS                     ║")
  table.insert(lines, "╠═══════════════════════════════════════════════════╣")
  table.insert(lines, string.format("║ Avg Lines/Minute:                   %12.2f ║", stats.avg_lines_per_minute))
  table.insert(lines, string.format("║ Avg Speed:                           %9.2f l/s ║", stats.avg_speed_lps))
  table.insert(lines, string.format("║ Min Speed:                           %9.2f l/s ║", stats.min_speed_lps))
  table.insert(lines, string.format("║ Max Speed:                           %9.2f l/s ║", stats.max_speed_lps))
  table.insert(lines, string.format("║ Speed StdDev:                        %9.2f l/s ║", stats.speed_stddev))
  table.insert(lines, "╠═══════════════════════════════════════════════════╣")
  table.insert(lines, "║              SMOOTHNESS METRICS                   ║")
  table.insert(lines, "╠═══════════════════════════════════════════════════╣")
  table.insert(lines, string.format("║ Turbulence Events:                          %5d ║", stats.turbulence_events))
  table.insert(lines, string.format("║ Avg Turbulence Score:                %9.2f ms ║", stats.avg_turbulence))
  table.insert(lines, string.format("║ Consistency Score:                    %9.2f%% ║", stats.consistency_score))
  table.insert(lines, "╚═══════════════════════════════════════════════════╝")
  table.insert(lines, "")
  table.insert(lines, "Turbulence: Frame timing deviations from expected interval")
  table.insert(lines, "Consistency: 100% = perfectly consistent speed")

  return lines
end

---Show stats in floating window
function M.show_stats()
  local lines = M.format_stats()

  -- Calculate dimensions
  local width = 0
  for _, line in ipairs(lines) do
    width = math.max(width, vim.fn.strdisplaywidth(line))
  end
  local height = #lines

  -- Create buffer
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, true, lines)

  -- Buffer options
  vim.api.nvim_set_option_value("modifiable", false, { buf = buf })
  vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = buf })
  vim.api.nvim_set_option_value("filetype", "smoothie-benchmark", { buf = buf })

  -- Define highlights
  local ns_id = vim.api.nvim_create_namespace("smoothie_benchmark")

  -- Define highlight groups
  vim.api.nvim_set_hl(0, "SmoothieBenchmarkBorder", { fg = "#61AFEF", bold = true })
  vim.api.nvim_set_hl(0, "SmoothieBenchmarkHeader", { fg = "#E06C75", bold = true })
  vim.api.nvim_set_hl(0, "SmoothieBenchmarkLabel", { fg = "#E5C07B" })
  vim.api.nvim_set_hl(0, "SmoothieBenchmarkValue", { fg = "#98C379", bold = true })
  vim.api.nvim_set_hl(0, "SmoothieBenchmarkUnit", { fg = "#56B6C2", italic = true })

  -- Apply highlights
  for i, line in ipairs(lines) do
    local line_num = i - 1 -- 0-indexed

    -- Borders
    if line:match("^[╔╠╚═]") then
      vim.api.nvim_buf_add_highlight(buf, ns_id, "SmoothieBenchmarkBorder", line_num, 0, -1)
    -- Main header
    elseif line:match("BENCHMARK STATISTICS") then
      vim.api.nvim_buf_add_highlight(buf, ns_id, "SmoothieBenchmarkHeader", line_num, 0, -1)
    -- Section headers
    elseif line:match("METRICS") then
      vim.api.nvim_buf_add_highlight(buf, ns_id, "SmoothieBenchmarkHeader", line_num, 0, -1)
    -- Data rows
    elseif line:match("║.*:.*║") then
      local colon_pos = line:find(":")
      if colon_pos then
        -- Highlight label (before colon)
        vim.api.nvim_buf_add_highlight(buf, ns_id, "SmoothieBenchmarkLabel", line_num, 1, colon_pos)
        -- Highlight value (after colon, excluding units)
        local value_start = colon_pos
        local value_end = #line - 1
        -- Check for units
        local unit_start = line:find(" [lm]/s", value_start) or line:find(" ms", value_start) or line:find("%%", value_start)
        if unit_start then
          vim.api.nvim_buf_add_highlight(buf, ns_id, "SmoothieBenchmarkValue", line_num, value_start, unit_start)
          vim.api.nvim_buf_add_highlight(buf, ns_id, "SmoothieBenchmarkUnit", line_num, unit_start, value_end)
        else
          vim.api.nvim_buf_add_highlight(buf, ns_id, "SmoothieBenchmarkValue", line_num, value_start, value_end)
        end
      end
    end
  end

  -- Center window
  local ui = vim.api.nvim_list_uis()[1]
  local col = math.floor((ui.width - width) / 2)
  local row = math.floor((ui.height - height) / 2)

  -- Window options
  local opts = {
    relative = "editor",
    width = width,
    height = height,
    col = col,
    row = row,
    style = "minimal",
    border = "rounded",
    title = " Smoothie Benchmarks (Lua) ",
    title_pos = "center",
  }

  local win = vim.api.nvim_open_win(buf, true, opts)

  -- Set window highlight
  vim.api.nvim_set_option_value("winhl", "Normal:Normal,FloatBorder:FloatBorder", { win = win })

  -- Close mappings
  local map = require("mapper").map
  map("n", "q", "<cmd>close<CR>", { buffer = buf, nowait = true })
  map("n", "<Esc>", "<cmd>close<CR>", { buffer = buf, nowait = true })
end

return M
