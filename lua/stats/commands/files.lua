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
  local stats = { size = 0, lines = 0 }

  local add_file = function(file_name)
    local path = current_directory .. file_name
    table.insert(fileList, path)
    local file = io.open(path, 'r+b')
    vim.dbglog(path, file)
    -- local content = file:read('*a')
    -- _, lines = content:gsub('\n', '')
    -- stats.size = stats.size + file:seek('end')
    -- stats.lines = stats.lines + lines
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
            add_file(fileName)
          end
        end
      else
        add_file(fileName)
      end
    end
  end
  return { fileList, dirList, stats }
end

-- for key, value in ipairs(scandir(vim.fn.stdpath('config'), true)) do
--   vim.dbglog(value)
-- end
-- local stats_files = function(args, state) end
-- local stats = function(args)
--   stats_files(args)
--   -- local cmd_map = {
--   --   configs = stats_configs,
--   -- }
--   -- if cmd_map[args[2]] then
--   --   cmd_map[args[2]](args)
--   -- else
--   --   stats_overview(args)
--   -- end
-- end
return {
  stats = stats,
  stats_track = stats_track,
}
