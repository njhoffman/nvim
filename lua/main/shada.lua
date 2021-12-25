-- | if &bufhidden =~ 'wipe' && &buftype =~ 'nofile' && &buftype =~ hidden | silent! wshada | silent! !~/bin/wshada.sh | endif",
local shadaEvents = {
  { "BufRead", "*", [[call ShadaWrite()]], },
  { "Signal", "SIGUSR1", [[call ShadaRead()]] },
}
-- local shadaEvents = { { "BufWrite", "*", [[call ShadaWrite()]] }, { "Signal", "SIGUSR1", [[call ShadaRead()]] } }

return shadaEvents
