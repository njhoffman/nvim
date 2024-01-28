require('spider').setup({
  -- if setting this to false, have to do cw/dw fix
  skipInsignificantPunctuation = false,
  jumpSubWords = true,
})

-- fix cw/dw operator behavior
local map_w_type = 3 -- 1/2/3

local mapper = require('mapper')
local spider_map = function(modes, key, cmd_key, opts)
  -- NOTE: for dot repeat to work, must be in form of Ex-commands
  mapper.map(
    modes,
    key,
    "<cmd>lua require('spider').motion('" .. cmd_key .. "')<CR>",
    vim.tbl_extend(
      'force',
      { desc = '󱇫 spider-' .. cmd_key .. ' motion', silent = true, category = 'Motion', plugin = 'nvim-spider' },
      opts or {}
    )
  )
end

spider_map({ 'n', 'o', 'x' }, 'e', 'e')
spider_map({ 'n', 'o', 'x' }, 'b', 'b')
spider_map({ 'n', 'o', 'x' }, 'ge', 'ge')

-- stylua: ignore
if map_w_type == 1 then
  -- map operator w to spider-e
  spider_map({ 'o'},       'w', 'e', { desc = '󱇫 spider-w(e) motion' })
  spider_map({ 'n', 'x' }, 'w', 'w')
elseif map_w_type == 2 then
  -- map operator w stays default, operator W to spider-w
  spider_map({ 'o' },      'w', 'e', { desc = '󱇫 spider-w(e) motion' })
  -- spider_map({ 'o' },      'W', 'w', { desc = '󱇫 spider-w(e) motion' })
  spider_map('n', 'w', 'w')
  -- spider_map('x', 'w', 'w')
  -- spider_map('o', 'w', 'w')
elseif map_w_type == 3 then
  -- directly map cw/dw to ce/de
  mapper.map(
    'o',
    'cw',
    'ce',
    { desc = '󱇫 spider-ce motion', plugin = 'nvim-spider', category = 'Motion', remap = true }
  )
  mapper.map(
    'o',
    'dw',
    'de',
    { desc = '󱇫 spider-de motion', plugin = 'nvim-spider', category = 'Motion', remap = true }
  )
else
  -- default spider-w behavior (cw/dw deletes eol)
  spider_map({ 'n', 'x', 'o' }, 'w', 'w')
end
