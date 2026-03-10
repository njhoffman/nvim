local api = vim.api
local cmd = vim.cmd
local expand = vim.fn.expand
local fn = vim.fn
local u = require("config.utils")
local keymap = u.uniqueKeymap
--------------------------------------------------------------------------------
-- META

local pathOfThisFile = debug.getinfo(1).source:sub(2)
keymap("n", "<D-,>", function()
  vim.cmd.edit(pathOfThisFile)
end, { desc = "⌨️  Edit " .. vim.fs.basename(pathOfThisFile) })

--------------------------------------------------------------------------------
-- NAVIGATION

-- HJKL behaves like hjkl, but bigger distance
keymap({ "o", "x" }, "H", "^")
keymap("n", "H", "0^") -- `0` ensures fully scrolling to the left on long, indented lines
keymap({ "n", "x" }, "L", "$zv") -- zv: unfold
keymap({ "n", "x" }, "J", "6j")
keymap({ "n", "x" }, "K", "6k")

-- Jump history
-- non-unique, since it overwrites nvim default: https://neovim.io/doc/user/vim_diff.html#default-mappings
keymap("n", "<C-l>", "<C-i>", { desc = "󱋿 Jump forward", unique = false })
keymap("n", "<C-h>", "<C-o>", { desc = "󱋿 Jump back" })

-- Search
keymap("n", "-", "/")
keymap("x", "-", "<Esc>/\\%V", { desc = "Search IN sel" })

-- Diagnostics
keymap("n", "ge", vim.diagnostic.goto_next, { desc = "󰒕 Next Diagnostic" })
keymap("n", "gE", vim.diagnostic.goto_prev, { desc = "󰒕 Previous Diagnostic" })
keymap({ "n", "v", "i" }, "<D-g>", vim.lsp.buf.signature_help, { desc = "󰏪 Signature" })

-- needs remapping since `gf` is used for LSP-references
keymap("n", "gp", "gf", { desc = " Goto Path under cursor" })

-- quickfix
keymap("n", "gq", "<cmd>cnext<CR>zv", { desc = " Next Quickfix" })
keymap("n", "gQ", "<cmd>cprevious<CR>zv", { desc = " Prev Quickfix" })
keymap("n", "dQ", "<cmd>cexpr []<CR>", { desc = " Delete Qf List" })

--------------------------------------------------------------------------------
-- TEXTOBJECTS

-- remapping of builtin text objects
for remap, original in pairs(u.textobjRemaps) do
  keymap({ "o", "x" }, "i" .. remap, "i" .. original, { desc = "󱡔 inner " .. original })
  keymap({ "o", "x" }, "a" .. remap, "a" .. original, { desc = "󱡔 outer " .. original })
end

-- special remaps
keymap("o", "k", 'i"', { desc = "󱡔 inner quote" })
keymap("o", "J", "2j") -- dd = 1 line, dj = 2 lines, dJ = 3 lines
keymap("n", "<Space>", '"_ciw', { desc = "󱡔 change word" })
keymap("n", "<S-Space>", '"_daw', { desc = "󱡔 delete word" })

--------------------------------------------------------------------------------
-- EDITING

-- Delete trailing stuff
-- (wrapping in normal avoids temporarily scrolling to the side)
keymap("n", "X", "<cmd>normal!mz$x`z<CR>", { desc = "󱎘 Delete char at EoL" })

-- COMMENTS
keymap("n", "qw", function()
  require("utils.quality-of-life").commentHr()
end, { desc = " Horizontal Divider" })
keymap("n", "wq", function()
  require("utils.quality-of-life").duplicateAsComment()
end, { desc = " Duplicate Line as Comment" })

