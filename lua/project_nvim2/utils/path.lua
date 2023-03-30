local uv = vim.loop

local paths = {
  datapath = "",
  projectpath = "",
  historyfile = "",
}

paths.init = function(opt)
  paths.datapath = opt.datapath
  paths.projectpath = paths.datapath .. "/project_nvim" -- directory
  paths.historyfile = paths.projectpath .. "/project_history" -- file
end

paths.create_scaffolding = function(callback)
  if callback ~= nil then -- async
    uv.fs_mkdir(paths.projectpath, 448, callback)
  else -- sync
    uv.fs_mkdir(paths.projectpath, 448)
  end
end

paths.is_excluded = function(dir)
  local config = require("project_nvim.config")
  for _, dir_pattern in ipairs(config.options.exclude_dirs or {}) do
    if dir:match(dir_pattern) ~= nil then
      return true
    end
  end

  return false
end

return paths
