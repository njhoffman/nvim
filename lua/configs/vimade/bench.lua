-- Benchmark suite for comparing vimade vs custom namespace approaches.
-- Run with: :lua require("configs.vimade.bench").run()

local M = {}

local ITERATIONS = 100

-- Measure execution time of a function over N iterations.
-- Returns { mean_us, min_us, max_us, total_us }.
local function measure(fn, iterations)
  iterations = iterations or ITERATIONS
  local total = 0
  local min_t = math.huge
  local max_t = 0

  for _ = 1, iterations do
    local start = vim.uv.hrtime()
    fn()
    local elapsed = (vim.uv.hrtime() - start) / 1000 -- nanoseconds to microseconds
    total = total + elapsed
    min_t = math.min(min_t, elapsed)
    max_t = math.max(max_t, elapsed)
  end

  return {
    mean = total / iterations,
    min = min_t,
    max = max_t,
    total = total,
    iterations = iterations,
  }
end

-- Count namespaces and their highlights.
local function namespace_stats()
  local namespaces = vim.api.nvim_get_namespaces()
  local total_ns = 0
  local total_hls = 0
  local vimade_ns = 0
  local vimade_hls = 0

  for name, ns_id in pairs(namespaces) do
    total_ns = total_ns + 1
    local hls = vim.api.nvim_get_hl(ns_id, {})
    local hl_count = vim.tbl_count(hls)
    total_hls = total_hls + hl_count

    if name:find("vimade") or name == "" then
      -- Anonymous namespaces are typically vimade's
      local has_control = hls["vimade_control"] ~= nil
      if has_control or name:find("vimade") then
        vimade_ns = vimade_ns + 1
        vimade_hls = vimade_hls + hl_count
      end
    end
  end

  return {
    total_ns = total_ns,
    total_hls = total_hls,
    vimade_ns = vimade_ns,
    vimade_hls = vimade_hls,
  }
end

-- Benchmark 1: Vimade tick cost.
local function bench_vimade_tick()
  local ok, vimade = pcall(require, "vimade")
  if not ok or not vimade.update then
    return nil, "vimade not loaded"
  end

  local ns_before = namespace_stats()
  local result = measure(function()
    vimade.update()
  end)
  local ns_after = namespace_stats()

  return {
    name = "Vimade Tick",
    timing = result,
    ns_before = ns_before,
    ns_after = ns_after,
  }
end

-- Benchmark 2: Custom namespace approach (simulate what a full replacement would cost).
-- Clones all global highlights into a custom namespace, applies a simple fade, sets on window.
local function bench_custom_namespace()
  local color = require("vimade.util.color")
  local test_ns = vim.api.nvim_create_namespace("bench_custom_ns")
  local winid = vim.api.nvim_get_current_win()
  local fade = 0.45

  -- Get the background color for fading target.
  local normal = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
  local bg = normal.bg or 0x1e1e2e

  local result = measure(function()
    local all_hls = vim.api.nvim_get_hl(0, {})
    for name, def in pairs(all_hls) do
      if not def.link then
        local new_def = {}
        if def.fg then
          new_def.fg = color.interpolate24b(def.fg, bg, fade)
        end
        if def.bg then
          new_def.bg = color.interpolate24b(def.bg, bg, fade)
        end
        if def.sp then
          new_def.sp = color.interpolate24b(def.sp, bg, fade)
        end
        if def.bold then
          new_def.bold = def.bold
        end
        if def.italic then
          new_def.italic = def.italic
        end
        if def.underline then
          new_def.underline = def.underline
        end
        if def.strikethrough then
          new_def.strikethrough = def.strikethrough
        end
        vim.api.nvim_set_hl(test_ns, name, new_def)
      else
        vim.api.nvim_set_hl(test_ns, name, { link = def.link })
      end
    end
    vim.api.nvim_win_set_hl_ns(winid, test_ns)
  end)

  -- Count highlights set.
  local hl_count = vim.tbl_count(vim.api.nvim_get_hl(test_ns, {}))

  -- Clean up: restore default namespace.
  vim.api.nvim_win_set_hl_ns(winid, 0)

  return {
    name = "Custom Namespace Clone+Fade",
    timing = result,
    hl_count = hl_count,
  }
end

