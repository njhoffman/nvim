-- General gitops helpers: LSP format, repo lookup and text alignment.

local logger = require("modules.gitops.utils.logger")
local M = {}

M.lsp_format_async = function()
  if type(vim.lsp.buf.format) == "function" then
    vim.lsp.buf.format({ async = true })
  end
end

M.lsp_format = function()
  if type(vim.lsp.buf.format) == "function" then
    vim.lsp.buf.format()
  end
end

--- Git dir of a work tree: `.git` itself, or the `gitdir:` a worktree's or submodule's `.git`
--- file points to. Read from disk, not `git rev-parse`, since pickers call this per entry.
--- @param worktree string
--- @return string?
local function find_gitdir(worktree)
  local dotgit = worktree .. "/.git"
  local stat = vim.uv.fs_stat(dotgit)
  if not stat then
    return nil
  elseif stat.type == "directory" then
    return dotgit
  end
  local file = io.open(dotgit, "r")
  local line = file and file:read("*l") or ""
  if file then
    file:close()
  end
  local target = line:match("^gitdir:%s*(.-)%s*$")
  if not target or target == "" then
    return nil
  end
  if not vim.startswith(target, "/") then
    target = worktree .. "/" .. target
  end
  return vim.fs.normalize(target)
end

--- Repo of a buffer: gitsigns' data when it has attached, else the repo holding the buffer's file
--- (the cwd for unnamed and non-file buffers such as picker prompts). Empty table outside a repo.
--- @param bufnr? integer
--- @return { worktree?: string, gitdir?: string }
M.get_repo = function(bufnr)
  bufnr = (bufnr == nil or bufnr == 0) and vim.api.nvim_get_current_buf() or bufnr
  local ok, gitsigns = pcall(vim.api.nvim_buf_get_var, bufnr, "gitsigns_status_dict")
  if ok and type(gitsigns) == "table" and gitsigns.root then
    return { worktree = gitsigns.root, gitdir = gitsigns.gitdir }
  end
  local valid = vim.api.nvim_buf_is_valid(bufnr)
  local name = valid and vim.api.nvim_buf_get_name(bufnr) or ""
  local is_file = valid and vim.bo[bufnr].buftype == "" and name ~= ""
  local start = is_file and vim.fs.dirname(name) or vim.fn.getcwd()
  local worktree = vim.fs.root(start, ".git")
  local gitdir = worktree and find_gitdir(worktree)
  if not gitdir then
    logger.debug("get_repo: no repo for buffer " .. bufnr .. " (" .. start .. ")")
    return {}
  end
  return { worktree = worktree, gitdir = gitdir }
end

M.split_string = function(inputstr, sep)
  if sep == nil then
    sep = "%s"
  end
  local t = {}
  for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
    table.insert(t, str)
  end
  return t
end

---@param text string
---@param max_length number
---@return string
M.truncate_text = function(text, max_length)
  if vim.api.nvim_strwidth(text) > max_length then
    return string.sub(text, 1, max_length - 1) .. "…"
  end

  return text
end

---@param text string
---@param align "'left'" | "'center'" | "'right'"
---@param line_length number
---@param gap_char string
---@return string
M.align_text = function(text, align, line_length, gap_char)
  local gap_length = line_length - vim.api.nvim_strwidth(text)

  local gap_left = ""
  local gap_right = ""

  if align == "left" then
    gap_right = string.rep(gap_char, gap_length)
  elseif align == "center" then
    gap_left = string.rep(gap_char, math.ceil(gap_length / 2))
    gap_right = string.rep(gap_char, math.floor(gap_length / 2))
  elseif align == "right" then
    gap_left = string.rep(gap_char, gap_length)
  end

  return gap_left .. text .. gap_right
end

M.get_widths = function(part_lines)
  local widths = {}
  for _, line in ipairs(part_lines) do
    if vim.islist(line) then
      for n, part in ipairs(line) do
        if type(widths[n]) == "nil" then
          widths[n] = 0
        end
        if type(part) == "string" and #part > widths[n] then
          widths[n] = #part
        end
      end
    else
      for key, part in pairs(line) do
        if type(widths[key]) == "nil" then
          widths[key] = 0
        end
        if type(part) == "string" and #part > widths[key] then
          widths[key] = #part
        end
      end
    end
  end
  return widths
end

M.escape_chars = function(x)
  return (
    x:gsub("%%", "%%%%")
      :gsub("^%^", "%%^")
      :gsub("%$$", "%%$")
      :gsub("%(", "%%(")
      :gsub("%)", "%%)")
      :gsub("%.", "%%.")
      :gsub("%[", "%%[")
      :gsub("%]", "%%]")
      :gsub("%*", "%%*")
      :gsub("%+", "%%+")
      :gsub("%-", "%%-")
      :gsub("%?", "%%?")
  )
end

return M
