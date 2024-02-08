-- highlight for Window separator

-- Normally all windows on a buffer share the same syntax settings. It is
-- possible, however, to set a particular window on a file to have its own
-- private syntax setting. A possible example would be to edit LaTeX source
-- with conventional highlighting in one window, while seeing the same source
-- highlighted differently (so as to hide control sequences and indicate bold,
-- italic etc regions) in another. The 'scrollbind' option is useful here.
--
-- To set the current window to have the syntax "foo", separately from all other
-- windows on the buffer:
--    :ownsyntax foo
--  						*w:current_syntax*
-- This will set the "w:current_syntax" variable to "foo".  The value of
-- "b:current_syntax" does not change.  This is implemented by saving and
-- restoring "b:current_syntax", since the syntax files do set
-- "b:current_syntax".  The value set by the syntax file is assigned to
-- "w:current_syntax".
-- Note: This resets the 'spell', 'spellcapcheck' and 'spellfile' options.
--
-- Once a window has its own syntax, syntax commands executed from other windows
-- on the same buffer (including :syntax clear) have no effect. Conversely,
-- syntax commands executed from that window do not affect other windows on the
-- same buffer.
--
-- A window with its own syntax reverts to normal behavior when another buffer
-- is loaded into that window or the file is reloaded.
-- When splitting the window, the new window will use the original syntax.
-- WinSeparator({ fg = '#660044', bg = '#140004', gui = 'bold' }),
-- winhighlight=CursorLineNr:ReactiveCursorLineNr@mode.n,CursorLine:ReactiveCursorLine@mode.n,ColorColumn:
-- TODO: vimade custom level, Normal:NormalNC, StatusLineNC, WinBarNC,TablineSel, TablineFill, Tabline, MsgSeparator
-- :set fillchars+=vert:\ "White space at the end
-- :set fillchars+=vert:\|
-- :vim.opt.fillchars = "vert:┃,horiz:━,verthoriz:╋,horizup:┻,horizdown:┳,vertleft:┫,vertright:┣,eob: " -- more obvious separator
-- set fillchars+=vert:┃
-- "set fillchars+=vert:█
require('winsep').setup({
  highlight = {
    bg = '#140004',
    fg = '#660044',
  },
  -- timer refresh rate
  interval = 30,
  -- This plugin will not be activated for filetype in the following table.
  no_exec_files = { 'packer', 'TelescopePrompt', 'mason', 'CompetiTest', 'NvimTree' },
  -- Symbols for separator lines, the order: horizontal, vertical, top left, top right, bottom left, bottom right.
  symbols = { '━', '┃', '┏', '┓', '┗', '┛' },
  close_event = function()
    -- Executed after closing the window separator
  end,
  create_event = function()
    -- Executed after creating the window separator
  end,
})
