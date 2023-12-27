local yank_path = function()
  local path = vim.fn.expand('%:p')
  vim.fn.setreg('+', path)
  path = path:gsub(vim.fn.getenv('HOME'), '~')
  vim.notify('`' .. path .. '` yanked to "+"', 2)
end

local yank_cwd = function()
  local project_root = require('project_nvim').get_project_root()
  vim.fn.setreg('+', project_root)
  vim.notify('`' .. project_root .. '` yanked to "+"', 2)
end

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
return {
  trash_file = trash_file,
  yank_path = yank_path,
  yank_cwd = yank_cwd,
}
