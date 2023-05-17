local null_ls = require('null-ls')

return {
  -- Code actions
  null_ls.builtins.code_actions.shellcheck,
  null_ls.builtins.code_actions.gitsigns.with({
    config = {
      filter_actions = function(title)
        return title:lower():match('blame') == nil -- filter out blame actions
      end,
    },
  }),
  null_ls.builtins.code_actions.refactoring,
  null_ls.builtins.code_actions.ts_node_action,
  null_ls.builtins.code_actions.gitrebase,
  null_ls.builtins.code_actions.gomodifytags,
  null_ls.builtins.code_actions.impl,
  null_ls.builtins.code_actions.proselint.with({
    filetypes = { 'markdown', 'tex' },
    command = 'proselint',
    args = { '--json' },
  }),
  require('typescript.extensions.null-ls.code-actions'),
}
