local u = require('utils.core')
-- When creating a new line with o, make sure there is a trailing comma on the
-- current line
vim.keymap.set('n', 'o', function()
  local line = vim.api.nvim_get_current_line()

  local should_add_comma = string.find(line, '[^,{[]$')
  if should_add_comma then
    return 'A,<cr>'
  else
    return 'o'
  end
end, { buffer = true, expr = true })

-- convert to yaml
vim.keymap.set('n', '<localleader>Fy', function()
  vim.cmd('silent update')
  local filename = vim.fn.expand('%')
  local nameAsYaml = vim.fn.expand('%:r') .. '.yaml'
  local yaml = vim.fn.system({ 'yq', '--output-format=yaml', filename })
  if vim.v.shell_error ~= 0 then
    vim.notify('Error', yaml)
    return
  end
  local error = u.writeToFile(nameAsYaml, yaml, 'w')
  if error then
    vim.notify('Error', error)
    return
  end
  vim.fn.system({ 'open', '-R', nameAsYaml })
end, { buffer = true, desc = ' Convert to yaml' })
