
local get_editor_props = function()
  return {
    width = vim.api.nvim_get_option_value("columns", { scope = 'global' }),
    height = vim.api.nvim_get_option_value("lines", { scope = 'global'  })
  }
end

--     ft = vim.api.nvim_get_option_value("filetype", { buf = bufnr })

local get_winprops = function(winnr)
  winnr = winnr or 0
  local winid = vim.fn.win_getid(winnr or 0)

  return {
    winnr = winnr,
    winid = winid,
    height = vim.api.nvim_win_get_height(winid),
    width = vim.api.nvim_win_get_width(winid),
  }
end


local get_win_splits = function(currwin)

  local dirmap = { left = "h", right = "l", down = "j", up = "k" }
  local splits = {}
  for name, dir in pairs(dirmap) do
    if vim.fn.winnr(dir) ~= currwin.winnr then
      splits[name] = get_winprops(currwin)
    end
  end
  return splits
end

local get_win_floats = function()
  local floats = {}
  for _, winid in ipairs(vim.api.nvim_list_wins()) do
    local wininfo = vim.api.nvim_win_get_config(winid)
    if wininfo.relative ~= "" then
      local winprops = get_winprops(winid)
      floats[winid] = winprops
    end
  end
  return floats
end

local calc_new_props = function(acction, mapdef, existing_props)
  local newsizeprops = {
    update = {},
    remove  = {}
    add = { w = 0.5 * sizeprops.editor.width }
  }
  return newsizeprops
end


local get_existing_props = function()
  local sizeprops = {
     editor = get_editor_props(),
     splits = get_win_splits(),
     floats = get_win_floats()
  }
  return sizeprops
end


local apply_win_updates = function(winupdates)
  if winupdates.add then
    vim.dbglog('adding a window', winupadtes.add)
  elseif winupdates.remove then
    vim.dbglog('adding a window', winupadtes.remove)
  else if winupdates.change then
    vim.dbglog('changing windows', winupdates.change)
  end
end


local winmap = {
  default_split = { w = 0.5 },
  default_float = { w = 0.3, h = 0.9 }
}
local default_winprops = {}

local match_mapdef = function(action, id, winprops)
  if type(winmap[id]) == 'table' then
    return winmap[id]
  elseif type(winmap[id]) == 'function' then
    return winmap[id](action, winprops)
  else
    return get_defaults(action, winprops)
  end
end




local sizers = {}
sizers.add_window = function(id, winprops)
  winprops = vim.tbl_deep_extend( 'force',  {},  default_winprops,
  type(winprops) == 'string' and { wintype = winprops } or  winprops)

  local matchdef = match_mapdef('add', existing_props)
  local winupdates = calc_new_props(action, matchdef, existing_props)
  apply_win_updates(winupdates)
end

sizers.remove_window = function(id, winprops)

end







end

--   end

--   match_winmap_def('add', id, winprops)
--   local matchdef = winmap[id] or winmap.default_split

--   -- TODO: expand matching function based on existing props
--   return winmap[id] or winmap.default_split


--   return calc_new_props(mapdef, existing_props, winprops)
-- end

-- sizers.rm_window = function(winnr)

-- end

-- sizers.resize = function()
-- end

return  sizers

