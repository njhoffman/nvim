local M = {}

M.print_table = function(t, indent)
  indent = indent or ""
  for k, v in pairs(t) do
    if type(v) == "table" then
      print(indent .. k .. ":")
      M.print_table(v, indent .. "  ")
    else
      print(indent .. k .. ": " .. tostring(v))
    end
  end
end

M.remove_invalid_marks = function(marks)
  local valid = {}
  for _, mark in ipairs(marks) do
    if not vim.fn.filereadable(mark.file) then
      vim.cmd("delmarks " .. mark.mark)
    else
      table.insert(valid, mark)
    end
  end
  return valid
end

M.filter_global_marks = function(marks, filters)
  filters = filters or {}
  -- elseif filters.same_project then
  return vim.tbl_filter(function(mark)
    if filters.only_loaded and not vim.api.nvim_buf_is_loaded(mark.info.bufnr) then
      return false
    elseif filters.same_file and mark.info.file ~= vim.api.nvim_get_current_buf() then
      return false
    elseif filters.same_filetype and mark.info.filetype ~= vim.bo.filetype then
      return false
    end
    return true
  end, marks)
end

M.for_each_global_mark = function(callback, filters)
  local invalid = 0
  local marks = M.remove_invalid_marks(vim.fn.getmarklist())
  marks = M.filter_global_marks(marks, filters)
  for _, mark_info in ipairs(marks) do
    if mark_info.mark:match("'[A-Z]") then
      local char = mark_info.mark:sub(2)
      if callback then
        callback(char, mark_info)
      end
    end
  end
end

M.sorted_global_marks = function(filters)
  local marks = {}
  M.for_each_global_mark(function(char, info)
    table.insert(marks, { char = char, info = info })
  end, filters)
  table.sort(marks, function(a, b)
    return a.char < b.char
  end)
  return marks
end

M.log = function(msg)
  vim.dbglog(msg)
end

return M
