local utils = {}
-- Utilities ------------------------------------------------------------------
utils.echo = function(msg, is_important)
  local Config = require("mini.surround.Config")
  if Config.get_config().silent then
    return
  end

  -- Construct message chunks
  msg = type(msg) == "string" and { { msg } } or msg
  table.insert(msg, 1, { "(mini.surround) ", "WarningMsg" })

  -- Avoid hit-enter-prompt
  local max_width = vim.o.columns * math.max(vim.o.cmdheight - 1, 0) + vim.v.echospace
  local chunks, tot_width = {}, 0
  for _, ch in ipairs(msg) do
    local new_ch = { vim.fn.strcharpart(ch[1], 0, max_width - tot_width), ch[2] }
    table.insert(chunks, new_ch)
    tot_width = tot_width + vim.fn.strdisplaywidth(new_ch[1])
    if tot_width >= max_width then
      break
    end
  end

  -- Echo. Force redraw to ensure that it is effective (`:h echo-redraw`)
  vim.cmd([[echo '' | redraw]])
  vim.api.nvim_echo(chunks, is_important, {})
end

utils.unecho = function()
  local Config = require("mini.surround.Config")
  if Config.cache.msg_shown then
    vim.cmd([[echo '' | redraw]])
  end
end

utils.get_line_cols = function(line_num)
  return vim.fn.getline(line_num):len()
end

utils.string_find = function(s, pattern, init)
  init = init or 1

  -- Match only start of full string if pattern says so.
  -- This is needed because `string.find()` doesn't do this.
  -- Example: `string.find('(aaa)', '^.*$', 4)` returns `4, 5`
  if pattern:sub(1, 1) == "^" then
    if init > 1 then
      return nil
    end
    return string.find(s, pattern)
  end

  -- Handle patterns `x.-y` differently: make match as small as possible. This
  -- doesn't allow `x` be present inside `.-` match, just as with `yyy`. Which
  -- also leads to a behavior similar to punctuation id (like with `va_`): no
  -- covering is possible, only next, previous, or nearest.
  local check_left, _, prev = string.find(pattern, "(.)%.%-")
  local is_pattern_special = check_left ~= nil and prev ~= "%"
  if not is_pattern_special then
    return string.find(s, pattern, init)
  end

  -- Make match as small as possible
  local from, to = string.find(s, pattern, init)
  if from == nil then
    return
  end

  local cur_from, cur_to = from, to
  while cur_to == to do
    from, to = cur_from, cur_to
    cur_from, cur_to = string.find(s, pattern, cur_from + 1)
  end

  return from, to
end

---@param arr table List of items. If item is list, consider as set for
---   product. Else - make it single item list.
---@private
utils.cartesian_product = function(arr)
  if not (type(arr) == "table" and #arr > 0) then
    return {}
  end
  arr = vim.tbl_map(function(x)
    return vim.islist(x) and x or { x }
  end, arr)

  local res, cur_item = {}, {}
  local process
  process = function(level)
    for i = 1, #arr[level] do
      table.insert(cur_item, arr[level][i])
      if level == #arr then
        -- Flatten array to allow tables as elements of step tables
        table.insert(res, vim.tbl_flatten(cur_item))
      else
        process(level + 1)
      end
      table.remove(cur_item, #cur_item)
    end
  end

  process(1)
  return res
end

utils.wrap_callable_table = function(x)
  if vim.is_callable(x) and type(x) == "table" then
    return function(...)
      return x(...)
    end
  end
  return x
end

return utils
