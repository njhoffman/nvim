-- https://github.com/smoka7/multicursors.nvim
-- https://github.com/brenton-leighton/multiple-cursors.nvim

local mc = require("multicursor-nvim")

mc.setup({
  -- hlSearch = false,
  -- shallowUndo = false,
  -- signs = {}, { "┆", "│", "┃", "↑", "↓", "⇡", "⇣" }
})

local pfx = "<leader>m"

-- stylua: ignore
local keymaps    = {
  escape         = {pfx .. 'q', "<Esc>"},    -- n   <esc>
  toggle         = {pfx .. 'm', "<M-M>"},    -- nv  <c-q>
  next           = {pfx .. "]", "]m"},       -- nv
  prev           = {pfx .. "[", "[m"},       -- nv
  delete         = {pfx .. "x"},             -- nv  <leader>x
  restore        = {pfx .. "u"},             -- n   <leader>gv
  duplicate      = {pfx .. "gm"},            -- nv  <leader><c-q>
  align          = {pfx .. "ga"},            -- n   <leader>a
  split          = {pfx .. "gs"},            -- v   S
  insertVisual   = {pfx .. "gi"},            -- v   I
  appendVisual   = {pfx .. "ga"},            -- v   A
  matchInteract  = {pfx .. "M"},             -- v   M
  matchAddAll    = {pfx .. "a"},             -- nv  <leader>A
  matchAddAbove  = {pfx .. "N"},             -- nv  <leader>n
  matchAddBelow  = {pfx .. "n"},             -- nv  <leader>N
  matchSkipAbove = {pfx .. "sN"},            -- nv  <leader>s
  matchSkipBelow = {pfx .. "sn"},            -- nv  <leader>S
  lineAddAbove   = {pfx .. "k"},             -- nv
  lineAddBelow   = {pfx .. "j"},             -- nv
  lineSkipAbove  = {pfx .. "sk"},            -- nv  <leader><up>
  lineSkipBelow  = {pfx .. "sj"},            -- nv  <leader><down>
  jumpForward    = {"<c-i>" },
  jumpBackward   = {"<c-o>" },
}

local get_key_cmd = function(mode, lhs)
  local keys = vim.api.nvim_get_keymap(mode)
  local old_val = nil
  lhs = type(lhs) == "table" and lhs[1] or lhs

  for _, key in ipairs(keys) do
    if string.lower(key.lhs) == string.lower(lhs) then
      old_val = key.callback or key.rhs
    end
  end
  return old_val
end

local map = require("mapper").map
local set = function(modes, lhs, rhs, desc, layerSet)
  lhs = type(lhs) == "table" and lhs or { lhs }
  for _, l in ipairs(lhs) do
    if type(l) == "string" and l ~= "" then
      local mapfunc = layerSet or map
      mapfunc(modes, l, rhs, { desc = desc })
    end
  end
end

