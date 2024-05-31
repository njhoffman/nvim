-- https://github.com/folke/flash.nvim
local lazy = {
  'folke/flash.nvim',
  event = 'VeryLazy',
  opts = { labels = 'asdfghjklqwertyuiopzxcvbnm' },
  keys = {
    { 's', false },
    { 'S', false },
  },
  config = function(_, opts)
    local flash = require('flash')
    flash.setup(opts)
    _G.flashnav = {
      jump = function()
        flash.jump({ search = { mode = 'search' } })
      end,
      jumptoline = function()
        flash.jump({
          search = { mode = 'search', max_length = 0 },
          label = { after = { 0, 0 } },
          pattern = '^',
        })
      end,
      treesitter = function()
        flash.treesitter()
      end,
      remote = function()
        flash.remote()
      end,
      toggle = function()
        flash.toggle()
      end,
      continue = function()
        flash.jump({ continue = true })
      end,
    }
  end,
}

local function flash()
  map({ 'n', 'x', 'o' }, 'gs', function()
    flashnav.jump()
  end, 'Flash')
  map({ 'n', 'x', 'o' }, 'gS', function()
    flashnav.treesitter()
  end, 'Flash treesitter')
  map({ 'n', 'x', 'o' }, 'gl', function()
    flashnav.jumptoline()
  end, 'Flash to Line')
  map({ 'n', 'x', 'o' }, 'gr', function()
    flashnav.continue()
  end, 'Flash Resume')
end
