local default = {
  ring = {
    history_length = 100,
    storage = 'shada',
    storage_path = vim.fn.stdpath('data') .. '/databases/yanky.db', -- Only for sqlite storage
    sync_with_numbered_registers = true,
    cancel_event = 'update',
    ignore_registers = { '_' },
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
    storage = 'shada', -- shada, sqlite, memory
    storage_path = vim.fn.stdpath('data') .. '/databases/yanky.sqlite3', -- Only for sqlite storage
    sync_with_numbered_registers = true,
    cancel_event = 'update',
    ignore_registers = { '_' },
    update_register_on_cycle = false,
  },
  highlight = {
    on_put = true,
    on_yank = true,
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

local yanky = require('yanky')
yanky.register_plugs()
yanky.setup(cfg)

-- local map = vim.keymap.set
local map = require('mapper').map

-- gp = "GPutAfter",
-- gP = "GPutBefore",

local yanky_cycle = function(direction)
  local history = require('yanky.history')
  local count = history.storage.length()
  if direction == 'next' then
    vim.cmd([[ execute "normal! \<Plug>(YankyCycleForward)" ]])
  else
    vim.cmd([[ execute "normal! \<Plug>(YankyCycleBackward)" ]])
  end
  if history.position > 1 and history.position < count then
    vim.notify(history.position .. '/' .. count .. ' yank ring', vim.log.levels.INFO)
  end
end

---ensures unique keymaps https://www.reddit.com/r/neovim/comments/16h2lla/can_you_make_neovim_warn_you_if_your_config_maps/
---@alias vimMode "n"|"v"|"x"|"i"|"o"|"c"|"t"|"ia"|"ca"|"!a"
---@param modes vimMode|vimMode[]
---@param lhs string
---@param rhs string|function
---@param opts? { unique: boolean, desc: string, buffer: boolean, nowait: boolean, remap: boolean }
function uniqueKeymap(modes, lhs, rhs, opts)
  if not opts then
    opts = {}
  end
  if opts.unique == nil then
    opts.unique = true
  end
  vim.keymap.set(modes, lhs, rhs, opts)
end

local keymap = uniqueKeymap
-- do not clutter register with x
-- keymap({ 'n', 'x' }, 'x', '"_x')
-- do not clutter register with c/C (like substitute command)
keymap({ 'n', 'x' }, 'c', '"_c')
keymap('n', 'C', '"_C')

-- do not clutter the register if blank line is deleted
keymap('n', 'dd', function()
  if vim.api.nvim_get_current_line():find('^%s*$') then
    return '"_dd'
  end
  return 'dd'
end, { expr = true })

-- stylua: ignore start
-- base mappings
map({'n','o', 'x'}, 'y', '<Plug>(YankyYank)', { desc = ' sticky yank',  silent = true })
map('n', 'yil', 'v0o$y', { category = 'Motion', desc = ' yank in line', silent = true }) -- <cmd>normal yy<cr>
map('n', 'yy',  'v0o$y', { category = 'Motion', desc = ' yank in line'  })
-- map({'n', 'x'}, 'y',         'ygv<esc>',  category = 'Motion', label = 'yank keep cursor begin', desc = '  yank maintaining cursor start position', silent = true })
-- map('n', 'yy', 'mQ0y$`Q',                { category = 'Motion', label = 'yank in line no eol',    desc = '  yank in line no eol' })
map('n', 'p', '<Plug>(YankyPutAfter)',  { desc = ' paste (yanky)',  silent = true })
map('n', 'P', '<Plug>(YankyPutBefore)', { desc = ' paste & indent', silent = true })
map('n', '<M-C-P>',  '<cmd>lua require("configs.yanky").yanky_cycle("prev")<cr>', { desc = ' cycle killring backward', silent = true })
map('n', '<M-C-N>',  '<cmd>lua require("configs.yanky").yanky_cycle("next")<cr>',  { desc = ' cycle killring forward', silent = true })
map({'o', 'x'}, '<leader>pl','<cmd>lua require("yanky.textobj").last_put()<cr>',  { desc = ' put last yanked text object', silent = true })

-- unimpaired-like mappings
map("n", "]p", "<Plug>(YankyPutIndentAfterLinewise)",   { desc = ' paste & indent after (linewise)' })
map("n", "[p", "<Plug>(YankyPutIndentBeforeLinewise)",  { desc = ' paste & indent before (linewise)' })
map("n", "]P", "<Plug>(YankyPutIndentAfterLinewise)",   { desc = ' paste & indent after (blockwise)' })
map("n", "[P", "<Plug>(YankyPutIndentBeforeLinewise)",  { desc = ' paste & indent before (blockwise)' })
map("n", "<p", "<Plug>(YankyPutBeforeCharwiseJoined)",  { desc = ' paste before (charwise)' })
map("n", ">p", "<Plug>(YankyPutAfterCharwiseJoined)",   { desc = ' paste after (charwise)' })
map("n", "<P", "<Plug>(YankyPutBeforeCharwise)",        { desc = ' paste before (charwise joined)' })
map("n", ">P", "<Plug>(YankyPutAfterCharwise)",         { desc = ' paste after (charwise joined)' })
map("n", "=p", "<Plug>(YankyPutAfterFilter)",           { desc = ' paste & reindent after line' })
map("n", "=P", "<Plug>(YankyPutBeforeFilter)",          { desc = ' paste & reindent before line' })

map('n', 'gcp', '<cmd>norm p`[V`]gc`[<cr>', { category = 'Motion',   desc = ' paste as a comment' })
map('n', 'gcP', '<cmd>norm p`[v`]gc`[<cr>', { category = 'Motion',   desc = ' paste as a comment' })
map('n', '<leader>pc', '<cmd>normal p`[v`]gc<cr>', { category = 'Motion',  desc = ' paste as a comment' })
map('n', '<leader>pp', '"*p',                      { category = 'Motion',  desc = ' paste primary (*) clipboard register' })
map('n', '<leader>pm', '<cmd>set invpaste<cr>',    { category = 'Motion',  desc = ' toggle paste mode' })

map("i", "<M-p>", function()
  local regContent = vim.trim(vim.fn.getreg("+"))
  vim.fn.setreg("+", regContent, "v") ---@diagnostic disable-line: param-type-mismatch
  return "<C-g>u<C-r><C-o>+" -- "<C-g>u" adds undopoint before the paste
end, { desc = " paste charwise", expr = true })

return { yanky_cycle = yanky_cycle }

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
