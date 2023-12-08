local helputils = require('utils.helptags')
local function get_help_cursor()
  local match, word = helputils.search_cursor_word()
  if match then
    vim.cmd('help ' .. word)
  else
    require('telescope.run')('builtin', 'help_tags')
  end
end

return { get_help_cursor = get_help_cursor }
