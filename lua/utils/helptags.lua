local get_help_tags = function()
  local utils = {}

  utils.path_tail = (function()
    local os_sep = '/'

    return function(path)
      for i = #path, 1, -1 do
        if path:sub(i, i) == os_sep then
          return path:sub(i + 1, -1)
        end
      end
      return path
    end
  end)()

  local opts = {}
  opts.lang = vim.F.if_nil(opts.lang, vim.o.helplang)
  opts.fallback = vim.F.if_nil(opts.fallback, true)
  opts.file_ignore_patterns = {}

  local langs = vim.split(opts.lang, ',', true)
  if opts.fallback and not vim.tbl_contains(langs, 'en') then
    table.insert(langs, 'en')
  end
  local langs_map = {}
  for _, lang in ipairs(langs) do
    langs_map[lang] = true
  end

  local tag_files = {}
  local function add_tag_file(lang, file)
    if langs_map[lang] then
      if tag_files[lang] then
        table.insert(tag_files[lang], file)
      else
        tag_files[lang] = { file }
      end
    end
  end

  local help_files = {}
  local all_files = vim.api.nvim_get_runtime_file('doc/*', true)
  for _, fullpath in ipairs(all_files) do
    local file = utils.path_tail(fullpath)
    if file == 'tags' then
      add_tag_file('en', fullpath)
    elseif file:match('^tags%-..$') then
      local lang = file:sub(-2)
      add_tag_file(lang, fullpath)
    else
      help_files[file] = fullpath
    end
  end

  local Path = require('plenary.path')

  local tags = {}
  local tags_map = {}
  local delimiter = string.char(9)
  for _, lang in ipairs(langs) do
    for _, file in ipairs(tag_files[lang] or {}) do
      local lines = vim.split(Path:new(file):read(), '\n', true)
      for _, line in ipairs(lines) do
        -- TODO: also ignore tagComment starting with ';'
        if not line:match('^!_TAG_') then
          local fields = vim.split(line, delimiter, true)
          if #fields == 3 and not tags_map[fields[1]] then
            if fields[1] ~= 'help-tags' or fields[2] ~= 'tags' then
              table.insert(tags, {
                name = fields[1],
                filename = help_files[fields[2]],
                cmd = fields[3],
                lang = lang,
              })
              tags_map[fields[1]] = #tags
            end
          end
        end
      end
    end
  end
  return tags_map, tags
end

local get_word = function()
  local word = vim.fn.expand('<cWORD>') or ''
  local args_pattern = '%([^)]*%)?.*'
  local vim_pattern = 'vim%.api%.'
  word = string.gsub(word, args_pattern, '()')
  word = string.gsub(word, vim_pattern, '')
  return word
end

local ignored_words = { '=' }

local tags_map, tags = get_help_tags()
local search_cursor_word = function()
  local word = get_word()
  if vim.tbl_contains(ignored_words, word) then
    return nil, nil
  else
    return tags[tags_map[word]], word
  end
end

return {
  get_help_tags = get_help_tags,
  search_cursor_word = search_cursor_word,
}
