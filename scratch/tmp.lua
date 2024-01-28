local operators = vim.api.nvim_get_keymap('o')
local motions = vim.api.nvim_get_keymap('')

for _, map in pairs(operators) do
  print('Operator: ' .. map.lhs)
end

for _, map in pairs(motions) do
  print('Motion: ' .. map.lhs)
end
