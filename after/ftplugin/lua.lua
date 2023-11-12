-- vim: fdm=marker:fdc=1


vim.cmd([[
if &filetype !=# 'lua'
  finish
endif
]])

vim.api.nvim_set_keymap('n', '<localleader>1', ':luafile%<cr>', { silent = true })

-- Enable `gf` for `require()`d files.
-- Modified (slight cleanup) from
-- https://gist.github.com/iagoleal/92bd781dae1926525cd5e049eb32d64b
-- {{{
local fmt = string.format

-- Iterator that splits a string o a given delimiter
local function split(str, delim)
  delim = delim or '%s'
  return string.gmatch(str, fmt('[^%s]+', delim))
end

-- Find the proper directory separator depending
-- on lua installation or OS.
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

-- Search for lua traditional include paths.
-- This mimics how require internally works.
local function include_paths(fname, ext)
  ext = ext or 'lua'
  local paths = string.gsub(package.path, '%?', fname)
  for path in split(paths, '%;') do
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

local regex = {
  constDeclaration = '^%s*%f[%w_]const%f[^%w_]',
}

local check_wrong_language = function()
  local start = vim.fn.getpos("'[")
  local ending = vim.fn.getpos("']")
  if start ~= nil and ending ~= nil then
    local content = vim.fn.join(
      vim.api.nvim_buf_get_text(0, start[2] - 1, start[3] - 1, ending[2], ending[3] - 1, {}) or { '' },
      '\n'
    )
    vim.dbglog(start, ending, content)
    if string.match(content, regex.constDeclaration) then
      vim.notify('You are in lua not javascript!', 3)
      local new_content = vim.fn.split(string.gsub(content, regex.constDeclaration, 'local '), '\n')
      vim.api.nvim_buf_set_text(0, start[2] - 1, start[3] - 1, ending[2] - 1, ending[3] - 1, new_content)
    end
  end
end

-- vim.api.nvim_create_autocmd('InsertLeave', {
--   callback = function()
--     check_wrong_language()
--     -- if string.match(line_content or '', 'const ') then
--     --   vim.notify('You are in lua not javascript!')
--     --   local new_line_content = string.gsub(line_content, 'pattern', 'replacement')
--     --   vim.api.nvim_buf_set_text(0, line_number - 1, line_number, 0, 1, { new_line_content })
--     -- end
--   end,
-- })

-- Set options to open require with gf
vim.opt_local.include = [=[\v<((do|load)file|require)\s*\(?['"]\zs[^'"]+\ze['"]]=]
vim.opt_local.includeexpr = 'v:lua.find_required_path(v:fname)'
-- }}}
