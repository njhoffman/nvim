local async = require("hover.async")
local help_tags = require("hover.providers.help-tags")
local tags_map, tags = help_tags.init()

local get_word = function()
  local word = vim.fn.expand("<cWORD>") or ""
  local args_pattern = "%([^)]*%)?.*"
  local vim_pattern = "vim%.api%."
  word = string.gsub(word, args_pattern, "()")
  word = string.gsub(word, vim_pattern, "")
  return word
end

local execute = async.void(function(done)
  local word = get_word()
  if not tags_map[word] then
    return done(false)
  end

  local match = tags[tags_map[word]]
  local ext_match = vim.split(match.filename, "%.")
  local ext = ext_match[#ext_match]
  local lines
  if ext == "txt" then
    lines = help_tags.get_txt_lines(match)
  else
    lines = help_tags.get_md_lines(match)
  end

  lines = vim.lsp.util.trim_empty_lines(lines)
  done({ lines = lines, filetype = "help" })
end)

local function enabled(done)
  local is_ft = vim.tbl_contains({
    "lua",
  }, vim.bo.filetype)

  if not is_ft then
    return done(false)
  end

  local word = get_word()
  if not tags_map[word] then
    return done(false)
  end
  return done(true)
end

require("hover").register({
  name = "help",
  menu = "Help",
  desc = "Help",
  priority = 1000,
  enabled = enabled,
  execute = execute,
})
