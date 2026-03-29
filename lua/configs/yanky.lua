-- keys = {
--   {
--     '<leader>p',
--     function()
--       require('telescope').extensions.yank_history.yank_history({})
--     end,
--     desc = 'Open Yank History',
--   },
--   { 'y', '<Plug>(YankyYank)', mode = { 'n', 'x' }, desc = 'Yank text' },
--   { 'p', '<Plug>(YankyPutAfter)', mode = { 'n', 'x' }, desc = 'Put yanked text after cursor' },
--   { 'P', '<Plug>(YankyPutBefore)', mode = { 'n', 'x' }, desc = 'Put yanked text before cursor' },
--   { 'gp', '<Plug>(YankyGPutAfter)', mode = { 'n', 'x' }, desc = 'Put yanked text after selection' },
--   { 'gP', '<Plug>(YankyGPutBefore)', mode = { 'n', 'x' }, desc = 'Put yanked text before selection' },
--   { '<c-p>', '<Plug>(YankyPreviousEntry)', desc = 'Select previous entry through yank history' },
--   { '<c-n>', '<Plug>(YankyNextEntry)', desc = 'Select next entry through yank history' },
--   { ']p', '<Plug>(YankyPutIndentAfterLinewise)', desc = 'Put indented after cursor (linewise)' },
--   { '[p', '<Plug>(YankyPutIndentBeforeLinewise)', desc = 'Put indented before cursor (linewise)' },
--   { ']P', '<Plug>(YankyPutIndentAfterLinewise)', desc = 'Put indented after cursor (linewise)' },
--   { '[P', '<Plug>(YankyPutIndentBeforeLinewise)', desc = 'Put indented before cursor (linewise)' },
--   { '>p', '<Plug>(YankyPutIndentAfterShiftRight)', desc = 'Put and indent right' },
--   { '<p', '<Plug>(YankyPutIndentAfterShiftLeft)', desc = 'Put and indent left' },
--   { '>P', '<Plug>(YankyPutIndentBeforeShiftRight)', desc = 'Put before and indent right' },
--   { '<P', '<Plug>(YankyPutIndentBeforeShiftLeft)', desc = 'Put before and indent left' },
--   { '=p', '<Plug>(YankyPutAfterFilter)', desc = 'Put after applying a filter' },
--   { '=P', '<Plug>(YankyPutBeforeFilter)', desc = 'Put before applying a filter' },
-- },
local default = {
  ring = {
    history_length = 100,
    storage = "shada",
    storage_path = vim.fn.stdpath("data") .. "/databases/yanky.db", -- Only for sqlite storage
    sync_with_numbered_registers = true,
    cancel_event = "update",
    ignore_registers = { "_" },
    update_register_on_cycle = false,
  },
  picker = {
    select = {
      action = nil, -- nil to use default put action
    },
    telescope = {
      use_default_mappings = true, -- if default mappings should be used
      mappings = nil, -- nil to use default mappings or no mappings (see `use_default_mappings`)
    },
  },
  system_clipboard = {
    sync_with_ring = true,
  },
  highlight = {
    on_put = true,
    on_yank = true,
    timer = 500,
  },
  preserve_cursor_position = {
    enabled = true,
  },
  textobj = {
    enabled = true,
  },
}
-- textobj = {
--   enabled = true,
-- },

local cfg = {
  ring = {
    history_length = 100,
    storage = "shada", -- shada, sqlite, memory
    storage_path = vim.fn.stdpath("data") .. "/databases/yanky.sqlite3", -- Only for sqlite storage
    sync_with_numbered_registers = true,
    cancel_event = "update",
    ignore_registers = { "_" },
    update_register_on_cycle = false,
  },
  -- tiny-glimmer handles highlights
  highlight = {
    on_put = false,
    on_yank = false,
    timer = 200,
  },
  system_clipboard = {
    sync_with_ring = true,
  },
  textobj = {
    enabled = true,
  },
  preserve_cursor_position = {
    enabled = true,
  },
  -- picker = {
  --   -- select = {
  --   -- 	action = require("yanky.picker").actions.put("p"),
  --   -- },
  --   telescope = {
  --     mappings = {
  --       default = mapping.put('p'),
  --       i = {
  --         ['<c-p>'] = mapping.put('p'),
  --         ['<c-k>'] = mapping.put('P'),
  --         ['<c-x>'] = mapping.delete(),
  --         ['<c-r>'] = mapping.set_register(utils.get_default_register()),
  --       },
  --       n = {
  --         p = mapping.put('p'),
  --         P = mapping.put('P'),
  --         gp = mapping.put('gp'),
  --         gP = mapping.put('gP'),
  --         d = mapping.delete(),
  --         r = mapping.set_register(utils.get_default_register()),
  --       },
  --     },
  --   },
  -- },
}

