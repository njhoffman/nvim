local path_nvim = function(file)
  local nvim = vim.fn.stdpath('config') .. '/'
  if string.len(nvim) > 0 then
    return string.gsub(file, nvim, '')
  end
  return file
end

local function file_exists(name)
  local f = io.open(name, 'r')
  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end

return { path_nvim = path_nvim, file_exists = file_exists }
