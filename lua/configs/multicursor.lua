-- https://github.com/smoka7/multicursors.nvim
-- https://github.com/brenton-leighton/multiple-cursors.nvim

local mc = require("multicursor-nvim")

mc.setup({
  -- shallowUndo = false,
  -- signs = {},
})

-- stylua: ignore
local keymaps = {
  toggle         = "<M-n>",             -- nv  <c-q>
  escape         = "<Esc>",             -- n   <esc>
  next           = "<right>",           -- nv
  prev           = "<left>",            -- nv
  delete         = "<leader>mx",        -- nv  <leader>x
  restore        = "<leader>mr",        -- n   <leader>gv
  duplicate      = "<leader>md",        -- nv  <leader><c-q>
  align          = "<leader>ma",        -- n   <leader>a
  split          = "gS",                -- v   S
  insertVisual   = "gI",                -- v   I
  appendVisual   = "gA",                -- v   A

  lineAddAbove   = "<up>",              -- nv
  lineAddBelow   = "<down>",            -- nv
  lineSkipAbove  = "<C-Up>",            -- nv  <leader><up>
  lineSkipBelow  = "<C-Down>",          -- nv  <leader><down>
  matchAddAbove  = "<leader>mn",        -- nv  <leader>n
  matchAddBelow  = "<leader>mN",        -- nv  <leader>N
  matchSkipAbove = "<leader>ms",        -- nv  <leader>s
  matchSkipBelow = "<leader>mS",        -- nv  <leader>S
  matchAddAll    = "<leader>mA",        -- nv  <leader>A
}

local get_key_cmd = function(mode, lhs)
  local keys = vim.api.nvim_get_keymap(mode)
  local old_val = nil

  for _, key in ipairs(keys) do
    if key.lhs == lhs then
      old_val = key.callback or key.rhs
    end
  end
  return old_val
end

local map = require("mapper").map
local set = function(modes, lhs, rhs, desc)
  if type(lhs) == "string" and lhs ~= "" then
    map(modes, lhs, rhs, { desc = desc })
  end
end

local setup_keymaps = function()
  -- Easy way to add and remove cursors using the main cursor.
  set({ "n", "v" }, keymaps.toggle, mc.toggleCursor, "multicursor toggle")

  -- Add or skip cursor above/below the main cursor.
  set({ "n", "v" }, keymaps.lineAddAbove, function()
    mc.lineAddCursor(-1)
  end, "multicursor line add above")
  set({ "n", "v" }, keymaps.lineAddBelow, function()
    mc.lineAddCursor(1)
  end, "multicursor line add below")
  set({ "n", "v" }, keymaps.lineSkipAbove, function()
    mc.lineSkipCursor(-1)
  end, "multicursor line skip above")
  set({ "n", "v" }, keymaps.lineSkipBelow, function()
    mc.lineSkipCursor(1)
  end, "multicursor line skip below")

  -- Add or skip adding a new cursor by matching word/selection
  set({ "n", "v" }, keymaps.matchAddAbove, function()
    mc.matchAddCursor(1)
  end, "multicursor match add above")
  set({ "n", "v" }, keymaps.matchAddBelow, function()
    mc.matchAddCursor(-1)
  end, "multicursor match add below")
  set({ "n", "v" }, keymaps.matchSkipAbove, function()
    mc.matchSkipCursor(1)
  end, "multicursor match skip above")
  set({ "n", "v" }, keymaps.matchSkipBelow, function()
    mc.matchSkipCursor(-1)
  end, "multicursor match skip below")

  -- Add all matches in the document
  set({ "n", "v" }, keymaps.matchAddAll, mc.matchAllAddCursors, "multicursor match add all")

  -- Rotate the main cursor.
  set({ "n", "v" }, keymaps.next, mc.nextCursor, "multicursor next cursor")
  set({ "n", "v" }, keymaps.prev, mc.prevCursor, "multicursor prev cursor")

  -- Delete the main cursor.
  set({ "n", "v" }, keymaps.delete, mc.deleteCursor, "multicursor delete cursor")

  -- Clone every cursor and disable the originals.
  set({ "n", "v" }, keymaps.duplicate, mc.duplicateCursors, "multicursor duplicate cursor")

  -- bring back cursors if you accidentally clear them
  set("n", keymaps.restore, mc.restoreCursors, "multicursor restore cursors")

  -- Align cursor columns.
  set("n", keymaps.align, mc.alignCursors, "multicursor align columns")

  -- Split visual selections by regex.
  set("v", keymaps.split, mc.splitCursors, "multicursor split selection by regex")

  -- -- Append/insert for each line of visual selections.
  set("v", keymaps.insertVisual, mc.insertVisual, "multicursor insert cursor on each selected line")
  set("v", keymaps.appendVisual, mc.appendVisual, "multicursor append cursor on each selected line")

  -- save original keymapping of escape
  local orig_escape = get_key_cmd("n", keymaps.escape)
  set("n", keymaps.escape, function()
    if not mc.cursorsEnabled() then
      mc.enableCursors()
    elseif mc.hasCursors() then
      mc.clearCursors()
    elseif type(orig_escape) == "function" then
      orig_escape()
    elseif type(orig_escape) == "string" then
      local keys = vim.api.nvim_replace_termcodes(orig_escape, true, true, true)
      vim.api.nvim_feedkeys(keys, "n", false)
    end
  end, "multicursors enable or clear cursors")

  -- You can also add cursors with any motion you prefer:
  -- set("n", "<right>", function()
  --     mc.addCursor("w")
  -- end)
  -- set("n", "<leader><right>", function()
  --     mc.skipCursor("w")
  -- end)

  -- -- Add and remove cursors with control + left click.
  -- set("n", "<c-leftmouse>", mc.handleMouse)
  --
  -- -- match new cursors within visual selections by regex.
  -- set("v", "M", mc.matchCursors)
  --
  -- -- Rotate visual selection contents.
  -- set("v", "<leader>t", function()
  --   mc.transposeCursors(1)
  -- end)
  -- set("v", "<leader>T", function()
  --   mc.transposeCursors(-1)
  -- end)
  --
  -- -- Jumplist support
  -- set({ "v", "n" }, "<c-i>", mc.jumpForward)
  -- set({ "v", "n" }, "<c-o>", mc.jumpBackward)

  -- It starts with <c-n> to select a word, then it seems to add keymaps with single keystrokes like `n`, `N`, `q`, `Q` to go the next, previous, skip and remove actions respectively
  -- vim.keymap.set("n", "n", function()
  --     if (mc.hasCursors()) {
  --         mc.addCursor("*")
  --     }
  --     else {
  --         vim.cmd.norm("n")
  --     }
  -- end)
