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
}

local yanky = require("yanky")
yanky.register_plugs()
yanky.setup(cfg)

-- local map = vim.keymap.set
local map = require("lib.mapper").map

-- gp = "GPutAfter",
-- gP = "GPutBefore",

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
