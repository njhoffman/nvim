local load = function(jumps, idx)
  vim.dbglog('jumps', jumps, idx)
end

return { load = load }
