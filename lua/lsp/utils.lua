local util = require('lspconfig').util
local logger = require('logger').init('lsp-root')

local function root_pattern(...)
  local patterns = vim.tbl_flatten({ ... })
  return function(startpath)
    startpath = util.strip_archive_subpath(startpath)
    for _, pattern in ipairs(patterns) do
      local match = util.search_ancestors(startpath, function(path)
        for _, p in ipairs(vim.fn.glob(util.path.join(util.path.escape_wildcards(path), pattern), true, true)) do
          if util.path.exists(p) then
            return path
          end
        end
      end)

      if match ~= nil then
        return match, pattern
      end
    end
  end
end

local log_match = function(client, root_file, pattern)
  local root_short = vim.fn.split(root_file, '/')
  root_short = vim.fn.join(vim.fn.slice(root_short, -1), '/')
  logger:debug('[' .. client .. '] ' .. pattern .. ' -> ' .. root_short)
  return root_file
end

local initRoot = function(name, steps)
  return function(fname)
    local skip_next = false
    local root, pattern = nil, nil
    for i, step in ipairs(steps) do
      if skip_next then
        skip_next = false
      else
        if type(step) == 'table' then
          root, pattern = root_pattern(unpack(step))(fname)
        elseif step == 'git_ancestor' then
          root = util.find_git_ancestor(fname)
          pattern = step
        elseif string.match(step, 'package_json:') then
          local field = vim.fn.split(step, ':')[2] or ''
          local root_files = util.insert_package_json(steps[i + 1], field, fname)
          root, pattern = root_pattern(unpack(root_files))(fname)
          skip_next = true
        else
          error('Invalid step: ' .. step)
        end
        if root then
          return log_match(name, root, pattern)
        end
      end
    end
  end
end

return { initRoot = initRoot }
