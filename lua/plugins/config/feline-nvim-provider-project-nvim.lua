local last_buffer, project_path, project_name = nil, "", ""

local function get_project_path()
  if vim.fn.bufnr() ~= last_buffer then
    project_path = ""
    project_name = ""
    last_buffer = nil
  end

  if project_path == "" then
    project_path = require("project_nvim.project").get_project_root() or ""
    -- vim.dbglog('prj: ' .. project_path)
    if project_path == nil or project_path == "" then
      project_path = string.gsub(vim.fn.getcwd(), os.getenv("HOME"), "~")
    else
      project_path = string.gsub(project_path, os.getenv("HOME"), "~")
    end
    if project_path ~= nil and project_path ~= "" then
      project_path, project_name = string.match(project_path, "(.*)%/(.*)")
      last_buffer = vim.fn.bufnr()
    end
  end
end

local project_hl = function()
  if project_name == nil or project_name == "" then
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
  if project_path == nil then val.bg = "#333333" end
  return val
end

local project_right_sep = function()
  return { "block", { hl = { bg = "NONE", fg = "dodgerblue3" } } }
end

local project_nvim = function()
  project_path = get_project_path()
  project_name = project_name or ""
  return " " .. project_name .. " "
end

return {
  provider = project_nvim,
  -- project = project_user_options,
  hl = project_hl,
  left_sep = project_left_sep,
  right_sep = project_right_sep,
  window_number = function()
    return tostring(vim.api.nvim_win_get_number(0))
  end
}