-- Benchmark 3: Decoration provider cost (simulates per-range restore).
local function bench_decoration_provider()
  local bufnr = vim.api.nvim_get_current_buf()
  local line_count = vim.api.nvim_buf_line_count(bufnr)
  local test_ns = vim.api.nvim_create_namespace("bench_decor_provider")

  -- Simulate 5 restore ranges spread across the buffer.
  local ranges = {}
  local step = math.max(1, math.floor(line_count / 6))
  for i = 1, 5 do
    local start = (i - 1) * step
    local stop = math.min(start + math.floor(step / 2), line_count - 1)
    ranges[i] = { start, 0, stop, -1 }
  end

  -- Measure the cost of setting ephemeral extmarks for these ranges.
  local result = measure(function()
    for _, range in ipairs(ranges) do
      for row = range[1], range[3] do
        pcall(vim.api.nvim_buf_set_extmark, bufnr, test_ns, row, 0, {
          end_row = row,
          end_col = -1,
          hl_group = "Normal",
          ephemeral = true,
          priority = 4097,
        })
      end
    end
  end)

  local total_lines = 0
  for _, range in ipairs(ranges) do
    total_lines = total_lines + (range[3] - range[1] + 1)
  end

  return {
    name = "Decoration Provider (5 ranges)",
    timing = result,
    range_count = #ranges,
    total_lines = total_lines,
  }
end

-- Benchmark 4: Combined (vimade tick + decoration provider).
local function bench_combined()
  local ok, vimade = pcall(require, "vimade")
  if not ok or not vimade.update then
    return nil, "vimade not loaded"
  end

  local bufnr = vim.api.nvim_get_current_buf()
  local line_count = vim.api.nvim_buf_line_count(bufnr)
  local test_ns = vim.api.nvim_create_namespace("bench_combined")

  local ranges = {}
  local step = math.max(1, math.floor(line_count / 6))
  for i = 1, 5 do
    local start = (i - 1) * step
    local stop = math.min(start + math.floor(step / 2), line_count - 1)
    ranges[i] = { start, 0, stop, -1 }
  end

  local result = measure(function()
    vimade.update()
    for _, range in ipairs(ranges) do
      local sr, er = range[1], range[3]
      for row = sr, er do
        pcall(vim.api.nvim_buf_set_extmark, bufnr, test_ns, row, 0, {
          end_row = row,
          end_col = -1,
          hl_group = "Normal",
          ephemeral = true,
          priority = 4097,
        })
      end
    end
  end)

  return {
    name = "Combined (Vimade + Decor Provider)",
    timing = result,
  }
end

-- Benchmark 5: tint.nvim namespace setup cost.
-- Measures the expensive one-time cost of generating both tint namespaces
-- (runs at startup and on ColorScheme change).
local function bench_tint_setup()
  local tint_ok, tint_mod = pcall(require, "tint")
  if tint_ok and tint_mod.refresh then
    -- tint.nvim is loaded: measure its actual refresh path.
    local ns_before = namespace_stats()
    local result = measure(function()
      tint_mod.refresh()
    end)
    local ns_after = namespace_stats()

    -- Count tint-specific namespaces.
    local tint_ns_count = 0
    local tint_hl_count = 0
    for name, ns_id in pairs(vim.api.nvim_get_namespaces()) do
      if name:find("^_tint_") then
        tint_ns_count = tint_ns_count + 1
        tint_hl_count = tint_hl_count + vim.tbl_count(vim.api.nvim_get_hl(ns_id, {}))
      end
    end

    return {
      name = "tint.nvim Setup (refresh)",
      timing = result,
      hl_count = tint_hl_count,
      tint_ns_count = tint_ns_count,
      ns_before = ns_before,
      ns_after = ns_after,
    }
  end

  -- tint.nvim not loaded: simulate the same work pattern.
  -- Create 2 namespaces, iterate all highlights, transform colors, set into both.
  local tint_colors_ok, tint_colors = pcall(require, "tint.colors")
  local tint_transforms_ok, tint_transforms = pcall(require, "tint.transforms")

  local sim_default_ns = vim.api.nvim_create_namespace("bench_tint_norm")
  local sim_tint_ns = vim.api.nvim_create_namespace("bench_tint_dim")

  -- Build transform pipeline (same as tint.nvim default: saturate(0.7) -> tint(-40)).
  local xforms
  if tint_transforms_ok then
    xforms = { tint_transforms.saturate(0.7), tint_transforms.tint(-40) }
  end

  local result = measure(function()
    local all_hls = vim.api.nvim_get_hl(0, {})
    for name, def in pairs(all_hls) do
      -- Copy to default ns (untinted).
      vim.api.nvim_set_hl(sim_default_ns, name, def)

      -- Transform and copy to tint ns.
      if not def.link then
        local tinted = vim.deepcopy(def)
        if tinted.fg and xforms and tint_colors_ok then
          local hex = tint_colors.get_hex(tinted.fg)
          local r, g, b = tint_colors.hex_to_rgb(hex)
          for _, x in ipairs(xforms) do
            r, g, b = x(r, g, b, { hl_group_name = name })
          end
          tinted.fg = tint_colors.rgb_to_hex(r, g, b)
        end
        if tinted.sp and xforms and tint_colors_ok then
          local hex = tint_colors.get_hex(tinted.sp)
          local r, g, b = tint_colors.hex_to_rgb(hex)
          for _, x in ipairs(xforms) do
            r, g, b = x(r, g, b, { hl_group_name = name })
          end
          tinted.sp = tint_colors.rgb_to_hex(r, g, b)
        end
        vim.api.nvim_set_hl(sim_tint_ns, name, tinted)
      else
        vim.api.nvim_set_hl(sim_tint_ns, name, def)
      end
    end
  end)

  local hl_count = vim.tbl_count(vim.api.nvim_get_hl(sim_tint_ns, {}))

  return {
    name = "tint.nvim Setup (simulated)",
    timing = result,
    hl_count = hl_count,
    tint_ns_count = 2,
  }
