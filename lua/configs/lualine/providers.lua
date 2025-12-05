-- Custom providers for lualine
-- Migrated and rewritten from feline configuration

local M = {}

-- ============================================================================
-- PROJECT PROVIDER
-- ============================================================================
local project_state = { path = nil, name = nil, cwd = nil }

local function get_project_path()
  if vim.fn.getcwd() ~= project_state.cwd then
    project_state.path = nil
    project_state.name = nil
    project_state.cwd = vim.fn.getcwd()
  end

  local ok, project_nvim = pcall(require, "project_nvim")
  if project_state.path == nil then
    if ok and type(project_nvim.get_root) == "function" then
      project_state.path = project_nvim.get_root()
    end
    if project_state.path == nil then
      project_state.path = string.gsub(project_state.cwd, os.getenv("HOME") or "", "~")
    else
      project_state.path = string.gsub(project_state.path, os.getenv("HOME") or "", "~")
    end
    if project_state.path ~= nil then
      project_state.path, project_state.name = string.match(project_state.path, "(.*)%/(.*)")
    end
  end
end

M.project = function()
  get_project_path()
  return (project_state.name or "")
end

M.project_color = function()
  get_project_path()
  if project_state.name == nil then
    return { fg = "#8899bb", bg = "#223355" }
  end
  return { fg = "#ffffff", bg = "#3311bb" }
end

-- ============================================================================
-- ASCII PROVIDER - Shows hex code of character under cursor
-- ============================================================================
M.ascii = function()
  local line = vim.fn.getline(".")
  local col = vim.fn.col(".")
  if col > #line then
    return ""
  end
  local char = vim.fn.strcharpart(line, col - 1, 1)
  if char == "" or char == " " then
    return ""
  end
  local char_code = vim.fn.char2nr(char)
  return string.format("0x%X", char_code)
end

-- ============================================================================
-- LINE COUNT PROVIDER - Shows total lines or visual selection stats
-- ============================================================================
local line_count_state = "default"

local function is_visual()
  local mode = vim.fn.mode()
  local visual_modes = {
    ["v"] = true,
    ["vs"] = true,
    ["V"] = true,
    ["Vs"] = true,
    ["\22"] = true, -- CTRL-V
    ["\22s"] = true,
  }
  return visual_modes[mode]
end

local function get_char_count()
  local wc = vim.fn.wordcount()
  return tostring(wc.visual_chars or 0)
end

local function get_visual_line_count()
  local ln_beg = vim.fn.line("v")
  local ln_end = vim.fn.line(".")
  local lines = ln_beg <= ln_end and ln_end - ln_beg + 1 or ln_beg - ln_end + 1
  return tostring(lines)
end

M.line_count = function()
  if is_visual() then
    line_count_state = "visual"
    return get_visual_line_count() .. " " .. get_char_count() .. "ﮜ"
  else
    line_count_state = "default"
    return tostring(vim.fn.line("$"))
  end
end

M.line_count_get_hl = function()
  if line_count_state == "visual" then
    return { fg = "#7187f2" }
  else
    return { fg = "#1177a2" }
  end
end

-- ============================================================================
-- GIT PROVIDERS
-- ============================================================================
local function get_buf_var(name)
  local ok, val = pcall(vim.api.nvim_buf_get_var, 0, name)
  if ok then
    return val
  end
  return nil
end

M.git_branch = function()
  local branch = get_buf_var("gitsigns_head")
  if branch and branch ~= "" then
    return branch
  end
  return ""
end

local function git_diff(type)
  local gsd = get_buf_var("gitsigns_status_dict")
  if gsd and gsd[type] and gsd[type] > 0 then
    return tostring(gsd[type])
  end
  return ""
end

M.git_diff_added = function()
  local count = git_diff("added")
  if count ~= "" then
    return " " .. count
  end
  return ""
end

M.git_diff_removed = function()
  local count = git_diff("removed")
  if count ~= "" then
    return " " .. count
  end
  return ""
end

M.git_diff_changed = function()
  local count = git_diff("changed")
  if count ~= "" then
    return " " .. count
  end
  return ""
end

-- ============================================================================
-- MISC STATS PROVIDER - Shows notification counts
-- ============================================================================
M.misc_stats = function()
  local ok_notify, notify = pcall(require, "notify")
  local ok_noice, noice = pcall(require, "noice.message.manager")

  local notif = {
    pending = 0,
    history = 0,
    noice = 0,
  }

  if ok_notify and notify then
    notif.pending = notify.pending() or 0
    local hist = notify.history({ include_hidden = true })
    notif.history = hist and #hist or 0
  end

  if ok_noice and noice and noice._history then
    notif.noice = #noice._history
  end

  local animate = vim.b.minianimate_disable == true and " " or ""

  return animate
    .. " "
    .. notif.history
    .. ":"
    .. notif.noice
    .. " "
    .. (notif.pending > 0 and "x" .. notif.pending or "")
end

-- ============================================================================
-- NOICE MODE PROVIDER
-- ============================================================================
M.noice_mode = function()
  local ok, noice = pcall(require, "noice")
  if ok and noice.api.status.mode.has() then
    return tostring(noice.api.status.mode.get())
  end
  return ""
end

return M