-- WHITESPACE & INDENTATION
keymap("n", "=", "mzO<Esc>`z", { desc = "  blank above" })
keymap("n", "_", "mzo<Esc>`z", { desc = "  blank below" })
keymap("n", "<Tab>", ">>", { desc = "󰉶 indent line" })
keymap("n", "<S-Tab>", "<<", { desc = "󰉵 outdent line" })
keymap("x", "<Tab>", ">gv", { desc = "󰉶 indent selection" })
keymap("x", "<S-Tab>", "<gv", { desc = "󰉵 outdent selection" })
keymap("i", "<S-Tab>", "<C-d>", { desc = "󰉵 outdent" })

keymap("n", "[", "<", { desc = "󰉵 outdent" })
keymap("n", "]", ">", { desc = "󰉶 indent" })

-- Close all top-level folds
keymap("n", "zz", "<cmd>%foldclose<CR>", { desc = "󰘖 Close toplevel folds" })

-- [O]pen new scope / brace
keymap({ "n", "i" }, "<D-o>", function()
  require("utils.quality-of-life").openNewScope()
end, { desc = " Open new scope" })

-- Spelling
-- works even with `spell=false`
keymap("n", "z.", "1z=", { desc = "󰓆 Fix Spelling" })

-- ~ without moving don't move cursor, useful for vertical changes
-- (`v~` instead of `~h` so dot-repetition also doesn't move the cursor)
keymap("n", "~", "v~")

-- Merging
keymap({ "n", "x" }, "M", "J", { desc = "󰗈 Merge line up" })
keymap({ "n", "x" }, "gm", "ddpkJ", { desc = "󰗈 Merge line down" })
keymap({ "n", "x" }, "gM", "gJ", { desc = "󰗈 Merge line up (+ trim)" })

--------------------------------------------------------------------------------
-- LINE & CHARACTER MOVEMENT
keymap("n", "<Down>", [[<cmd>. move +1<CR>==]], { desc = "󰜮 Move Line Down" })
keymap("n", "<Up>", [[<cmd>. move -2<CR>==]], { desc = "󰜷 Move Line Up" })
keymap("n", "<Right>", [["zx"zp]], { desc = "➡️  Move Char Right" })
keymap("n", "<Left>", [["zdh"zph]], { desc = "⬅ Move Char Left" })
keymap("x", "<Down>", [[:move '>+1<CR>gv=gv]], { desc = "󰜮 Move Selection down", silent = true })
keymap("x", "<Up>", [[:move '<-2<CR>gv=gv]], { desc = "󰜷 Move Selection up", silent = true })
keymap("x", "<Right>", [["zx"zpgvlolo]], { desc = "➡️  Move Selection right" })
keymap("x", "<Left>", [["zdh"zPgvhoho]], { desc = "⬅ Move Selection left" })

--------------------------------------------------------------------------------

-- COMMAND & INSERT MODE
keymap("c", "<C-u>", "<C-e><C-u>") -- kill whole line
keymap({ "i", "c" }, "<C-a>", "<Home>")
keymap({ "i", "c" }, "<C-e>", "<End>")
keymap("c", "<BS>", function()
  local cmdLine = vim.fn.getcmdline()
  local cmdPos = vim.fn.getcmdpos()
  local isIncRename = cmdLine:find("^IncRename ") and cmdPos < 12
  local isSubstitute = cmdLine:find("^%% s/") and cmdPos < 6
  if cmdLine == "" or isIncRename or isSubstitute then
    return
  end
  return "<BS>"
end, { desc = "Restricted <BS>", expr = true })

-- indent properly when entering insert mode on empty lines
keymap("n", "i", function()
  if api.nvim_get_current_line():find("^%s*$") then
    return [["_cc]]
  end
  return "i"
end, { expr = true, desc = "better i" })

--------------------------------------------------------------------------------

-- VISUAL MODE
keymap("x", "V", "j", { desc = "repeated V selects more lines" })
keymap("x", "v", "<C-v>", { desc = "`vv` starts Visual Block" })

--------------------------------------------------------------------------------

-- TERMINAL MODE
-- also relevant for REPLs such as iron.nvim
keymap("t", "<C-CR>", [[<C-\><C-n><C-w>w]], { desc = " Goto next window" })
keymap("t", "<D-v>", [[<C-\><C-n>pi]], { desc = " Paste (Terminal Mode)" })
keymap("t", "<Esc>", [[<C-\><C-n>]], { desc = " Esc (Terminal Mode)" })

--------------------------------------------------------------------------------
-- BUFFERS & WINDOWS & FILES

keymap("n", "<CR>", function()
  if vim.bo.buftype == "terminal" then
    u.normal("a<CR>") -- confirm in Terminal Mode
  elseif vim.bo.buftype == "" then
    require("funcs.alt-alt").gotoAltBuffer()
  else
    return -- disable in other buffertypes
  end
end, { desc = "󰽙 Alt Buffer" })
keymap({ "n", "x", "i" }, "<C-CR>", "<C-w>w", { desc = " Next Window" })

keymap({ "n", "x", "i" }, "<D-w>", function()
  require("funcs.alt-alt").betterClose()
end, { desc = "󰽙 Close buffer/window" })

--------------------------------------------------------------------------------
-- CLIPBOARD

-- keep the register clean
keymap({ "n", "x" }, "x", '"_x')
keymap({ "n", "x" }, "c", '"_c')
keymap("n", "C", '"_C')

-- do not clutter the register if blank line is deleted
keymap("n", "dd", function()
  if api.nvim_get_current_line():find("^%s*$") then
    return '"_dd'
  end
  return "dd"
end, { expr = true })

-- paste w/o switching register
keymap("x", "p", "P")

-- always paste characterwise when in insert mode
keymap("i", "<D-v>", function()
  local regContent = vim.trim(fn.getreg("+"))
  fn.setreg("+", regContent, "v") ---@diagnostic disable-line: param-type-mismatch
  return "<C-g>u<C-r><C-o>+" -- "<C-g>u" adds undopoint before the paste
end, { desc = " Paste charwise", expr = true })

--- paste via cmd+v
keymap("n", "<D-v>", "p")
keymap("c", "<D-v>", "<C-r>+", { desc = " Paste" })

------------------------------------------------------------------------------
-- CMD-KEYBINDINGS

keymap({ "n", "x" }, "<D-l>", function()
  fn.system({ "open", "-R", expand("%:p") })
end, { desc = "󰀶 Reveal in Finder" })
keymap({ "n", "x" }, "<D-5>", function()
  require("utils.quality-of-life").openAlfredPref()
end, { desc = "󰮤 Reveal in Alfred" })

-- cmd+e: inline code
keymap("n", "<D-e>", "bi`<Esc>ea`<Esc>", { desc = "  Inline Code" }) -- no selection = word under cursor
keymap("x", "<D-e>", "<Esc>`<i`<Esc>`>la`<Esc>", { desc = "  Inline Code" })
keymap("i", "<D-e>", "``<Left>", { desc = "  Inline Code" })

--------------------------------------------------------------------------------
-- QUITTING
keymap({ "n", "x" }, "<MiddleMouse>", "<cmd>try|wqall|catch|qall|endtry<CR>", { desc = "Quit App" })

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "qf", "help", "checkhealth" },
  callback = function()
    vim.keymap.set("n", "q", cmd.close, { buffer = true, nowait = true, desc = "Close" })
  end,
})
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "gitcommit", "gitrebase" },
  callback = function()
    if vim.bo.buftype == "nofile" then
      return
    end -- do not trigger in DressingInput
    -- INFO cquit exists non-zero, aborting the commit/rebase
    vim.keymap.set("n", "q", cmd.cquit, { buffer = true, nowait = true, desc = "Quit" })
  end,
})

--- LEADER COMMANDS
--------------------------------------------------------------------------------

-- Copy Last Command
keymap("n", "<leader>lc", function()
  local lastCommand = fn.getreg(":"):gsub("^lua[ =]*", "")
  fn.setreg("+", lastCommand)
  u.notify("Copied", lastCommand)
end, { desc = "󰘳 Copy last command" })

-- [l]ast command a[g]ain
keymap("n", "<leader>lg", ":<Up><CR>", { desc = "󰘳 Last command again", silent = true })

-- show current filetype & buftype
keymap("n", "<leader>lf", function()
  local out = {
    "filetype: " .. bo.filetype,
    "buftype: " .. bo.buftype,
    ("indent: %s (%s)"):format(bo.expandtab and "spaces" or "tabs", bo.tabstop),
  }
  local ok, node = pcall(vim.treesitter.get_node)
  if ok and node then
    table.insert(out, "node: " .. node:type())
  end
  u.notify("Buffer Information", table.concat(out, "\n"), "trace")
end, { desc = " Buffer Info" })

--------------------------------------------------------------------------------
-- REFACTORING
keymap("n", "<leader>ff", ":% s/<C-r><C-w>//g<Left><Left>", { desc = " :s (cursor word)" })
keymap("x", "<leader>ff", [["zy:% s/<C-r>z//g<Left><Left>]], { desc = " :s (selection)" })
keymap("x", "<leader>fv", ": s///g<Left><Left><Left>", { desc = " :s (inside visual)" })
keymap("n", "<leader>fd", ":g//d<Left><Left>", { desc = " delete matching" })

---@param useSpaces boolean
local function retabber(useSpaces)
  local char = useSpaces and "󱁐" or "󰌒"
  bo.expandtab = useSpaces
  bo.tabstop = 2
  cmd.retab({ bang = true })
  if not useSpaces then
    bo.tabstop = 3
  end
  u.notify("Indent", ("Now using %s"):format(char))
end
keymap("n", "<leader>f<Tab>", function()
  retabber(false)
end, { desc = "󰌒 Use Tabs" })
keymap("n", "<leader>f<Space>", function()
  retabber(true)
end, { desc = "󱁐 Use Spaces" })
keymap("n", "<leader>f<CR>", function()
  vim.opt_local.fileformat = "unix"
end, { desc = "󰌑 Use Unix File Endings" })

--------------------------------------------------------------------------------
-- UNDO

keymap("n", "<leader>ur", function()
  cmd("silent later " .. tostring(vim.opt.undolevels:get()))
end, { desc = "󰛒 Redo All" })

keymap({ "n", "x" }, "<leader>uc", function()
  require("funcs.alt-alt").reopenBuffer()
end, { desc = "󰽙 Undo buffer closing" })

-- save open time for each buffer
autocmd("BufReadPost", {
  ---@diagnostic disable-next-line: inject-field
  callback = function()
    vim.b.timeOpened = os.time()
  end,
})

keymap("n", "<leader>uo", function()
  local now = os.time()
  local secsPassed = now - vim.b.timeOpened
  cmd.earlier(tostring(secsPassed) .. "s")
end, { desc = "󰜊 Undo since last open" })

--------------------------------------------------------------------------------
-- LSP

---@param action object CodeAction https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#codeAction
---@return boolean
local function codeActionFilter(action)
  local title, _ = action.title, action.kind

  ---@type table<string, boolean>
  local filter = {
    -- stylua: ignore
    lua = not (title:find("in this file") or title:find("in the workspace")
      or title:find("defined global") or title:find("Change to parameter")),
    javascript = not (title == "Move to a new file"),
    typescript = not (title == "Move to a new file"),
  }
  return filter[vim.bo.filetype]
end

keymap({ "n", "x" }, "<leader>c", function()
  vim.lsp.buf.code_action({ filter = codeActionFilter })
end, { desc = "󰒕 Code Action" })
keymap("n", "<leader>h", vim.lsp.buf.hover, { desc = "󰒕 Hover" })

--------------------------------------------------------------------------------
-- LOGGING

-- stylua: ignore start
keymap({ "n", "x" }, "<leader>lm", function() require("funcs.printing-press").messageLog() end, { desc = " message log" })
keymap({ "n", "x" }, "<leader>ll", function() require("funcs.printing-press").variableLog() end, { desc = " variable log" })
keymap({ "n", "x" }, "<leader>lo", function() require("funcs.printing-press").objectLog() end, { desc = " object log" })
keymap("n", "<leader>lb", function() require("funcs.printing-press").beepLog() end, { desc = " beep log" })
keymap("n", "<leader>l1", function() require("funcs.printing-press").timeLog() end, { desc = " time log" })
keymap("n", "<leader>lr", function() require("funcs.printing-press").removeLogs() end, { desc = "󰹝 remove log" })
keymap("n", "<leader>ld", function() require("funcs.printing-press").debugLog() end, { desc = " debugger log" })
keymap("n", "<leader>la", function() require("funcs.printing-press").assertLog() end, { desc = " assert log" })
-- stylua: ignore end

keymap("n", "<leader>li", cmd.Inspect, { desc = " :Inspect" })
keymap("n", "<leader>lt", cmd.InspectTree, { desc = " :InspectTree" })

--------------------------------------------------------------------------------

-- Append to / delete from EoL
local trailChars = { ",", ";", ")", "'", '"', "|", "\\", "{", ".", "}" }
for _, key in pairs(trailChars) do
  keymap("n", "<leader>" .. key, "mzA" .. key .. "<Esc>`z", { desc = "which_key_ignore" })
end

-- MAKE
keymap("n", "<leader>r", function()
  vim.cmd("silent! update")
  vim.cmd.lmake()
end, { desc = " Make" })
keymap("n", "<leader>R", function()
  require("utils.quality-of-life").selectMake()
end, { desc = " Select Make" })

-- TERMINAL
keymap({ "n", "x" }, "<leader>t", function()
  require("utils.quality-of-life").sendToWezTerm()
end, { desc = " Send to WezTerm" })

--------------------------------------------------------------------------------
-- OPTION TOGGLING

keymap("n", "<leader>on", "<cmd>set number!<CR>", { desc = " Line Numbers" })
keymap("n", "<leader>ow", "<cmd>set wrap!<CR>", { desc = "󰖶 Wrap" })
keymap("n", "<leader>ol", vim.cmd.LspRestart, { desc = "󰒕 LspRestart" })

keymap("n", "<leader>od", function() -- codespell-ignore
  local change = vim.diagnostic.is_disabled(0) and "enable" or "disable"
  vim.diagnostic[change](0)
end, { desc = " Diagnostics" })
keymap("n", "<leader>oh", function()
  local enabled = vim.lsp.inlay_hint.is_enabled(0)
  vim.lsp.inlay_hint.enabled(0, not enabled)
end, { desc = "󰒕 LSP Inlay Hints" })

keymap("n", "<leader>oc", function()
  vim.opt_local.conceallevel = vim.opt_local.conceallevel:get() == 0 and 1 or 0
end, { desc = "󰈉 Conceal" })

-- FIX
keymap("n", "<leader>of", function()
  vim.opt.scrolloff = 13
end, { desc = "⇓ Fix Scrolloff" })

-- local child_nodes = parent_node:named_children()
-- for _, child_node in pairs(child_nodes) do
--   local s_row, s_col, e_row, e_col = child_node:range()
--   -- Get the textobjects

--   -- vim.treesitter.query.get_node_text(child_node, 0),
--   print(
--     string.format(
--       "Text object name: %s at [%d, %d] to [%d, %d]",
--       s_row + 1,
--       s_col + 1,
--       e_row + 1,
--       e_col + 1
--     )
--   )
-- end

-- ### Basic Text Objects in Normal Mode
-- Neovim defines several text objects, which are generally accessed using the commands `vi<object>` (to visually select the text object) and `di<object>` (to delete the text object around the cursor). The object can be:

-- - `w` for word
-- - `s` for a sentence
-- - `p` for a paragraph
-- - `[` or `]` for a section/block (in applicable programming contexts)
-- - `'`, `"`, `(`, `{`, etc., for content within quotes, parentheses, or braces.

--  {                                  --  {
--    "block.inner",                   --    {lhs = "aN", mode = "o" },                  { lhs = "aN", mode = "x" },
--    "block.outer",                   --    { lhs = "an", mode = "o" },                 { lhs = "an", mode = "x" },
--    "call.outer",                    --    { lhs = "a", mode = "o" },                  { lhs = "a", mode = "x" },
--    "call.inner",                    --    { lhs = "a#", mode = "o" },                 { lhs = "a#", mode = "x" },
--    "_start",                        --    { lhs = "aF", mode = "o" },                 { lhs = "aF", mode = "x" },
--    "_end",                          --    { lhs = "am", mode = "o" },                 { lhs = "am", mode = "x" },
--    "comment.inner",                 --    { lhs = "ak", mode = "o" },                 { lhs = "ak", mode = "x" },
--    "comment.outer",                 --    { lhs = "av", mode = "o" },                 { lhs = "av", mode = "x" },
--    "conditional.inner",             --    { lhs = "a,", mode = "o" },                 { lhs = "a,", mode = "x" },
--    "conditional.outer",             --    { lhs = "az", mode = "o" },                 { lhs = "az", mode = "x" },
--    "function.outer",                --    { lhs = "a_", mode = "o" },                 { lhs = "a_", mode = "x" },
--    "function.inner",                --    { lhs = "a%", mode = "o" },                 { lhs = "a%", mode = "x" },
--    "return.inner",                  --    { lhs = "au", mode = "o" },                 { lhs = "au", mode = "x" },
--    "return.outer",                  --    { lhs = "ih", mode = "o" },                 { lhs = "ih", mode = "x" },
--    "loop.outer",                    --    { lhs = "iN", mode = "o" },                 { lhs = "iN", mode = "x" },
--    "loop.inner",                    --    { lhs = "in", mode = "o" },                 { lhs = "in", mode = "x" },
--    "parameter.inner",               --    { lhs = "i", mode = "o" },                  { lhs = "i", mode = "x" },
--    "number.inner",                  --    { lhs = "i#", mode = "o" },                 { lhs = "i#", mode = "x" },
--    "assignment.lhs",                --    { lhs = "iF", mode = "o" },                 { lhs = "iF", mode = "x" },
--    "assignment.inner",              --    { lhs = "im", mode = "o" },                 { lhs = "im", mode = "x" },
--    "assignment.rhs",                --    { lhs = "ik", mode = "o" },                 { lhs = "ik", mode = "x" },
--    "assignment.outer",              --    { lhs = "iv", mode = "o" },                 { lhs = "iv", mode = "x" },
--    "statement.outer",               --    { lhs = "i,", mode = "o" },                 { lhs = "i,", mode = "x" },
--    "parameter.outer",               --    { lhs = "iz", mode = "o" },                 { lhs = "iz", mode = "x" },
--  }                                  --    { lhs = "i_", mode = "o" },                 { lhs = "i_", mode = "x" },
--                                     --    { lhs = "i%", mode = "o" },                 { lhs = "i%", mode = "x" },
--                                     --    { lhs = "iu", mode = "o" },                 { lhs = "iu", mode = "x"},
--                                     --  }
--                                     --
-- { {
--     desc = "î­¾  around prev textobject",
--     lhs = "aN",
--     mode = "o",
--     name = ""
--   }, {
--     desc = "î­¾  around next textobject",
--     lhs = "an",
--     mode = "o",
--     name = ""
--   }, {
--     desc = "Around textobject",
--     lhs = "a",
--     mode = "o"
--   }, {
--     desc = "outer chainMember textobj",
--     lhs = "am",
--     mode = "o",
--     name = "<Cmd>lua require('various-textobjs').chainMember('outer')<CR>"
--   }, {
--     desc = "î­¾  around key from kv pair",
--     lhs = "ak",
--     mode = "o",
--     name = "<Cmd>lua require('various-textobjs').key('outer')<CR>"
--   }, {
--     desc = "î­¾  around underscore",
--     lhs = "a_",
--     mode = "o",
--     name = ""
--   }, {
--     desc = "outer closedFold textobj",
--     lhs = "az",
--     mode = "o",
--     name = "<Cmd>lua require('various-textobjs').closedFold('outer')<CR>"
--   }, {
--     desc = "î­¾  around value from kv pair",
--     lhs = "av",
--     mode = "o",
--     name = "<Cmd>lua require('various-textobjs').value('outer')<CR>"
--   }, {
--     desc = "outer filepath textobj",
--     lhs = "aF",
--     mode = "o",
--     name = "<Cmd>lua require('various-textobjs').filepath('outer')<CR>"
--   }, {
--     desc = "outer color textobj",
--     lhs = "a#",
--     mode = "o",
--     name = "<Cmd>lua require('various-textobjs').color('outer')<CR>"
--   }, {
--     desc = "outer argument textobj",
--     lhs = "a,",
--     mode = "o",
--     name = "<Cmd>lua require('various-textobjs').argument('outer')<CR>"
--   }, {
--     desc = "ï£¯ Select an |any-block| like built-in |ab|",
--     lhs = "a%",
--     mode = "o",
--     name = "<Plug>(matchup-a%)"
--   }, {
--     lhs = "au",
--     mode = "o",
--     name = ':<C-U>lua require("treesitter._textobjects.unit").select(true)<CR>'
--   }, {
--     desc = "Select Hunk textobject",
--     lhs = "ih",
--     mode = "o"
--   }, {
--     desc = "î­¾  inside prev textobject",
--     lhs = "iN",
--     mode = "o",
--     name = ""
--   }, {
--     desc = "î­¾  inside next textobject",
--     lhs = "in",
--     mode = "o",
--     name = ""
--   }, {
--     desc = "Inside textobject",
--     lhs = "i",
--     mode = "o"
--   }, {
--     desc = "inner chainMember textobj",
--     lhs = "im",
--     mode = "o",
--     name = "<Cmd>lua require('various-textobjs').chainMember('inner')<CR>"
--   }, {
--     desc = "î­¾  inner key from kv pair",
--     lhs = "ik",
--     mode = "o",
--     name = "<Cmd>lua require('various-textobjs').key('inner')<CR>"
--   }, {
--     desc = "î­¾  inner underscore",
--     lhs = "i_",
--     mode = "o",
--     name = ""
--   }, {
--     desc = "inner closedFold textobj",
--     lhs = "iz",
--     mode = "o",
--     name = "<Cmd>lua require('various-textobjs').closedFold('inner')<CR>"
--   }, {
--     desc = "î­¾  inner value from kv pair",
--     lhs = "iv",
--     mode = "o",
--     name = "<Cmd>lua require('various-textobjs').value('inner')<CR>"
--   }, {
--     desc = "inner filepath textobj",
--     lhs = "iF",
--     mode = "o",
--     name = "<Cmd>lua require('various-textobjs').filepath('inner')<CR>"
--   }, {
--     desc = "inner color textobj",
--     lhs = "i#",
--     mode = "o",
--     name = "<Cmd>lua require('various-textobjs').color('inner')<CR>"
--   }, {
--     desc = "inner argument textobj",
--     lhs = "i,",
--     mode = "o",
--     name = "<Cmd>lua require('various-textobjs').argument('inner')<CR>"
--   }, {
--     desc = "ï£¯ Select an |open-to-close-block| like built-in |ib|",
--     lhs = "i%",
--     mode = "o",
--     name = "<Plug>(matchup-i%)"
--   }, {
--     lhs = "iu",
--     mode = "o",
--     name = ':<C-U>lua require("treesitter._textobjects.unit").select()<CR>'
--   }, {
--     desc = "î­¾  around prev textobject",
--     lhs = "aN",
--     mode = "x",
--     name = ""
--   }, {
--     desc = "î­¾  around next textobject",
--     lhs = "an",
--     mode = "x",
--     name = ""
--   }, {
--     desc = "Around textobject",
--     lhs = "a",
--     mode = "x"
--   }, {
--     desc = "outer chainMember textobj",
--     lhs = "am",
--     mode = "x",
--     name = "<Cmd>lua require('various-textobjs').chainMember('outer')<CR>"
--   }, {
--     desc = "î­¾  around key from kv pair",
--     lhs = "ak",
--     mode = "x",
--     name = "<Cmd>lua require('various-textobjs').key('outer')<CR>"
--   }, {
--     desc = "î­¾  around underscore",
--     lhs = "a_",
--     mode = "x",
--     name = ""
--   }, {
--     desc = "outer closedFold textobj",
--     lhs = "az",
--     mode = "x",
--     name = "<Cmd>lua require('various-textobjs').closedFold('outer')<CR>"
--   }, {
--     desc = "î­¾  around value from kv pair",
--     lhs = "av",
--     mode = "x",
--     name = "<Cmd>lua require('various-textobjs').value('outer')<CR>"
--   }, {
--     desc = "outer filepath textobj",
--     lhs = "aF",
--     mode = "x",
--     name = "<Cmd>lua require('various-textobjs').filepath('outer')<CR>"
--   }, {
--     desc = "outer color textobj",
--     lhs = "a#",
--     mode = "x",
--     name = "<Cmd>lua require('various-textobjs').color('outer')<CR>"
--   }, {
--     desc = "outer argument textobj",
--     lhs = "a,",
--     mode = "x",
--     name = "<Cmd>lua require('various-textobjs').argument('outer')<CR>"
--   }, {
--     desc = "ï£¯ Select an |any-block| like built-in |ab|",
--     lhs = "a%",
--     mode = "x",
--     name = "<Plug>(matchup-a%)"
--   }, {
--     lhs = "au",
--     mode = "x",
--     name = ':lua require("treesitter._textobjects.unit").select(true)<CR>'
--   }, {
--     desc = "Select Hunk textobject",
--     lhs = "ih",
--     mode = "x"
--   }, {
--     desc = "î­¾  inside prev textobject",
--     lhs = "iN",
--     mode = "x",
--     name = ""
--   }, {
--     desc = "î­¾  inside next textobject",
--     lhs = "in",
--     mode = "x",
--     name = ""
--   }, {
--     desc = "Inside textobject",
--     lhs = "i",
--     mode = "x"
--   }, {
--     desc = "inner chainMember textobj",
--     lhs = "im",
--     mode = "x",
--     name = "<Cmd>lua require('various-textobjs').chainMember('inner')<CR>"
--   }, {
--     desc = "î­¾  inner key from kv pair",
--     lhs = "ik",
--     mode = "x",
--     name = "<Cmd>lua require('various-textobjs').key('inner')<CR>"
--   }, {
--     desc = "î­¾  inner underscore",
--     lhs = "i_",
--     mode = "x",
--     name = ""
--   }, {
--     desc = "inner closedFold textobj",
--     lhs = "iz",
--     mode = "x",
--     name = "<Cmd>lua require('various-textobjs').closedFold('inner')<CR>"
--   }, {
--     desc = "î­¾  inner value from kv pair",
--     lhs = "iv",
--     mode = "x",
--     name = "<Cmd>lua require('various-textobjs').value('inner')<CR>"
--   }, {
--     desc = "inner filepath textobj",
--     lhs = "iF",
--     mode = "x",
--     name = "<Cmd>lua require('various-textobjs').filepath('inner')<CR>"
--   }, {
--     desc = "inner color textobj",
--     lhs = "i#",
--     mode = "x",
--     name = "<Cmd>lua require('various-textobjs').color('inner')<CR>"
--   }, {
--     desc = "inner argument textobj",
--     lhs = "i,",
--     mode = "x",
--     name = "<Cmd>lua require('various-textobjs').argument('inner')<CR>"
--   }, {
--     desc = "ï£¯ Select an |open-to-close-block| like built-in |ib|",
--     lhs = "i%",
--     mode = "x",
--     name = "<Plug>(matchup-i%)"
--   }, {
--     lhs = "iu",
--     mode = "x",
--   } }
