# Testing Guide

This document describes the testing framework and procedures for the Neovim configuration.

## Overview

The testing infrastructure uses two complementary testing frameworks:

1. **Plenary.nvim** - For unit tests (pure Lua logic, utilities)
2. **Mini.test** - For integration tests (full Neovim environment with buffers, windows, etc.)

## Directory Structure

```
~/.config/nvim/
├── tests/
│   ├── minimal_init.lua         # Minimal init for isolated test environment
│   ├── unit/                    # Unit tests (plenary.nvim)
│   │   ├── example_spec.lua     # Example unit tests
│   │   └── utils_spec.lua       # Utility function tests
│   ├── integration/             # Integration tests (mini.test)
│   │   ├── test_config.lua      # Configuration integration tests
│   │   └── test_plugin_loading.lua  # Plugin loading tests
│   └── fixtures/                # Test fixtures and data
├── scripts/
│   └── run_tests.sh             # Bash test runner script
└── lua/
    └── test_runner.lua          # Lua test runner module
```

## Running Tests

### From Command Line

Use the provided bash script to run tests from the terminal:

```bash
# Run all tests
./scripts/run_tests.sh all

# Run only unit tests
./scripts/run_tests.sh unit

# Run only integration tests
./scripts/run_tests.sh integration
```

### From Within Neovim

After setting up the test runner commands (see Setup section), you can run tests from within Neovim:

```vim
:TestAll           " Run all tests
:TestUnit          " Run unit tests only
:TestIntegration   " Run integration tests only
:TestFile          " Run current test file
:TestNearest       " Run nearest test case (mini.test only)
```

### Manually with Plenary

To run a specific plenary test file:

```vim
:PlenaryBustedFile tests/unit/example_spec.lua
```

To run all plenary tests in a directory:

```vim
:PlenaryBustedDirectory tests/unit/
```

### Manually with Mini.test

To run mini.test tests:

```lua
:lua require('mini.test').run()
:lua require('mini.test').run_file('tests/integration/test_config.lua')
:lua require('mini.test').run_at_location()  " Run test at cursor
```

## Writing Tests

### Unit Tests (Plenary)

Unit tests use plenary.nvim's busted-compatible API. Create files ending with `_spec.lua` in `tests/unit/`:

```lua
-- tests/unit/my_module_spec.lua
describe("My Module", function()
  it("does something", function()
    local result = my_function(input)
    assert.are.equal(expected, result)
  end)

  it("handles errors", function()
    assert.has_error(function()
      my_function_that_errors()
    end)
  end)
end)
```

#### Common Assertions (Plenary)

```lua
assert.are.equal(expected, actual)
assert.are.same(table1, table2)         -- Deep equality
assert.is_true(value)
assert.is_false(value)
assert.is_nil(value)
assert.is_not_nil(value)
assert.has_error(function)
```

### Integration Tests (Mini.test)

Integration tests use mini.test API. Create files starting with `test_` in `tests/integration/`:

```lua
-- tests/integration/test_my_feature.lua
local new_set = MiniTest.new_set

local T = new_set({
  hooks = {
    pre_case = function()
      -- Setup before each test
    end,
    post_case = function()
      -- Cleanup after each test
    end,
  },
})

T["feature_name"] = new_set()

T["feature_name"]["test description"] = function()
  -- Test code here
  MiniTest.expect.equality(actual, expected)
end

return T
```

#### Common Expectations (Mini.test)

```lua
MiniTest.expect.equality(actual, expected)
MiniTest.expect.no_equality(actual, not_expected)
MiniTest.expect.no_error(function)
MiniTest.expect.error(function)
```

## Test Structure Best Practices

### Unit Tests

- Test pure functions in isolation
- Mock external dependencies
- Focus on single units of functionality
- Fast execution (< 1ms per test)
- No side effects

### Integration Tests

- Test full workflows
- Test interactions between components
- Test with real Neovim environment
- Test buffer, window, and command operations
- Can have side effects (cleaned up in hooks)

## Setup for Development

To enable test runner commands in your configuration, add to your init.lua or a dedicated module:

```lua
-- Load and setup test runner
local test_runner = require('test_runner')
test_runner.setup_commands()
```

## Continuous Integration

### Pre-commit Testing

Add to your git pre-commit hook:

```bash
#!/bin/bash
# .git/hooks/pre-commit

./scripts/run_tests.sh all
if [ $? -ne 0 ]; then
    echo "Tests failed. Commit aborted."
    exit 1
fi
```

### Automated Testing

The bash test runner exits with appropriate codes:
- `0` - All tests passed
- `1` - Some tests failed

This makes it suitable for CI/CD pipelines.

## Troubleshooting

### Tests not running

1. Ensure plenary.nvim and mini.nvim are installed:
   ```vim
   :Lazy
   ```

2. Check that test files follow naming conventions:
   - Unit tests: `*_spec.lua`
   - Integration tests: `test_*.lua`

3. Verify minimal_init.lua has correct paths

### Plugin not found errors

If tests fail with "module not found" errors:

1. Update the minimal_init.lua with correct runtimepaths
2. Ensure plugins are installed: `:Lazy sync`

### Test failures

1. Run tests with verbose output:
   ```bash
   nvim --headless --noplugin -u tests/minimal_init.lua \
     -c "lua vim.print = print" \
     -c "PlenaryBustedDirectory tests/unit/"
   ```

2. Check test isolation - tests should not depend on each other

3. Verify setup/teardown hooks are working correctly

## Adding New Tests

### Checklist

1. ✅ Determine test type (unit vs integration)
2. ✅ Create test file in appropriate directory
3. ✅ Follow naming convention
4. ✅ Write descriptive test names
5. ✅ Add setup/teardown if needed
6. ✅ Run test to verify it works
7. ✅ Run all tests to ensure no regressions

### Example Workflow

```bash
# 1. Create test file
nvim tests/unit/my_new_feature_spec.lua

# 2. Write tests
# (use examples above)

# 3. Run just this test
nvim --headless --noplugin -u tests/minimal_init.lua \
  -c "PlenaryBustedFile tests/unit/my_new_feature_spec.lua"

# 4. Run all tests
./scripts/run_tests.sh all
```

## Performance Guidelines

### Unit Tests
- Should complete in < 1ms each
- No file I/O if possible
- No network requests
- Mock external dependencies

### Integration Tests
- Should complete in < 100ms each
- Clean up all created resources
- Use scratch buffers (`:enew`)
- Delete test files after use

## Future Enhancements

- [ ] Code coverage reporting
- [ ] Performance benchmarking
- [ ] Snapshot testing for UI
- [ ] Property-based testing
- [ ] Mutation testing
- [ ] Parallel test execution
- [ ] Test result caching
- [ ] Watch mode for development

## Resources

- [Plenary.nvim Testing](https://github.com/nvim-lua/plenary.nvim/blob/master/TESTS_README.md)
- [Mini.test Documentation](https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-test.md)
- [Neovim Test Examples](https://github.com/neovim/neovim/tree/master/test/functional)
- [Busted API Reference](https://lunarmodules.github.io/busted/)
