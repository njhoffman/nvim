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

vim.api.nvim_create_autocmd(
  all_events,
  { pattern = '*', callback = record_event, desc = 'EventTracker' }
)
