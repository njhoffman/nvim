local utils = require('telescope.utils')
local Path = require('plenary.path')
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

return gen_from_file
