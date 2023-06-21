local timing = function(opts, timing, num)
  -- command finishes here if async job
  if type(timing.command ~= 'string') then
    ---@diagnostic disable-next-line: missing-parameter, param-type-mismatch
    timing.command = vim.fn.reltimestr(vim.fn.reltime(timing.total))
  end

  if type(timing.total) ~= 'string' then
    ---@diagnostic disable-next-line: missing-parameter, param-type-mismatch
    timing.total = vim.fn.reltimestr(vim.fn.reltime(timing.total))
    timing.average = timing.total * 10000 / num
    vim.dbglog(
      opts.prompt_title .. ':',
      timing.average,
      '(' .. num .. ') ',
      -- opts.finder_type,
      -- '\n',
      -- timing.command,
      -- timing.first_entry,
      timing.total
    )
  end
end

return {
  timing = timing,
  trace = vim.dbglog,
  debug = vim.dbglog,
  info = vim.dbglog,
  warn = vim.dbglog,
  error = vim.dbglog,
}
