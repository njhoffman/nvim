local utils = require("notify.util.render")
local errors = require("notify.demo.errors")
local file_pfx = string.gsub(vim.fn.stdpath("config") .. "/", os.getenv("HOME") .. "/", "")

local get_path = function(file)
  local path = vim.fn.trim(file) or file
  local file_match = string.match(path, ".*" .. file_pfx)
  if file_match then
    path = vim.fn.stdpath("config") .. "/" .. string.gsub(path, file_match, "")
  elseif not string.match(path, "^/") then
    path = vim.fn.stdpath("config") .. "/" .. string.gsub(path, "^./", "")
  end
  return path
end

local logger = require("logger").init("notifier")
local log_parts = function(parts, lines)
  local output = {
    "[prefix]     " .. parts.prefix,
    "[code]       " .. parts.code,
    "[title]      " .. parts.title,
    "[message]    " .. parts.message,
    "[subtitle]   " .. parts.subtitle,
    "[submessage] " .. parts.submessage,
    "[subscope]   " .. parts.subscope,
    "[subdetails] " .. parts.subdetails,
    "[linenr]     " .. parts.linenr,
    "[filepath]   " .. parts.filepath,
    "[prettypath] " .. parts.prettypath,
  }
  for i, stackgroup in ipairs(parts.stackgroups) do
    table.insert(output, "[stack " .. i .. "]     \n    " .. table.concat(stackgroup, "\n    "))
  end

  table.insert(output, '[lines]      \n    "' .. table.concat(lines, '"\n    "') .. '"')
  local is_valid = #parts.title > 0 and (vim.fn.empty(parts.line) or type(parts.line) == "number")
  vim.dbglog("\n" .. table.concat(output, "\n  "))
  -- if #parts.title == 0 or #parts.stack == 0 or (parts.line and type(parts.line) == "number") then
  --   logger:warn("Invalid error parsing \n  " .. table.concat(output, "\n  "))
  -- else
  --   logger:debug("Successful error parsing \n  " .. table.concat(output, "\n  "))
  -- end
end

