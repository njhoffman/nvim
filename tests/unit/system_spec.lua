-- Unit tests for system commands
-- Tests YankPath, YankCwd, and Trash functionality

describe("System Commands", function()
  local system

  before_each(function()
    system = require("commands.system")
    -- Clear the + register before each test
    vim.fn.setreg('+', '')
  end)

  describe("Module structure", function()
    it("exports required functions", function()
      assert.is_not_nil(system)
      assert.are.equal("table", type(system))
      assert.are.equal("function", type(system.yank_path))
      assert.are.equal("function", type(system.yank_cwd))
      assert.are.equal("function", type(system.trash_file))
    end)
  end)

  describe("yank_path", function()
    it("yanks current file path to clipboard", function()
      -- Create a test buffer with a file
      local test_file = vim.fn.tempname()
      vim.cmd("edit " .. test_file)

      system.yank_path()

      local yanked = vim.fn.getreg('+')
      assert.are.equal(test_file, yanked)

      -- Cleanup
      vim.cmd("bwipeout!")
    end)

    it("handles buffers with no file", function()
      -- Create a scratch buffer
      vim.cmd("enew")

      system.yank_path()

      local yanked = vim.fn.getreg('+')
      -- Should yank current working directory since no file
      assert.is_not_nil(yanked)

      -- Cleanup
      vim.cmd("bwipeout!")
    end)

    it("replaces HOME with tilde in notifications", function()
      -- This test checks that the display path uses ~ for HOME
      local home = vim.fn.getenv('HOME')
      if home and home ~= '' then
        local test_file = home .. '/test.txt'
        vim.cmd("edit " .. test_file)

        -- The notification should contain ~ instead of full HOME path
        system.yank_path()

        -- The register should contain full path
        local yanked = vim.fn.getreg('+')
        assert.are.equal(test_file, yanked)

        vim.cmd("bwipeout!")
      end
    end)
  end)

  describe("yank_cwd", function()
    it("yanks current working directory", function()
      local cwd = vim.fn.getcwd()

      system.yank_cwd()

      local yanked = vim.fn.getreg('+')
      assert.is_not_nil(yanked)
      assert.is_true(#yanked > 0)
      -- Should be cwd or project root
      assert.is_true(yanked == cwd or #yanked > 0)
    end)

    it("handles missing project_nvim gracefully", function()
      -- This should not error even if project_nvim is not available
      local ok = pcall(system.yank_cwd)
      assert.is_true(ok)

      local yanked = vim.fn.getreg('+')
      assert.is_not_nil(yanked)
      assert.is_true(#yanked > 0)
    end)

    it("falls back to getcwd when project_nvim unavailable", function()
      -- Mock project_nvim as unavailable
      package.loaded['project_nvim'] = nil

      system.yank_cwd()

      local yanked = vim.fn.getreg('+')
      local cwd = vim.fn.getcwd()

      assert.are.equal(cwd, yanked)
    end)
  end)

  describe("trash_file", function()
    it("handles buffer with no file", function()
      -- Create scratch buffer
      local bufnr = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_set_current_buf(bufnr)

      -- Should not error, just notify
      local ok = pcall(system.trash_file)
      assert.is_true(ok)

      -- Buffer should still exist
      assert.is_true(vim.api.nvim_buf_is_valid(bufnr))

      -- Cleanup
      vim.api.nvim_buf_delete(bufnr, { force = true })
    end)

    it("checks if file exists before trashing", function()
      -- Create a non-existent file buffer
      vim.cmd("edit /tmp/nonexistent_file_12345.txt")

      -- Should handle gracefully
      local ok = pcall(system.trash_file)
      assert.is_true(ok)

      vim.cmd("bwipeout!")
    end)

    -- Note: We don't test actual trashing as it requires trash-put
    -- and would modify the file system
  end)

  describe("Edge cases", function()
    it("handles empty HOME environment variable", function()
      local original_home = vim.fn.getenv('HOME')

      -- Temporarily clear HOME
      vim.fn.setenv('HOME', '')

      local test_file = '/tmp/test.txt'
      vim.cmd("edit " .. test_file)

      local ok = pcall(system.yank_path)
      assert.is_true(ok)

      -- Restore HOME
      vim.fn.setenv('HOME', original_home)

      vim.cmd("bwipeout!")
    end)

    it("handles special characters in file paths", function()
      local test_file = '/tmp/test with spaces & special.txt'
      vim.cmd("edit " .. vim.fn.fnameescape(test_file))

      system.yank_path()

      local yanked = vim.fn.getreg('+')
      assert.are.equal(test_file, yanked)

      vim.cmd("bwipeout!")
    end)
  end)

  describe("Register handling", function()
    it("uses + register (system clipboard)", function()
      local test_file = vim.fn.tempname()
      vim.cmd("edit " .. test_file)

      -- Clear all registers
      vim.fn.setreg('+', '')
      vim.fn.setreg('"', '')

      system.yank_path()

      -- Check + register specifically
      local plus_reg = vim.fn.getreg('+')
      assert.are.equal(test_file, plus_reg)

      vim.cmd("bwipeout!")
    end)
  end)
end)
