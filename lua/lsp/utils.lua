local lsp_util = require("lspconfig").util
local logger = require("logger").init("lsp-root")

local function escape_wildcards(path)
  return path:gsub("([%[%]%?%*])", "\\%1")
end

local root_pattern = function(...)
  local patterns = lsp_util.tbl_flatten({ ... })
  return function(startpath)
    vim.dbglog(startpath, patterns)
    startpath = lsp_util.strip_archive_subpath(startpath)
    for _, pattern in ipairs(patterns) do
      local match = lsp_util.search_ancestors(startpath, function(path)
        for _, p in
          ipairs(vim.fn.glob(table.concat({ escape_wildcards(path), pattern }, "/"), true, true))
        do
          if vim.loop.fs_stat(p) then
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
  local root_short = vim.fn.join(vim.fn.slice(vim.fn.split(root_file, "/"), -1), "/")
  logger:debug("[" .. client .. "] " .. pattern .. " -> " .. root_short)
  return root_file
end

local find_git_ancestor = function(startpath)
  return vim.fs.dirname(vim.fs.find(".git", { path = startpath, upward = true })[1])
end

local initRoot = function(name, steps)
  return function(fname)
    local skip_next = false
    local root, pattern = nil, nil
    for i, step in ipairs(steps) do
      if type(step) == "table" then
        root, pattern = root_pattern(unpack(step))(fname)
      elseif step == "git_ancestor" then
        root = find_git_ancestor(fname)
        pattern = step
        -- elseif string.match(step, "package_json:") then
        --   vim.dbglog(step, 1)
        --   -- local field = vim.fn.split(step, ":")[2] or ""
        --   -- vim.dbglog(step, 2, field)
        --   -- local root_files = lsp_util.insert_package_json(steps[i + 1], field, fname)
        --   -- root, pattern = root_pattern(unpack(root_files))(fname)
        --   local _, step_name = vim.fn.split(step, ":")

        --   local root_files = lsp_util.insert_package_json(steps[i + 1], step_name, fname)
        --   root, pattern = root_pattern(unpack(root_files))(fname)
        --   vim.dbglog(step, 3, root, pattern)
        --   skip_next = true
      else
        vim.dbglog("ERROR", name, step)
        error("Invalid step: " .. step)
      end
      if root then
        return log_match(name, root, pattern)
      end
    end
  end
end

return { initRoot = initRoot, root_pattern = root_pattern }
