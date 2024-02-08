local state = require('tail.state')

local start_test_timer = function()
  state._test_timer = vim.fn.timer_start(1000, function()
    vim.fn.writefile({
      os.time() .. ' ' .. os.date(),
    }, '/home/nicholas/.local/share/nvim/inspect.log', 'a')
  end, { ['repeat'] = -1 })
end

local stop_test_timer = function()
  vim.fn.timer_stop(state._test_timer)
  state._log_timer_id = nil
end

local human_size = function(bytes)
  if bytes < 1024 then
    return bytes .. ' B'
  elseif bytes < 1048576 then
    return string.format('%.1f KB', bytes / 1024)
  elseif bytes < 1073741824 then
    return string.format('%.1f MB', bytes / 1048576)
  else
    return string.format('%.1f GB', bytes / 1073741824)
  end
end

return {
  human_size = human_size,
  start_test_timer = start_test_timer,
  stop_test_timer = stop_test_timer,
}
