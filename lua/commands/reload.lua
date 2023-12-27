local get_reload_type = function(cfg)
  local type = 'basic   '
  if cfg.extended == true then
    type = 'extended'
  elseif cfg.siblings == true then
    type = 'sibling '
  end
  return type
end

local check_package = function(path, packages)
  local has = vim.tbl_contains
  local check_exists = function(p)
    return has(packages.loaded, p) or has(packages.not_loaded, p)
  end
  if package.loaded[path] and not check_exists(path) then
    return path, true
  elseif pcall(require, path) and not check_exists(path) then
    return path, false
  end
  return false
end

local sort_packages = function(packages)
  table.sort(packages.loaded)
  table.sort(packages.not_loaded)
end

local parse_paths = function(filepath)
  local paths = { base_path = '', sibling_path = '', src_path = '' }
  -- stylua: ignore
  paths.src_path = filepath
    :gsub(vim.fn.stdpath('config') .. '/lua/', '')
    :gsub(vim.fn.stdpath('config') .. '/', '')
    :gsub('/', '.')
  paths.src_path = paths.src_path:match('(.+)%..+$') or filepath
  paths.base_path = vim.fn.split(paths.src_path, '\\.')[1]
  paths.sibling_path = paths.src_path:gsub('%.', '/'):match('(.+)/.+'):gsub('/', '.')
  return paths
end

local reload_package_chain = function(filepath, cfg)
  local packages, package_path = { loaded = {}, not_loaded = {} }, ''
  local counts = { primary = 0, children = 0, siblings = 0, extended = 0, not_loaded = 0 }
  local paths = parse_paths(filepath)

  table.insert(packages.loaded, paths.src_path)
  counts.primary = counts.primary + 1

  -- local src_path = vim.fn.expand('%:r'):gsub('lua/', ''):gsub('/', '.')
  for src_part in string.gmatch(paths.src_path, '[^.]+') do
    if package_path == '' then
      package_path = src_part
    else
      package_path = package_path .. '.' .. src_part
    end
    for _, ppath in ipairs({ package_path, package_path .. '.init' }) do
      local result, is_loaded = check_package(ppath, packages)
      if result and is_loaded then
        counts.primary = counts.primary + 1
        table.insert(packages.loaded, result)
      elseif result and not is_loaded then
        counts.not_loaded = counts.not_loaded + 1
        table.insert(packages.not_loaded, result)
      end
    end
  end
  sort_packages(packages)

  if cfg.children then
    for name, _ in pairs(package.loaded) do
      if name:find(string.gsub(paths.src_path, '.init$', '')) == 1 then
        local result, is_loaded = check_package(name, packages)
        if result and is_loaded then
          counts.children = counts.children + 1
          table.insert(packages.loaded, result)
        elseif result and not is_loaded then
          counts.not_loaded = counts.not_loaded + 1
          table.insert(packages.not_loaded, result)
        end
      end
    end
  end
  sort_packages(packages)

  if cfg.siblings then
    for name, _ in pairs(package.loaded) do
      if name:find(string.gsub(paths.sibling_path, '.init$', '')) == 1 then
        local result, is_loaded = check_package(name, packages)
        if result and is_loaded then
          counts.siblings = counts.siblings + 1
          table.insert(packages.loaded, result)
        elseif result and not is_loaded then
          counts.not_loaded = counts.not_loaded + 1
          table.insert(packages.not_loaded, result)
        end
      end
    end
  end
  sort_packages(packages)

  if cfg.extended then
    for name, _ in pairs(package.loaded) do
      if name:find(string.gsub(paths.base_path, '.init$', '')) == 1 then
        local result, is_loaded = check_package(name, packages)
        if result and is_loaded then
          counts.extended = counts.extended + 1
          table.insert(packages.loaded, result)
        elseif result and not is_loaded then
          counts.not_loaded = counts.not_loaded + 1
          table.insert(packages.not_loaded, result)
        end
      end
    end
  end

  sort_packages(packages)
  -- add primary file to end of reloading chain
  table.insert(packages.loaded, #packages.loaded - 1, paths.src_path)

  for _, pkg in ipairs(packages.loaded) do
    package['loaded'][pkg] = nil
    local ppath = vim.fn.stdpath('config') .. '/lua/' .. pkg:gsub('%.', '/')
    if vim.fn.filereadable(ppath .. '.lua') == 0 then
      ppath = ppath .. '/init'
    end
    if cfg.source == true and vim.fn.filereadable(ppath .. '.lua') then
      vim.cmd.source(ppath .. '.lua')
      vim.notify('sourced: ' .. ppath .. '.lua', 1)
    end
    if cfg.dofile == true and vim.fn.filereadable(ppath .. '.lua') then
      dofile(ppath .. '.lua')
      vim.notify('dofile: ' .. ppath .. '.lua', 1)
    end
    if cfg.require == true then
      vim.notify('reloading: ' .. pkg, 1)
      require(pkg)
    end
  end

  vim.notify(
    'reload '
      .. get_reload_type(cfg)
      .. (#packages.loaded <= 9 and '  ' or ' ')
      .. #packages.loaded
      .. '\nprimary:        '
      .. (counts.primary <= 9 and ' ' or '')
      .. counts.primary
      .. '\nchildren:       '
      .. (counts.children <= 9 and ' ' or '')
      .. counts.children
      .. '\nsiblings:       '
      .. (counts.siblings <= 9 and ' ' or '')
      .. counts.siblings
      .. '\nextended:       '
      .. (counts.extended <= 9 and ' ' or '')
      .. counts.extended
      .. '\nnot_loaded:     '
      .. (counts.not_loaded <= 9 and ' ' or '')
      .. counts.not_loaded,
    2
  )
end

local default_config = {
  children = true,
  siblings = false,
  extended = false,
  source = false,
  dofile = false,
  require = true,
}

local reload = function(cfg)
  return function(cmd)
    local reload_cfg = vim.tbl_deep_extend('force', default_config, cfg or {})
    vim.cmd('silent update')
    local is_nvim_config = vim.loop.cwd() == vim.fn.stdpath('config')

    local filepath = vim.fn.expand('%:p') or ''
    if cmd and cmd.fargs and cmd.fargs[1] then
      filepath = vim.loop.cwd() .. cmd.fargs[1]
    end

    --- GUARD
    if filepath:find('nvim/after/ftplugin/') then
      vim.notify('ftplugins cannot be reloaded.', 3)
      return
    elseif filepath:find('nvim/lua/.*keymap') or filepath:find('nvim/lua/.*keybinding') then
      vim.notify('keymaps cannot be reloaded due to `map-unique`', 3)
      return
    -- unload from lua cache (assuming that the pwd is ~/.config/nvim)
    elseif is_nvim_config then
      vim.dbglog('trying to', filepath)
      reload_package_chain(filepath, reload_cfg)
      -- run `make`
      -- else
      -- vim.cmd.lmake()
    else
      vim.notify('not reloading: ' .. filepath, 3)
    end
  end
end
return reload

-- local filepath = vim.fn.expand('%:p')
-- local filepath = vim.fn.expand('/home/nicholas/.config/nvim/lua/telescope/_extensions/arecibo.lua')
-- local filepath = vim.fn.expand('/home/nicholas/.config/nvim/lua/configs/telescope/init.lua')
-- local filepath = vim.fn.expand('/home/nicholas/.config/nvim/lua/tracker/sources/variables.lua')
-- reload_package_chain(filepath)
