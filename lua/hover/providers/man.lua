local async = require("hover.async")
local job = require("hover.async.job").job

local function enabled(done)
  local is_ft = vim.tbl_contains({
    "sh",
    "zsh",
    "tcl",
    "make",
  }, vim.bo.filetype)
  done(is_ft)
end

-- local function get_page(path)
-- end
-- vim.bo.swapfile = false
-- vim.bo.buftype = 'nofile'
-- vim.bo.bufhidden = 'hide'
-- vim.bo.modified = false
-- vim.bo.readonly = true
-- vim.bo.modifiable = false
-- vim.b.pager = pager
-- vim.bo.filetype = 'man'

local execute = async.void(function(done)
  -- if not fn.bufname('%'):match('man://') then -- Avoid duplicate buffers, E95.
  --   vim.cmd.file({ 'man://' .. fn.fnameescape(ref):lower(), mods = { silent = true } })
  -- end

  local path = "man://fzf(1)"
  local manwidth
  if (vim.g.man_hardwrap or 1) ~= 1 then
    manwidth = 999
  elseif vim.env.MANWIDTH then
    manwidth = vim.env.MANWIDTH
  else
    manwidth = vim.api.nvim_win_get_width(0)
  end

  local cmd = { "man", "-l", path } or { "man", path }
  -- Force MANPAGER=cat to ensure Vim is not recursively invoked (by man-db).
  -- Set MAN_KEEP_FORMATTING so Debian man doesn't discard backspaces.
  local output = vim.fn.system(cmd, {
    "MANPAGER=cat",
    "MANWIDTH=" .. manwidth,
    "MAN_KEEP_FORMATTING=1",
  })
  local lines = vim.split(output, "\n")
  return done({ lines = lines, filetype = "man" })
end)

require("hover").register({
  name = "man",
  menu = "Man",
  desc = "Man Pages",
  priority = 150,
  enabled = enabled,
  execute = execute,
})
