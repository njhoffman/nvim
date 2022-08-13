local ok, opt = pcall(require, "options")
if not ok then vim.notify(opt, 'error'); return end
opt.register_option({
  name = "test_notify_level_record",
  default = "trace",
  type_info = "string",
  source = "settings",
  global = true,
  description = "Cutoff level to record notifications (error, warn, info, debug, trace)"
})

opt.register_option({
  name = "test_indentsize",
  default = 4,
  type_info = "number",
  source = "buffers",
  buffer_local = true,
})

opt.set('test_notify_level_record', 'info')
opt.set(0, 'test_indentsize', 2)
-- opt.set_local('test_indentsize', 2)
-- vim.dbg(opt.get_state())
vim.dbg(opt.get('test_notify_level_record'))
-- vim.dbg(opt.get('test_indentsize'))
-- vim.dbg(opt.get_local('test_indentsize'))
-- opt.display()

-- opt.set_local('test_indentsize', 2)
-- vim.fn.timer_start(5000, function()
--   vim.dbg(opt.get('test_notify_level_record'))
--   -- opt.display()
-- end)
