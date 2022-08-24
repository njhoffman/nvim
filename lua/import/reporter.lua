local opts = require('import.opts')

local simple_metrics = function(metrics)
  if metrics == nil then
    metrics = {
      { time = vim.loop.hrtime() },
      { time = nil },
      { duration = nil }
    }
  else
    metrics[2].time = vim.loop.hrtime()
    metrics[3].duration = metrics[2].time - metrics[1].time
  end
  return metrics
end

local detailed_metrics = function(metrics)
  return metrics
end

local calc_metrics = function(prev)
  local metrics = simple_metrics(prev)
  if opts.user_opts.detailed_metrics then
    return detailed_metrics(metrics)
  end
  return metrics
end

return {
  calc_metrics = calc_metrics
}
