local null_ls = require('null-ls')

return {
  -- Formatters
  -- null_ls.builtins.formatting.asmfmt,
  null_ls.builtins.formatting.beautysh,
  null_ls.builtins.formatting.black.with({
    extra_args = function(params)
      return { '--line-length=' .. vim.api.nvim_buf_get_option(params.bufnr, 'textwidth') }
    end,
  }),
  null_ls.builtins.formatting.clang_format,
  null_ls.builtins.formatting.eslint_d,
  null_ls.builtins.formatting.fixjson,
  null_ls.builtins.formatting.gofmt,
  null_ls.builtins.formatting.goimports,
  null_ls.builtins.formatting.golines,
  null_ls.builtins.formatting.jq,
  -- null_ls.builtins.formatting.lua_format,
  null_ls.builtins.formatting.isort.with({ extra_args = { '--profile', 'black' } }),
  null_ls.builtins.formatting.markdownlint,
  null_ls.builtins.formatting.markdown_toc,
  -- null_ls.builtins.formatting.mdformat,
  -- null_ls.builtins.formatting.nginx_beautifier,
  -- null_ls.builtins.formatting.pg_format,
  -- null_ls.builtins.formatting.prettier_eslint,
  null_ls.builtins.formatting.prettier.with({
    filetypes = { 'css', 'html', 'less', 'scss', 'toml', 'yaml' },
    extra_args = function(params)
      return {
        '--print-width',
        vim.api.nvim_buf_get_option(params.bufnr, 'textwidth'),
        '--tab-width',
        vim.api.nvim_buf_get_option(params.bufnr, 'shiftwidth'),
      }
    end,
  }),
  -- null_ls.builtins.formatting.puppet_lint,
  null_ls.builtins.formatting.shellharden.with({ filetypes = { 'sh', 'bash' } }),
  null_ls.builtins.formatting.shfmt.with({
    filetypes = { 'sh', 'bash' },
    extra_args = function(params)
      return {
        '--case-indent',
        '--space-redirects',
        '--simplify',
        '--language-dialect',
        'bash',
        '--indent',
        vim.api.nvim_buf_get_option(params.bufnr, 'shiftwidth'),
      }
    end,
  }),
  null_ls.builtins.formatting.sqlfluff,
  -- null_ls.builtins.formatting.sqlfmt,
  null_ls.builtins.formatting.standardrb,
  -- null_ls.builtins.formatting.standardts,
  null_ls.builtins.formatting.stylelint,
  null_ls.builtins.formatting.stylua.with({
    extra_args = function(params)
      return {
        '--quote-style',
        'AutoPreferSingle',
        '--column-width',
        vim.api.nvim_buf_get_option(params.bufnr, 'textwidth'),
        '--indent-width',
        vim.api.nvim_buf_get_option(params.bufnr, 'shiftwidth'),
        '--indent-type',
        'spaces',
      }
    end,
  }),
  null_ls.builtins.formatting.remark,
  null_ls.builtins.formatting.rubocop,
  -- null_ls.builtins.formatting.rubyfmt,
  -- null_ls.builtins.formatting.terrafmt,
  -- null_ls.builtins.formatting.terraform_fmt,
  -- null_ls.builtins.formatting.tidy,
  null_ls.builtins.formatting.trim_newlines,
  null_ls.builtins.formatting.trim_whitespace, -- only works for ff=unix
  null_ls.builtins.formatting.xmlformat,
  null_ls.builtins.formatting.xmllint,
  null_ls.builtins.formatting.yamlfix,
  null_ls.builtins.formatting.yamlfmt,
  -- null_ls.builtins.formatting.yq,
  null_ls.builtins.formatting.golines.with({ extra_args = { '--max-len=120', '--base-formatter=gofumpt' } }),
}
