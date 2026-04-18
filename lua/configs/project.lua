local display = require("project_nvim.display")
local Path = require("plenary.path")

local notify_id = nil
local change_project = function(dir, method)
  local notify = require("notify")
  local lsp = string.match(method or "", 'lsp "([^%s]+)"')
  dir = dir:gsub(vim.fn.getenv("HOME"), "~")
  local icon, highlight = display.get_icon(method, lsp)
  -- local title = icon
  local msg = " " .. icon .. " " .. dir
  -- local msg = dir
  -- notify.dismiss({})
  -- title = title,
  local notif_opts = {
    render = "minimal",
    merge = false,
    on_close = function()
      notify_id = nil
    end,
  }
  if notify_id and vim.fn.bufexists(notify_id) then
    notif_opts.replace = notify_id
  end
  notify_id = vim.notify(msg, 2, notif_opts)
end

local project_config = {
  manual_mode = false,
  detection_methods = { "lsp", "pattern" },
  patterns = {
    {
      ".project",
      "courseleaf.cfg",
    },
    ".git",
    "_darcs",
    ".hg",
    ".bzr",
    ".svn",
    "Makefile",
    "package.json",
  },
  ignore_lsp = { "null-ls", "copilot" },
  exclude_dirs = {},
  show_hidden = true,
  silent_chdir = false,
  chdir_func = change_project,
  paths = {
    history = vim.fn.stdpath("data") .. "/project_history",
    sessions = vim.fn.stdpath("data") .. "/sessions/saved",
  },
  last_session_project_on_startup = false,
  last_session_other_on_startup = false,
  session_manager_opts = {
    -- session_filename_to_dir = session_filename_to_dir, -- Function that replaces symbols into separators and colons to transform filename into a session directory.
    -- dir_to_session_filename = dir_to_session_filename, -- Function that replaces separators and colons into special symbols to transform session directory into a filename. Should use `vim.uv.cwd()` if the passed `dir` is `nil`.
    -- autoload_mode = config.AutoloadMode.LastSession, -- Define what to do when Neovim is started without arguments. See "Autoload mode" section below.
    --   Disabled	No session will be loaded.
    --   CurrentDir	The session in the current working directory will be loaded.
    --   LastSession	The last session will be loaded. This is the default.
    --   GitSession	If in a git repo the session for repository root will be loaded
    --   autoload_mode can be set to either a single mode or an array of modes, in which case each mode will be tried until one succeeds e.g.
    --   autoload_mode = { config.AutoloadMode.CurrentDir, config.AutoloadMode.LastSession }
    -- autosave_ignore_not_normal = true, -- Plugin will not save a session when no buffers are opened, or all of them aren't writable or listed.
    -- autosave_ignore_buftypes = {}, -- All buffers of these bufer types will be closed before the session is saved.
    -- autosave_only_in_session = false, -- Always autosaves session. If true, only autosaves after a session is active.
    -- max_path_length = 80,  -- Shorten the display path if length exceeds this threshold. Use 0 if don't want to shorten the path at all.
    -- load_include_current = false,  -- The currently loaded session appears in the load_session UI.
    autosave_last_session = true, -- Automatically save last session on exit and on session switch.
    -- sessions_dir = Path:new(vim.fn.stdpath("data"), "sessions", "saved").filename, -- The directory where the session files will be saved.
  },
  -- Project directories
  projects = {
    "~/git/*",
    "~/.zinit/plugins/*",
  },
}

require("project_nvim").setup(project_config)

local cmd = vim.api.nvim_create_user_command
local get_root = function()
  local path, method = require("project_nvim.project").get_project_root()
  local line = path or ""
  if method then
    line = path .. "  [" .. method .. "]"
  end
  vim.notify(line, 2, { title = method, anchor = "TC" })
end

cmd("ProjectGetRoot", get_root, {
  nargs = 0,
  desc = "Get project root path and method",
})

cmd("ProjectDbg", function()
  vim.dbg(require("project_nvim.state"))
end, { desc = "Dump debugging data" })
