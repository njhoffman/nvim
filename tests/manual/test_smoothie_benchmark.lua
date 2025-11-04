-- test_smoothie_benchmark.lua: Manual test for smoothie benchmarking
-- Run with: nvim -l tests/manual/test_smoothie_benchmark.lua

local function test_viml_benchmark()
  print("\n=== Testing VimL Benchmarking ===\n")

  -- Check that autoload function exists
  local exists = vim.fn.exists("*smoothie#benchmark#enable")
  assert(exists == 1, "smoothie#benchmark#enable should exist")
  print("✓ VimL benchmark functions exist")

  -- Test enable/disable
  vim.fn["smoothie#benchmark#enable"]()
  assert(vim.g.smoothie_benchmark_enabled == 1, "Benchmarking should be enabled")
  print("✓ Enable benchmarking works")

  vim.fn["smoothie#benchmark#disable"]()
  assert(vim.g.smoothie_benchmark_enabled == 0, "Benchmarking should be disabled")
  print("✓ Disable benchmarking works")

  -- Test data structure
  vim.fn["smoothie#benchmark#enable"]()
  vim.fn["smoothie#benchmark#reset"]()
  local data = vim.fn["smoothie#benchmark#get_data"]()
  assert(data.enabled == 1, "Data should show enabled")
  assert(#data.operations == 0, "Operations should be empty after reset")
  print("✓ Reset works")

  -- Test stats calculation with no data
  local stats = vim.fn["smoothie#benchmark#calculate_stats"]()
  assert(stats.error == "No operations recorded", "Should error with no data")
  print("✓ Stats calculation handles empty data")

  vim.fn["smoothie#benchmark#disable"]()
end

local function test_lua_benchmark()
  print("\n=== Testing Lua Benchmarking ===\n")

  -- Load smoothie module
  local ok, smoothie = pcall(require, "smoothie")
  assert(ok, "Should be able to load smoothie module")
  print("✓ Smoothie module loads")

  local benchmark = smoothie.benchmark
  assert(benchmark, "Benchmark module should exist")
  print("✓ Benchmark module exists")

  -- Test enable/disable
  benchmark.enable()
  local data = benchmark.get_data()
  assert(data.enabled == true, "Benchmarking should be enabled")
  print("✓ Enable benchmarking works")

  benchmark.disable()
  data = benchmark.get_data()
  assert(data.enabled == false, "Benchmarking should be disabled")
  print("✓ Disable benchmarking works")

  -- Test reset
  benchmark.enable()
  benchmark.reset()
  data = benchmark.get_data()
  assert(#data.operations == 0, "Operations should be empty after reset")
  assert(data.stats.operation_count == 0, "Operation count should be 0")
  print("✓ Reset works")

  -- Test stats calculation with no data
  local stats = benchmark.calculate_stats()
  assert(stats.error == "No operations recorded", "Should error with no data")
  print("✓ Stats calculation handles empty data")

  -- Test format_stats
  local lines = benchmark.format_stats()
  assert(#lines >= 1, "Should return formatted lines")
  assert(lines[1] == "No operations recorded", "Should show error message")
  print("✓ Format stats works")

  benchmark.disable()
end

local function test_toggle_system()
  print("\n=== Testing Toggle System ===\n")

  local ok, toggle = pcall(require, "commands.buffer.smoothie_toggle")
  assert(ok, "Should be able to load toggle module")
  print("✓ Toggle module loads")

  -- Test status
  local impl = toggle.get_implementation()
  assert(impl == "viml" or impl == "lua", "Should return valid implementation")
  print("✓ Get implementation works: " .. impl)

  -- Test commands exist
  local commands = vim.api.nvim_get_commands({})
  assert(commands.SmoothieUseVimL, "SmoothieUseVimL command should exist")
  assert(commands.SmoothieUseLua, "SmoothieUseLua command should exist")
  assert(commands.SmoothieToggle, "SmoothieToggle command should exist")
  assert(commands.SmoothieStatus, "SmoothieStatus command should exist")
  print("✓ All toggle commands exist")

  -- Test benchmark commands
  assert(commands.SmoothieBenchmarkEnableLua, "Lua benchmark commands should exist")
  assert(commands.SmoothieBenchmarkStatsLua, "Lua stats command should exist")
  print("✓ All Lua benchmark commands exist")

  assert(commands.SmoothieBenchmarkEnable, "VimL benchmark commands should exist")
  assert(commands.SBEnable, "VimL benchmark aliases should exist")
  print("✓ All VimL benchmark commands exist")
end

local function test_smoothie_core()
  print("\n=== Testing Smoothie Core Functions ===\n")

  local smoothie = require("smoothie")

  -- Test setup
  smoothie.setup({
    enabled = true,
    update_interval = 20,
    benchmark_enabled = false,
  })
  assert(smoothie.config.enabled == true, "Config should be applied")
  assert(smoothie.config.update_interval == 20, "Config should be applied")
  print("✓ Setup works")

  -- Test state initialization
  assert(smoothie.state.target_displacement == 0, "State should be initialized")
  assert(smoothie.state.timer_id == nil, "Timer should not be running")
  print("✓ State initialization works")

  -- Test functions exist
  assert(type(smoothie.downwards) == "function", "downwards should exist")
  assert(type(smoothie.upwards) == "function", "upwards should exist")
  assert(type(smoothie.forwards) == "function", "forwards should exist")
  assert(type(smoothie.backwards) == "function", "backwards should exist")
  assert(type(smoothie.cursor_movement) == "function", "cursor_movement should exist")
  assert(type(smoothie.stop) == "function", "stop should exist")
  print("✓ All core functions exist")

  -- Test use_visual_lines config option
  smoothie.setup({ use_visual_lines = true })
  assert(smoothie.config.use_visual_lines == true, "use_visual_lines should be enabled")
  print("✓ use_visual_lines config option works")

  smoothie.setup({ use_visual_lines = false })
  assert(smoothie.config.use_visual_lines == false, "use_visual_lines should be disabled")
  print("✓ use_visual_lines can be disabled")
end

local function test_freeze_fix()
  print("\n=== Testing Freeze Fix (G/gg commands) ===\n")

  local smoothie = require("smoothie")
  smoothie.setup({ enabled = true, update_interval = 10 })

  -- Create a buffer with some content
  vim.cmd("enew")
  local lines = {}
  for i = 1, 100 do
    table.insert(lines, "Line " .. i)
  end
  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)

  -- Test gg movement (should not freeze)
  vim.cmd("normal! G") -- Go to end
  local start_time = os.clock()
  smoothie.cursor_movement("gg")
  local end_time = os.clock()
  local elapsed = end_time - start_time

  -- Should complete in reasonable time (< 5 seconds)
  assert(elapsed < 5, "gg movement should not freeze (took " .. elapsed .. "s)")
  print("✓ gg movement doesn't freeze")

  -- Test G movement (should not freeze)
  vim.cmd("normal! gg") -- Go to start
  start_time = os.clock()
  smoothie.cursor_movement("G")
  end_time = os.clock()
  elapsed = end_time - start_time

  assert(elapsed < 5, "G movement should not freeze (took " .. elapsed .. "s)")
  print("✓ G movement doesn't freeze")

  -- Test edge case: gg when already at top
  vim.cmd("normal! gg")
  start_time = os.clock()
  smoothie.cursor_movement("gg")
  end_time = os.clock()
  elapsed = end_time - start_time

  assert(elapsed < 1, "gg at top should exit quickly (took " .. elapsed .. "s)")
  print("✓ gg at top doesn't hang")

  -- Test edge case: G when already at bottom
  vim.cmd("normal! G")
  start_time = os.clock()
  smoothie.cursor_movement("G")
  end_time = os.clock()
  elapsed = end_time - start_time

  assert(elapsed < 1, "G at bottom should exit quickly (took " .. elapsed .. "s)")
  print("✓ G at bottom doesn't hang")

  smoothie.stop()
end

local function test_consolidated_commands()
  print("\n=== Testing Consolidated Commands ===\n")

  local toggle = require("commands.buffer.smoothie_toggle")

  -- Test that consolidated commands work for both implementations
  local commands = vim.api.nvim_get_commands({})

  assert(commands.SBEnable, "SBEnable should exist")
  assert(commands.SBDisable, "SBDisable should exist")
  assert(commands.SBToggle, "SBToggle should exist")
  assert(commands.SBReset, "SBReset should exist")
  assert(commands.SBStats, "SBStats should exist")
  print("✓ All consolidated benchmark commands exist")

  assert(commands.SmoothieBenchmarkEnable, "Full benchmark commands should exist")
  assert(commands.SmoothieBenchmarkDisable, "Full benchmark commands should exist")
  print("✓ Full benchmark command names exist")

  -- Test that commands call the right functions
  assert(type(toggle.benchmark_enable) == "function", "benchmark_enable should be a function")
  assert(type(toggle.benchmark_disable) == "function", "benchmark_disable should be a function")
  assert(type(toggle.benchmark_toggle) == "function", "benchmark_toggle should be a function")
  assert(type(toggle.benchmark_reset) == "function", "benchmark_reset should be a function")
  assert(type(toggle.benchmark_stats) == "function", "benchmark_stats should be a function")
  print("✓ All consolidated command functions exist")
end

-- Run tests
local function main()
  print("╔═══════════════════════════════════════════════════╗")
  print("║         SMOOTHIE BENCHMARK TEST SUITE             ║")
  print("╚═══════════════════════════════════════════════════╝")

  local success, err = pcall(function()
    test_viml_benchmark()
    test_lua_benchmark()
    test_toggle_system()
    test_smoothie_core()
    test_freeze_fix()
    test_consolidated_commands()
  end)

  if success then
    print("\n╔═══════════════════════════════════════════════════╗")
    print("║              ✓ ALL TESTS PASSED                   ║")
    print("╚═══════════════════════════════════════════════════╝\n")
    os.exit(0)
  else
    print("\n╔═══════════════════════════════════════════════════╗")
    print("║              ✗ TESTS FAILED                       ║")
    print("╚═══════════════════════════════════════════════════╝")
    print("\nError: " .. tostring(err))
    os.exit(1)
  end
end

main()
