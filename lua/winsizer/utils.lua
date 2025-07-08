local get_existing_props = function()
  local sizeprops = {
    editor = get_editor_props(),
    splits = get_win_splits(),
    floats = get_win_floats(),
  }
  return sizeprops
end

local get_editor_props = function()
  return {
    width = vim.api.nvim_get_option_value("columns", { scope = "global" }),
    height = vim.api.nvim_get_option_value("lines", { scope = "global" }),
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

return {
  calc_updates = calc_updates,
}
