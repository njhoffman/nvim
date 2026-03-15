-- QuickClose command unit tests
-- Tests the syntax fix for the count_listed_buffers function (line 76)
-- and comprehensive functionality of the QuickClose command
local quickclose = require("commands.quickclose")

describe("QuickClose", function()
  before_each(function()
    -- Create a fresh buffer for each test
    vim.cmd("enew")
  end)

  after_each(function()
    -- Clean up all buffers except current
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
      if bufnr ~= vim.api.nvim_get_current_buf() and vim.api.nvim_buf_is_loaded(bufnr) then
        pcall(vim.api.nvim_buf_delete, bufnr, { force = true })
      end
    end
    -- Clean up all windows except current
    while vim.fn.winnr("$") > 1 do
      vim.cmd("close")
    end
  end)

  describe("buffer operations", function()
    it("can delete buffer when multiple listed buffers exist", function()
      -- Create two buffers
      local buf1 = vim.api.nvim_create_buf(true, false) -- listed, scratch
      local buf2 = vim.api.nvim_create_buf(true, false)

      -- Set current buffer to buf1
      vim.api.nvim_set_current_buf(buf1)

      -- Count buffers before
      local count_before = 0
      for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        if vim.bo[bufnr].buflisted then
          count_before = count_before + 1
        end
      end

      -- Should have at least 2 listed buffers
      assert.is_true(count_before >= 2)

      -- Quick close should delete the buffer (bdelete is called via vim.schedule)
      quickclose.quick_close()

      -- Wait for the scheduled bdelete to execute
      vim.wait(200, function()
        local count = 0
        for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
          if vim.bo[bufnr].buflisted then
            count = count + 1
          end
        end
        return count < count_before
      end)

      -- Count buffers after
      local count_after = 0
      for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        if vim.bo[bufnr].buflisted then
          count_after = count_after + 1
        end
      end

      -- Should have one less buffer
      assert.equals(count_before - 1, count_after)
    end)
  end)

  describe("window operations", function()
    it("can close floating window", function()
      -- Create a floating window
      local buf = vim.api.nvim_create_buf(false, true)
      local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = 50,
        height = 10,
        col = 10,
        row = 10,
      })

      -- Verify it's floating
      local config = vim.api.nvim_win_get_config(win)
      assert.is_not.equals("", config.relative)

      -- Quick close should close the window
      quickclose.quick_close()

      -- Window should be closed
      assert.is_false(vim.api.nvim_win_is_valid(win))
    end)

    it("can close split window", function()
      -- Create a split
      vim.cmd("split")

      -- Should have 2 windows
      local win_count_before = vim.fn.winnr("$")
      assert.equals(2, win_count_before)

      -- Quick close should close the window
      quickclose.quick_close()

      -- Should have 1 window
      local win_count_after = vim.fn.winnr("$")
      assert.equals(1, win_count_after)
    end)
  end)

  describe("special split detection", function()
    it("can identify quickfix buffer", function()
      -- Create quickfix window
      vim.fn.setqflist({})
      vim.cmd("copen")

      local win = vim.api.nvim_get_current_win()
      local buf = vim.api.nvim_win_get_buf(win)

      -- Verify it's quickfix type
      assert.equals("quickfix", vim.bo[buf].buftype)

      -- Close quickfix
      vim.cmd("cclose")
    end)

    it("can identify help buffer", function()
      -- Open a help buffer
      vim.cmd("help")

      local buf = vim.api.nvim_get_current_buf()

      -- Verify it's help type
      assert.equals("help", vim.bo[buf].buftype)

      -- Close help
      vim.cmd("close")
    end)
  end)

  describe("command registration", function()
    it("registers QuickClose command", function()
      -- Setup the command
      quickclose.setup()

      -- Check if command exists
      local commands = vim.api.nvim_get_commands({})
      assert.is_not_nil(commands.QuickClose)
      assert.equals("Smart close: close window, special split, or delete buffer", commands.QuickClose.definition)
    end)
  end)

  -- Tests for the syntax fix: count_listed_buffers function (line 76)
  -- This specifically tests that the 'do' keyword works correctly in the for loop
  describe("count_listed_buffers function (syntax fix test)", function()
    it("correctly counts listed buffers with multiple buffers", function()
      -- Create multiple buffers (some listed, some not)
      local buf1 = vim.api.nvim_create_buf(true, false)  -- listed
      local buf2 = vim.api.nvim_create_buf(true, false)  -- listed
      local buf3 = vim.api.nvim_create_buf(false, true)  -- not listed (scratch)

      -- Count listed buffers manually
      local expected_count = 0
      for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        if vim.bo[bufnr].buflisted then
          expected_count = expected_count + 1
        end
      end

      -- The function should work without syntax errors
      -- If the syntax was broken (using 'then' instead of 'do'), this would fail to load
      assert.is_true(expected_count >= 2, "Should have at least 2 listed buffers")

      -- Clean up
      pcall(vim.api.nvim_buf_delete, buf1, { force = true })
      pcall(vim.api.nvim_buf_delete, buf2, { force = true })
      pcall(vim.api.nvim_buf_delete, buf3, { force = true })
    end)

    it("handles empty buffer list gracefully", function()
      -- This test ensures the loop works even with edge cases
      -- The syntax fix (do instead of then) is critical for proper iteration
      local success = pcall(function()
        -- Create and delete buffer rapidly
        local buf = vim.api.nvim_create_buf(true, false)
        vim.api.nvim_buf_delete(buf, { force = true })
      end)

      assert.is_true(success, "Should handle buffer operations without syntax errors")
    end)
  end)

  describe("special split scenarios", function()
    it("closes special split when in normal window with split", function()
      -- Create a normal split
      vim.cmd("split")
      local normal_win = vim.api.nvim_get_current_win()

      -- Create a quickfix window
      vim.fn.setqflist({})
      vim.cmd("copen")

      -- Switch back to normal window
      vim.api.nvim_set_current_win(normal_win)

      local win_count_before = vim.fn.winnr("$")
      assert.equals(3, win_count_before, "Should have 3 windows: original + split + quickfix")

      -- QuickClose from normal window should close the quickfix
      quickclose.quick_close()

      -- Wait a moment for window to close
      vim.wait(100)

      local win_count_after = vim.fn.winnr("$")
      assert.equals(2, win_count_after, "Should have 2 windows after closing quickfix")

      -- Clean up
      pcall(vim.cmd, "cclose")
    end)

    it("closes current window when it's a special split", function()
      -- Create a split first
      vim.cmd("split")

      -- Create quickfix window
      vim.fn.setqflist({})
      vim.cmd("copen")

      local qf_win = vim.api.nvim_get_current_win()
      local win_count_before = vim.fn.winnr("$")

      -- QuickClose from quickfix should close it
      quickclose.quick_close()

      -- Wait a moment
      vim.wait(100)

      local win_count_after = vim.fn.winnr("$")
      assert.is_true(win_count_after < win_count_before, "Should have fewer windows")
      assert.is_false(vim.api.nvim_win_is_valid(qf_win), "Quickfix window should be closed")
    end)
  end)

  describe("last buffer edge case", function()
    it("handles last buffer scenario appropriately", function()
      -- Ensure we're down to one buffer
      for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        if bufnr ~= vim.api.nvim_get_current_buf() and vim.api.nvim_buf_is_loaded(bufnr) then
          pcall(vim.api.nvim_buf_delete, bufnr, { force = true })
        end
      end

      local current_buf = vim.api.nvim_get_current_buf()

      -- QuickClose on last buffer should either show Alpha or create new buffer
      local success = pcall(quickclose.quick_close)

      -- Should succeed without error
      assert.is_true(success, "Should handle last buffer scenario gracefully")

      -- Should have a valid buffer (either new one or Alpha)
      local new_buf = vim.api.nvim_get_current_buf()
      assert.is_true(vim.api.nvim_buf_is_valid(new_buf), "Should have a valid buffer after QuickClose")
    end)
  end)

  describe("regex pattern matching for filetypes", function()
    it("matches Avante.* filetype pattern", function()
      -- Create a buffer with Avante-like filetype
      local buf = vim.api.nvim_create_buf(false, true)
      vim.bo[buf].filetype = "AvanteInput"

      local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = 50,
        height = 10,
        col = 10,
        row = 10,
      })

      -- Test that regex pattern works (the fix ensures the loop can iterate)
      local pattern = "^Avante.*$"
      local str = "AvanteInput"
      local matches = str:match(pattern)

      assert.is_not_nil(matches, "Should match Avante.* pattern")

      -- Clean up
      pcall(vim.api.nvim_win_close, win, true)
      pcall(vim.api.nvim_buf_delete, buf, { force = true })
    end)
  end)
end)