local get_stackgroups = function(lines)
  local stackgroups = {}
  local stackline_idx = 0
  for i, line in ipairs(lines) do
    if string.match(line, "^%s+") and stackline_idx == 0 then
      stackline_idx = i
      table.insert(stackgroups, {})
    end
    if stackline_idx > 0 then
      line = utils.path_nvim(string.gsub(line, "^%s+", ""))
      if string.len(line) > 0 then
        table.insert(stackgroups[#stackgroups], line)
      end
    elseif string.match(line, "stack traceback:") then
      stackline_idx = stackline_idx == 0 and i or stackline_idx
      table.insert(stackgroups, {})
    end
  end
  stackline_idx = stackline_idx == 0 and 1 or stackline_idx - 1
  return stackgroups, vim.fn.slice(lines, 0, stackline_idx)
end

local error_patterns = {
  is_error = {
    "^Vim%(?[a-z]*%)?:E[%d]+: ?%w+.*",
    "^Vim%(?[a-z]*%)?:Error %w+.*",
    "^E[%d]+: ?%w+.*",
    "^Error %w+.*",
  },
  -- E5108: Error executing lua: /home/nicholas/.config/nvim/lua/funcs/alt-alt.lua:116:
  -- Vim:E565: Not allowed to change text or change window
  items = {
    -- "(E?[%d]*):?(.*)",
    -- "([^:]-):(E[%d]+):(.*)",
    -- "(Vim%(?[a-z]*%)?):?(E?[%d]*):? ?(Error %w+.*)",
    -- "([^:]-):?(E[%d]-):? ?(%w+.*)",
    -- "([^:]-):?(E?[%d]-):? ?(Error .*)",

    -- "([^:]+):(E[%d]+): (.*)",
    -- "([^:]-):?(E[%d]+): (.*)",
    -- "([^:]-):?(E[%d]+): (.*)",
    -- E5112: Error while creating lua chunk: lua/scripts/notify-test.lua:10: 'end' expected (to close 'function' at line 50) near '<eof>'
    -- Error executing Lua callback: /home/nicholas/.local/share/nvim/lazy/vimade/lua/vimade.lua:15: table index is nil
    "(Vim%(?[a-z]*%)?):?([E%d]+):? (.*)",
    "([%a%(%)]-):?([E%d]+): (.*)",
    -- "([%a%(%)]-):?(E?[%d]*):?(%a+.*)",
    "([%a%(%)]-):?(E[%d]+): ?(%w+.*)",
    "([%a%(%)]-):?(E?[%d]*):? ?(Error .*)",
  },
  -- path = '',
  -- linenr = '',
}

local function remove_substring(str, substring)
  -- Find the starting index of the substring
  local start_index, end_index = string.find(str, substring, 1, true)

  -- If the substring does not exist, return the original string
  if not start_index then
    return str
  end

  -- Concatenate the parts of the string before and after the substring
  local result = string.sub(str, 1, start_index - 1) .. string.sub(str, end_index + 1)

  return result
end

local parse_error_item = function(item, parts)
  -- vim.dbglog("item", item)
  -- local parts = { message = item[#item], code = item[#item - 1] }
  -- local parts = {
  --   code = string.match(title_line, ":?(E[%d]+)") or "",
  --   title = string.match(title_line, ":?E[%d]+: ([^:]+:[^:]+:[^:]+)")
  --     or string.match(title_line, ": ([^:]+:[^:]+:[^:]+)")
  --     or "",
  --   subtitle = '',
  -- }

  -- parts.message = string.match(title_line, "[^: ]*:[^:]*: ([^:]*)") or ""
  -- parts.path = string.match(title_line, "([^: ]*):") or ""
  -- parts.linenr = string.match(title_line, "[^: ]*:([^:]*):") or ""
  -- parts.fullpath = get_path(parts.path)
  -- parts.prettypath = utils.path_nvim(string.gsub(parts.fullpath, "^%s+", ""))
  return parts
end

local match_error_item = function(item, idx)
  local new_match = nil
  for _, pfx in ipairs({ ": ", "^" }) do
    for j, pattern in ipairs(error_patterns.items) do
      new_match = { string.match(item, pfx .. pattern) }
      if vim.fn.empty(new_match) == 0 then
        vim.dbglog(idx .. "-" .. j .. "\n", new_match, "\n", pfx .. pattern)
        -- vim.dbglog(
        --   "\n",
        --   vim.fn.empty(new_match) .. " " .. type(new_match),
        --   "\n",
        --   idx .. "-" .. tostring(j) .. pfx .. "| " .. #new_match .. " " .. new_match,
        --   "\n",
        --   pattern
        -- )
        goto continue
      end
    end
  end
  ::continue::
  return new_match
end

local get_error_items = function(error_lines)
  local error_items = {}
  for i = #error_lines, 1, -1 do
    if i == #error_lines then
      local curr = error_lines[i]
      while vim.fn.empty(curr) == 0 do
        local new_match = match_error_item(curr)
        -- vim.dbglog(curr, new_match)
        if not vim.fn.empty(new_match) == 0 then
          table.insert(error_items, new_match)
          curr = remove_substring(curr, new_match)
        else
          table.insert(error_items, curr)
          curr = ""
        end
      end
    end
  end
  return error_items
end

local check_error = function(lines)
  local is_error = false
  for _, pattern in ipairs(error_patterns.is_error) do
    is_error = is_error or string.match(lines[1], pattern)
  end
  return is_error
end

local run_test = function(vals, testvals)
  local test_results = {}
  for i, val in ipairs(vals) do
    local testval = testvals[i]
    local test_result = { val = val, testval = testval }
    if type(val) == "table" then
      for j, v in ipairs(val) do
        local tv = testval[j]
        if v == tv then
          table.insert(test_result, { val = v, testval = tv, result = "pass" })
        else
          table.insert(test_result, { val = v, testval = tv, result = "fail" })
        end
      end
    else
      if val == testval then
        test_result.result = "pass"
      else
        test_result.result = "fail"
      end
    end
    table.insert(test_results, test_result)
  end
  return test_results
end

local display_tests = function(results, testprops)
  vim.dbglog(testprops, results)
end

local run_errors = function(run_tests, indices)
  for idx, err in ipairs(errors) do
    local error_msg, testprops = err[1], err[2]
    if vim.fn.empty(indices) == 1 or vim.tbl_contains(indices, idx) then
      local lines = type(error_msg) == "table" and error_msg or vim.fn.split(error_msg, "\n")
      local is_error = check_error(lines)
      if not is_error then
        vim.dbglog("not error", idx, error_msg)
      else
        local stackgroups, error_lines = get_stackgroups(lines)
        local error_items = get_error_items(error_lines)
        if run_tests and testprops and testprops.items then
          local test_results = run_test(error_items, testprops.items)
          display_tests(test_results, { name = "Error Items", msg = error_msg, idx = idx })
        end

        local error_props = { stackgroups = stackgroups }

        -- vim.dbglog("error matches", error_matches)
        -- for _, error_item in ipairs(error_items) do
        --   parse_error_item(error_item, error_props)
        -- end

        -- vim.dbglog(idx .. "\n    " .. table.concat(lines, "\n    "), parts)
        -- log_parts(parts, lines)
      end
    end

    -- parse_error(error_msg, idx)
  end
end

local opts = { indices = {}, run_tests = true }

run_errors(opts.run_tests, opts.indices)
