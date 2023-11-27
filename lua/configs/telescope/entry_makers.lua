local utils = require('telescope.utils')
local Path = require('plenary.path')

-- opts.modes = vim.F.if_nil(opts.modes, { "n", "i", "c", "x" })
-- opts.show_plug = vim.F.if_nil(opts.show_plug, true)
-- opts.only_buf = vim.F.if_nil(opts.only_buf, false)
local function gen_from_keymaps(opts)
  local function mode_highlight(mode)
    if mode == 'i' then
      return 'Special'
    elseif mode == 'c' or mode == 't' then
      return 'Operator'
    elseif mode == 'n' then
      return 'SpecialChar'
    elseif mode == 'v' or mode == 'x' then
      return 'Visual'
    else
      return 'Normal'
    end
  end

  local function get_desc(entry)
    if type(entry.callback) == 'function' and not entry.desc then
      return require('telescope.actions.utils')._get_anon_function_name(debug.getinfo(entry.callback))
    end
    return vim.F.if_nil(entry.desc, entry.rhs)
  end

  local function get_lhs(entry)
    return utils.display_termcodes(entry.lhs)
  end

  -- @(buffer) !silent *noremap +expr  nowait

  -- stylua: ignore
  local attr_map = {
    { 'buffer',  '@' },
    { 'silent',  '!' },
    { 'noremap', '*' },
    { 'expr',    '+' },
    { 'nowait',  '' },
    -- unique
  }

  local function get_attr(entry)
    local ret = ''
    for _, attr in ipairs(attr_map) do
      if tonumber(entry[attr[1]]) ~= 0 then
        ret = ret .. attr[2]
      else
        ret = ret .. string.rep(' ', #attr[2])
      end
    end
    return ret
  end

  local displayer = require('telescope.pickers.entry_display').create({
    -- separator = '▏',
    separator = ' ',
    items = {
      { width = 1 },
      { width = 7 },
      { width = 20 },
      { remaining = true },
    },
  })
  local make_display = function(entry)
    local lhs_hl = 'TelescopeResultsField'
    local lhs = entry.lhs
    if string.match(lhs, '^<Plug>') then
      lhs = vim.fn.substitute(entry.lhs, '<Plug>', '', '')
      lhs_hl = 'TelescopeResultsComment'
    end
    return displayer({
      { entry.mode, mode_highlight(entry.value.mode) },
      { entry.attr, 'Normal' },
      { lhs, lhs_hl },
      { entry.desc },
    })
  end

  return function(entry)
    -- vim.dbglog('ENTRY', entry)
    local parsed = {
      lhs = get_lhs(entry),
      desc = get_desc(entry),
      attr = get_attr(entry),
    }
    return {
      mode = entry.mode,
      lhs = parsed.lhs,
      desc = parsed.desc,
      attr = parsed.attr,
      --
      valid = entry ~= '',
      value = entry,
      ordinal = vim.fn.join({ entry.mode, parsed.attr, parsed.lhs, parsed.desc }, ' '),
      display = make_display,
    }
  end
end

local handle_entry_index = function(opts, t, k)
  local override = ((opts or {}).entry_index or {})[k]
  if not override then
    return
  end

  local val, save = override(t, opts)
  if save then
    rawset(t, k, val)
  end
  return val
end

local function gen_from_file(opts)
  opts = opts or {}

  local cwd = vim.fn.expand(opts.cwd or vim.loop.cwd())

  local disable_devicons = opts.disable_devicons

  local mt_file_entry = {}

  mt_file_entry.cwd = cwd
  mt_file_entry.display = function(entry)
    local hl_group, icon
    local display = utils.transform_path(opts, entry.value)

    display, hl_group, icon = utils.transform_devicons(entry.value, display, disable_devicons)

    if hl_group then
      return display, { { { 1, #icon }, hl_group } }
    else
      return display
    end
  end

  mt_file_entry.__index = function(t, k)
    local override = handle_entry_index(opts, t, k)
    if override then
      return override
    end

    local raw = rawget(mt_file_entry, k)
    if raw then
      return raw
    end

    if k == 'path' then
      local retpath = Path:new({ t.cwd, t.value }):absolute()
      if not vim.loop.fs_access(retpath, 'R', nil) then
        retpath = t.value
      end
      return retpath
    end

    return rawget(t, rawget(lookup_keys, k))
  end

  if opts.file_entry_encoding then
    return function(line)
      line = vim.iconv(line, opts.file_entry_encoding, 'utf8')
      return setmetatable({ line }, mt_file_entry)
    end
  else
    return function(line)
      return setmetatable({ line }, mt_file_entry)
    end
  end
end
return {
  gen_from_keymaps = gen_from_keymaps,
  gen_from_file = gen_from_file,
}
