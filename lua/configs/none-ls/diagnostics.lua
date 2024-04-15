local null_ls = require('null-ls')

return {
  -- Diagnostics
  null_ls.builtins.diagnostics.actionlint,
  null_ls.builtins.diagnostics.ansiblelint,
  null_ls.builtins.diagnostics.checkmake,
  -- null_ls.builtins.diagnostics.clang_check,
  null_ls.builtins.diagnostics.dotenv_linter,
  -- null_ls.builtins.diagnostics.editorconfig_checker,
  null_ls.builtins.diagnostics.hadolint,
  -- null_ls.builtins.diagnostics.eslint_d,
  null_ls.builtins.diagnostics.gitlint.with({ extra_args = { '--ignore', 'B6' } }),
  null_ls.builtins.diagnostics.golangci_lint,
  null_ls.builtins.diagnostics.gospel,
  null_ls.builtins.diagnostics.jsonlint,
  -- null_ls.builtins.diagnostics.luacheck,
  -- null_ls.builtins.diagnostics.markdownlint,
  -- null_ls.builtins.diagnostics.markuplint,
  -- null_ls.builtins.diagnostics.mdl,
  -- null_ls.builtins.diagnostics.misspell.with({ filetypes = { 'tex' }, args = { '$FILENAME' } }),
  null_ls.builtins.diagnostics.proselint.with({
    filetypes = { 'markdown', 'tex' },
    extra_filetypes = { 'txt', 'text', 'org' },
    command = 'proselint',
  }),
  -- null_ls.builtins.diagnostics.puppet_lint,
  null_ls.builtins.diagnostics.revive,
  null_ls.builtins.diagnostics.rubocop,
  null_ls.builtins.diagnostics.shellcheck.with({
    extra_args = {
      '--enable',
      'add-default-case',
      '--enable',
      'avoid-nullary-conditions',
      '--enable',
      'check-unassigned-uppercase',
      '--enable',
      'deprecate-which',
    },
  }),
  null_ls.builtins.diagnostics.sqlfluff,
  null_ls.builtins.diagnostics.standardrb,
  null_ls.builtins.diagnostics.staticcheck,
  -- null_ls.builtins.diagnostics.tidy,
  -- null_ls.builtins.diagnostics.selene,
  null_ls.builtins.diagnostics.stylelint,
  null_ls.builtins.diagnostics.terraform_validate,
  null_ls.builtins.diagnostics.tfsec,
  -- NOTE: causes treesitter overruns
  -- null_ls.builtins.diagnostics.todo_comments,
  null_ls.builtins.diagnostics.trail_space.with({
    -- for 'mail' it's just annoying
    disabled_filetypes = { 'dirbuf', 'gitcommit', 'lua', 'markdown', 'mail' },
  }),
  -- null_ls.builtins.diagnostics.tsc,
  null_ls.builtins.diagnostics.vint,
  null_ls.builtins.diagnostics.yamllint,
  null_ls.builtins.diagnostics.zsh,

  null_ls.builtins.diagnostics.write_good.with({
    filetypes = { 'tex', '' },
    extra_filetypes = { 'txt', 'text' },
    args = { '--text=$TEXT', '--parse' },
    command = 'write-good',
  }),
}
