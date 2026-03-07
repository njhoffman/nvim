local parse_config = function(opts)
  local defaults = {
    win = { winnr = 0, winid = nil, verbose = false },
    buf = { bufnr = 0, unlisted = false, unloaded = false, verbose = false },
    ns = { nsid = 0, verbose = false },
    hl = { verbose = false },
    ext = { verbose = false },
  }
  -- if any of win, buf, ns, hl, ext are false don't output anything from those sections
  -- if any of win, buf, ns, hl, ext are true assign the defaults
  -- if winnr is 0 then use the current window
  -- if bufnr is 0 then use the current buffer
  -- if nsid is 0 then use the current namespace
  -- if bufnr, winnr, or ns is -1 then use all buffers/windows/namespaces
  --
end

return function(opts)
  local config = parse_config(opts)
end
