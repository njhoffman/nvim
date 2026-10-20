#!/usr/bin/env lua

local M = {}
local bufOpt = function(bufnr, name)
  return vim.api.nvim_get_option_value(name, { buf = bufnr })
end

local timerDelay = 10
local state = {
  buffers = {},
  timer = nil,
  counter = 0,
}
--------------------------------------------------------------------------------
local logger = require('logger').init('early-retirement')

local function updateActiveBuffers(config)
  local currBufferIds = vim.tbl_map(function(buf)
    return buf.bufnr
  end, vim.fn.getbufinfo({ buflisted = 1 }) or {})

  local newBuffers = {}
  vim.tbl_map(
    function(bufId)
      newBuffers[bufId] = config.retirementAgeMins * 60000
    end,
    vim.tbl_filter(function(currBuffId)
      return state.buffers[currBuffId] == nil
    end, currBufferIds)
  )
  local existingBuffers = {}
  vim.tbl_map(
    function(bufId)
      existingBuffers[bufId] = state.buffers[bufId] - timerDelay * 1000
    end,
    vim.tbl_filter(function(currBuffId)
      return state.buffers[currBuffId] ~= nil
    end, currBufferIds)
  )
  state.buffers = vim.tbl_deep_extend('force', existingBuffers, newBuffers)
end
local function deleteBufferWhenFileDeleted()
  vim.api.nvim_create_autocmd({ 'BufEnter', 'FocusGained' }, {
    callback = function(ctx)
      local bufnr = ctx.buf

      -- deferred to not interfere with new buffers
      vim.defer_fn(function()
        -- buffer has been deleted in the meantime
        if not vim.api.nvim_buf_is_valid(bufnr) then
          return
        end

        local bufname = vim.api.nvim_buf_get_name(bufnr)
        local isSpecialBuffer = bufOpt(bufnr, 'buftype') ~= ''
        local fileExists = vim.uv.fs_stat(bufname) ~= nil
        local isNewBuffer = bufname == ''
        if fileExists or isSpecialBuffer or isNewBuffer then
          return
        end

        vim.notify(
          ('%s does not exist anymore.'):format(vim.fs.basename(bufname)),
          vim.log.levels.INFO,
          { title = 'Closing Buffer' }
        )
        vim.api.nvim_buf_delete(bufnr, { force = false, unload = false })
      end, 100)
    end,
  })
end

---@param c opts effective config
local function checkOutdatedBuffer(c)
  local openBuffers = vim.fn.getbufinfo({ buflisted = 1 }) -- https://neovim.io/doc/user/builtin.html#getbufinfo
  if #openBuffers <= c.minimumBufferNum then
    return
  end

  for _, buf in pairs(openBuffers) do
    -- check all the conditions
    local underBufferLimit = #openBuffers <= c.minimumBufferNum
    local usedSecsAgo = os.time() - buf.lastused -- always 0 for current buffer, therefore it's never closed
    local recentlyUsed = usedSecsAgo < c.retirementAgeMins * 60
    local bufFt = bufOpt(buf.bufnr, 'filetype')
    local isIgnoredFt = vim.tbl_contains(c.ignoredFiletypes, bufFt)
    local isIgnoredSpecialBuffer = bufOpt(buf.bufnr, 'buftype') ~= '' and c.ignoreSpecialBuftypes
    local isIgnoredAltFile = (buf.name == vim.fn.expand('#:p')) and c.ignoreAltFile
    local isModified = bufOpt(buf.bufnr, 'modified')
    local isIgnoredUnsavedBuf = isModified and c.ignoreUnsavedChangesBufs
    local isIgnoredVisibleBuf = buf.hidden == 0 and buf.loaded == 1 and c.ignoreVisibleBufs
    local isIgnoredUnloadedBuf = buf.loaded == 0 and c.ignoreUnloadedBufs
    local isIgnoredFilename = c.ignoreFilenamePattern ~= '' and buf.name:find(c.ignoreFilenamePattern)

    if
      not underBufferLimit
      and not recentlyUsed
      and not isIgnoredFt
      and not isIgnoredSpecialBuffer
      and not isIgnoredAltFile
      and not isIgnoredUnsavedBuf
      and not isIgnoredVisibleBuf
      and not isIgnoredUnloadedBuf
      and not isIgnoredFilename
    then
      if c.notificationOnAutoClose then
        local filename = vim.fs.basename(buf.name)
        -- vim.notify(filename, vim.log.levels.INFO, { title = 'Auto-Closing Buffer' })
      end

      -- if isModified then
      --   vim.cmd.write()
      -- end
      -- vim.api.nvim_buf_delete(buf.bufnr, { force = false, unload = false })
    end
  end
end

-- schedule_wrap required for timers
local function pauseTimer(config)
  logger:trace('pausing timer')
  state.timer:stop()
end

-- schedule_wrap required for timers
local function startTimer(config)
  state.timer:start(
    0,
    10000,
    vim.schedule_wrap(function()
      state.counter = state.counter + 1
      updateActiveBuffers(config)
      checkOutdatedBuffer(config)
    end)
  )
end

local setupAutocmds = function(config)
  vim.api.nvim_create_augroup('earlyRetirement', { clear = true })
  vim.api.nvim_create_autocmd({ 'FocusLost' }, {
    group = 'earlyRetirement',
    callback = function()
      pauseTimer(config)
    end,
  })
  vim.api.nvim_create_autocmd({ 'FocusGained' }, {
    group = 'earlyRetirement',
    callback = function()
      startTimer(config)
    end,
  })
end

--------------------------------------------------------------------------------

---@class opts
---@field retirementAgeMins number minutes after which an inactive buffer is closed
---@field ignoredFiletypes string[] list of filetypes to never close
---@field notificationOnAutoClose boolean list of filetypes to never close
---@field ignoreAltFile boolean whether the alternate file is also going to be ignored
---@field ignoreUnsavedChangesBufs boolean when false, will automatically write and then close buffers with unsaved changes
---@field ignoreSpecialBuftypes boolean ignore non-empty buftypes, e.g. terminal buffers
---@field ignoreVisibleBufs boolean ignore visible buffers (buffers open in a window, "a" in `:buffers`)
---@field ignoreUnloadedBufs boolean session plugins often add buffers without unloading them
---@field minimumBufferNum number minimum number of open buffers for auto-closing to become active
---@field ignoreFilenamePattern string ignore files matches this lua pattern (string.find)
---@field deleteBufferWhenFileDeleted boolean

---@param userConfig opts
function M.setup(userConfig)
  local defaultConfig = {
    retirementAgeMins = 20,
    ignoredFiletypes = { 'lazy' },
    notificationOnAutoClose = false,
    ignoreAltFile = true,
    minimumBufferNum = 1,
    ignoreUnsavedChangesBufs = true,
    ignoreSpecialBuftypes = true,
    ignoreVisibleBufs = true,
    ignoreUnloadedBufs = false,
    ignoreFilenamePattern = '',
    deleteBufferWhenFileDeleted = false,
  }
  local config = vim.tbl_deep_extend('keep', userConfig, defaultConfig)

  state.timer = vim.uv.new_timer()
  startTimer(config)
  setupAutocmds(config)
  if config.deleteBufferWhenFileDeleted then
    deleteBufferWhenFileDeleted()
  end
end

--------------------------------------------------------------------------------
return M