end

-- Benchmark 6: tint.nvim hot path (tint/untint cycle).
-- This is the O(1) namespace swap that runs on every WinEnter/WinLeave.
local function bench_tint_hot_path()
  local winid = vim.api.nvim_get_current_win()
  local tint_ok, tint_mod = pcall(require, "tint")

  if tint_ok and tint_mod.tint and tint_mod.untint then
    local result = measure(function()
      tint_mod.tint(winid)
      tint_mod.untint(winid)
    end)
    return {
      name = "tint.nvim Hot Path (tint+untint)",
      timing = result,
    }
  end

  -- Simulate: raw nvim_win_set_hl_ns + window var guard.
  local ns_a = vim.api.nvim_create_namespace("bench_tint_hot_a")
  local ns_b = vim.api.nvim_create_namespace("bench_tint_hot_b")

  local result = measure(function()
    vim.api.nvim_win_set_var(winid, "bench_tint_ns", ns_a)
    vim.api.nvim_win_set_hl_ns(winid, ns_a)
    vim.api.nvim_win_set_var(winid, "bench_tint_ns", ns_b)
    vim.api.nvim_win_set_hl_ns(winid, ns_b)
  end)

  -- Clean up.
  vim.api.nvim_win_set_hl_ns(winid, 0)

  return {
    name = "tint.nvim Hot Path (simulated)",
    timing = result,
  }
end

-- Benchmark 7: Color math comparison (tint.nvim string pipeline vs vimade bitwise).
local function bench_color_math()
  local COLOR_ITERATIONS = 1000
  local vimade_color = require("vimade.util.color")
  local tint_colors_ok, tint_colors = pcall(require, "tint.colors")
  local tint_transforms_ok, tint_transforms = pcall(require, "tint.transforms")

  -- Generate test colors.
  local test_colors = {}
  for i = 1, COLOR_ITERATIONS do
    test_colors[i] = (i * 37 * 256 + i * 13) % 0xFFFFFF
  end

  local bg = 0x1e1e2e
  local fade = 0.45

  -- Vimade path: integer bitwise interpolation.
  local vimade_result = measure(function()
    for _, c in ipairs(test_colors) do
      vimade_color.interpolate24b(c, bg, fade)
    end
  end)

  -- tint.nvim path: hex string round-trip + saturate + tint.
  local tint_result
  if tint_colors_ok and tint_transforms_ok then
    local sat = tint_transforms.saturate(0.7)
    local tnt = tint_transforms.tint(-40)
    tint_result = measure(function()
      for _, c in ipairs(test_colors) do
        local hex = tint_colors.get_hex(c)
        local r, g, b = tint_colors.hex_to_rgb(hex)
        r, g, b = sat(r, g, b, { hl_group_name = "test" })
        r, g, b = tnt(r, g, b, { hl_group_name = "test" })
        tint_colors.rgb_to_hex(r, g, b)
      end
    end)
  end

  local results = {
    name = "Color Math Comparison",
    vimade = {
      timing = vimade_result,
      per_color_ns = (vimade_result.mean * 1000) / COLOR_ITERATIONS,
    },
  }

  if tint_result then
    results.tint = {
      timing = tint_result,
      per_color_ns = (tint_result.mean * 1000) / COLOR_ITERATIONS,
    }
    results.ratio = tint_result.mean / vimade_result.mean
  end

  return results
end

-- Format a timing result as a string.
local function format_timing(t)
  return string.format(
    "mean: %7.1f us | min: %7.1f us | max: %7.1f us | total: %7.1f ms",
    t.mean,
    t.min,
    t.max,
    t.total / 1000
  )
end

