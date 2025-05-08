local A = vim.api

local patch = function(U)
  ---Get region for line movement or visual selection
  ---NOTE: Returns the current line region, if `opmode` is not given.
  ---@param opmode? OpMotion
  ---@return CommentRange
  U.get_region = function(opmode)
    if not opmode then
      local row = unpack(A.nvim_win_get_cursor(0))
      return { srow = row, scol = 0, erow = row, ecol = 0 }
    end

    -- local marks = string.match(opmode, '[vV]') and { '<', '>' } or { '[', ']' }
    -- local sln, eln = A.nvim_buf_get_mark(0, marks[1]), A.nvim_buf_get_mark(0, marks[2])
    local marks = string.match(vim.fn.mode(), "[vV]") and { "v", "." }
      or (string.match(opmode, "[vV]") and { "'<", "'>" } or { "'[", "']" })

    local sln, eln = vim.fn.getpos(marks[1]), vim.fn.getpos(marks[2])
    return { srow = sln[2], scol = sln[3] - 1, erow = eln[2], ecol = eln[3] - 1 }
    --  return { srow = sln[1], scol = sln[2], erow = eln[1], ecol = eln[2] }
  end
end

return { patch = patch }
