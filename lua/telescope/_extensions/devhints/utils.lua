local lines = {}

local match_title = function(line)
  local pattern = "^title: (.+)$"
  return string.match(line, pattern)
end

local match_category = function(line)
  local pattern1 = "^[-]+$"
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

local match_link = function(line)
  local pattern = "%[([^]+]([^)]+))"
  local matches = vim.split(line:match(pattern) or "", "]%(")
  if #matches > 1 then
    return matches
  end
  return nil
end

local match_column = function(line)
  local pattern = "^{: ([^}]+)}$"
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
    links = {},
  }
  if file == nil then
    return sections
  end

  for line in file:lines() do
    if #state.lines == 0 and #string.gsub(line, "^%s+", "") == 0 then
      goto continue
    end
    table.insert(lines, line)
    local column = match_column(line)
    if column ~= nil then
      state.column = column
      goto continue
    end

    local link = match_link(line)
    if link ~= nil then
      table.insert(state.links, link)
      goto continue
    end

    local title = match_title(line)
    local category = match_category(line)
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
      state.links = {}
    elseif subcategory ~= nil then
      if #state.lines > 0 then
        table.insert(sections, vim.fn.deepcopy(state))
      end
      state.subcategory = subcategory
      state.lines = {}
    elseif state.category ~= nil and #line > 0 then
      table.insert(state.lines, line)
    end
    ::continue::
  end
  -- vim.dbglog(sections)
  return sections
end

return { load_file = load_file }
