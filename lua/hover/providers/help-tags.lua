local function init()
  local utils = {}

  utils.path_tail = (function()
    local os_sep = "/"

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

  local langs = vim.split(opts.lang, ",", true)
  if opts.fallback and not vim.tbl_contains(langs, "en") then
    table.insert(langs, "en")
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
  local all_files = vim.api.nvim_get_runtime_file("doc/*", true)
  for _, fullpath in ipairs(all_files) do
    local file = utils.path_tail(fullpath)
    if file == "tags" then
      add_tag_file("en", fullpath)
    elseif file:match("^tags%-..$") then
      local lang = file:sub(-2)
      add_tag_file(lang, fullpath)
    else
      help_files[file] = fullpath
    end
  end

  local Path = require("plenary.path")

  local tags = {}
  local tags_map = {}
  local delimiter = string.char(9)
  for _, lang in ipairs(langs) do
    for _, file in ipairs(tag_files[lang] or {}) do
      local lines = vim.split(Path:new(file):read(), "\n", true)
      for _, line in ipairs(lines) do
        -- TODO: also ignore tagComment starting with ';'
        if not line:match("^!_TAG_") then
          local fields = vim.split(line, delimiter, true)
          if #fields == 3 and not tags_map[fields[1]] then
            if fields[1] ~= "help-tags" or fields[2] ~= "tags" then
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

local function escape_pattern(pattern)
  local escaped = string.gsub(pattern, "^/", "")
  escaped = string.gsub(escaped, "[%-]", "%%-")
  escaped = string.gsub(escaped, "[%(]", "%%(")
  escaped = string.gsub(escaped, "[%)]", "%%)")
  escaped = string.gsub(escaped, "[%*]", "%%*")
  return escaped
end

local function get_md_lines(match)
  local cmd = escape_pattern(match.cmd)
  local lines = {}
  local inside_match = false
  local new_section = false
  local file = io.open(match.filename)
  return { "coming soon: " .. match.cmd }
  -- for line in file:lines() do
  --   if inside_match then
  --     inside_match = true
  --   else
  --     inside_match = string.match(line, cmd)
  --   end

  --   if inside_match then
  --     table.insert(lines, line)
  --   else
  --   end
  --   return lines
  -- end
end

local function get_txt_lines(match)
  local cmd = escape_pattern(match.cmd)
  local pattern_topic = "^=+$"
  local pattern_tag = "%*.*%*$"
  local lines = {}
  local inside_match = false
  local new_section = false
  local file = io.open(match.filename)
  for line in file:lines() do
    if inside_match then
      if string.match(line, pattern_topic) then
        inside_match = false
      end
      if not new_section and string.match(line, pattern_tag) then
        inside_match = false
      end
    else
      inside_match = string.match(line, cmd)
    end

    if inside_match then
      table.insert(lines, line)
    else
      if string.match(line, pattern_topic) then
        new_section = true
      else
        new_section = false
      end
    end
  end
  return lines
end

return {
  init = init,
  get_txt_lines = get_txt_lines,
  get_md_lines = get_md_lines,
}
