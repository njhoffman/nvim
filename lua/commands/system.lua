local function trash_file()
  vim.cmd.update({ bang = true })
  local fname = vim.api.nvim_buf_get_name(0)
  local basename = vim.fn.expand('%:t')
  local res = vim.fn.jobstart({ 'trash-put', fname })
  if res > 0 then
    vim.cmd.bwipeout()
    vim.notify('"' .. basename .. '" sent to trash.')
  else
    vim.notify(res .. ' - Could not delete file: ' .. fname, 5)
  end
end

return { trash_file = trash_file }
