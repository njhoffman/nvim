local miniclue = require('mini.clue')
local mapper_clues = require('mapper').clues or {}
local clues = {
  miniclue.gen_clues.builtin_completion(),
  miniclue.gen_clues.g(),
  miniclue.gen_clues.marks(),
  -- miniclue.gen_clues.registers(),
  miniclue.gen_clues.windows({
    submode_move = true,
    submode_navigate = true,
    submode_resize = true,
  }),
  miniclue.gen_clues.z(),
  mapper_clues,
}

local logger = require('logger').init('miniclue')

local get_count = function(_clues)
  local count = { total = 0 }
  for _, clue in ipairs(_clues) do
    for _, trigger in ipairs(clue) do
      if vim.tbl_islist(trigger) then
        for _, subtrigger in ipairs(trigger) do
          count.total = count.total + 1
          if type(subtrigger.mode) == 'nil' then
            logger:debug('no mode assigned: ' .. vim.inspect(subtrigger))
          elseif type(count[subtrigger.mode]) ~= 'number' then
            count[subtrigger.mode] = 1
          else
            count[subtrigger.mode] = count[subtrigger.mode] + 1
          end
        end
      else
        count.total = count.total + 1
        if type(trigger.mode) == 'nil' then
          logger:debug('no mode assigned: ' .. vim.inspect(trigger))
        elseif type(count[trigger.mode]) ~= 'number' then
          count[trigger.mode] = 1
        else
          count[trigger.mode] = count[trigger.mode] + 1
        end
      end
    end
  end
  return count
end

local count = get_count(clues)
logger:debug('loading with ' .. count.total .. ' keys: ' .. vim.inspect(count):gsub('\n', ' '):gsub(' ', ''))

miniclue.setup({
  triggers = {
    -- Leader triggers
    { mode = 'n', keys = '<leader>' },
    { mode = 'x', keys = '<leader>' },

    -- Built-in completion
    { mode = 'i', keys = '<C-x>' },

    -- `g` key
    { mode = 'n', keys = 'g' },
    { mode = 'x', keys = 'g' },

    -- Marks
    { mode = 'n', keys = "'" },
    { mode = 'n', keys = '`' },
    { mode = 'x', keys = "'" },
    { mode = 'x', keys = '`' },

    -- Registers
    -- { mode = 'n', keys = '"' },
    -- { mode = 'x', keys = '"' },
    -- { mode = 'i', keys = '<C-r>' },
    -- { mode = 'c', keys = '<C-r>' },

    -- Window commands
    { mode = 'n', keys = '<C-w>' },

    -- `z` key
    { mode = 'n', keys = 'z' },
    { mode = 'x', keys = 'z' },
  },
  clues = clues,
  window = {
    -- Floating window config
    config = {
      width = math.min(40, math.floor(tonumber(vim.o.columns * 0.4))),
      row = 'auto',
      col = 'auto',
    },
    -- Delay before showing clue window
    delay = 1000,
    -- Keys to scroll inside the clue window
    scroll_down = '<M-f>',
    scroll_up = '<M-b>',
  },
})

-- require('mini.bracketed').setup()
-- require('mini.clue').setup({
--   triggers = {
--     { mode = 'n', keys = ']' },
--     { mode = 'n', keys = '[' },
--   },
--   clues = {
--     { mode = 'n', keys = ']b', postkeys = ']' },
--     { mode = 'n', keys = ']w', postkeys = ']' },
--
--     { mode = 'n', keys = '[b', postkeys = '[' },
--     { mode = 'n', keys = '[w', postkeys = '[' },
--   },
-- })

