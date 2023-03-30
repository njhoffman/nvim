local state = { path = nil, name = nil, cwd = nil }
local function get_project_path()
  if vim.fn.getcwd() ~= state.cwd then
    state.path = nil
    state.name = nil
    state.cwd = vim.fn.getcwd()
  end

  local project_nvim = require("project_nvim")
  if state.path == nil then
    state.path = type(project_nvim.get_root) == "function" and project_nvim.get_root() or nil
    if state.path == nil then
      state.path = string.gsub(state.cwd, os.getenv("HOME"), "~")
    else
      state.path = string.gsub(state.path, os.getenv("HOME"), "~")
    end
    if state.path ~= nil then
      state.path, state.name = string.match(state.path, "(.*)%/(.*)")
    end
  end
end

local project_hl = function()
  if state.name == nil then
    return { fg = "white", bg = "#333333" }
  end
  return { fg = "white", bg = "#440088" }
end

local project_left_sep = function()
  local val = {
    str = "slant_left",
    fg = "white",
    bg = "#224488",
    style = "bold",
  }
  if state.path == nil then
    val.bg = "#333333"
  end
  return val
end

local project_right_sep = function()
  return { "block", { hl = { bg = "NONE", fg = "dodgerblue3" } } }
end

local project_uo = function()
  get_project_path()
  return " " .. (state.name or "") .. " "
end

return {
  name = "project_path",
  provider = project_uo,
  hl = project_hl,
  left_sep = project_left_sep,
  right_sep = project_right_sep,
  window_number = function()
    return tostring(vim.api.nvim_win_get_number(0))
  end,
}
