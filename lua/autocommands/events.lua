-- 'BufReadCmd',
-- 'BufWriteCmd',
-- 'SourceCmd',

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
  'FileAppendCmd',
  'FileAppendPost',
  'FileAppendPre',
  'FileChangedRO',
  'FileChangedShell',
  'FileChangedShellPost',
  'FileReadCmd',
  'FileReadPost',
  'FileReadPre',
  'FileType',
  'FileWriteCmd',
  'FileWritePost',
  'FileWritePre',
  'FilterReadPost',
  'FilterReadPre',
  'FilterWritePost',
  'FilterWritePre',
  'FocusGained',
  'FocusLost',
  'FuncUndefined',
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

local debuglog = require('debuglog').log

local get_events = function(ignored)
  ignored = ignored or {}
  local active_events = {}
  for _, ev in ipairs(all_events) do
    local keep = true
    for _, ignore_ev in ipairs(ignored) do
      if ignore_ev == ev then
        keep = false
      end
    end
    if keep == true then
      table.insert(active_events, ev)
    end
  end
  debuglog('monitoring ' .. #active_events .. ' / ' .. #all_events .. ' events')
  return active_events
end

local queue = {}
local output_events = function()
  local event_n = 0
  local last_event = ''
  local combined = {}
  for _, ev in ipairs(queue) do
    if ev == last_event or last_event == '' then
      event_n = event_n + 1
      last_event = ev
    else
      last_event = event_n > 1 and last_event .. ' x' .. event_n or last_event
      table.insert(combined, last_event)
      event_n = 1
      last_event = ev
    end
  end

  if event_n > 0 then
    last_event = event_n > 1 and last_event .. ' x' .. event_n or last_event
    table.insert(combined, last_event)
  end

  for _, ev_out in ipairs(combined) do
    debuglog(ev_out)
  end
  queue = {}
end

local record_event = function(show_data)
  return function(au)
    -- au.id, au.event, au.match, au.group, au.buf, au.file, au.data
    -- local cfg_dir = vim.fn.stdpath('config')
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
    table.insert(queue, out)
  end
end

return {
  get_events = get_events,
  record_event = record_event,
  output_events = output_events,
}
