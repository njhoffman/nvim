local utils = require('telescope.utils')

local unescape = function(v)
  return string.gsub(v, "\\([\\'\\$\\*\\|])", '%1')
end

local function mode_highlight(mode)
  if mode == 'i' then
    return 'String'
  elseif mode == 'c' or mode == 't' then
    return 'Operator'
  elseif mode == 'n' then
    return 'Number'
  elseif mode == 'x' then
    return 'Visual'
  elseif mode == 'v' or mode == 's' then
    return 'VisualRed'
  else
    return 'SpecialChar'
  end
end

local function get_desc(entry)
  if type(entry.callback) == 'function' and not entry.desc then
    return require('telescope.actions.utils')._get_anon_function_name(debug.getinfo(entry.callback))
  end
  return unescape(vim.nonnil(entry.desc, entry.rhs))
end

local function get_lhs(entry)
  return utils.display_termcodes(entry.lhs)
end

local gen_from_keymaps = function(opts)
  -- @(buffer) !silent *noremap +expr  nowait

  -- stylua: ignore
  local attr_map = {
    { 'buffer',  '@' },
    { 'silent',  '!' },
    { 'remap',   '*' },
    { 'expr',    '+' },
    { 'nowait',  '' },
    -- unique
  }
  local function get_attr(entry)
    local ret = ''
    for _, attr in ipairs(attr_map) do
      if attr[1] == 'remap' then
        if tonumber(entry.noremap) == 0 then
          ret = ret .. attr[2]
        end
      elseif tonumber(entry[attr[1]]) ~= 0 then
        ret = ret .. attr[2]
      else
        ret = ret .. ' '
      end
    end
    return ret
  end

  local displayer = require('telescope.pickers.entry_display').create({
    -- separator = '│',-- │ ︳⏐
    -- separator_hl =  'TelescopeResultsSeparator',
    separator = ' ',
    items = {
      { width = 1 },
      { width = 6 },
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
    local mode = entry.mode
    if not vim.tbl_contains({ 'n', 'i', 'c', 'o', 'x', 't', 'v', 's' }, entry.mode) then
      mode = '?'
    end
    return displayer({
      { mode, mode_highlight(entry.value.mode) },
      { entry.attr, 'TelescopeResultsBorder' },
      { lhs, lhs_hl },
      { entry.desc },
    })
  end

  return function(entry)
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
      ordinal = vim.fn.join({ entry.mode, parsed.attr, parsed.lhs, parsed.desc }, '.'),
      display = make_display,
    }
  end
end

return gen_from_keymaps
