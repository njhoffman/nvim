require('tracker').setup({
  metrics = {
    -- aucommands = {},
    -- augroups = {},
    -- highlights = {},
  },
  list = {
    highlights = {},
    -- events = {event_list = events},
  },
})
-- tracker.setup()

-- local clock = os.clock
-- function sleep(n) -- seconds
--   local t0 = clock()
--   while clock() - t0 <= n do
--   end
-- end

-- vim.api.nvim_create_augroup("test_diff", {})
-- vim.dbglog("created test_diff")
-- vim.api.nvim_create_augroup("test_diff2", {})
-- vim.dbglog("created test_diff2")
-- --
-- vim.api.nvim_del_augroup_by_name("test_diff2")
-- vim.api.nvim_del_augroup_by_name("test_diff")
-- vim.dbglog("deleted")
--
-- print(tonumber(6 % 3))