local yanky = require("yanky")
yanky.register_plugs()
yanky.setup(cfg)

-- local map = vim.keymap.set
local map = require("mapper").map

-- gp = "GPutAfter",
-- gP = "GPutBefore",

-- local yanky_cycle = function(direction)
--   local history = require("yanky.history")
--   local count = history.storage.length()
--   if direction == "next" then
--     vim.cmd([[ execute "normal! \<Plug>(YankyCycleForward)" ]])
--   else
--     vim.cmd([[ execute "normal! \<Plug>(YankyCycleBackward)" ]])
--   end
--   if history.position > 1 and history.position < count then
--     vim.notify(history.position .. "/" .. count .. " yank ring", vim.log.levels.INFO)
--   end
-- end

-- do not clutter register with x
-- keymap({ 'n', 'x' }, 'x', '"_x')
-- do not clutter register with c/C (like substitute command)
map({ "n", "x" }, "c", '"_c', { unique = true, nowait = true, desc = "Change to black hole register" })
map("n", "C", '"_C', { unique = true, nowait = true, desc = "Change to end to black hole register" })

-- do not clutter the register if blank line is deleted
map("n", "dd", function()
  if vim.api.nvim_get_current_line():find("^%s*$") then
    return '"_dd'
  end
  return "dd"
end, { unique = true, expr = true, nowait = true, desc = "Smart dd (blank line to black hole)" })

--  TODO: gcp/gcP/gbp/gbP new line with indent, gc< and gb< inline

-- stylua: ignore start
-- base mappings
map({'n','o', 'x'}, 'y', '<Plug>(YankyYank)', { desc = '  sticky yank',  silent = true })
-- map('n', 'yil', 'v0o$y', { category = 'Motion', desc = '  yank in line', silent = true }) -- <cmd>normal yy<cr>
map('n', 'yy',  'v0o$y', { category = 'Motion', desc = '  yank in line'  })
-- map({'n', 'x'}, 'y',         'ygv<esc>',  category = 'Motion', label = 'yank keep cursor begin', desc = '  yank maintaining cursor start position', silent = true })
-- map('n', 'yy', 'mQ0y$`Q',                { category = 'Motion', label = 'yank in line no eol',    desc = '  yank in line no eol' })

map('n', '<leader>p[',  '<cmd>lua require("configs.yanky").yanky_cycle("prev")<cr>', { desc = '  cycle killring backward', silent = true })
map('n', '<leader>p]',  '<cmd>lua require("configs.yanky").yanky_cycle("next")<cr>',  { desc = '  cycle killring forward', silent = true })

map({'o', 'x'}, '<leader>pl','<cmd>lua require("yanky.textobj").last_put()<cr>',  { desc = '  put last yanked text object', silent = true })

map({"n","x"}, '<M-p>', '<Plug>(YankyPutAfterFilter)', { desc = '  put yanked text after selection' })
map({"n","x"}, '<M-C-P>', '<Plug>(YankyPutBeforeFilter)', { desc = '  put yanked text after selection' })

