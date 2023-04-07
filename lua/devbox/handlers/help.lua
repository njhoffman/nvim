local helptags = require("utils.helptags")

local tags_map = helptags.init()

local match_tag = function(word, done, provider)
  local result = { summary = " help  ", hl = "DebugMsg", name = "help" }
  local args_pattern = "%([^)]*%)?.*"
  local vim_pattern = "vim%.api%."
  word = string.gsub(word, args_pattern, "()")
  word = string.gsub(word, vim_pattern, "")
  if tags_map[word] then
    result.summary = " help  " .. word
    result.hl = "MoreMsg"
    result.content = tags_map[word]
    done(provider, result)
  else
    done(provider, result)
  end
end

local help_handler = function(done, provider)
  local word = vim.fn.expand("<cWORD>") or ""
  match_tag(word, done, provider)
end

return {
  handler = help_handler,
  tags = tags_map,
}
