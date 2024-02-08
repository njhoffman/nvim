local devicons = require('nvim-web-devicons')
local entry_display = require('telescope.pickers.entry_display')

--  --     7 min  local visual_str = {\ ['v'] = true, -- Visual by character\ ['vs'] = true, -- Visual by character using |v_CTRL-O| in Select mode\
--  2L    18 hrs  local visual_str = {\ ['v'] = true, -- Visual by character\ ['vs'] = true, -- Visual by character using |v_CTRL-O| in Select mode\
--  4L 麗  2 days  local visual_str = {\ ['v'] = true, -- Visual by character\ ['vs'] = true, -- Visual by character using |v_CTRL-O| in Select mode\
--  entry.value.cwd           = "/home/nicholas/.config/nvim",
--  entry.value.date          = "Wed 21 Nov 2023 03:15:04 PM CST",
--  entry.value.filename      = "/home/nicholas/.config/nvim/lua/telescope/_extensions/yank_history/yank_history.lua",
--  entry.value.filetype      = "lua",
--  entry.value.history_index = 0,
--  entry.value.project_root  = "/home/nicholas/.config/nvim",
--  entry.value.regcontents   = "  vim.dbglog('INIT')\
--  entry.value.regtype       = "V",
-- TelescopeResultsClass, Number, Comment, Field, Title, Border, Method, Normal, Constant, Function, Special
-- Operator, Variable, Struct
--                                 ﭨ  ﭨ  ﭨ  ﭨ  ﮜ  ﮜ  ﮜ  ﮜ        
--  麗 濾ﮜ        縷 ﮜ          ﭟ   ﲵ  ﭟ
local icons = {
  ['v'] = '', -- Visual by character
  ['V'] = '', -- Visual by line
  ['vs'] = '麗', -- Visual by character using |v_CTRL-O| in Select mode
  ['nl'] = '↳',
}

local gen_from_history = function(opts)
  local displayer = entry_display.create({
    separator = ' ',
    items = {
      { width = 4, right_justify = true },
      { width = 1 },
      { width = 1 },
      { remaining = true },
    },
  })

  local make_display = function(entry)
    local content = entry.content
    local content_lines = vim.split(content, '\n') or {}

    --  for |blockwise-visual| text <CTRL-V> is one character with value 0x15.
    local type_icon = icons[entry.value.regtype] or '?'
    local extension = vim.fn.fnamemodify(entry.value.filename, ':e')
    local file_icon, file_hl = devicons.get_icon(entry.value.filetype, extension)
    return displayer({
      {
        #content_lines == 1 and '' or #content_lines == 2 and (' ' .. icons.nl) or (#content_lines - 1 .. icons.nl),
        'TelescopeResultsComment',
        -- #content_lines == 1 and 'TelescopeResultsComment' or 'TelescopeResultsNumber',
      },
      { type_icon, 'TelescopeResultsNumber' },
      { file_icon == nil and '' or file_icon, file_hl == nil and '' or file_hl },
      content:gsub('\n', '\\n'),
    })
  end

  return function(entry)
    return {
      valid = true,
      value = entry,
      ordinal = entry.regcontents,
      content = entry.regcontents,
      display = make_display,
    }
  end
end

return { gen_from_history = gen_from_history }
