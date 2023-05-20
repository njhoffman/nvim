local finders = require('telescope.finders')
local entry_display = require('telescope.pickers.entry_display')

local function display_termcodes(str)
  return str:gsub(string.char(9), '<TAB>'):gsub('', '<C-F>'):gsub(' ', '<Space>')
end

-- telescope.actions.utils
local function get_anon_function_name(func_ref)
  local Path = require('plenary.path')
  local info = debug.getinfo(func_ref)
  local fname
  -- if fn defined in string (ie loadstring) source is string
  -- if fn defined in file, source is file name prefixed with a `@´
  local path = Path:new((info.source:gsub('@', '')))
  if not path:exists() then
    return '<anonymous>'
  end
  for i, line in ipairs(path:readlines()) do
    if i == info.linedefined then
      fname = line
      break
    end
  end

  -- test if assignment or named function, otherwise anon
  if (fname:match('=') == nil) and (fname:match('function %S+%(') == nil) then
    return '<anonymous>'
  else
    local patterns = {
      { 'function', '' }, -- remove function
      { 'local', '' }, -- remove local
      { '[%s=]', '' }, -- remove whitespace and =
      { [=[%[["']]=], '' }, -- remove left-hand bracket of table assignment
      { [=[["']%]]=], '' }, -- remove right-ahnd bracket of table assignment
      { '%((.+)%)', '' }, -- remove function arguments
      { '(.+)%.', '' }, -- remove TABLE. prefix if available
    }
    for _, tbl in ipairs(patterns) do
      fname = (fname:gsub(tbl[1], tbl[2])) -- make sure only string is returned
    end
    -- not sure if this can happen, catch all just in case
    if fname == nil or fname == '' then
      return '<anonymous>'
    end
    return fname
  end
end

local function mode_highlight(mode)
  if mode == 'i' then
    return 'Special'
  elseif mode == 'n' then
    return 'SpecialChar'
  elseif mode == 'v' then
    return 'Visual'
  else
    return 'Normal'
  end
end

local function get_lhs(entry)
  return display_termcodes(entry.lhs)
end

local function get_attr(entry)
  local ret = ''
  if entry.noremap ~= 0 then
    ret = ret .. '*'
  end
  if entry.buffer ~= 0 then
    ret = ret .. '@'
  end
  return ret
end

-- Creates a Telescope `finder` based on the given options
-- and list of mappers
local finder = function(keymaps)
  local widths = { lhs_display = 0, category = 0, description = 0, mode = 0, rhs_display = 0 }

  -- The mapper has the following keys :
  -- - buffer_only: bool
  -- - category: str
  -- - rhs: str
  -- - lhs: str
  -- - mode: str
  -- - options: table
  -- - where_file: str
  -- - where_line: int
  --
  -- We want the display line to be like this :
  -- category mapping description

  -- Loop over all of the mappers and find the maximum length of each of the keys
  for _, entry in pairs(keymaps) do
    entry.meta.attr = get_attr(entry)
    entry.lhs_display = get_lhs(entry)

    if entry.callback then
      entry.rhs_display = get_anon_function_name(entry.callback)
    else
      entry.rhs_display = tostring(entry.rhs)
    end
    entry.description = entry.opts.desc or entry.rhs_display
    for key, value in pairs(widths) do
      if key == 'category' then
        widths[key] = math.max(value, vim.fn.strdisplaywidth(entry.meta[key] or ''))
      else
        widths[key] = math.max(value, vim.fn.strdisplaywidth(entry[key] or ''))
      end
    end
  end

  -- The mapper display line
  local displayer = entry_display.create({
    -- separator = " | ",
    separator = ' ▏',
    items = {
      { width = widths.category },
      { width = widths.mode },
      { width = widths.lhs_display },
      { width = widths.description },
      { width = widths.rhs_display },
    },
  })

  local make_display = function(entry)
    return displayer({
      { entry.meta.category, 'TelescopeResultsClass' },
      { entry.mode, mode_highlight(entry.mode) },
      { entry.lhs_display, 'TelescopeResultsComment' },
      { entry.opts.desc },
    })
  end

  return finders.new_table({
    results = keymaps,
    entry_maker = function(keymap)
      keymap.value = keymap.description
      keymap.ordinal = keymap.meta.category .. ' ' .. keymap.mode .. ' ' .. keymap.lhs .. ' ' .. keymap.description
      keymap.display = make_display
      keymap.id = keymap.unique_id
      keymap.lines = keymap.lines
      return keymap
    end,
  })
end

return { finder = finder }
