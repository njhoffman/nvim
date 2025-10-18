-- Unit tests for custom utility functions
-- Tests utilities that might exist in lua/utils/

describe("Custom Utility Tests", function()
  describe("Path utilities", function()
    it("can work with filesystem paths", function()
      local path = vim.fn.stdpath("config")
      assert.is_not_nil(path)
      assert.is_true(#path > 0)
      assert.is_true(vim.fn.isdirectory(path) == 1)
    end)

    it("can expand paths", function()
      local home = vim.fn.expand("~")
      assert.is_not_nil(home)
      assert.is_true(#home > 0)
    end)
  end)

  describe("Configuration helpers", function()
    it("can access vim options", function()
      -- Test getting options
      local tabstop = vim.o.tabstop
      assert.is_not_nil(tabstop)
      assert.is_true(type(tabstop) == "number")

      -- Test setting options (in scratch buffer)
      local original = vim.o.number
      vim.o.number = true
      assert.is_true(vim.o.number)
      vim.o.number = original
    end)

    it("can check vim features", function()
      -- Test that we're running in Neovim
      assert.are.equal(1, vim.fn.has("nvim"))
      -- Test that Neovim version exists (another way to verify nvim)
      local version = vim.version()
      assert.is_not_nil(version)
      assert.is_not_nil(version.major)
    end)
  end)

  describe("Module loading", function()
    it("can access vim API modules", function()
      -- Test that vim.api is available
      assert.is_not_nil(vim.api)
      assert.are.equal("table", type(vim.api))

      -- Test a common vim function
      assert.are.equal("function", type(vim.api.nvim_get_current_buf))
    end)

    it("handles missing modules gracefully", function()
      local ok, err = pcall(require, "nonexistent_module_xyz")
      assert.is_false(ok)
      assert.is_not_nil(err)
    end)
  end)

  describe("Async operations", function()
    it("can use vim.schedule", function()
      local executed = false
      vim.schedule(function()
        executed = true
      end)

      -- Wait for scheduled function
      vim.wait(100, function()
        return executed
      end)

      assert.is_true(executed)
    end)

    it("can use vim.defer_fn", function()
      local executed = false
      vim.defer_fn(function()
        executed = true
      end, 10)

      -- Wait for deferred function
      vim.wait(50, function()
        return executed
      end)

      assert.is_true(executed)
    end)
  end)
end)
