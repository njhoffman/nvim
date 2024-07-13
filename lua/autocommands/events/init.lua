local events = require('autocommands.events.groups')

local processed = { events = {}, records = {} }
local process_events = function(...)
  for k, v in pairs({ ... }) do
    processed.events[k] = v
  end
end

local process_records = function(event, fields)
  processed.records[event] = processed.records[event] or {}
  table.insert(processed.records[event], fields)
end

local is_processed = function(event, fields)
  if processed.events[event] then
    return true
  end

  local match
  local records = processed.records[event] or {}
  for _, i in ipairs(records) do
    local record = records[i]
    for f_key, f_val in pairs(record) do
      match = (match == nil or match) and fields[f_key] == f_val
    end
    if match then
      goto continue
    end
    match = nil
  end
  ::continue::
  return match
end

-- BufNewFile			starting to edit a non-existent file
-- BufReadPre	BufReadPost	starting to edit an existing file
-- FilterReadPre	FilterReadPost	read the temp file with filter output
-- FileReadPre	FileReadPost	any other file read

-- WinClosed 1002 5 BufWinLeave  5 BufHidden  5 BufUnload  5 BufWipeout  5
-- SourcePre -> SourcePost
-- BufNew -> BufAdd
-- BufNew -> BufAdd -> BufReadPre -> BufReadPost -> BufEnter -> BufWinEnter
-- CursorHold -> QuitPre -> ExitPre -> BufWinLeave -> BufUnload -> VimLeavePre -> VimLeave -> UILeave
-- User SessionSavePre -> User SessionSavePost
-- WinResized -> WinScrolled
-- InsertCharPre -> CursorMovedI -> TextChangedI
-- HIGHLIGHT: Syntax, Filetype, Vimenter, UIEnter

-- stylua: ignore
local seqs   = {
  -- CursorMoved, WinScrolled
  BufRead     = { { 'BufReadPre', 'BufReadPost' } },
  DirChange   = { { 'DirChangedPre', 'DirChanged' } },
  FileRead    = { { 'FileReadPre', 'FileReadPost' } },
  FilterRead  = { { 'FilterReadPre', 'FilterReadPost' } },
  -- SessionSave = { { 'User:SessionSavePre', 'User:SessionSavePost' } },
  Source      = { { 'SourcePre', 'SourcePost' }, { match = true } },
  WinResize   = { { 'WinResized', 'WinScrolled' }, { match = true } },
  -- WinWipeout  = { { 'WinClosed', 'BufWinLeave', 'BufHidden', 'BufUnload', 'BufWipeout' } }
}
local def_seq = { event = true, buf = true, match = false }
for _, seqkey in ipairs(seqs) do
  seqs[seqkey] = vim.tbl_deep_extend('force', def_seq, seqs[seqkey][2])
end

local user_events = {}

vim.api.nvim_create_user_command('EventsUser', function()
  -- local logger = require('logger').init('events')
  vim.notify(vim.inspect(user_events), vim.lsp.log_levels.INFO)
end, { desc = 'Prints all user events' })

local augroup = vim.api.nvim_create_augroup('LoggerEvents', { clear = true })

local init_event = function(scope, event_group)
  local logger = require('logger').init(scope)
  local target_events = event_group[1] or {}
  local event_levels = event_group[2] or {}
  local filtered_events = vim.tbl_filter(function(event)
    return not vim.list_contains(processed.events, event)
  end, target_events)

  process_events(unpack(filtered_events))

  vim.api.nvim_create_autocmd(filtered_events, {
    group = augroup,
    callback = function(data)
      local lvl = event_levels[data.event] or 3
      if data.event == 'User' then
        user_events[data.match] = (user_events[data.match] or 0) + 1
        lvl = event_levels[data.match] or lvl
      elseif data.event == 'OptionSet' then
        local opt = {
          cmd = vim.v.option_command,
          type = vim.v.option_type,
          old = tostring(vim.v.option_old),
          new = tostring(vim.v.option_new),
        }
        opt.old = type(vim.v.option_old) == 'string' and ('"' .. opt.old .. '"') or opt.old
        opt.new = type(vim.v.option_new) == 'string' and ('"' .. opt.new .. '"') or opt.new
        --     ﯀ ﰲ 
        data.data = opt.cmd .. ' ' .. opt.old .. '  ' .. opt.new .. ''
      end

      local buf = type(data.buf) == 'number' and ' [' .. tostring(data.buf) .. ']' or ''

      local match = tostring(data.match) ~= '' and (' ' .. data.match) or ''
      if match:match(vim.fn.getenv('HOME')) then
        match = match:gsub(tostring(vim.fn.stdpath('config')), '<config>')
        match = match:gsub(tostring(vim.fn.stdpath('data')), '<data>')
        match = match:gsub(vim.fn.getenv('HOME'), '<home>')
      elseif tonumber(data.match) ~= nil then
        match = ' ' .. tonumber(data.match)
      else
        match = type(data.match) == 'string'
            and tostring(data.match) ~= ''
            and (' "' .. data.match .. '"')
          or match
      end

      local _data = data.data
          and tostring(data.data) ~= ''
          and ' ' .. (type(data.data) == 'table' and vim.inspect(data.data, { newline = '' }) or data.data)
        or ''

      if #vim.tbl_keys(data) > 7 or logger == nil then
        vim.dbglog('***\n\n***', lvl, scope, data)
      elseif #vim.tbl_keys(data) == 7 then
        logger:log(lvl, data.event .. match .. _data .. buf)
      else
        logger:log(lvl, data.event .. match .. buf)
      end
    end,
  })
end

-- init_event('events-buf', events.buf)
-- init_event('events-cmd', events.cmd)
-- init_event('events-file', events.file)
-- init_event('events-mode', events.mode)
-- init_event('events-startup', events.startup)
-- init_event('events-user', events.user)
-- vim.dbglog('active', processed.events, processed.records)
-- init_event('events-win', events.win)
-- init_event('events', events.all)
