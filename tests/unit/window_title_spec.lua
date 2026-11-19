-- The window title from core/autocommands/misc.lua: outside tmux it ends in a
-- zero-width space, the mark xremap looks for before leaving Ctrl+hjkl to the
-- terminal (see ~/.config/tmux/conf.d/display.conf).

local MARK = "\226\128\139"
local MISC = vim.fn.stdpath("config") .. "/lua/core/autocommands/misc.lua"

local function title_with(tmux)
  local saved_tmux, saved_execute = vim.env.TMUX, os.execute
  -- Outside tmux misc.lua runs `tmux setenv`; keep it off the user's server.
  os.execute = function() return 0 end
  vim.env.TMUX = tmux
  local ok, err = pcall(function()
    dofile(MISC)
    vim.api.nvim_exec_autocmds("VimEnter", { group = "UpdateDirectory" })
  end)
  vim.env.TMUX = saved_tmux
  os.execute = saved_execute
  assert(ok, err)
  return vim.o.titlestring
end

describe("window title", function()
  it("ends in the xremap mark outside tmux", function()
    local title = title_with(nil)
    assert.are.equal(MARK, title:sub(-#MARK))
    assert.is_true(vim.o.title)
  end)

  it("has no mark inside tmux, where tmux owns the terminal title", function()
    local title = title_with("/tmp/tmux-1000/default,1,0")
    assert.is_nil(title:find(MARK, 1, true))
  end)
end)
