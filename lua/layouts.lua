local M = {}
function M.smartDuplicate()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local line = vim.api.nvim_get_current_line()

  -- FILETYPE-SPECIFIC TWEAKS
  if vim.bo.ft == "css" then
    local newLine = line
    if line:find("top:") then
      newLine = line:gsub("top:", "bottom:")
    end
    if line:find("bottom:") then
      newLine = line:gsub("bottom:", "top:")
    end
    if line:find("right:") then
      newLine = line:gsub("right:", "left:")
    end
    if line:find("left:") then
      newLine = line:gsub("left:", "right:")
    end
    line = newLine
  elseif vim.bo.ft == "javascript" or vim.bo.ft == "typescript" then
    line = line:gsub("^(%s*)if(.+{)$", "%1} else if%2")
  elseif vim.bo.ft == "lua" then
    line = line:gsub("^(%s*)if( .* then)$", "%1elseif%2")
  elseif vim.bo.ft == "zsh" or vim.bo.ft == "bash" then
    line = line:gsub("^(%s*)if( .* then)$", "%1elif%2")
  elseif vim.bo.ft == "python" then
    line = line:gsub("^(%s*)if( .*:)$", "%1elif%2")
  end

  -- INSERT DUPLICATED LINE
  vim.api.nvim_buf_set_lines(0, row, row, false, { line })

  -- MOVE CURSOR DOWN, AND TO VALUE/FIELD (IF EXISTS)
  local _, luadocFieldPos = line:find("%-%-%-@%w+ ")
  local _, valuePos = line:find("[:=][:=]? ")
  local targetCol = luadocFieldPos or valuePos or col
  vim.api.nvim_win_set_cursor(0, { row + 1, targetCol })
end
function M.gotoMostChangedFile()
  local notifyOpts = { title = "Most changed file", icon = "󰊢" }

  -- get list of changed files
  local gitResponse = vim.system({ "git", "diff", "--numstat", "." }):wait()
  if gitResponse.code ~= 0 then
    vim.notify("Not in git repo.", vim.log.levels.WARN, notifyOpts)
    return
  end
  local changedFiles = vim.split(gitResponse.stdout, "\n", { trimempty = true })
  local gitroot = vim.trim(vim.system({ "git", "rev-parse", "--show-toplevel" }):wait().stdout)
  if #changedFiles == 0 then
    vim.notify("No files with changes found.", nil, notifyOpts)
    return
  end

  -- identify file with most changes
  local targetFile
  local mostChanges = 0
  vim.iter(changedFiles):each(function(line)
    local added, deleted, relPath = line:match("(%d+)%s+(%d+)%s+(.+)")
    if not (added and deleted and relPath) then
      return
    end -- in case of changed binary files

    local absPath = vim.fs.normalize(gitroot .. "/" .. relPath)
    if not vim.uv.fs_stat(absPath) then
      return
    end

    local changes = tonumber(added) + tonumber(deleted)
    if changes > mostChanges then
      mostChanges = changes
      targetFile = absPath
    end
  end)
  local currentFile = vim.api.nvim_buf_get_name(0)
  if targetFile == currentFile then
    vim.notify("Already at only changed file.", nil, notifyOpts)
    return
  end

  vim.cmd.edit(targetFile)
end