-- unimpaired-like mappings
map({"n","x"}, 'p', '<Plug>(YankyPutAfter)',                    { desc = '  paste (yanky)',  silent = true })
map({"n","x"}, 'P', '<Plug>(YankyPutBefore)',                   { desc = '  paste & indent', silent = true })
map({"n","x"}, "[p", "<Plug>(YankyGPutAfterFilter)",   { desc = '  put yanked text after selection' })
map({"n","x"}, "[P", "<Plug>(YankyGPutBeforeFilter)",         { desc = "  put yanked text before selection" })
map({"n","x"}, "]p", "<Plug>(YankyPutIndentAfterLinewise)",    { desc = '  paste & indent after (linewise)' })
map({"n","x"}, "]P", "<Plug>(YankyPutIndentBeforeLinewise)",           { desc = "  paste & indent before (linewise)" })
-- { "gp", "<Plug>(YankyGPutAfter)", mode = { "n", "x" }, desc = "Put yanked text after selection" },
-- { "gP", "<Plug>(YankyGPutBefore)", mode = { "n", "x" }, desc = "Put yanked text before selection" },
-- map("n", "]P", "<Plug>(YankyPutIndentAfterBlockwise)",   { desc = '  paste & reindent after (blockwise)' })
-- map("n", "[P", "<Plug>(YankyPutIndentBeforeBlockwise)",  { desc = '  paste & reindent before (blockwise)' })
-- map("n", "=p", "<Plug>(YankyPutAfterFilter)",            { desc = '  paste & reindent after line' })
-- map("n", "=P", "<Plug>(YankyPutBeforeFilter)",           { desc = '  paste & reindent before line' })

map("n", "=p", "<Plug>(YankyPutIndentAfterBlockwise)",            { desc = '  paste & reindent after line' })
map("n", "=P", "<Plug>(YankyPutIndentBeforeBlockwise)",           { desc = '  paste & reindent before line' })
map("n", "<p", "<Plug>(YankyPutBeforeCharwiseJoined)",   { desc = '  paste before (charwise joined)' })
map("n", ">p", "<Plug>(YankyPutAfterCharwiseJoined)",    { desc = '  paste after (charwise joined)' })
map("n", "<P", "<Plug>(YankyPutBeforeCharwise)",         { desc = '  paste before (charwise)' })
map("n", ">P", "<Plug>(YankyPutAfterCharwise)",          { desc = '  paste after (charwise)' })
--   require("yanky.picker").actions.put("gp") -- put after cursor and leave the cursor after
--   require("yanky.picker").actions.put("gP") -- put before cursor and leave the cursor after
map('n', '<leader>pp', '"*p',                            { category = 'Motion',  desc = '  paste primary (*) clipboard register' })
map('n', '<leader>pm', '<cmd>set invpaste<cr>',          { category = 'Motion',  desc = '  toggle paste mode' })
map("i", "<M-p>", function()
  local regContent = vim.trim(vim.fn.getreg("+"))
  vim.fn.setreg("+", regContent, "v") ---@diagnostic disable-line: param-type-mismatch
  return "<C-g>u<C-r><C-o>+" -- "<C-g>u" adds undopoint before the paste
end, { desc = "  paste charwise", expr = true })

return { yanky_cycle = yanky_cycle }

