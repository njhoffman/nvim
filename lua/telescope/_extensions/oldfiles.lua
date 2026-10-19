local finders = require('telescope.finders')
local pickers = require('telescope.pickers')
local utils = require('telescope.utils')
local Path = require('plenary.path')

local mru_utils = require('oldfiles.utils')
local logger = require('logger').init('mru')

local setup_highlights = function()
  vim.api.nvim_set_hl(0, 'TelescopeMRUDate', { default = true, link = 'SpecialChar' })
  vim.api.nvim_set_hl(0, 'TelescopeMRUSize', { default = true, link = 'Keyword' })
end

local conf = require('telescope.config').values
local lookup_keys = {
  ordinal = 1,
  value = 1,
  filename = 1,
  cwd = 2,
}
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

local file_meta = {}

local parse_file_meta = function(path)
  local meta = file_meta[path]
  local parsed = {
    size = mru_utils.file_size(meta.size),
    created = mru_utils.time_ago(meta.ctime.sec),
    accessed = mru_utils.time_ago(meta.atime.sec),
    modified = mru_utils.time_ago(meta.mtime.sec),
  }
  return parsed
end

local file_display = function(opts)
  local winwidth = vim.api.nvim_get_option_value('columns', {})
  winwidth = math.floor(winwidth * (opts.theme ~= 'ivy' and 0.8 or 1))
  local disable_devicons = opts.disable_devicons
  return function(entry)
    local hl_group, icon

    local meta = parse_file_meta(entry.value)
    local display = utils.transform_path(opts, entry.value)

    display, hl_group, icon = utils.transform_devicons(entry.value, display, disable_devicons)

    local hls = {}
    if hl_group then
      table.insert(hls, { { 0, #icon }, hl_group })
    end

    local display_right = ''
    if opts.show_time then
      display_right = ' ' .. meta.accessed
    end
    if opts.show_size then
      display_right = display_right .. (#display_right > 0 and ' ' or '') .. meta.size
    end
    display = mru_utils.truncate(display, winwidth - #display_right - 5)
    display = display .. mru_utils.align(display_right, winwidth - vim.fn.strdisplaywidth(display) - 5, 'right')

    local start_pos = winwidth - #display_right - 2
    if opts.show_time then
      table.insert(hls, { { start_pos, start_pos + #meta.accessed + 2 }, 'TelescopeMRUDate' })
      start_pos = start_pos + #meta.accessed + 2
    end
    if opts.show_size then
      table.insert(hls, { { start_pos, start_pos + #meta.size + 1 }, 'TelescopeMRUSize' })
    end
    return display, hls
  end
end

local gen_from_file = function(opts)
  opts = opts or {}
  local cwd = vim.fn.expand(opts.cwd or vim.loop.cwd())

  local mt_file_entry = {}
  mt_file_entry.cwd = cwd
  mt_file_entry.display = file_display(opts)
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

-- Makes sure aliased options are set correctly
local apply_cwd_only_aliases = function(opts)
  opts = opts or {}
  local has_cwd_only = opts.cwd_only ~= nil
  local has_only_cwd = opts.only_cwd ~= nil

  if has_only_cwd and not has_cwd_only then
    -- Internally, use cwd_only
    opts.cwd_only = opts.only_cwd
    opts.only_cwd = nil
  end

  return opts
end

local config = {
  -- cwd_only,
  -- only_cwd,
  -- include_current_session,
  -- show_time,
  -- show_size
  -- disable_devicons
  -- cwd
}

local setup = function(opts)
  config = opts or config
  setup_highlights()
end

local oldfiles = function(user_opts)
  local opts = apply_cwd_only_aliases(config)
  opts = vim.tbl_extend('force', opts, user_opts or {})
  opts.include_current_session = vim.nonnil(opts.include_current_session, true)

  vim.cmd('silent! rshada!')

  local current_buffer = vim.api.nvim_get_current_buf()
  local current_file = vim.api.nvim_buf_get_name(current_buffer)
  local results = {}

  if opts.include_current_session then
    for _, buffer in ipairs(vim.split(vim.fn.execute(':buffers! t'), '\n')) do
      local match = tonumber(string.match(buffer, '%s*(%d+)'))
      local open_by_lsp = string.match(buffer, 'line 0$')
      if match and not open_by_lsp then
        local file = vim.api.nvim_buf_get_name(match)
        local file_stat = vim.loop.fs_stat(file)
        file_meta[file] = file_stat
        if file_stat and match ~= current_buffer then
          table.insert(results, file)
        end
      end
    end
  end

  for _, file in ipairs(vim.v.oldfiles) do
    local file_stat = vim.loop.fs_stat(file)
    if not vim.tbl_contains(results, file) and file ~= current_file then
      if file_stat and file_stat.type == 'file' then
        file_meta[file] = file_stat
        table.insert(results, file)
      else
        logger:trace('not found: ' .. file)
      end
    end
  end

  if opts.cwd_only or opts.cwd then
    local cwd = opts.cwd_only and vim.loop.cwd() or opts.cwd
    cwd = cwd .. utils.get_separator()
    cwd = cwd:gsub([[\]], [[\\]])
    results = vim.tbl_filter(function(result)
      return vim.fn.matchstrpos(result, cwd)[2] ~= -1
    end, results)
  end

  table.sort(results, function(a, b)
    return file_meta[a].atime.sec > file_meta[b].atime.sec
  end)

  logger:debug('launching oldfiles ' .. #results .. ' /' .. #vim.v.oldfiles)

  local sorter = opts and opts.sorter or conf.file_sorter

  pickers
    .new(opts, {
      prompt_title = 'Oldfiles',
      finder = finders.new_table({
        results = results,
        entry_maker = opts.entry_maker or gen_from_file(opts),
      }),
      sorter = sorter(opts),
      previewer = conf.file_previewer(opts),
      attach_mappings = function(_, map)
        for mode, mode_maps in pairs(opts.mappings or {}) do
          for lhs, rhs in pairs(mode_maps or {}) do
            map(mode, lhs, rhs)
          end
          return true
        end
      end,
    })
    :find()
end

return require('telescope').register_extension({
  exports = {
    oldfiles = oldfiles,
  },
  setup = setup,
})
