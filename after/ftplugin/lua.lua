vim.cmd([[
if &filetype !=# 'lua'
  finish
endif
]])

local cmd = vim.cmd
local expand = vim.fn.expand
local fmt = string.format
local u = require('utils.core')

-- habits from writing too much in other languages
u.ftAbbr('//', '--')
u.ftAbbr('const', 'local')
u.ftAbbr('let', 'local')
u.ftAbbr('var', 'local')
u.ftAbbr('fi', 'end')
u.ftAbbr('!=', '~=')
u.ftAbbr('!==', '~=')
-- vim.cmd('setlocal iskeyword+=:')
-- u.ftAbbr(':', '=')
-- shorthands
u.ftAbbr('tre', 'then return end') -- codespell-ignore

local reload_methods = {
  source = false,
  dofile = false,
  require = true,
}

local reload_package_chain = function()
  local packages, package_path = {}, ''
  local src_path = vim.fn.expand('%:r'):gsub('lua/', ''):gsub('/', '.')
  for package_name in string.gmatch(src_path, '[^.]+') do
    package_path = package_path .. (#package_path > 0 and '.' or '') .. package_name
    if package.loaded[package_path] then
      table.insert(packages, package_path)
      package.loaded[package_path] = nil
    end
  end

  for _, pkg in ipairs(packages) do
    local ppath = vim.fn.stdpath('config') .. '/lua/' .. pkg:gsub('%.', '/')
    if vim.fn.filereadable(ppath .. '.lua') == 0 then
      ppath = ppath .. '/init'
    end
    if reload_methods.source == true and vim.fn.filereadable(ppath .. '.lua') then
      vim.cmd.source(ppath .. '.lua')
      vim.notify('sourced: ' .. ppath .. '.lua')
    end
    if reload_methods.dofile == true and vim.fn.filereadable(ppath .. '.lua') then
      dofile(ppath .. '.lua')
      vim.notify('dofile: ' .. ppath .. '.lua')
    end
    if reload_methods.require == true then
      require(pkg)
      vim.notify('reloaded: ' .. pkg)
    end
  end
end

-- if in nvim dir, reload file/plugin, otherwise run `make`
vim.keymap.set('n', '<leader>iR', function()
  cmd('silent update')
  local is_nvim_config = vim.loop.cwd() == vim.fn.stdpath('config')
  local filepath = vim.fn.expand('%:p')

  --- GUARD
  if filepath:find('nvim/after/ftplugin/') then
    vim.notify('ftplugins cannot be reloaded.', 'warn')
    return
  elseif filepath:find('nvim/lua/.*keymap') or filepath:find('nvim/lua/.*keybinding') then
    vim.notify('keymaps cannot be reloaded due to `map-unique`', 'warn')
    return
  -- unload from lua cache (assuming that the pwd is ~/.config/nvim)
  elseif is_nvim_config then
    reload_package_chain()
  -- run `make`
  else
    vim.cmd.lmake()
  end
end, { buffer = true, desc = ' Reload /  Make' })
vim.api.nvim_set_keymap('n', '<localleader>1', ':luafile%<cr>', { silent = true })

-- Enable `gf` for `require()`d files.
-- Modified (slight cleanup) from
-- https://gist.github.com/iagoleal/92bd781dae1926525cd5e049eb32d64b

-- Find the proper directory separator depending on lua installation or OS.
local function dir_separator()
  -- Look at package.config for directory separator string (it's the first line)
  if package.config then
    return string.match(package.config, '^[^\n]')
  elseif vim.fn.has('win32') == 1 then
    return '\\'
  else
    return '/'
  end
end

-- Search for lua traditional include paths (this mimics how require internally works)
local function include_paths(fname, ext)
  ext = ext or 'lua'
  local paths = string.gsub(package.path, '%?', fname)
  for path in u.split(paths, '%;') do
    if vim.fn.filereadable(path) == 1 then
      return path
    end
  end
end

-- Search for nvim lua include paths
local function include_rtpaths(fname, ext)
  ext = ext or 'lua'
  local sep = dir_separator()
  local rtpaths = vim.api.nvim_list_runtime_paths()
  local modfile, initfile = fmt('%s.%s', fname, ext), fmt('init.%s', ext)
  for _, path in ipairs(rtpaths) do
    -- Look on runtime path for 'lua/*.lua' files
    local path1 = table.concat({ path, ext, modfile }, sep)
    if vim.fn.filereadable(path1) == 1 then
      return path1
    end
    -- Look on runtime path for 'lua/*/init.lua' files
    local path2 = table.concat({ path, ext, fname, initfile }, sep)
    if vim.fn.filereadable(path2) == 1 then
      return path2
    end
  end
end

-- Global function that searches the path for the required file
function find_required_path(module)
  -- Look at package.config for directory separator string (it's the first line)
  local sep = string.match(package.config, '^[^\n]')
  -- Properly change '.' to separator (probably '/' on *nix and '\' on Windows)
  local fname = vim.fn.substitute(module, '\\.', sep, 'g')
  local f
  ---- First search for lua modules
  f = include_paths(fname, 'lua')
  if f then
    return f
  end
  -- This part is just for nvim modules
  f = include_rtpaths(fname, 'lua')
  if f then
    return f
  end
  ---- Now search for Fennel modules
  f = include_paths(fname, 'fnl')
  if f then
    return f
  end
  -- This part is just for nvim modules
  f = include_rtpaths(fname, 'fnl')
  if f then
    return f
  end
end

-- Set options to open require with gf
vim.opt_local.include = [=[\v<((do|load)file|require)\s*\(?['"]\zs[^'"]+\ze['"]]=]
vim.opt_local.includeexpr = 'v:lua.find_required_path(v:fname)'
