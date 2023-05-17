local helputils = require('utils.helptags')

local helptags = function(_, _)
  local match = helputils.search_cursor_word()
  --  ﲉ 
  if match then
    return 'ﲉ'
  else
    return ' '
  end
end

return {
  name = 'helptags',
  provider = helptags,
}
