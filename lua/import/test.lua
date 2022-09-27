local benchmarks = {}
benchmarks.aucommands = {
  get = function()
    return vim.api.nvim_get_autocmds({})
  end,
  diff = function(prev, next)
    -- buflocal = false,
    -- callback = <function 9>,
    -- command = "",
    -- event = "WinScrolled",
    -- group = 38,
    -- group_name = "treesitter_context_update",
    -- id = 57,
    -- once = false,
    -- pattern = "*"
  end,
}
benchmarks.augroups = {
  get = function() end,
  diff = function(prev, next) end,
}

local test_benchmarks = {
  benchmarks.aucommands,
  benchmarks.augroups,
}

vim.import("import.mock", function(mock)
  vim.dbglog("MOCK", mock())
end, { benchmark = test_benchmarks })

-- local mock = vim.import("import.mock", _, { benchmark = test_benchmarks })
-- vim.dbglog("MOCK", mock())

-- local au1 = {
--   {
--     buflocal = false,
--     command = "call matchup#loader#init_buffer()",
--     event = "FileType",
--     group = 118,
--     group_name = "matchup_filetype",
--     once = false,
--     pattern = "*",
--   },
-- }
--
-- local au2 = {
--   {
--     buflocal = false,
--     command = "call matchup#loader#init_buffer()",
--     event = "FileType",
--     group = 118,
--     group_name = "matchup_filetype",
--     once = false,
--     pattern = "*",
--   },
--   {
--     buflocal = false,
--     callback = "<function 107>",
--     command = "",
--     desc = "Reattach module",
--     event = "FileType",
--     group = 120,
--     group_name = "NvimTreesitter-matchup",
--     id = 131,
--     once = false,
--     pattern = "*",
--   },
-- }
--
-- vim.dbglog(benchmarks.aucommands.diff(au1, au2))
-- -- vim.dbglog(benchmarks.aucommands.diff(au2, au1))
