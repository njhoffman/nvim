local process_depth = function(state, next, parent)
  state.depth = state.depth + 1
  if vim.islist(next) then
    -- state.depths[depth] =
    -- state.outline
  end
  for key, value in pairs(target) do
    depths[depth] = vim.tbl_keys()
    local has_table = not vim.tbl_islist(target)

    for key, value in pairs(target) do
      if type(value) == "table" then
        depth = depth + 1
        target = value
        break
      end
    end
    table.insert(depths, depth)
  end

  local format_outline = function(target)
    if type(target) ~= "table" then
      return nil
    end

    local state = { outline = {}, totals = {}, depth = 0 }
    local next = target

    while #next > 0 do
      next = process_depth(state)
    end
  end

  return target
end

-- local format_depth = function(target, depth)
--   return target
-- end
--
-- local format_rules = function(target, rules)
--   return target
-- end
--
-- local formatters = {
--   depth = format_depth,
--   outline = format_outline,
--   rules = format_rules,
-- }
--
-- return formatters