local setup_keymaps = function()
  -- Easy way to add and remove cursors using the main cursor.
  set({ "n", "x" }, keymaps.toggle, mc.toggleCursor, "multicursor toggle")

  -- Interactively ask for a pattern, add a cursor for each match of this pattern over every visual selections.
  set({ "x" }, keymaps.matchInteract, mc.matchCursors, "multicursor match input pattern")

  -- Add or skip cursor above/below the main cursor.
  set({ "n", "x" }, keymaps.lineAddAbove, function()
    mc.lineAddCursor(-1)
  end, "multicursor line add above")
  set({ "n", "x" }, keymaps.lineAddBelow, function()
    mc.lineAddCursor(1)
  end, "multicursor line add below")
  set({ "n", "x" }, keymaps.lineSkipAbove, function()
    mc.lineSkipCursor(-1)
  end, "multicursor line skip above")
  set({ "n", "x" }, keymaps.lineSkipBelow, function()
    mc.lineSkipCursor(1)
  end, "multicursor line skip below")

  -- Add or skip adding a new cursor by matching word/selection
  --     Move only the main cursor by matching the current word/selection.
  set({ "n", "x" }, keymaps.matchAddAbove, function()
    mc.matchAddCursor(1)
  end, "multicursor match add above")
  set({ "n", "x" }, keymaps.matchAddBelow, function()
    mc.matchAddCursor(-1)
  end, "multicursor match add below")
  set({ "n", "x" }, keymaps.matchSkipAbove, function()
    mc.matchSkipCursor(1)
  end, "multicursor match skip above")
  set({ "n", "x" }, keymaps.matchSkipBelow, function()
    mc.matchSkipCursor(-1)
  end, "multicursor match skip below")

  -- Add all matches in the document
  set({ "n", "x" }, keymaps.matchAddAll, mc.matchAllAddCursors, "multicursor match add all")

  mc.addKeymapLayer(function(layerSet)
    -- Rotate the main cursor.
    set({ "n", "x" }, keymaps.next, mc.nextCursor, "multicursor next cursor", layerSet)
    set({ "n", "x" }, keymaps.prev, mc.prevCursor, "multicursor prev cursor", layerSet)
    -- Delete the main cursor.
    set({ "n", "x" }, keymaps.delete, mc.deleteCursor, "multicursor delete cursor", layerSet)
    -- Clone every cursor and disable the originals.
    set(
      { "n", "x" },
      keymaps.duplicate,
      mc.duplicateCursors,
      "multicursor duplicate cursor",
      layerSet
    )

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
    end, "multicursors enable or clear cursors", layerSet)
  end)

  -- bring back cursors if you accidentally clear them
  set("n", keymaps.restore, mc.restoreCursors, "multicursor restore cursors")

  -- Align cursor columns.
  set("n", keymaps.align, mc.alignCursors, "multicursor align columns")

  -- Interactively ask for a regex separator, split every visual selection
  set("x", keymaps.split, mc.splitCursors, "multicursor split selection by regex")

  -- -- Append/insert for each line of visual selections.
  set("x", keymaps.insertVisual, mc.insertVisual, "multicursor insert cursor on each selected line")
  set("x", keymaps.appendVisual, mc.appendVisual, "multicursor append cursor on each selected line")

  set({ "n", "x" }, keymaps.jumpForward, mc.jumpForward, "multicursor jumplist fowards")
  set({ "n", "x" }, keymaps.jumpBackward, mc.jumpBackward, "multicursor jumplist backwards")

  --     get first cursor
  --     mc.action(function(ctx)
  --         local cursor = ctx:firstCursor()
  --         vim.print(cursor:getLine())
  --         cursor:feedkeys("ihello world")
  --     end)
  --   mc.matchSkipCursor(-1)
  -- end, "multicursor match skip below")

  -- You can also add cursors with any motion you prefer:
  -- set("n", "<right>", function()
  --     mc.addCursor("w")
  -- end)
  -- set("n", "<leader><right>", function()
  --     mc.skipCursor("w")
  -- end)

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

  -- It starts with <c-n> to select a word then it seems to
  -- add keymaps with single keystrokes like `n` `N` `q` `Q`
  -- to go the next previous skip and remove actions respectively

  -- vim.keymap.set("n", "n", function()
  --     if (mc.hasCursors()) {
  --         mc.addCursor("*")
  --     }
  --     else {
  --         vim.cmd.norm("n")
  --     }
  -- end)
end

function setup_hls()
  local hl = vim.api.nvim_set_hl
  hl(0, "MultiCursorCursor", { reverse = true })
  hl(0, "MultiCursorVisual", { link = "Visual" })
  hl(0, "MultiCursorSign", { link = "SignColumn" })
  hl(0, "MultiCursorMatchPreview", { link = "Search" })
  hl(0, "MultiCursorDisabledCursor", { reverse = true })
  hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
  hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
end

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    setup_keymaps()
    -- setup_hls()
  end,
})

return {
  setup_keymaps = setup_keymaps,
  setup_hls = setup_hls,
}

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

