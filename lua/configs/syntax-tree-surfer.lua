local opts = { noremap = true, silent = true }
local sts = require('syntax-tree-surfer')

sts.setup({
  highlight_group = 'STS_highlight',
  disable_no_instance_found_report = false,
  default_desired_types = {
    'function',
    'function_definition',
    'struct_definition',
    'if_statement',
    'else_clause',
    'do_clause',
    'else_statement',
    'elseif_statement',
    'for_statement',
    'let_statement',
    'while_statement',
    'switch_statement',
  },
  left_hand_side = 'fdsawervcxqtzb',
  right_hand_side = 'jkl;oiu.,mpy/n',
  icon_dictionary = {
    ['if_statement'] = '𝒾',
    ['else_clause'] = 'ℯ',
    ['else_statement'] = 'ℯ',
    ['elseif_statement'] = 'ℯ',
    ['elseif_clause'] = 'ℯ',
    ['for_statement'] = 'ﭜ',
    ['while_statement'] = 'ﯩ',
    ['switch_statement'] = 'ﳟ',
    ['function'] = '󰊕',
    ['function_definition'] = '󰊕',
    ['variable_declaration'] = '',
    ['let_statement'] = 'ℒ',
    ['do_statement'] = '𝒟',
    ['struct_definition'] = '𝒮',
  },
})

vim.keymap.set('n', ';f', function() -- jump to all that you specify
  sts.targeted_jump({
    'function',
    'function_definition',
    'struct_definition',
    'if_statement',
    'else_clause',
    'do_clause',
    'else_statement',
    'elseif_statement',
    'for_statement',
    'let_statement',
    'while_statement',
    'switch_statement',
  })
end, { noremap = true, silent = true, desc = 'Node Jumps ' })

lambda.command('STSJumpToTop', function()
  require('syntax-tree-surfer').go_to_top_node_and_execute_commands(
    false,
    { 'normal! O', 'normal! O', 'startinsert' }
  )
end, {})
