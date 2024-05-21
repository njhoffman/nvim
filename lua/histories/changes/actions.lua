local change_pos = function(item)
  vim.fn.setpos('.', { 0, item.lnum, item.col, item.coladd })
  vim.fn.setpos('.', { 0, item.lnum, item.col, item.coladd })
end