--  • mc.addCursor                                        |multicursor-addCursor|
--  • mc.skipCursor                                      |multicursor-skipCursor|
--  • mc.toggleCursor                                  |multicursor-toggleCursor|
--  • mc.lineAddCursor                                |multicursor-lineAddCursor|
--  • mc.lineSkipCursor                              |multicursor-lineSkipCursor|
--  • mc.matchAddCursor                              |multicursor-matchAddCursor|
--  • mc.matchSkipCursor                            |multicursor-matchSkipCursor|
--  • mc.matchAllAddCursors                      |multicursor-matchAllAddCursors|
--  • mc.searchAddCursor                            |multicursor-searchAddCursor|
--  • mc.searchSkipCursor                          |multicursor-searchSkipCursor|
--  • mc.searchAllAddCursors                    |multicursor-searchAllAddCursors|
--  • mc.nextCursor                                      |multicursor-nextCursor|
--  • mc.prevCursor                                      |multicursor-prevCursor|
--  • mc.firstCursor                                    |multicursor-firstCursor|
--  • mc.lastCursor                                      |multicursor-lastCursor|
--  • mc.hasCursors                                      |multicursor-hasCursors|
--  • mc.deleteCursor                                  |multicursor-deleteCursor|
--  • mc.clearCursors                                  |multicursor-clearCursors|
--  • mc.handleMouse                                    |multicursor-handleMouse|
--  • mc.handleMouseDrag                            |multicursor-handleMouseDrag|
--  • mc.handleMouseRelease                      |multicursor-handleMouseRelease|
--  • mc.alignCursors                                  |multicursor-alignCursors|
--  • mc.splitCursors                                  |multicursor-splitCursors|
--  • mc.matchCursors                                  |multicursor-matchCursors|
--  • mc.transposeCursors                          |multicursor-transposeCursors|
--  • mc.swapCursors                                    |multicursor-swapCursors|
--  • mc.insertVisual                                  |multicursor-insertVisual|
--  • mc.appendVisual                                  |multicursor-appendVisual|
--  • mc.sequenceIncrement                        |multicursor-sequenceIncrement|
--  • mc.sequenceDecrement                        |multicursor-sequenceDecrement|
--  • mc.addCursorOperator                        |multicursor-addCursorOperator|
--  • mc.operator                                          |multicursor-operator|
--  • mc.diagnosticAddCursor                    |multicursor-diagnosticAddCursor|
--  • mc.diagnosticSkipCursor                  |multicursor-diagnosticSkipCursor|
--  • mc.diagnosticMatchCursors              |multicursor-diagnosticMatchCursors|
--  • mc.jumpForward                                    |multicursor-jumpForward|
--  • mc.jumpBackward                                  |multicursor-jumpBackward|
--  • mc.disableCursors                              |multicursor-disableCursors|
--  • mc.enableCursors                                |multicursor-enableCursors|
--  • mc.cursorsEnabled                              |multicursor-cursorsEnabled|
--  • mc.feedkeys                                          |multicursor-feedkeys|
--  • mc.addKeymapLayer                              |multicursor-addKeymapLayer|
--  • mc.removeKeymapLayer                        |multicursor-removeKeymapLayer|
--  • mc.action                                              |multicursor-action|
--             set({"n", "x"}, "<up>", function() mc.lineAddCursor(-1) end)
--             set({"n", "x"}, "<down>", function() mc.lineAddCursor(1) end)
--             set({"n", "x"}, "<leader><up>", function() mc.lineSkipCursor(-1) end)
--             set({"n", "x"}, "<leader><down>", function() mc.lineSkipCursor(1) end)
--             set({"n", "x"}, "<leader>n", function() mc.matchAddCursor(1) end)
--             set({"n", "x"}, "<leader>s", function() mc.matchSkipCursor(1) end)
--             set({"n", "x"}, "<leader>N", function() mc.matchAddCursor(-1) end)
--             set({"n", "x"}, "<leader>S", function() mc.matchSkipCursor(-1) end)
--             set("n", "<c-leftmouse>", mc.handleMouse)
--             set("n", "<c-leftdrag>", mc.handleMouseDrag)
--             set("n", "<c-leftrelease>", mc.handleMouseRelease)
--             set({"n", "x"}, "<c-q>", mc.toggleCursor)
--             mc.addKeymapLayer(function(layerSet)
--                 layerSet({"n", "x"}, "<left>", mc.prevCursor)
--                 layerSet({"n", "x"}, "<right>", mc.nextCursor)
--                 layerSet({"n", "x"}, "<leader>x", mc.deleteCursor)
--                     if not mc.cursorsEnabled() then
--                         mc.enableCursors()
--                         mc.clearCursors()
--         vim.keymap.set("n", "<right>", function()
--             mc.addCursor("w")
--         vim.keymap.set("n", "<leader><right>", function()
--             mc.skipCursor("w")
--         vim.keymap.set("n", "<c-q>", mc.toggleCursor)
--         vim.keymap.set({"n", "v"}, "<up>", function()
--             mc.lineAddCursor(-1)
--         vim.keymap.set({"n", "v"}, "<down>", function()
--             mc.lineAddCursor(1)
--         vim.keymap.set({"n", "v"}, "<leader><up>", function()
--             mc.lineSkipCursor(-1)
--         vim.keymap.set({"n", "v"}, "<leader><down>", function()
--             mc.lineSkipCursor(1)
--         vim.keymap.set({"n", "v"}, "<leader>n", function()
--             mc.matchAddCursor(1)
--         vim.keymap.set({"n", "v"}, "<leader>N", function()
--             mc.matchAddCursor(-1)
--         vim.keymap.set({"n", "v"}, "<leader>s", function()
--             mc.matchSkipCursor(1)
--         vim.keymap.set({"n", "v"}, "<leader>S", function()
--             mc.matchSkipCursor(-1)
--         vim.keymap.set({"n", "v"}, "<leader>A", mc.matchAllAddCursors)
--         vim.keymap.set("n", "<leader>/n", function()
--             mc.searchAddCursor(1)
--         vim.keymap.set("n", "<leader>/N", function()
--             mc.searchAddCursor(-1)
--         vim.keymap.set("n", "<leader>/s", function()
--             mc.searchSkipCursor(-1)
--         vim.keymap.set("n", "<leader>/S", function()
--             mc.searchSkipCursor(-1)
--         vim.keymap.set("n", "<leader>/A", mc.searchAllAddCursors)
--         vim.keymap.set({"n", "v"}, "<left>", mc.nextCursor)
--         vim.keymap.set({"n", "v"}, "<right>", mc.prevCursor)
--         vim.keymap.set({"n", "v"}, "H", mc.firstCursor)
--         vim.keymap.set({"n", "v"}, "L", mc.lastCursor)
--         vim.keymap.set({ "n", "v" }, "<esc>", function()
--             if mc.hasCursors() then
--                 mc.clearCursors()
--         vim.keymap.set({"n", "v"}, "<leader>x", mc.deleteCursor)
--         vim.keymap.set({ "n", "v" }, "<esc>", function()
--             if mc.hasCursors() then
--                 mc.clearCursors()
--         vim.keymap.set("n", "<c-leftmouse>", mc.handleMouse)
--         vim.keymap.set("n", "<c-leftdrag>", mc.handleMouseDrag)
--         vim.keymap.set("n", "<c-leftrelease>", mc.handleMouseRelease)
--         vim.keymap.set("n", "<leader>a", mc.alignCursors)
--         vim.keymap.set("v", "S", mc.splitCursors)
--         vim.keymap.set("v", "M", mc.matchCursors)
--         vim.keymap.set("v", "<leader>t", function()
--             mc.transposeCursors(1)
--         vim.keymap.set("v", "<leader>T", function()
--             mc.transposeCursors(-1)
--         vim.keymap.set("v", "<leader>h", function()
--             mc.swapCursors(-1)
--         vim.keymap.set("v", "<leader>l", function()
--             mc.swapCursors(1)
--         vim.keymap.set("v", "I", mc.insertVisual)
--         vim.keymap.set("v", "A", mc.appendVisual)
--         vim.keymap.set({"x", "n"}, "g<c-a>", mc.sequenceIncrement)
--         vim.keymap.set({"x", "n"}, "g<c-x>", mc.sequenceDecrement)
--         vim.keymap.set("n", "ga", mc.addCursorOperator)
--         vim.keymap.set({ "x", "n" }, "<leader>m", mc.operator)
--         vim.keymap.set({"n", "x"}, "]d", function()
--             mc.diagnosticAddCursor(1)
--         vim.keymap.set({"n", "x"}, "[d", function()
--             mc.diagnosticAddCursor(-1)
--         vim.keymap.set({"n", "x"}, "]d", function()
--             mc.diagnosticAddCursor(1)
--         vim.keymap.set({"n", "x"}, "[d", function()
--             mc.diagnosticAddCursor(-1)
--         vim.keymap.set({"n", "x"}, "md", function()
--             mc.diagnosticMatchCursors({ severity = vim.diagnostic.severity.ERROR })
--         vim.keymap.set({"n", "x"}, "<c-i>", mc.jumpForward)
--         vim.keymap.set({"n", "x"}, "<c-o>", mc.jumpBackward)
--         vim.keymap.set({"n", "v"}, "<c-q>", mc.disableCursors)
--         vim.keymap.set({"n", "v"}, "<c-q>", mc.enableCursors)
--         if not mc.cursorsEnabled() then
--             mc.enableCursors()
--     provided function (similar to `vim.keymap.set`) will be automatically
--         mc.addKeymapLayer(function(layerSet)
--             layerSet("n", "x", mc.deleteCursor)
--         Same arguments as |vim.keymap.set()|.
--       • |vim.keymap.set()|
--         mc.action(function(ctx)
--     mc.action(function(ctx)
--     mc.action(function(ctx)
--  • numCursors                                     |multicursor-ctx-numCursors|
-- ctx:numCursors()                                  *multicursor-ctx-numCursors*
