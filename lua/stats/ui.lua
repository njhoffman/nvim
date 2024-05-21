local stats_select = function(items, opts, cb)
  opts.prompt = opts.prompt or 'Title Test'
  local backend_opts = {
    position = '90%',
    zindex = 50,
    relative = 'editor',
    min_width = 15,
    min_height = 1,
    max_width = 120,
    max_height = 40,
    border = {
      highlight = 'FloatBorder',
      padding = {
        top = 1,
        bottom = 1,
        left = 1,
        right = 1,
      },

      style = 'rounded',
      text = {
        top = 'InfoWindow',
        top_align = 'center',
      },
    },
    buf_options = {
      swapfile = false,
      filetype = 'DressingSelect',
      modifiable = false,
      readonly = true,
    },
    win_options = {
      -- Window transparency (0-100)
      winblend = 10,
      -- Disable line wrapping
      wrap = false,
      -- Indicator for when text exceeds window
      list = true,
      listchars = 'precedes:…,extends:…',
      -- Increase this for more context when text scrolls off the window
      sidescrolloff = 0,
    },
    keymap = {
      n = {
        ['<Esc>'] = false,
        ['<CR>'] = false,
      },
      i = {
        ['<C-c>'] = false,
        ['<CR>'] = false,
        ['<Up>'] = false,
        ['<Down>'] = false,
      },
    },
    override = function(conf)
      -- This is the config that will be passed to nvim_open_win.
      -- Change values here to customize the layout
      return conf
    end,
  }
  require('dressing.select.nui').select(backend_opts, items, opts, fetch_stats)
end

local fetch_stats = function()
  local stat_items = get_items()
  stats_select(stat_items, {
    prompt = 'Stats',
    format_item = function(item)
      return item
    end,
  }, function(choice)
    -- print(choice)
  end)
end

-- local event = require('nui.utils.autocmd').event
-- nui_select:on(event.BufLeave, function()
--   vim.dbglog('DONT LEAVE')
--   -- cb(nil, nil)
-- end, { once = true })
-- menu:mount()

-- stats_select:on(event.BufLeave, menu.menu_props.on_close, { once = true })
-- vim.ui.select(, opts, cb)
