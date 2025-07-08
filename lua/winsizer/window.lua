
local calc_updates  = function(action, mapdef, existing_props)
  local updates = {
    update = {},
    remove  = {}
    add = { w = 0.5 * sizeprops.editor.width }
  }
  return updates
end

local apply_win_updates = function(winupdates)
  if winupdates.add then
    vim.dbglog("adding a window", winupadtes.add)
  elseif winupdates.remove then
    vim.dbglog("adding a window", winupdates.remove)
  else
    if winupdates.change then vim.dbglog("changing windows", winupdates.change) end
  end
end

return {
  calc_updates = calc_updates,
  apply_updates = apply_updates
}
