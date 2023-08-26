local austats = require('stats.commands.aucommands')
local envstats = require('stats.commands.environment')
local keystats = require('mapper.stats')

local function reformatInt(i)
  return tostring(i):reverse():gsub('%d%d%d', '%1,'):reverse():gsub('^,', '')
end

local get_items = function()
  local env_counts = envstats.get_counts()
  local au_counts = austats.get_counts()
  local key_counts = keystats.get_stats()

  local items = {
    string.format('Filetype         %8s', env_counts.filetype),
    -- string.format('Startup Time     %8s', env_counts.startup_time),
    string.format('Memory (RSS)     %8s', reformatInt(env_counts.memory)),
    string.format('Memory (VSZ)     %8s', reformatInt(env_counts.virtual_memory)),
    string.format('Plugins          %8s', reformatInt(env_counts.plugins)),
    string.format('Plugins Size     %8s', env_counts.plugins_size),
    string.format('AuGroups         %8s', reformatInt(au_counts.groups)),
    string.format('AuCommands       %8s', reformatInt(au_counts.commands)),
    string.format('Commands         %8s', reformatInt(env_counts.commands)),
    string.format('History          %8s', reformatInt(env_counts.history_commands)),
    string.format('Functions        %8s', reformatInt(env_counts.functions)),
    string.format('Highlights       %8s', reformatInt(env_counts.highlights)),
    string.format('Variables        %8s', reformatInt(env_counts.variables)),
    -- string.format('Syntax Items     %8s', reformatInt(env_counts.syntax_items)),
    -- string.format('Scriptnames      %8s', reformatInt(env_counts.scriptnames)),
    -- string.format('Messages         %8s', reformatInt(env_counts.messages)),
    -- string.format('Changes          %8s', reformatInt(env_counts.changes)),
    string.format('NvimMapper Keys  %8s', reformatInt(key_counts.mapper.total)),
    string.format('WhichKey         %8s', reformatInt(key_counts.whichkey.ok.total)),
    string.format('Total Mapped     %8s', reformatInt(key_counts.neovim.total)),
  }
  return items
end

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
  require('dressing.select.nui').select(backend_opts, items, opts, cb)

  -- local event = require('nui.utils.autocmd').event
  -- nui_select:on(event.BufLeave, function()
  --   vim.dbglog('DONT LEAVE')
  --   -- cb(nil, nil)
  -- end, { once = true })
  -- menu:mount()

  -- stats_select:on(event.BufLeave, menu.menu_props.on_close, { once = true })
  -- vim.ui.select(, opts, cb)
end

local table_overview = function()
  local s = environment.get_counts()
  local p = print

  p('------------------------------')
  -- p(("startup time         %8s     "):format(s.start_time))
  p(('memory             %6s     '):format(s.memory))
  p(('virtual memory     %6s     '):format(s.virtual_memory))
  p(('packer lines         %4s     '):format(s.packer_lines))
  p(('plugins size         %4s     '):format(s.plugins_size))
  p(('changes              %4d     '):format(s.changes))
  p(('messages             %4d     '):format(s.messages))
  p(('commands             %4d     '):format(s.commands))
  p(('commands history     %4d     '):format(s.history_commands))
  p(('scriptnames          %4d     '):format(s.scriptnames))
  p(('variables            %4d     '):format(s.variables))
  p(('functions            %4d     '):format(s.functions))
  p(('syntax items         %4d     '):format(s.syntax_items))
  p(('highlights           %4d     '):format(s.highlights))
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

-- fetch_stats()
return {
  fetch_stats = fetch_stats,
}
