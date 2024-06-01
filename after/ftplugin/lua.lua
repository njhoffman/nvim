vim.cmd([[
if &filetype !=# 'lua'
  finish
endif
]])

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
u.ftAbbr('===', '==')
-- vim.cmd('setlocal iskeyword+=:')
-- u.ftAbbr(':', '=')
-- shorthands
u.ftAbbr('tre', 'then return end') -- codespell-ignore

-- if in nvim dir, reload file/plugin, otherwise run `make`
vim.api.nvim_set_keymap('n', '<localleader>1', '<cmd>luafile %<cr>', { silent = true })
vim.api.nvim_set_keymap('n', '<C-1>', '<cmd>Reload | luafile %<cr>', { silent = true })

MiniSplitjoin = MiniSplitjoin or {}

if MiniSplitjoin.gen_hook ~= nil then
  local curly = { brackets = { '%b{}' } }
  -- Add trailing comma when splitting inside curly brackets
  local add_comma_curly = MiniSplitjoin.gen_hook.add_trailing_separator(curly)
  -- Delete trailing comma when joining inside curly brackets
  local del_comma_curly = MiniSplitjoin.gen_hook.del_trailing_separator(curly)
  -- Pad curly brackets with single space after join
  local pad_curly = MiniSplitjoin.gen_hook.pad_brackets(curly)
  -- Create buffer-local config
  vim.b.minisplitjoin_config = {
    split = { hooks_post = { add_comma_curly } },
    join = { hooks_post = { del_comma_curly, pad_curly } },
  }
end

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
Find_Required_Path = function(module)
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
vim.opt_local.includeexpr = 'v:lua.Find_Required_Path(v:fname)'
