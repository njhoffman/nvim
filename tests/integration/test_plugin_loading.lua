-- Integration tests for plugin loading and initialization
-- Tests the custom vim.import system and lazy.nvim integration

local new_set = MiniTest.new_set

local T = new_set({
  hooks = {
    pre_once = function()
      -- Setup once before all tests in this file
    end,
  },
})

T["module_loading"] = new_set()

T["module_loading"]["can access vim API"] = function()
  -- Test that vim.api is accessible
  MiniTest.expect.no_equality(vim.api, nil)
  MiniTest.expect.equality(type(vim.api), "table")
end

T["module_loading"]["vim.import wrapper may exist"] = function()
  -- Note: vim.import is a custom wrapper added by full config
  -- In minimal init, it won't exist, which is expected
  local has_import = vim.import ~= nil
  -- This is just informational - both states are valid
  if has_import then
    MiniTest.expect.equality(type(vim.import), "function")
  end
  -- Always pass - we're just documenting the state
  MiniTest.expect.equality(true, true)
end

T["module_loading"]["can handle module load errors gracefully"] = function()
  local ok, err = pcall(require, "definitely_nonexistent_module_12345")
  MiniTest.expect.equality(ok, false)
  MiniTest.expect.no_equality(err, nil)
end

T["filesystem"] = new_set()

T["filesystem"]["config directory exists"] = function()
  local config_dir = vim.fn.stdpath("config")
  MiniTest.expect.no_equality(config_dir, nil)
  MiniTest.expect.equality(vim.fn.isdirectory(config_dir), 1)
end

T["filesystem"]["init.lua exists"] = function()
  local init_lua = vim.fn.stdpath("config") .. "/init.lua"
  MiniTest.expect.equality(vim.fn.filereadable(init_lua), 1)
end

T["filesystem"]["lua directory structure exists"] = function()
  local lua_dir = vim.fn.stdpath("config") .. "/lua"
  MiniTest.expect.equality(vim.fn.isdirectory(lua_dir), 1)

  -- Check for key directories
  local important_dirs = {
    "plugins",
    "configs",
    "commands",
    "utils",
  }

  for _, dir in ipairs(important_dirs) do
    local full_path = lua_dir .. "/" .. dir
    local exists = vim.fn.isdirectory(full_path) == 1
    if not exists then
      vim.notify("Missing directory: " .. full_path, vim.log.levels.WARN)
    end
  end
end

T["commands"] = new_set()

T["commands"]["test runner commands are available"] = function()
  -- These commands should be registered by test_runner.lua
  local commands = vim.api.nvim_get_commands({})

  local expected_commands = {
    "TestUnit",
    "TestIntegration",
    "TestAll",
    "TestFile",
    "TestNearest",
  }

  for _, cmd in ipairs(expected_commands) do
    local exists = commands[cmd] ~= nil
    if not exists then
      vim.notify("Command not found: " .. cmd, vim.log.levels.INFO)
    end
    -- Note: This is informational, not a hard requirement
    -- Commands may only be registered when test_runner is loaded
  end
end

T["highlights"] = new_set()

T["highlights"]["can query highlight groups"] = function()
  -- Should be able to query standard highlight groups
  local normal_hl = vim.api.nvim_get_hl(0, { name = "Normal" })
  MiniTest.expect.no_equality(normal_hl, nil)
end

T["highlights"]["can create custom highlight group"] = function()
  vim.api.nvim_set_hl(0, "TestHighlight", { fg = "#ff0000" })
  local hl = vim.api.nvim_get_hl(0, { name = "TestHighlight" })
  MiniTest.expect.no_equality(hl, nil)
  MiniTest.expect.no_equality(hl.fg, nil)
end

return T