-- vim.api.nvim_create_autocmd("TextYankPost", {
-- 	desc = "User: Highlighted Yank",
-- 	callback = function() vim.highlight.on_yank { timeout = 1000 } end,
-- })
--
-- --------------------------------------------------------------------------------
-- -- STICKY YANK
--
-- do
-- 	local cursorBefore
-- 	keymap({ "n", "x" }, "y", function()
-- 		cursorBefore = vim.api.nvim_win_get_cursor(0)
-- 		return "y"
-- 	end, { expr = true })
-- 	keymap("n", "Y", function()
-- 		cursorBefore = vim.api.nvim_win_get_cursor(0)
-- 		return "y$"
-- 	end, { expr = true, unique = false }) -- `unique`, since it's a nvim-builtin
--
-- 	vim.api.nvim_create_autocmd("TextYankPost", {
-- 		desc = "User: Sticky yank/delete",
-- 		callback = function()
-- 			if vim.v.event.regname ~= "" or not cursorBefore then return end
--
-- 			if vim.v.event.operator == "y" then vim.api.nvim_win_set_cursor(0, cursorBefore) end
-- 		end,
-- 	})
-- end
--
-- --------------------------------------------------------------------------------
-- -- KEEP THE REGISTER CLEAN
--
-- keymap({ "n", "x" }, "x", '"_x')
-- keymap({ "n", "x" }, "c", '"_c')
-- keymap("n", "C", '"_C')
-- keymap("x", "p", "P")
-- keymap("n", "dd", function()
-- 	local lineEmpty = vim.trim(vim.api.nvim_get_current_line()) == ""
-- 	return (lineEmpty and '"_dd' or "dd")
-- end, { expr = true })
--
-- -- PASTING
-- keymap("n", "P", function()
-- 	local curLine = vim.api.nvim_get_current_line():gsub("%s*$", "")
-- 	local reg = vim.trim(vim.fn.getreg("+"))
-- 	vim.api.nvim_set_current_line(curLine .. " " .. reg)
-- end, { desc = " Sticky paste at EoL" })
--
-- keymap("i", "<D-v>", function()
-- 	local reg = vim.trim(vim.fn.getreg("+")):gsub("\n%s*$", "\n") -- remove indentation if multi-line
-- 	vim.fn.setreg("+", reg, "v")
-- 	return "<C-g>u<C-r><C-o>+" -- `<C-g>u` adds undopoint before the paste
-- end, { desc = " Paste charwise", expr = true })
--
-- -- for compatibility with macOS clipboard managers
-- keymap("n", "<D-v>", "p", { desc = " Paste" })
--
-- --------------------------------------------------------------------------------
-- -- SPECIAL YANK OPERATIONS
--
-- keymap("n", "<leader>yl", function()
-- 	-- not using `:glocal // yank` because it yanks lines one after the other
-- 	vim.ui.input({ prompt = "󰅍 Yank lines matching:" }, function(input)
-- 		if not input then return end
-- 		local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
-- 		local matchLines = vim.tbl_filter(function(l) return l:find(input, nil, true) end, lines)
-- 		vim.fn.setreg("+", table.concat(matchLines, "\n"))
-- 		local pluralS = #matchLines == 1 and "" or "s"
-- 		local msg = ("%d line%s"):format(#matchLines, pluralS)
-- 		vim.notify(msg, nil, { title = "Copied", icon = "󰅍" })
-- 	end)
-- end, { desc = "󰦨 Lines matching pattern" })
--
-- keymap("n", "<leader>y:", function()
-- 	local lastCmd = vim.fn.getreg(":"):gsub("^lua ?", "")
-- 	vim.fn.setreg("+", lastCmd)
-- 	vim.notify(lastCmd, nil, { title = "Copied", icon = "󰅍" })
-- end, { desc = "󰘳 Last :excmd" })
-- Linewise put        : this will force put above or below the current line ;
-- Shift right/left put: will put above or below the current line and increasing or decreasing indent ;
-- Filter put          : will put above or below the current line and reindenting.
--
--   Yanky(put-type)(modifier)(rewriter)
-- put-type can be:
--   PutAfter       : put after your cursor (as p key) ;
--   PutBefore      : put before your cursor (as P key) ;
--   GPutAfter      : like PutAfter but leave the cursor after the new text (as gp key) ;
--   GPutBefore     : like PutBefore but leave the cursor after the new text (as gP key) ;
--   PutIndentAfter : like PutAfter but adjust the indent to the current line (as ]p key) ;
--   PutIndentBefore: like PutBefore but adjust the indent to the current line (as [p key) ;
-- modifier (optional) can be:
--   Linewise  : put in linewise mode ;
--   Charwise  : put in charwise mode ;
--   Blockwise : put in blockwise mode ;
--   ShiftRight: increase indent ;
--   ShiftLeft : decrease indent.
-- rewriter (optional) can be:
--   Joined: put lines trimed and joined.
-- telescope actions:
--   require("yanky.picker").actions.put("p") -- put after cursor
--   require("yanky.picker").actions.put("P") -- put before cursor
--   require("yanky.picker").actions.put("gp") -- put after cursor and leave the cursor after
--   require("yanky.picker").actions.put("gP") -- put before cursor and leave the cursor after
--   require("yanky.picker").actions.delete() -- delete entry from yank history
--   require("yanky.picker").actions.set_register(regname) -- fill register with selected value
--   require("yanky.picker").actions.put_and_set_register("p", regname) -- put and fill register with selected value

-- YankyPutAfter                         YankyPutBefore
-- YankyPutAfterBlockwise                YankyPutBeforeBlockwise
-- YankyPutAfterBlockwiseJoined          YankyPutBeforeBlockwiseJoined
-- YankyPutAfterCharwise                 YankyPutBeforeCharwise
-- YankyPutAfterCharwiseJoined           YankyPutBeforeCharwiseJoined
-- YankyPutAfterFilter                   YankyPutBeforeFilter
-- YankyPutAfterFilterJoined             YankyPutBeforeFilterJoined
-- YankyPutAfterJoined                   YankyPutBeforeJoined
-- YankyPutAfterLinewise                 YankyPutBeforeLinewise
-- YankyPutAfterLinewiseJoined           YankyPutBeforeLinewiseJoined
--
-- YankyGPutAfter                        YankyGPutBefore
-- YankyGPutAfterBlockwise               YankyGPutBeforeBlockwise
-- YankyGPutAfterBlockwiseJoined         YankyGPutBeforeBlockwiseJoined
-- YankyGPutAfterCharwise                YankyGPutBeforeCharwise
-- YankyGPutAfterCharwiseJoined          YankyGPutBeforeCharwiseJoined
-- YankyGPutAfterFilter                  YankyGPutBeforeFilter
-- YankyGPutAfterFilterJoined            YankyGPutBeforeFilterJoined
-- YankyGPutAfterJoined                  YankyGPutBeforeJoined
-- YankyGPutAfterLinewise                YankyGPutBeforeLinewise
-- YankyGPutAfterLinewiseJoined          YankyGPutBeforeLinewiseJoined
--
-- YankyPutIndentAfter                    YankyPutIndentBefore
-- YankyPutIndentAfterBlockwise           YankyPutIndentBeforeBlockwise
-- YankyPutIndentAfterBlockwiseJoined     YankyPutIndentBeforeBlockwiseJoined
-- YankyPutIndentAfterCharwise            YankyPutIndentBeforeCharwise
-- YankyPutIndentAfterCharwiseJoined      YankyPutIndentBeforeCharwiseJoined
-- YankyPutIndentAfterFilter              YankyPutIndentBeforeFilter
-- YankyPutIndentAfterFilterJoined        YankyPutIndentBeforeFilterJoined
-- YankyPutIndentAfterJoined              YankyPutIndentBeforeJoined
-- YankyPutIndentAfterLinewise            YankyPutIndentBeforeLinewise
-- YankyPutIndentAfterLinewiseJoined      YankyPutIndentBeforeLinewiseJoined

-- YankyPutAfterShiftLeft                YankyPutBeforeShiftLeft
-- YankyPutAfterShiftLeftJoined          YankyPutBeforeShiftLeftJoined
-- YankyPutAfterShiftRight               YankyPutBeforeShiftRight
-- YankyPutAfterShiftRightJoined         YankyPutBeforeShiftRightJoined
-- YankyGPutAfterShiftLeft               YankyGPutBeforeShiftLeft
-- YankyGPutAfterShiftLeftJoined         YankyGPutBeforeShiftLeftJoined
-- YankyGPutAfterShiftRight              YankyGPutBeforeShiftRight
-- YankyGPutAfterShiftRightJoined        YankyGPutBeforeShiftRightJoined
-- YankyPutIndentAfterShiftLeft          YankyPutIndentBeforeShiftLeft
-- YankyPutIndentAfterShiftLeftJoined    YankyPutIndentBeforeShiftLeftJoined
-- YankyPutIndentAfterShiftRight         YankyPutIndentBeforeShiftRight
-- YankyPutIndentAfterShiftRightJoined   YankyPutIndentBeforeShiftRightJoined
