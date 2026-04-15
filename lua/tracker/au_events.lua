local all_events = {
  "BufAdd",
  "BufDelete",
  "BufEnter",
  "BufFilePost",
  "BufFilePre",
  "BufHidden",
  "BufLeave",
  "BufModifiedSet",
  "BufNew",
  "BufNewFile",
  "BufRead ",
  "BufReadPost",
  "BufReadPre ",
  "BufUnload",
  "BufWinEnter",
  "BufWinLeave",
  "BufWipeout",
  "BufWrite",
  "BufWritePost",
  "BufWritePre",
  "ChanInfo",
  "ChanOpen",
  "CmdUndefined",
  "CmdlineChanged",
  "CmdlineEnter",
  "CmdlineLeave",
  "CmdwinEnter",
  "CmdwinLeave",
  "ColorScheme",
  "ColorSchemePre",
  "CompleteChanged",
  "CompleteDone",
  "CompleteDonePre",
  "CursorHold",
  "CursorHoldI",
  "CursorMoved",
  "CursorMovedI",
  "DiffUpdated",
  "DirChanged",
  "DirChangedPre",
  "ExitPre",
  "FileAppendCmd",
  "FileAppendPost",
  "FileAppendPre",
  "FileChangedRO",
  "FileChangedShell",
  "FileChangedShellPost",
  "FileReadCmd",
  "FileReadPost",
  "FileReadPre",
  "FileType",
  "FileWriteCmd",
  "FileWritePost",
  "FileWritePre",
  "FilterReadPost",
  "FilterReadPre",
  "FilterWritePost",
  "FilterWritePre",
  "FocusGained",
  "FocusLost",
  "FuncUndefined",
  "InsertChange",
  "InsertCharPre",
  "InsertEnter",
  "InsertLeave",
  "InsertLeavePre",
  "MenuPopup",
  "ModeChanged",
  "OptionSet",
  "QuickFixCmdPost",
  "QuickFixCmdPre",
  "QuitPre",
  "RecordingEnter",
  "RecordingLeave",
  "RemoteReply",
  "SearchWrapped",
  "SessionLoadPost",
  "ShellCmdPost",
  "ShellFilterPost",
  "Signal",
  "SourcePost",
  "SourcePre",
  "SpellFileMissing",
  "StdinReadPost",
  "StdinReadPre",
  "SwapExists",
  "Syntax",
  "TabClosed",
  "TabEnter",
  "TabLeave",
  "TabNew",
  "TabNewEntered",
  "TermClose",
  "TermEnter",
  "TermLeave",
  "TermOpen",
  "TermResponse",
  "TextChanged",
  "TextChangedI",
  "TextChangedP",
  "TextChangedT",
  "TextYankPost",
  "UIEnter",
  "UILeave",
  "User",
  "VimEnter",
  "VimLeave",
  "VimLeavePre",
  "VimResized",
  "VimResume",
  "VimSuspend",
  "WinClosed",
  "WinEnter",
  "WinLeave",
  "WinNew",
  "WinResized",
  "WinScrolled",
}

local debuglog = require("logger.debug").log

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
  debuglog("monitoring " .. #active_events .. " /" .. #all_events .. " events")
  return active_events
end

local queue = {}
local record_event = function(show_data)
  return function(au)
    -- au.id, au.event, au.match, au.group, au.buf, au.file, au.data
    -- local cfg_dir = vim.fn.stdpath('config')
    local cfg_dir = "~/.config/nvim/"
    local filename = ""
    if type(au.file) == "string" and au.file ~= "" then
      filename = "(" .. string.gsub(au.file or "", "/home/nicholas", "~") .. ")"
      filename = string.gsub(filename, cfg_dir, "")
    end

    local buf = " * "
    if type(au.buf) == "number" then
      buf = tostring(au.buf)
      local pfx = #buf == 1 and "  " or #buf == 2 and " " or ""
      buf = pfx .. buf
    end

    local group = au.group and "[" .. au.group .. "] " or ""
    local out = buf .. " " .. au.event .. group .. " " .. filename
    if show_data and type(au.data) == "table" then
      out = out .. " => "
      for key, val in pairs(au.data) do
        out = out .. key .. "=" .. val .. ", "
      end
    end
    table.insert(queue, out)
  end
end

local callbacks = {}
local output_event_cbs = function()
  for _, cb in ipairs(callbacks) do
    cb[1](queue, cb[2])
  end
  queue = {}
end

local init_events = function(opts, cb)
  local state = require("tracker.state")
  local events = require("tracker.au_events")
  local ignored = opts.ignored_events
    or {
      "FocusLost",
      "FocusGained",
      "WinResized",
      "WinScrolled",
    }

  table.insert(callbacks, { cb, opts })
  if state.events_initialized then
    return
  end

  local events_list = opts.events or { "User" }
  events_list = #events_list == 0 and events.get_events(ignored) or events_list

  local timer = vim.fn.timer_start(1000, output_event_cbs, { ["repeat"] = -1 })
  if type(state.timers["events"]) == "nil" then
    state.timers["events"] = {}
  end
  table.insert(state.timers["events"], timer)

  vim.api.nvim_create_autocmd(events_list, {
    pattern = "*",
    callback = record_event(opts.show_data),
    desc = "tracking aucmds with" .. #events_list .. "events",
  })
  state.initialized[opts.name] = true
end

local start_timer = function(opts)
  local state = require("tracker.state")
  local timer = vim.fn.timer_start(1000, output_event_cbs, { ["repeat"] = -1 })
  if type(state.timers[opts.name]) == "nil" then
    state.timers[opts.name] = {}
  end
  table.insert(state.timers["events"], timer)
end

return {
  name = "events",
  start_timer = start_timer,
  init_events = init_events,
  get_events = get_events,
}
