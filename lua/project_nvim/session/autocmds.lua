local utils = require('session_manager.utils')
local history = require('project_nvim.utils.history')
local path = require('project_nvim.utils.path')
local payload = require('project_nvim.payload')
local actions = require('project_nvim.session.actions')

local create_user_commands = function()
  -- Create user commands
  -- Open the previous session
  vim.api.nvim_create_user_command('ProjectLoadRecent', function(args)
    local cnt = args.count
    if cnt < 1 then
      -- cnt is an offset from the last session in history
      if actions.in_session() then
        cnt = 1 -- skip current session
      else
        cnt = 0
      end
    end
    local recent = history.get_recent_projects()
    local index = #recent - cnt
    if index < 1 then
      index = 1
    end
    if #recent > 0 then
      actions.switch_project(recent[index])
    else
      vim.notify('No recent projects')
    end
  end, { nargs = 0, count = true })
end

local setup = function()
  create_user_commands()
  local augroup = vim.api.nvim_create_augroup('project_session', { clear = true })

  -- setup events for neo-tree when it's loaded
  vim.api.nvim_create_autocmd({ 'FileType' }, {
    pattern = 'neo-tree',
    group = augroup,
    once = true,
    callback = require('project_nvim.utils.neo-tree').setup_events_for_neotree,
  })
  -- save history to file when exit nvim
  vim.api.nvim_create_autocmd({ 'VimLeavePre' }, {
    pattern = '*',
    group = augroup,
    callback = function()
      history.write_projects_to_history()
    end,
  })
  -- add project to history when open nvim in project's directory
  vim.api.nvim_create_autocmd({ 'User' }, {
    pattern = 'SessionLoadPost',
    group = augroup,
    once = true,
    callback = function()
      if path.dir_pretty ~= nil then
        history.add_session_project(path.dir_pretty)
      end
    end,
  })
  -- switch project after save previous session
  vim.api.nvim_create_autocmd({ 'User' }, {
    pattern = 'SessionSavePost',
    group = augroup,
    callback = function()
      M.save_project_waiting = true
    end,
  })
  -- add more state data to the session file via global variable
  vim.api.nvim_create_autocmd({ 'User' }, {
    pattern = 'SessionSavePre',
    group = augroup,
    callback = function()
      payload.pre_save()
    end,
  })
  -- 1. Trigger FileType autocmd to attach lsp server to the active buffer
  -- 2. Restore saved state data from the global var in the session file
  vim.api.nvim_create_autocmd({ 'User' }, {
    pattern = 'SessionLoadPost',
    group = augroup,
    callback = function()
      vim.defer_fn(function()
        vim.api.nvim_command('silent! doautocmd FileType')
      end, 200)
      payload.load_post()
      if path.dir_pretty == nil then
        path.dir_pretty = path.cwd()
      end
    end,
  })
  -- Exit from session when directory changed from outside
  vim.api.nvim_create_autocmd({ 'DirChangedPre' }, {
    pattern = 'global',
    group = augroup,
    callback = function(event)
      if path.dir_pretty == nil then
        return
      end
      if path.dir_pretty ~= path.short_path(event.file) then
        -- directory changed from outside
        history.write_projects_to_history()
        local dir = path.dir_pretty
        -- TODO: handle pre-initialization message
        vim.defer_fn(function()
          vim.notify('cwd exit from session: ' .. dir, vim.log.levels.DEBUG)
        end, 100)
        path.dir_pretty = nil
        utils.is_session = false
        -- touch session file to update mtime and auto load it on next start
        local sessions = utils.get_sessions()
        for idx, session in ipairs(sessions) do
          if path.short_path(session.dir.filename) == dir then
            local Path = require('plenary.path')
            return Path:new(sessions[idx].filename):touch()
          end
        end
      end
    end,
  })
end

return { setup = setup }
