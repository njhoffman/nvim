local yank_path = function()
  local path = vim.fn.expand('%:p')
  vim.fn.setreg('+', path)
  local display_path = path:gsub(vim.fn.getenv('HOME'), '~')
  vim.notify('`' .. display_path .. '` yanked to "+"', vim.log.levels.INFO)
end

local yank_cwd = function()
  local project_root
  local ok, project_nvim = pcall(require, 'project_nvim')
  if ok and project_nvim.get_project_root then
    project_root = project_nvim.get_project_root()
  end

  -- Fallback to vim.fn.getcwd() if project_nvim not available
  if not project_root or project_root == '' then
    project_root = vim.fn.getcwd()
  end

  vim.fn.setreg('+', project_root)
  vim.notify('`' .. project_root .. '` yanked to "+"', vim.log.levels.INFO)
end

local function trash_file()
  local fname = vim.api.nvim_buf_get_name(0)

  if fname == '' then
    vim.notify('Cannot trash: buffer has no associated file', vim.log.levels.WARN)
    return
  end

  -- Save file first if modified
  if vim.bo.modified then
    vim.cmd.update({ bang = true })
  end

  local basename = vim.fn.expand('%:t')

  local res = vim.fn.jobstart({ 'trash-put', fname })
  if res > 0 then
    vim.cmd.bwipeout()
    vim.notify('"' .. basename .. '" sent to trash', vim.log.levels.INFO)
  else
    vim.notify('Could not delete file: ' .. fname, vim.log.levels.ERROR)
  end
end
return {
  trash_file = trash_file,
  yank_path = yank_path,
  yank_cwd = yank_cwd,
}
