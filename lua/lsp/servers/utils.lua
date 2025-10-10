
local M = {}
M.find_root = function(patterns)
  return function(fname)
    local matches = vim.fs.find(patterns, {
      path = fname,
      limit = 5,
      upward = true,
      follow = true,
      stop = vim.loop.os_homedir(),
    }
    )
    local root_dir = vim.fs.dirname( matches[1] )
    vim.dbglog('root', root_dir, matches)
    return root_dir, matches
  end
end

return M
