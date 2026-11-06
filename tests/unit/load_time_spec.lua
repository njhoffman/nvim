-- The startup time message, and that it is reported once, without animating.
local load_time = require("core.load_time")

describe("core.load_time", function()
  describe("format", function()
    it("gives both times and the plugin counts", function()
      assert.equals(
        "Ready in 0.70s, loaded in 1.02s (210/386 plugins)",
        load_time.format(697, 1021, { loaded = 210, count = 386 })
      )
    end)

    it("leaves out the first screen when no UI ever attached", function()
      assert.equals("Loaded in 1.02s", load_time.format(nil, 1021))
    end)
  end)

  describe("setup", function()
    local notify, calls

    before_each(function()
      notify, calls = vim.notify, {}
      vim.notify = function(message, level, opts)
        calls[#calls + 1] = { message = message, level = level, opts = opts }
      end
      vim.g.start_time = vim.fn.reltime()
      vim.g.startup_ready_ms, vim.g.startup_loaded_ms = nil, nil
    end)

    after_each(function()
      vim.notify = notify
    end)

    it("reports both times once, without animating", function()
      load_time.setup()
      vim.api.nvim_exec_autocmds("UIEnter", {})
      vim.api.nvim_exec_autocmds("User", { pattern = "VeryLazy" })
      vim.api.nvim_exec_autocmds("User", { pattern = "VeryLazy" })
      vim.wait(200, function()
        return #calls > 0
      end)

      assert.equals(1, #calls)
      assert.is_truthy(calls[1].message:find("^Ready in %d+%.%d+s, loaded in %d+%.%d+s"))
      assert.is_false(calls[1].opts.animate)
      assert.is_number(vim.g.startup_ready_ms)
      assert.is_true(vim.g.startup_loaded_ms >= vim.g.startup_ready_ms)
    end)
  end)
end)