-- local nmap_leader = function(suffix, rhs, desc)
--   vim.keymap.set('n', '<Leader>' .. suffix, rhs, { desc = desc })
-- end
-- local xmap_leader = function(suffix, rhs, desc)
--   vim.keymap.set('x', '<Leader>' .. suffix, rhs, { desc = desc })
-- end
-- nmap_leader('bd', '<Cmd>lua MiniBufremove.delete()<CR>',  'Delete')
-- nmap_leader('bw', '<Cmd>lua MiniBufremove.wipeout()<CR>', 'Wipeout')
-- nmap_leader('lf', '<Cmd>lua vim.lsp.buf.format()<CR>',     'Format')
-- xmap_leader('lf', '<Cmd>lua vim.lsp.buf.format()<CR>',     'Format')
-- nmap_leader('lr', '<Cmd>lua vim.lsp.buf.rename()<CR>',     'Rename')
-- nmap_leader('lR', '<Cmd>lua vim.lsp.buf.references()<CR>', 'References')
-- miniclue.enable_all_triggers()
-- # Leader clues ~
--
-- Assume there are these |<Leader>| mappings set up: >
--   -- Set `<Leader>` before making any mappings and configuring 'mini.clue'
--   vim.g.mapleader = ' '
--   local nmap_leader = function(suffix, rhs, desc)
--     vim.keymap.set('n', '<Leader>' .. suffix, rhs, { desc = desc })
--   end
--   local xmap_leader = function(suffix, rhs, desc)
--     vim.keymap.set('x', '<Leader>' .. suffix, rhs, { desc = desc })
--   end
--
--   nmap_leader('bd', '<Cmd>lua MiniBufremove.delete()<CR>',  'Delete')
--   nmap_leader('bw', '<Cmd>lua MiniBufremove.wipeout()<CR>', 'Wipeout')
--
--   nmap_leader('lf', '<Cmd>lua vim.lsp.buf.format()<CR>',     'Format')
--   xmap_leader('lf', '<Cmd>lua vim.lsp.buf.format()<CR>',     'Format')
--   nmap_leader('lr', '<Cmd>lua vim.lsp.buf.rename()<CR>',     'Rename')
--   nmap_leader('lR', '<Cmd>lua vim.lsp.buf.references()<CR>', 'References')
--
--
-- The following setup will enable |<Leader>| as trigger in Normal and Visual
-- modes and add descriptions to mapping groups: >
--   require('mini.clue').setup({
--     -- Register `<Leader>` as trigger
--     triggers = {
--       { mode = 'n', keys = '<Leader>' },
--       { mode = 'x', keys = '<Leader>' },
--     },
--
--     -- Add descriptions for mapping groups
--     clues = {
--       { mode = 'n', keys = '<Leader>b', desc = '+Buffers' },
--       { mode = 'n', keys = '<Leader>l', desc = '+LSP' },
--     },
--   })
--
-- # Clues without mappings ~
-- Clues can be shown not only for actually present mappings. This is helpful for
-- showing clues for built-in key combinations. Here is an example of clues for
-- a subset of built-in completion (see |MiniClue.gen_clues.builtin_completion()|
-- to generate clues for all available completion sources): >
--
--   require('mini.clue').setup({
--   })
-- <
--                                                     *MiniClue-examples-submodes*
-- # Submodes ~
--
-- Submode is a state initiated after pressing certain key combination ("prefix")
-- during which some keys are interpreted differently.
--
-- In this module submode can be implemented following these steps:
--
-- - Create mappings for each key inside submode. Left hand side of mappings
--   should consist from prefix followed by the key.
--
-- - Create clue for each key inside submode with `postkeys` value equal to
--   prefix. It would mean that after executing particular key combination from
--   this submode, pressing its prefix will be automatically emulated (leading
--   back to being inside submode).
--
-- - Register submode prefix (or some of its starting part) as trigger.
--
-- ## Submode examples ~
--
-- - Submode for moving with |mini.move|:
--     - Press `<Leader>m` to start submode.
--     - Press any of `h`/`j`/`k`/`l` to move selection/line.
--     - Press `<Esc>` to stop submode.
--
--   The code: >
--
--   require('mini.move').setup({
--     mappings = {
--       left       = '<Leader>mh',
--       right      = '<Leader>ml',
--       down       = '<Leader>mj',
--       up         = '<Leader>mk',
--       line_left  = '<Leader>mh',
--       line_right = '<Leader>ml',
--       line_down  = '<Leader>mj',
--       line_up    = '<Leader>mk',
--     },
--   })
--
--   require('mini.clue').setup({
--     triggers = {
--       { mode = 'n', keys = '<Leader>m' },
--       { mode = 'x', keys = '<Leader>m' },
--     },
--     clues = {
--       { mode = 'n', keys = '<Leader>mh', postkeys = '<Leader>m' },
--       { mode = 'n', keys = '<Leader>mj', postkeys = '<Leader>m' },
--       { mode = 'n', keys = '<Leader>mk', postkeys = '<Leader>m' },
--       { mode = 'n', keys = '<Leader>ml', postkeys = '<Leader>m' },
--       { mode = 'x', keys = '<Leader>mh', postkeys = '<Leader>m' },
--       { mode = 'x', keys = '<Leader>mj', postkeys = '<Leader>m' },
--       { mode = 'x', keys = '<Leader>mk', postkeys = '<Leader>m' },
--       { mode = 'x', keys = '<Leader>ml', postkeys = '<Leader>m' },
--     },
--   })
