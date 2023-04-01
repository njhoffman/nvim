local man_handler = function(start_time, timing)
  local word = vim.fn.expand("<cword>") or ""
  if string.len(word) == 0 then
    return { summary = "  -------- man   ", hl = "DebugMsg" }
  end

  local output = vim.fn.system("man " .. word)
  if string.match(output, "No manual entry for ") then
    return { summary = "  -------- man   ", hl = "DebugMsg" }
  else
    local load_time = vim.fn.reltimestr(vim.fn.reltime(start_time))
    timing.total = timing.total + (load_time * 100000)
    timing.n = timing.n + 1
    return { summary = load_time .. " man   " .. word .. " " .. #output .. " lines", hl = "MoreMsg" }
  end
end
return { handler = man_handler }
