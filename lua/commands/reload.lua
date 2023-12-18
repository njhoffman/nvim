local default_config = {
  parents = true,
  children = true,
  source = false,
  dofile = false,
  require = true,
}

local reload_package_chain = function(filepath, cfg)
  local packages, package_path = {}, ''
  local src_path = filepath:gsub(vim.fn.stdpath('config') .. '/lua/', ''):gsub('/', '.')
  src_path = src_path:match('(.+)%..+$') or filepath
  table.insert(packages, src_path)
  -- local src_path = vim.fn.expand('%:r'):gsub('lua/', ''):gsub('/', '.')
  for package_name in string.gmatch(src_path, '[^.]+') do
    package_path = package_path .. (#package_path > 0 and '.' or '') .. package_name
    if package.loaded[package_path] then
      table.insert(packages, package_path)
      package.loaded[package_path] = nil
    end
  end

  if cfg.parents then
    for _, pkg in ipairs(packages) do
      for name, _ in pairs(package.loaded) do
        if name:find(pkg) == 1 then
          package.loaded[name] = nil
          table.insert(packages, name)
        end
      end
    end
  end

  -- vim.dbglog('packages', packages)
  -- if cfg.children then
  --   for _, pkg in ipairs(packages) do
  --     for name, _ in pairs(package.loaded) do
  --       if name:find(pkg) == 1 then
  --         package.loaded[name] = nil
  --         table.insert(packages, name)
  --       end
  --     end
  --   end
  -- end

  for _, pkg in ipairs(packages) do
    local ppath = vim.fn.stdpath('config') .. '/lua/' .. pkg:gsub('%.', '/')
    if vim.fn.filereadable(ppath .. '.lua') == 0 then
      ppath = ppath .. '/init'
    end
    if cfg.source == true and vim.fn.filereadable(ppath .. '.lua') then
      vim.cmd.source(ppath .. '.lua')
      vim.notify('sourced: ' .. ppath .. '.lua')
    end
    if cfg.dofile == true and vim.fn.filereadable(ppath .. '.lua') then
      dofile(ppath .. '.lua')
      vim.notify('dofile: ' .. ppath .. '.lua')
    end
    if cfg.require == true then
      require(pkg)
      vim.notify('reloaded: ' .. pkg)
    end
  end
end

local reload = function(cfg)
  return function(cmd)
    local reload_cfg = cfg or default_config

    vim.cmd('silent update')
    local is_nvim_config = vim.loop.cwd() == vim.fn.stdpath('config')

    local filepath = vim.fn.expand('%:p')
    if cmd and cmd.fargs and cmd.fargs[1] then
      filepath = vim.loop.cwd() .. cmd.fargs[1]
    end

    --- GUARD
    if filepath:find('nvim/after/ftplugin/') then
      vim.notify('ftplugins cannot be reloaded.', 'warn')
      return
    elseif filepath:find('nvim/lua/.*keymap') or filepath:find('nvim/lua/.*keybinding') then
      vim.notify('keymaps cannot be reloaded due to `map-unique`', 'warn')
      return
    -- unload from lua cache (assuming that the pwd is ~/.config/nvim)
    elseif is_nvim_config then
      reload_package_chain(filepath, reload_cfg)
    -- run `make`
    else
      vim.cmd.lmake()
    end
  end
end

return { reload = reload }
