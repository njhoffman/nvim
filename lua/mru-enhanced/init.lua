#!/usr/bin/env lua

  -- | if &bufhidden =~ 'wipe' && &buftype =~ 'nofile' && &buftype =~ hidden | silent! wshada | silent! !~/bin/wshada.sh | endif",
  -- local shadaEventsViml = { { "BufWrite", "*", [[call ShadaWrite()]] }, { "Signal", "SIGUSR1", [[call ShadaRead()]] } }
  if Opts.shada_events == true then
    autocmds.ShadaEvents = {
      { "BufRead", "*", [[call ShadaWrite()]] },
      { "Signal", "SIGUSR1", [[call ShadaRead()]] },
    }
  end

