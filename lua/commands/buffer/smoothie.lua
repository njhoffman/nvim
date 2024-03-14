local mapper = require('mapper')
local map = mapper.map

local setup_paging = function()
  map('n', '<PageUp>', '<Plug>(SmoothieBackwards)', {
    category = 'Motion',
    plugin = 'vim-smoothie',
    label = ' scroll backwards',
    desc = ' smoothie scroll backwards',
    noremap = false,
    silent = true,
  })
  map('n', '<PageDown>', '<Plug>(SmoothieDownwards)', {
    category = 'Motion',
    plugin = 'vim-smoothie',
    label = ' scroll forwards',
    desc = ' smoothie scroll forwards',
    noremap = false,
    silent = true,
  })
  -- normal! \<C-d>
  map('n', '<C-f>', '<cmd>normal! <C-d><C-d><cr>', {
    category = 'Motion',
    plugin = 'vim-smoothie',
    label = ' scroll forwards',
    desc = ' smoothie scroll forwards',
    remap = true,
    silent = true,
  })

  map('n', '<C-b>', '<cmd>normal! <C-u><C-u><cr>', {
    category = 'Motion',
    plugin = 'vim-smoothie',
    label = ' scroll forwards',
    desc = ' smoothie scroll forwards',
    remap = true,
    silent = true,
  })

  map(
    'n',
    '<space>',
    -- '<Plug>(SmoothieDownwards)<Plug>(SmoothieDownwards)<Plug>(SmoothieDownwards)',
    '<cmd>normal! <C-d><C-d><C-d><cr>',
    {
      category = 'Motion',
      plugin = 'vim-smoothie',
      label = ' scroll forwards x2',
      desc = ' smoothie scroll forwards x2',
      noremap = false,
      silent = true,
    }
  )
  -- map('n', '<M-f>', '<Plug>(SmoothieDownwards)', {
  --   category = 'Motion',
  --   plugin = 'vim-smoothie',
  --   label = ' scroll forwards',
  --   desc = ' smoothie scroll forwards',
  --   noremap = false,
  --   silent = true,
  -- })

  -- map('n', '<M-b>', '<Plug>(SmoothieUpwards)', {
  --   category = 'Motion',
  --   plugin = 'vim-smoothie',
  --   label = ' scroll forwards',
  --   desc = ' smoothie scroll forwards',
  --   noremap = false,
  --   silent = true,
  -- })
  -- map('n', '<M-f>', '<Plug>(SmoothieDownwards)', {
  --   category = 'Motion',
  --   plugin = 'vim-smoothie',
  --   label = ' scroll forwards',
  --   desc = ' smoothie scroll forwards',
  --   noremap = false,
  --   silent = true,
  -- })

  -- map('n', '<M-b>', '<Plug>(SmoothieUpwards)', {
  --   category = 'Motion',
  --   plugin = 'vim-smoothie',
  --   label = ' scroll forwards',
  --   desc = ' smoothie scroll forwards',
  --   noremap = false,
  --   silent = true,
  -- })
end

local function setup_gg()
  map('n', 'gg', '<Plug>(Smoothie_gg)', {
    category = 'Motion',
    plugin = 'vim-smoothie',
    label = ' scroll top',
    desc = ' smoothie scroll to top',
    noremap = false,
    silent = true,
  })
end

local function setup_G()
  map('n', 'G', '<Plug>(Smoothie_G)', {
    category = 'Motion',
    plugin = 'vim-smoothie',
    label = ' scroll bottom',
    desc = ' smoothie scroll to bottom',
    noremap = false,
    silent = true,
  })
end

return { setup_paging = setup_paging, setup_gg = setup_gg, setup_G = setup_G }
