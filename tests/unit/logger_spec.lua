-- Unit tests for the logger module
-- Covers: scope management, level filtering, sinks, debug helpers,
-- the :LogScopes command, and globals integration.

local reset_modules = function()
  for mod, _ in pairs(package.loaded) do
    if mod == "logger" or mod:match("^logger%.") then
      package.loaded[mod] = nil
    end
  end
end

describe("Logger", function()
  describe("scope management", function()
    it("init(scope) returns a logger with all level methods", function()
      local logger = require("logger")
      local scoped = logger.init("test_scope_a")
      assert.is_not_nil(scoped)
      assert.are.equal("function", type(scoped.trace))
      assert.are.equal("function", type(scoped.debug))
      assert.are.equal("function", type(scoped.info))
      assert.are.equal("function", type(scoped.warn))
      assert.are.equal("function", type(scoped.error))
    end)

    it("tracks scopes in logger.scopes after init", function()
      local logger = require("logger")
      logger.init("test_scope_b")
      assert.is_not_nil(logger.scopes["test_scope_b"])
    end)

    it("scope level overrides from levels.lua are applied", function()
      local logger = require("logger")
      -- 'notify' has main = 0 (trace) in levels.lua
      logger.init("notify")
      -- Level is stored +1 by get_sink_levels (number+1 -> 1..5, -1 stays -1)
      assert.are.equal(1, logger.scopes["notify"].main)
    end)

    it("unknown scope falls back to '*' default (main=2 info)", function()
      local logger = require("logger")
      logger.init("nonexistent_scope_xyz")
      -- Default is main = 2 (info), stored as 3 after get_sink_levels
      assert.are.equal(3, logger.scopes["nonexistent_scope_xyz"].main)
    end)

    it("init twice returns a functional logger both times", function()
      local logger = require("logger")
      local first = logger.init("test_scope_c")
      local second = logger.init("test_scope_c")
      assert.is_not_nil(first)
      assert.is_not_nil(second)
      assert.are.equal("function", type(second.info))
    end)
  end)

  describe("level filtering", function()
    it("info-level message writes to the module sink file", function()
      local logger = require("logger")
      -- Force module sink on so the scope-specific file is written.
      local scope = "test_level_info"
      local scoped = logger.init(scope, { module = 0 })
      scoped:info("info_probe_xyz")

      local logpath = vim.fn.stdpath("data") .. "/nvim-" .. scope .. ".log"
      assert.is_true(vim.fn.filereadable(logpath) == 1)
      local content = table.concat(vim.fn.readfile(logpath), "\n")
      assert.is_not_nil(content:find("info_probe_xyz", 1, true))
    end)

    it("message below module sink level does not produce output", function()
      local logger = require("logger")
      -- Module sink at warn (3): info calls should not write.
      local scope = "test_level_filter"
      local scoped = logger.init(scope, { module = 3 })
      local path = vim.fn.stdpath("data") .. "/nvim-" .. scope .. ".log"
      -- Truncate the file first so we can measure subsequent write.
      local f = io.open(path, "w")
      if f then
        f:close()
      end
      scoped:info("info_probe_must_not_appear")
      -- File should still be empty after the write.
      local size = vim.fn.getfsize(path)
      assert.is_true(size <= 0)
    end)

    it("error writes when module sink level is set to warn", function()
      local logger = require("logger")
      local scope = "test_level_error"
      local scoped = logger.init(scope, { module = 3 })
      scoped:error("error_probe_abc")
      local path = vim.fn.stdpath("data") .. "/nvim-" .. scope .. ".log"
      assert.is_true(vim.fn.filereadable(path) == 1)
      local content = table.concat(vim.fn.readfile(path), "\n")
      assert.is_not_nil(content:find("error_probe_abc", 1, true))
    end)
  end)

  describe("sinks", function()
    it("module sink writes to stdpath('data')/nvim-<scope>.log", function()
      local logger = require("logger")
      local scope = "test_scope_sinks"
      local scoped = logger.init(scope, { module = 0 })
      scoped:info("sink_probe")
      local expected = vim.fn.stdpath("data") .. "/nvim-" .. scope .. ".log"
      assert.is_true(vim.fn.filereadable(expected) == 1)
    end)

    it("log content contains the logged message", function()
      local logger = require("logger")
      local scope = "test_scope_nameinlog"
      local scoped = logger.init(scope, { module = 0 })
      scoped:info("name_probe")
      local path = vim.fn.stdpath("data") .. "/nvim-" .. scope .. ".log"
      local content = table.concat(vim.fn.readfile(path), "\n")
      assert.is_not_nil(content:find("name_probe", 1, true))
    end)
  end)

  describe("debug helpers", function()
    it("logger.debug module exposes expected API", function()
      local dbg = require("logger.debug")
      -- Some of these may be callable tables rather than raw functions, so
      -- just check they are non-nil and callable (via pcall with no args).
      for _, name in ipairs({ "log", "inspect", "dump", "traceback", "namespaces", "buf", "dbg", "timer" }) do
        assert.is_not_nil(dbg[name], "logger.debug." .. name .. " should exist")
      end
    end)

    it("inspect returns a string for a simple table", function()
      local dbg = require("logger.debug")
      local result = dbg.inspect({ a = 1, b = "hi" })
      assert.are.equal("string", type(result))
      assert.is_not_nil(result:find("a", 1, true))
    end)

    it("dump returns Lua-readable string for a table", function()
      local dbg = require("logger.debug")
      local result = dbg.dump({ x = 1, y = 2 })
      assert.are.equal("string", type(result))
      assert.is_not_nil(result:find("x"))
      assert.is_not_nil(result:find("y"))
    end)

    it("dump handles cyclic tables without stack overflow", function()
      local dbg = require("logger.debug")
      local tbl = { name = "cyclic" }
      tbl.self = tbl
      local ok, result = pcall(dbg.dump, tbl)
      assert.is_true(ok)
      assert.are.equal("string", type(result))
    end)

    it("traceback returns a non-empty array of frame strings", function()
      local dbg = require("logger.debug")
      local frames = dbg.traceback()
      assert.are.equal("table", type(frames))
      assert.is_true(#frames > 0)
      assert.are.equal("string", type(frames[1]))
    end)

    it("namespaces returns a table of lines", function()
      local dbg = require("logger.debug")
      local lines = dbg.namespaces({ buf = -1, show_extmarks = false })
      assert.are.equal("table", type(lines))
    end)

    it("timer with a name can be started and stopped", function()
      local dbg = require("logger.debug")
      dbg.timer("spec_timer")
      -- Second call stops the timer and returns elapsed ns
      local elapsed = dbg.timer("spec_timer")
      assert.are.equal("number", type(elapsed))
      assert.is_true(elapsed >= 0)
    end)
  end)

  describe("globals integration", function()
    before_each(function()
      -- The test runner loads with --noplugin, so globals/init.lua is not
      -- auto-loaded. Load it explicitly to test the vim.* integration.
      if vim.dbglog == nil then
        pcall(require, "globals")
      end
    end)

    it("vim.dbglog is installed and callable", function()
      assert.is_not_nil(vim.dbglog)
      assert.are.equal("function", type(vim.dbglog))
      local ok = pcall(vim.dbglog, "globals_integration_probe")
      assert.is_true(ok)
    end)

    it("vim.dbgout has the expected helper methods", function()
      assert.is_not_nil(vim.dbgout)
      assert.are.equal("function", type(vim.dbgout.dump))
      assert.are.equal("function", type(vim.dbgout.ns))
      assert.are.equal("function", type(vim.dbgout.buf))
    end)

    it("vim.dbgtime is a function", function()
      assert.is_not_nil(vim.dbgtime)
      assert.are.equal("function", type(vim.dbgtime))
    end)

    it("old require paths are not present in package.loaded", function()
      -- After all the above has loaded, the old paths should never have been used
      -- (this also implicitly validates nothing is reaching for them)
      assert.is_nil(package.loaded["debuglog"])
      assert.is_nil(package.loaded["structlog"])
    end)
  end)

  describe("public command", function()
    it(":LogScopes user command is registered", function()
      -- Force logger to load (the command is registered as a side effect)
      require("logger")
      local cmds = vim.api.nvim_get_commands({})
      assert.is_not_nil(cmds["LogScopes"])
    end)
  end)

  describe("hybrid call syntax", function()
    it("colon call writes to the module sink file", function()
      local logger = require("logger")
      local scope = "test_hybrid_colon"
      local scoped = logger.init(scope, { module = 0 })
      local path = vim.fn.stdpath("data") .. "/nvim-" .. scope .. ".log"
      local f = io.open(path, "w")
      if f then
        f:close()
      end
      scoped:info("probe_colon_xyz")
      local content = table.concat(vim.fn.readfile(path), "\n")
      assert.is_not_nil(content:find("probe_colon_xyz", 1, true))
    end)

    it("dot call writes to the module sink file", function()
      local logger = require("logger")
      local scope = "test_hybrid_dot"
      local scoped = logger.init(scope, { module = 0 })
      local path = vim.fn.stdpath("data") .. "/nvim-" .. scope .. ".log"
      local f = io.open(path, "w")
      if f then
        f:close()
      end
      scoped.info("probe_dot_xyz")
      local content = table.concat(vim.fn.readfile(path), "\n")
      assert.is_not_nil(content:find("probe_dot_xyz", 1, true))
    end)

    it("dot call binds to the instance, not a static fallback", function()
      local logger = require("logger")
      local scope = "test_hybrid_bind"
      local scoped = logger.init(scope, { module = 0 })
      local path = vim.fn.stdpath("data") .. "/nvim-" .. scope .. ".log"
      local f = io.open(path, "w")
      if f then
        f:close()
      end
      scoped:info("colon_bind_probe")
      scoped.info("dot_bind_probe")
      local content = table.concat(vim.fn.readfile(path), "\n")
      assert.is_not_nil(content:find("colon_bind_probe", 1, true))
      assert.is_not_nil(content:find("dot_bind_probe", 1, true))
      assert.is_not_nil(content:find(scope, 1, true))
    end)
  end)

  describe("structlog framework (smoke)", function()
    it("logger.structlog is loadable with the expected API", function()
      local sl = require("logger.structlog")
      assert.are.equal("function", type(sl.configure))
      assert.are.equal("function", type(sl.get_logger))
      assert.are.equal("function", type(sl.update_sink_level))
      assert.is_not_nil(sl.level)
      assert.is_not_nil(sl.sinks)
      assert.is_not_nil(sl.formatters)
      assert.is_not_nil(sl.processors)
    end)
  end)
end)

-- Keep reset_modules in scope — useful if a test wants a clean module state
-- but currently the logger intentionally maintains cross-test state via
-- package.loaded (sinks and scopes) so we do not reset in before_each.
return { _reset_modules = reset_modules }
