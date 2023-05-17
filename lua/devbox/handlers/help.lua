local helputils = require('utils.helptags')

-- local tags_map = helptags.init()
--
-- local match_tag = function(word, done, provider)
--   local result = { summary = ' help  ', hl = 'DebugMsg', name = 'help' }
--   local args_pattern = '%([^)]*%)?.*'
--   local vim_pattern = 'vim%.api%.'
--   word = string.gsub(word, args_pattern, '()')
--   word = string.gsub(word, vim_pattern, '')
-- end

local help_handler = function(done, provider)
  local result = { summary = ' help  ', hl = 'DebugMsg', name = 'help' }
  local match, word = helputils.search_cursor_word()
  if match then
    result.summary = ' help  ' .. word
    result.hl = 'MoreMsg'
    result.content = match
  end
  done(provider, result)
end

return {
  handler = help_handler,
}
