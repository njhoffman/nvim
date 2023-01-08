local output = function(mode)
  local maps = vim.api.nvim_get_keymap(mode)
  for _, map in pairs(maps) do
    vim.dbglog(mode, map.lhs, map.rhs, map.desc)
  end
end

local output_undesc = function(mode)
  local maps = vim.api.nvim_get_keymap(mode)
  for _, map in pairs(maps) do
    if not map.desc or string.len(map.desc) == 0 then
      vim.dbglog(mode, map.lhs, map.rhs, map.desc)
    end
  end
end

local output_desc = function(mode)
  local maps = vim.api.nvim_get_keymap(mode)
  for _, map in pairs(maps) do
    if map.desc and string.len(map.desc) > 0 then
      vim.dbglog(mode, map.lhs, map.rhs, map.desc)
    end
  end
end

-- output("n")
-- output_undesc("n")
output_desc("n")

-- vim.dbglog(vim.api.nvim_get_keymap('i'))
-- vim.dbglog(vim.api.nvim_get_keymap('c'))
-- vim.dbglog(vim.api.nvim_get_keymap('x'))
-- vim.dbglog(vim.api.nvim_get_keymap('s'))
-- -- vim.dbglog(vim.api.nvim_get_keymap('v'))
-- vim.dbglog(vim.api.nvim_get_keymap('t'))
-- vim.dbglog(vim.api.nvim_get_keymap('l'))
