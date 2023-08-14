local log = { _version = '0.1.0' }

log.outfile = '/tmp/nvim-preload.log'
log.level = 'trace'

local modes = {
  { name = 'trace' },
  { name = 'debug' },
  { name = 'info' },
  { name = 'warn' },
  { name = 'error' },
  { name = 'fatal' },
}

local levels = {}
for i, v in ipairs(modes) do
  levels[v.name] = i
end

local round = function(x, increment)
  increment = increment or 1
  x = x / increment
  return (x > 0 and math.floor(x + 0.5) or math.ceil(x - 0.5)) * increment
end

local _tostring = tostring
local tostring = function(...)
  local t = {}
  for i = 1, select('#', ...) do
    local x = select(i, ...)
    if type(x) == 'number' then
      x = round(x, 0.01)
    end
    t[#t + 1] = _tostring(x)
  end
  return table.concat(t, ' ')
end

for i, x in ipairs(modes) do
  local nameupper = x.name:upper()
  log[x.name] = function(...)
    -- Return early if we're below the log level
    if i < levels[log.level] then
      return
    end

    local msg = tostring(...)
    local info = debug.getinfo(2, 'Sl')
    local lineinfo = info.short_src .. ':' .. info.currentline

    -- Output to console
    -- print(string.format('%s[%-6s%s]%s %s: %s', nameupper, os.date('%H:%M:%S'), lineinfo, msg))

    -- Output to log file
    if log.outfile then
      local fp = io.open(log.outfile, 'a')
      local str = string.format('[%-6s%s] %s: %s\n', nameupper, os.date(), lineinfo, msg)
      if fp ~= nil then
        fp:write(str)
        fp:close()
      end
    end
  end
end

-- These are deliberately left out due to side effects
-- - FuncUndefined, SourceCmd, BufReadCmd, BufWriteCmd
-- - FileAppendCmd, FileWriteCmd, FileReadCmd

local all_events = {
  'BufAdd',
  'BufDelete',
  'BufEnter',
  'BufFilePost',
  'BufFilePre',
  'BufHidden',
  'BufLeave',
  'BufModifiedSet',
  'BufNew',
  'BufNewFile',
  'BufRead ',
  'BufReadPost',
  'BufReadPre ',
  'BufUnload',
  'BufWinEnter',
  'BufWinLeave',
  'BufWipeout',
  'BufWrite',
  'BufWritePost',
  'BufWritePre',
  'ChanInfo',
  'ChanOpen',
  'CmdUndefined',
  'CmdlineChanged',
  'CmdlineEnter',
  'CmdlineLeave',
  'CmdwinEnter',
  'CmdwinLeave',
  'ColorScheme',
  'ColorSchemePre',
  'CompleteChanged',
  'CompleteDone',
  'CompleteDonePre',
  'CursorHold',
  'CursorHoldI',
  'CursorMoved',
  'CursorMovedI',
  'DiffUpdated',
  'DirChanged',
  'DirChangedPre',
  'ExitPre',
  'FileAppendPost',
  'FileAppendPre',
  'FileChangedRO',
  'FileChangedShell',
  'FileChangedShellPost',
  'FileReadPost',
  'FileReadPre',
  'FileType',
  'FileWritePost',
  'FileWritePre',
  'FilterReadPost',
  'FilterReadPre',
  'FilterWritePost',
  'FilterWritePre',
  'FocusGained',
  'FocusLost',
  'InsertChange',
  'InsertCharPre',
  'InsertEnter',
  'InsertLeave',
  'InsertLeavePre',
  'MenuPopup',
  'ModeChanged',
  'OptionSet',
  'QuickFixCmdPost',
  'QuickFixCmdPre',
  'QuitPre',
  'RecordingEnter',
  'RecordingLeave',
  'RemoteReply',
  'SearchWrapped',
  'SessionLoadPost',
  'ShellCmdPost',
  'ShellFilterPost',
  'Signal',
  'SourcePost',
  'SourcePre',
  'SpellFileMissing',
  'StdinReadPost',
  'StdinReadPre',
  'SwapExists',
  'Syntax',
  'TabClosed',
  'TabEnter',
  'TabLeave',
  'TabNew',
  'TabNewEntered',
  'TermClose',
  'TermEnter',
  'TermLeave',
  'TermOpen',
  'TermResponse',
  'TextChanged',
  'TextChangedI',
  'TextChangedP',
  'TextChangedT',
  'TextYankPost',
  'UIEnter',
  'UILeave',
  'User',
  'VimEnter',
  'VimLeave',
  'VimLeavePre',
  'VimResized',
  'VimResume',
  'VimSuspend',
  'WinClosed',
  'WinEnter',
  'WinLeave',
  'WinNew',
  'WinResized',
  'WinScrolled',
}

local start_time = vim.fn.reltime()
local stop_autocmd_log = function()
  ---@diagnostic disable-next-line: missing-parameter
  local log_time = vim.fn.reltimestr(vim.fn.reltime(start_time))
  log_time = string.sub(string.gsub(log_time, ' ', ''), 1, 5)
  log.info('Finished autocmd log in ' .. log_time .. 's', 1, { anchor = 'TC' })
end

vim.api.nvim_create_autocmd('VimEnter', {
  pattern = '*',
  callback = stop_autocmd_log,
})

log.info('Started autocmd log')
local record_event = function(au)
  -- au.id, au.event, au.match, au.group, au.buf, au.file, au.data
  -- local cfg_dir = vim.fn.stdpath('config')
  local show_data = true
  local cfg_dir = '~/.config/nvim/'
  local filename = ''
  if type(au.file) == 'string' and au.file ~= '' then
    filename = '(' .. string.gsub(au.file or '', '/home/nicholas', '~') .. ')'
    filename = string.gsub(filename, cfg_dir, '')
  end

  local buf = ' * '
  if type(au.buf) == 'number' then
    buf = tostring(au.buf)
    local pfx = #buf == 1 and '  ' or #buf == 2 and ' ' or ''
    buf = pfx .. buf
  end

  local group = au.group and '[' .. au.group .. '] ' or ''
  local out = buf .. ' ' .. au.event .. group .. ' ' .. filename
  if show_data and type(au.data) == 'table' then
    out = out .. ' => '
    for key, val in pairs(au.data) do
      out = out .. key .. '=' .. val .. ', '
    end
  end
  log.debug(out)
end
vim.api.nvim_create_autocmd(all_events, { pattern = '*', callback = record_event, desc = 'EventTracker' })
