-- default values

---@diagnostic disable-next-line: unused-local
local default = {
  -- if a buffer has been inactive for this many minutes, close it
  retirementAgeMins = 20,

  -- filetypes to ignore
  ignoredFiletypes = {},

  -- will not close the alternate file
  ignoreAltFile = true,

  -- minimum number of open buffers for auto-closing to become active, e.g.,
  -- by setting this to 4, no auto-closing will take place when you have 3
  -- or less open buffers. Note that this plugin never closes the currently
  -- active buffer, so a number < 2 will effectively disable this setting.
  minimumBufferNum = 1,

  -- will ignore buffers with unsaved changes. If false, the buffers will
  -- automatically be written and then closed.
  ignoreUnsavedChangesBufs = true,

  -- ignore non-empty buftypes, e.g. terminal buffers
  ignoreSpecialBuftypes = true,

  -- ignore visible buffers (buffers open in a window, "a" in `:buffers`)
  ignoreVisibleBufs = true,

  -- ignore unloaded buffers. session-management plugin often add buffers
  -- to the buffer list without loading them
  ignoreUnloadedBufs = false,
  -- uses vim.notify for plugins like nvim-notify
  notificationOnAutoClose = false,
}

local opts = {
  retirementAgeMins = 20,
  minimumBufferNum = 8,
  notificationOnAutoClose = true,
}

-- require("early-retirement").setup(opts)
