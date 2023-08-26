local stats_track = function(args) end
--- Create a flat list of all files in a directory
-- @param directory - The directory to scan (default value = './')
-- @param recursive - Whether or not to scan subdirectories recursively (default value = true)
-- @param extensions - List of extensions to collect, if blank all will be collected
function scandir(directory, recursive, extensions)
  directory = directory or ''
  recursive = recursive or false
  local current_directory = directory
  local command = 'ls ' .. current_directory .. ' -p'
  if recursive then
    command = command .. 'R'
  end

  local fileList = {}
  local dirList = { current_directory }
  local lines = 0

  local add_file = function(file_name)
    local path = current_directory .. file_name
    local lines_cmd = table.remove(vim.fn.systemlist('wc -l ' .. path .. '| cut -f1 -d" "'), 1)
    if type(tonumber(lines_cmd)) == 'nil' then
      vim.dbglog('NIL', path)
    else
      lines = lines + tonumber(lines_cmd)
    end
    table.insert(fileList, path)
  end

  for fileName in io.popen(command):lines() do
    if string.sub(fileName, -1) == '/' then
      table.insert(dirList, fileName)
    elseif string.sub(fileName, -1) == ':' then
      current_directory = string.sub(fileName, 1, -2)
      current_directory = current_directory .. '/'
    elseif string.len(fileName) == 0 then
      -- Blank line
      current_directory = directory
      -- elseif string.find(fileName,"%.lua$") then
      -- File is a .lua file
    else
      if type(extensions) == 'table' then
        for _, extension in ipairs(extensions) do
          if string.find(fileName, '%.' .. extension .. '$') then
            vim.fn.add_file(fileName)
          end
        end
      else
        add_file(fileName)
      end
    end
  end
  return fileList, dirList, lines
end

local get_dir_size = function(path)
  return table.remove(vim.fn.systemlist('du -shc * ' .. path .. '| tail -n1 | cut -f1'), 1)
end

local stats_files = function(args, state)
  local plugins_size = get_dir_size(vim.fn.stdpath('data') .. '/lazy')
  local nvim_size = get_dir_size(vim.fn.stdpath('config'))
  local nvim_files, nvim_dirs, nvim_lines = scandir(vim.fn.stdpath('config'), true)
  local plugin_files, plugin_dirs, plugin_lines = scandir(vim.fn.stdpath('data') .. '/lazy', true)
  vim.dbglog({
    plugins_size = plugins_size,
    plugin_dirs = #plugin_dirs,
    plugin_files = #plugin_files,
    plugin_lines = plugin_lines,
    nvim_size = nvim_size,
    nvim_files = #nvim_files,
    nvim_dirs = #nvim_dirs,
    nvim_lines = nvim_lines,
  })
end

local stats = function(args)
  stats_files()
  -- local cmd_map = {
  --   configs = stats_configs,
  -- }
  -- if cmd_map[args[2]] then
  --   cmd_map[args[2]](args)
  -- else
  --   stats_overview(args)
  -- end
end
return {
  stats = stats,
  stats_track = stats_track,
}
