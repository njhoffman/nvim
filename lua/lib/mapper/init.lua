local records = require('lib.mapper.records')
local commands = require('lib.mapper.commands')
local output = require('lib.mapper.output')

vim.api.nvim_create_user_command('KeymapsTree', function(params)
  local args = vim.fn.split(params.args, ' ')
  if args[1] == 'notify' then
    output.tree_notify()
  else
    output.tree_log()
  end
end, { nargs = '?' })

return {
  map = commands.map,
  vmap = commands.vmap,
  prefix = commands.prefix,
  list = records.list,
  tree = records.tree,
  clues = records.clues,
}
