local helputils = require('utils.helptags')
local function get_help_cursor()
  require('configs.telescope.launcher')('builtin', 'help_tags')
  -- local match, word = helputils.search_cursor_word()
  -- if match then
  --   vim.cmd('help ' .. word)
  -- else
  --   require('configs.telescope.launcher')('builtin', 'help_tags')
  -- end
end

-- TODO: edit command on helpfile should open src on dest
-- TODO: automatic export on file save
-- TODO: consistent tag prefixes

local cfg = {
  dir_src = vim.fn.stdpath('config') .. '/doc/helpfiles',
  dir_dest = vim.fn.stdpath('data') .. '/site/doc',
  template_src = vim.fn.stdpath('config') .. '/doc/helpfiles/_template.txt',
  template_dest = vim.fn.stdpath('config') .. '/doc/helpfiles/template.txt',
}

local edit_new_helpfile = function()
  if vim.fn.filereadable(cfg.template_src) == 0 then
    vim.notify('File not found: ' .. cfg.template_src)
    return
  end
  -- todo: check for existing
  vim.cmd('!cp -n ' .. cfg.template_src .. ' ' .. cfg.template_dest)
  vim.cmd('e ' .. cfg.template_dest)
end

local export_help_files = function()
  if vim.fn.isdirectory(cfg.dir_help) == 0 then
    vim.fn.mkdir(cfg.dir_dest, 'p')
  end

  local n = 0
  local helpglob = vim.fn.glob(cfg.dir_src .. '/*', nil, true)
  for _, file in ipairs(helpglob) do
    if file ~= '_template.txt' then
      vim.cmd('!cp ' .. file .. ' ' .. cfg.dir_dest)
      vim.cmd('helptags ' .. cfg.dir_dest)
      n = n + 1
    end
  end
  vim.notify('Exported ' .. n .. ' help files to ' .. cfg.dir_dest)
end

return {
  edit_new_helpfile = edit_new_helpfile,
  export_help_files = export_help_files,
  get_help_cursor = get_help_cursor,
}
