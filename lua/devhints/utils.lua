local lines = {}

local match_title = function(line)
  local pattern = "^title: (.+)$"
  return string.match(line, pattern)
end

local match_category = function(line)
  local pattern1 = "^---[-]+$"
  local pattern2 = "^## .+$"
  local matched1 = string.match(line, pattern1)
  local matched2 = string.match(line, pattern2)
  local category = nil
  if matched1 and #matched1 > 3 then
    category = lines[#lines - 1]
  elseif matched2 and #matched2 > 0 then
    category = string.gsub(line, "## ", "")
  end
  return category
end

local match_subcategory = function(line)
  local pattern = "^### (.+)$"
  return string.match(line, pattern)
end

local match_column = function(line)
  local pattern = "^{: .-([a-z]+)-column}$"
  return string.match(line, pattern)
end

local load_file = function(path)
  local file = io.open(path)
  local sections = {}
  local state = {
    title = nil,
    category = nil,
    subcategory = nil,
    column = nil,
    lines = {},
  }

  for line in file:lines() do
    table.insert(lines, line)
    local title = match_title(line)
    local category = match_category(line)
    local column = match_column(line)
    local subcategory = match_subcategory(line)
    if title ~= nil then
      state.title = title
    elseif category ~= nil then
      if #state.lines > 0 then
        table.insert(sections, vim.fn.deepcopy(state))
      end
      state.category = category
      state.column = nil
      state.subcategory = nil
      state.lines = {}
    elseif column ~= nil then
      state.column = column
    elseif subcategory ~= nil then
      if #state.lines > 0 then
        table.insert(sections, vim.fn.deepcopy(state))
      end
      state.subcategory = subcategory
      state.lines = {}
    elseif state.category ~= nil and #line > 0 then
      table.insert(state.lines, line)
    end
  end
  return sections
end

return { load_file = load_file }
