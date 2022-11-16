local benchmarks = require("import.benchmarks")
local test_benchmarks = {
  benchmarks.aucommands,
  -- benchmarks.augroups,
}
--
-- -- -- importer.import("import-dbg.mock", function(mock)
-- -- --   vim.dbglog("MOCK", mock())
-- -- -- end, { benchmark = test_benchmarks })
-- --
local importer = require("import-dbg")
local mock = importer.import("import.mock", _, { benchmarks = test_benchmarks })
local mocked = mock()
vim.dbglog(mocked)
