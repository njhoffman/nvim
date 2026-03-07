local manager = require("session_manager")
local utils = require("session_manager.utils")
local state = require("project_nvim.state")
local history = require("project_nvim.utils.history")
local path = require("project_nvim.utils.path")

local delete_session = function(dir)
  if utils.is_session and dir == path.cwd() then
    utils.is_session = false
  end
  local sessions = utils.get_sessions()
  for idx, session in ipairs(sessions) do
    if path.short_path(session.dir.filename) == dir then
      local Path = require("plenary.path")
      return Path:new(sessions[idx].filename):rm()
    end
  end
end

local in_session = function()
  return utils.is_session
end

local start_session_here = function()
  -- load session or create new one if not exists
  local cwd = path.cwd()
  if not cwd then
    return
  end
  local fullpath = vim.fn.expand(cwd)
  local session = require("session_manager.config").dir_to_session_filename(fullpath)
  if session:exists() then
    manager.load_current_dir_session(false)
  else
    vim.cmd("silent! %bd") -- close all buffers from previous session
    -- create empty session
    manager.save_current_session()
  end
  -- add to history
  if path.dir_pretty ~= nil then
    history.add_session_project(path.dir_pretty)
  else
    history.add_session_project(cwd)
  end
end

local load_session = function(dir)
  if not dir then
    return
  end
  if path.cwd() ~= dir then
    path.dir_pretty = path.short_path(dir)
    vim.api.nvim_set_current_dir(dir)
  end

  start_session_here()
end

local switch_after_save_session = function(dir)
  -- Switch project after saving current session
  --
  -- save current session
  -- before switch project
  state.save_project_waiting = true
  manager.save_current_session()
  -- wait for SessionSavePost autocmd or timeout 2 sec
  vim.wait(2000, function()
    return true
  end, 1)
  load_session(dir)
end

local _start_session_here = nil -- open or create session in current dir

local switch_project = function(dir)
  if in_session() then
    switch_after_save_session(dir)
  else
    load_session(dir)
  end
end

local setup = function()
  local session_manager_config = require("session_manager.config")
  local options = require("project_nvim.config").get()
  local AutoLoadMode = session_manager_config.AutoloadMode
  -- Disable session autoload by default
  options.session_manager_opts.autoload_mode = AutoLoadMode.Disabled

  -- Don't load a session if nvim started with args, open just given files
  if vim.fn.argc() == 0 then
    if path.dir_matches_project() then
      -- nvim started in the project dir, open current dir session
      if options.last_session_project_on_startup then
        _start_session_here = true
      else
        vim.defer_fn(function()
          vim.notify("project.nvim: session autoload is disabled", vim.log.levels.TRACE)
        end, 200)
      end
    else
      -- open the last session if not disabled in config
      if options.last_session_other_on_startup then
        options.session_manager_opts.autoload_mode = AutoLoadMode.LastSession
      end
    end
  end

  local open_path = path.resolve("%:p")
  if open_path ~= nil and path.dir_matches_project(open_path) then
    vim.api.nvim_set_current_dir(open_path)
    _start_session_here = true
  end

  options.session_manager_opts.sessions_dir = path.sessionspath

  -- Session Manager setup
  require("session_manager").setup(options.session_manager_opts)

  -- Register Telescope extension
  -- require("telescope").load_extension("neovim-project")

  -- unset session_manager_opts
  ---@diagnostic disable-next-line: inject-field
  -- options.session_manager_opts = nil

  if _start_session_here then
    start_session_here()
  end

  -- unregister SessionManager command
end

return {
  setup = setup,
  in_session = in_session,
  switch_project = switch_project,
  delete_session = delete_session,
}
