local action_state = require("telescope.actions.state")

-- TODO : unique id for picker

local timing = { fetch = {}, reload = {}, time_last = nil, bufnr = nil }

local log_picker = function(picker)
  -- local pickerObj = {}
  local pickerObj =
    vim.fn.deepcopy(vim._.omit(picker, { "finder", "highlighter", "layout", "manager" }))
  pickerObj.finder = vim._.omit(picker.finder, { "results", "linked_states" })
  pickerObj.layout = vim._.omit(picker.layout, { "picker" })
  pickerObj.manager = vim._.omit(picker.manager, { "results", "linked_states" })
  vim.dbglog(pickerObj)
end

local on_complete = function(picker)
  -- processed, displayed, looped, previewed
  -- log_timing(picker.stats.processed)
  local prompt = action_state.get_current_line()
  if picker.results_bufnr ~= timing.bufnr then
    timing = { fetch = {}, reload = {}, time_last = nil, bufnr = picker.results_bufnr }
  end

  local finder_name = picker.finder.name
  local picker_name = picker.__name and vim.split(picker.__name, "%.")[2] or ""
  local time_start = picker.finder.time_start
  local log_msg = ""
  if time_start and (#timing.fetch == 0 or type(time_start) == "function") then
    time_start = type(time_start) == "function" and time_start() or time_start
    local cmd = type(picker.finder.cmd) == "function" and picker.finder.cmd() or picker.finder.cmd
    local time_diff = (vim.loop.hrtime() - time_start) / 1e6
    local rate = picker.stats.processed / (time_diff / 1000)
    table.insert(timing.fetch, { rate = rate, diff = time_diff, cmd = cmd })
    log_msg = string.format("󰇚 %-20s %6.0f/s", picker_name .. ":" .. finder_name, rate)
    -- if cmd then
    --   vim.dbglog(cmd.command .. " ", table.concat(cmd.args, " "))
    -- end
  elseif timing.time_last then
    local time_diff = (vim.loop.hrtime() - timing.time_last) / 1e6
    local rate = picker.stats.processed / (time_diff / 1000)
    table.insert(timing.reload, { diff = time_diff, rate = rate })
    log_msg = string.format("󰑓 %-20s %6.0f/s", picker_name .. ":" .. finder_name, rate)
  end
  timing.time_last = vim.loop.hrtime()

  if log_msg ~= "" then
    vim.dbglog(log_msg .. string.format(
      " %6s %-6s %6.0fk %2s %s",
      picker.stats.displayed,
      picker.stats.processed,
      picker.stats.looped / 1e3,
      picker.stats.status,
      -- picker.stats.filtered,
      prompt or ""
    ))
  end
end

return on_complete
