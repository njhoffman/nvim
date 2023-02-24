vim.g.jq_highlight_builtin_functions = 0
-- Don't highlight module prefix, like NAME:: (default: 1)
vim.g.jq_highlight_module_prefix = 0
-- Don't highlight imported JSON file prefix, like $NAME:: (default: 1)
vim.g.jq_highlight_json_file_prefix = 0
-- Highlight objects like .foo (default: 0)
vim.g.jq_highlight_objects = 1
-- Highlight all function calls (default: 0)
-- This will highlight all words directly followed by an opening parenthesis
vim.g.jq_highlight_function_calls = 1
