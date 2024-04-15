local mapper = require('mapper')
local map = mapper.map

local setup_paging = function()
  local page_down = vim.api.nvim_replace_termcodes('<C-e>', true, true, true)
  local bottom_margin = 5

  local scroll_page = function()
    local winheight = vim.api.nvim_win_get_height(0)
    local cursor = vim.api.nvim_win_get_cursor(0)
    local last_line = vim.api.nvim_buf_line_count(0)

    if cursor[1] + (winheight * 1) > last_line then
      vim.cmd('normal! G')
    else
      -- vim.cmd('normal! ' .. winheight .. 'j') --  .. page_down)
      vim.cmd('normal! ' .. winheight .. page_down)
    end
  end

  map('n', '<C-f>', scroll_page, {
    category = 'motion',
    desc = ' scroll forwards',
    silent = true,
  })

  map('n', '<C-b>', '<cmd>normal! <C-b><cr>', {
    category = 'Motion',
    desc = ' scroll downwards',
    silent = true,
  })

  -- map('n', '<space>', '<cmd>normal! <C-f><C-f><cr>', {
  -- map('n', '<space>', '<Plug>(SmoothieDownwards)<Plug>(SmoothieDownwards)', {
  map('n', '<space>', scroll_page, {
    category = 'Motion',
    desc = ' scroll forwards x2',
    noremap = true,
    silent = true,
  })
end

local function setup_gg()
  map('n', 'gg', '<Plug>(Smoothie_gg)', {
    category = 'Motion',
    desc = ' scroll top',
    silent = true,
  })
end

local function setup_G()
  map('n', 'G', '<Plug>(Smoothie_G)', {
    category = 'Motion',
    plugin = 'vim-smoothie',
    desc = ' scroll bottom',
    silent = true,
  })
end

map('n', '<PageUp>', '<Plug>(SmoothieUpwards)', {
  category = 'Motion',
  plugin = 'vim-smoothie',
  desc = ' scroll upwards',
  silent = true,
})

map('n', '<PageDown>', '<Plug>(SmoothieDownwards)', {
  category = 'Motion',
  plugin = 'vim-smoothie',
  desc = ' scroll downwards',
  silent = true,
})

return { setup_paging = setup_paging, setup_gg = setup_gg, setup_G = setup_G }