end

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    setup_keymaps()
  end,
})

-- -- smoka7 mappings
-- <Esc> Clear the selections and go back to normal mode
-- <C-c> Clear the selections and go back to normal mode
-- i     Enters insert mode
-- a     Enters append mode
-- e     Enters extend mode
-- c     Deletes the text inside selections and starts insert mode
-- n     [count] Finds the next match after the main selection
-- N     [count] Finds the previous match before the main selection
-- <C-a> Creates selections for all the matches
-- q     [count] Skips the current selection and finds the next one
-- Q     [count] Skips the current selection and finds the previous one
-- ]     [count] Swaps the main selection with next selection
-- [     [count] Swaps the main selection with previous selection
-- }     [count] Deletes the main selection and goes to next
-- {     [count] Deletes the main selection and goes to previous
-- <C-n> Creates a selection for the char under the cursor
-- j     [count] Creates a selection on the char below the cursor
-- J     [count] Skips the current selection and Creates a selection on the char below
-- k     [count] Creates a selection on the char above the cursor
-- K     [count] Skips the current selection and Creates a selection on the char above
-- r     Replaces the text inside selections with content of unnamed register
-- p     Puts the text inside unnamed register before selections
-- P     Puts the text inside unnamed register after selections
-- y     Yanks the text inside selections to unnamed register
-- Y     Yanks the text from the start of selection till the end of the line to unnamed register
-- yy    Yanks the line of selection to unnamed register
-- gu    changes selections case to lowercase
-- gU    changes selections case to UPPERCASE
-- z     Aligns selections by adding space before selections
-- Z     Aligns selections by adding space at the start of the line
-- d     Deletes the text inside selections
-- D     count Deletes the text from the start of selections till the end of the line
-- dd    count Deletes line of selections
-- @     Executes a macro at the start of selections
-- .     Repeats last change at the start of selections
-- ,     Clears All Selections except the main one
-- :     Prompts for a normal command and Executes it at the start of selections
-- u     Undo changes
-- <C-r> Redo changes
--
-- -- brandon-leighton mappings
-- {"<C-j>", "<Cmd>MultipleCursorsAddDown<CR>", mode = {"n", "x"}, desc = "Add cursor and move down"},
-- {"<C-k>", "<Cmd>MultipleCursorsAddUp<CR>", mode = {"n", "x"}, desc = "Add cursor and move up"},
-- {"<C-Up>", "<Cmd>MultipleCursorsAddUp<CR>", mode = {"n", "i", "x"}, desc = "Add cursor and move up"},
-- {"<C-Down>", "<Cmd>MultipleCursorsAddDown<CR>", mode = {"n", "i", "x"}, desc = "Add cursor and move down"},
-- {"<C-LeftMouse>", "<Cmd>MultipleCursorsMouseAddDelete<CR>", mode = {"n", "i"}, desc = "Add or remove cursor"},
-- {"<Leader>a", "<Cmd>MultipleCursorsAddMatches<CR>", mode = {"n", "x"}, desc = "Add cursors to cword"},
-- {"<Leader>A", "<Cmd>MultipleCursorsAddMatchesV<CR>", mode = {"n", "x"}, desc = "Add cursors to cword in previous area"},
-- {"<Leader>d", "<Cmd>MultipleCursorsAddJumpNextMatch<CR>", mode = {"n", "x"}, desc = "Add cursor and jump to next cword"},
-- {"<Leader>D", "<Cmd>MultipleCursorsJumpNextMatch<CR>", mode = {"n", "x"}, desc = "Jump to next cword"},
-- {"<Leader>l", "<Cmd>MultipleCursorsLock<CR>", mode = {"n", "x"}, desc = "Lock virtual cursors"},