-- Run all benchmarks and display results.
M.run = function()
  local results = {}
  local lines = {}

  lines[#lines + 1] = string.rep("=", 80)
  lines[#lines + 1] = "  Vimade Benchmark Suite (" .. ITERATIONS .. " iterations)"
  lines[#lines + 1] = string.rep("=", 80)
  lines[#lines + 1] = ""

  -- Pre-benchmark namespace stats.
  local ns_stats = namespace_stats()
  lines[#lines + 1] = string.format(
    "Namespace baseline: %d total (%d hls) | %d vimade (%d hls)",
    ns_stats.total_ns,
    ns_stats.total_hls,
    ns_stats.vimade_ns,
    ns_stats.vimade_hls
  )
  lines[#lines + 1] = ""

  -- Run standard benchmarks.
  local benchmarks = {
    bench_vimade_tick,
    bench_custom_namespace,
    bench_decoration_provider,
    bench_combined,
    bench_tint_setup,
    bench_tint_hot_path,
  }

  for _, bench_fn in ipairs(benchmarks) do
    local result, err = bench_fn()
    if result then
      results[#results + 1] = result
      lines[#lines + 1] = string.rep("-", 80)
      lines[#lines + 1] = "  " .. result.name
      lines[#lines + 1] = string.rep("-", 80)
      lines[#lines + 1] = "  " .. format_timing(result.timing)

      if result.hl_count then
        lines[#lines + 1] = string.format("  Highlights: %d", result.hl_count)
      end
      if result.tint_ns_count then
        lines[#lines + 1] = string.format("  tint namespaces: %d", result.tint_ns_count)
      end
      if result.range_count then
        lines[#lines + 1] =
          string.format("  Ranges: %d | Lines covered: %d", result.range_count, result.total_lines)
      end
      if result.ns_before and result.ns_after then
        lines[#lines + 1] = string.format(
          "  NS delta: %+d total, %+d vimade",
          result.ns_after.total_ns - result.ns_before.total_ns,
          result.ns_after.vimade_ns - result.ns_before.vimade_ns
        )
      end
      lines[#lines + 1] = ""
    else
      lines[#lines + 1] = string.format("  SKIPPED: %s (%s)", "benchmark", err or "unknown")
      lines[#lines + 1] = ""
    end
  end

  -- Color math comparison (special format).
  local cm_result = bench_color_math()
  if cm_result then
    results[#results + 1] = cm_result
    lines[#lines + 1] = string.rep("-", 80)
    lines[#lines + 1] = "  " .. cm_result.name
    lines[#lines + 1] = string.rep("-", 80)
    lines[#lines + 1] =
      string.format("  vimade (bitwise):    %s", format_timing(cm_result.vimade.timing))
    lines[#lines + 1] =
      string.format("  vimade per-color:    %.1f ns", cm_result.vimade.per_color_ns)
    if cm_result.tint then
      lines[#lines + 1] =
        string.format("  tint.nvim (string):  %s", format_timing(cm_result.tint.timing))
      lines[#lines + 1] =
        string.format("  tint.nvim per-color: %.1f ns", cm_result.tint.per_color_ns)
      lines[#lines + 1] = string.format("  ratio (tint/vimade): %.1fx", cm_result.ratio)
    else
      lines[#lines + 1] = "  tint.nvim: not available (tint.colors/tint.transforms not loaded)"
    end
    lines[#lines + 1] = ""
  end

  -- Post-benchmark namespace stats.
  local ns_after = namespace_stats()
  lines[#lines + 1] = string.rep("=", 80)
  lines[#lines + 1] = string.format(
    "Namespace after: %d total (%d hls) | %d vimade (%d hls)",
    ns_after.total_ns,
    ns_after.total_hls,
    ns_after.vimade_ns,
    ns_after.vimade_hls
  )
  lines[#lines + 1] = string.rep("=", 80)

  -- Display in a scratch buffer.
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].filetype = "markdown"
  vim.cmd.split()
  vim.api.nvim_win_set_buf(0, buf)

  return results
end

-- Run a single benchmark by name.
M.run_single = function(name)
  local map = {
    vimade = bench_vimade_tick,
    custom = bench_custom_namespace,
    decor = bench_decoration_provider,
    combined = bench_combined,
    tint_setup = bench_tint_setup,
    tint_hot = bench_tint_hot_path,
    color_math = bench_color_math,
  }
  local fn = map[name]
  if not fn then
    local opts = table.concat(vim.tbl_keys(map), ", ")
    print("Unknown benchmark: " .. name .. ". Options: " .. opts)
    return
  end
  local result, err = fn()
  if result then
    if result.timing then
      print(result.name .. ": " .. format_timing(result.timing))
    elseif result.vimade then
      print("vimade: " .. format_timing(result.vimade.timing))
      if result.tint then
        print("tint:   " .. format_timing(result.tint.timing))
        print(string.format("ratio:  %.1fx", result.ratio))
      end
    end
  else
    print("Error: " .. (err or "unknown"))
  end
  return result
end

return M
