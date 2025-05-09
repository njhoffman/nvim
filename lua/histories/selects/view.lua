local load = function(selects, select_idx)
  vim.dbglog("selectcs", selects, select_idx)
end

return { load = load }
