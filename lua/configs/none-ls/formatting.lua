local null_ls = require('null-ls')
local iter = require('plenary.iterators')
local path = require('plenary.path')
local scan = require('plenary.scandir')

local eslint_root_files = { '.eslintrc', '.eslintrc.js', '.eslintrc.json' }
local prettier_root_files = { '.prettierrc', '.prettierrc.js', '.prettierrc.json' }
local stylua_root_files = { 'stylua.toml', '.stylua.toml' }
local elm_root_files = { 'elm.json' }

local function search_for_git_repos(base_dirs)
  return iter
    .iter(base_dirs)
    :map(function(base_dir)
      local git_dirs = scan.scan_dir(vim.fn.expand(base_dir.path), {
        depth = base_dir.max_depth,
        add_dirs = true,
        hidden = true,
        search_pattern = '%.git$',
      })
      return iter.iter(git_dirs):map(function(git_dir)
        return path:new(git_dir):parent()
      end)
    end)
    :flatten()
    :tolist()
end

return {
  -- Formatters
  -- null_ls.builtins.formatting.asmfmt,
  null_ls.builtins.formatting.beautysh.with({
    extra_args = function(params)
      return {
        '--indent-size',
        vim.api.nvim_buf_get_option(params.bufnr, 'shiftwidth'),
      }
    end,
  }),
  -- python formatting: autoflake | autopep8 | black | blackd | blue | isort | pyflyby | pyink | reorder_python_imports | ruff | usort | yapf
  -- null_ls.builtins.formatting.black.with({
  --   extra_args = function(params)
  --     return { '--line-length=' .. vim.api.nvim_buf_get_option(params.bufnr, 'textwidth') }
  --   end,
  -- }),
  null_ls.builtins.formatting.clang_format,
  null_ls.builtins.formatting.eslint_d,
  null_ls.builtins.formatting.fixjson,
  null_ls.builtins.formatting.gofmt,
  null_ls.builtins.formatting.goimports,
  null_ls.builtins.formatting.golines,
  null_ls.builtins.formatting.jq,
  -- null_ls.builtins.formatting.lua_format,
  -- null_ls.builtins.formatting.isort.with({ extra_args = { '--profile', 'black' } }),
  null_ls.builtins.formatting.markdownlint,
  null_ls.builtins.formatting.markdown_toc,
  -- null_ls.builtins.formatting.mdformat,
  -- null_ls.builtins.formatting.nginx_beautifier,
  -- null_ls.builtins.formatting.pg_format,
  -- null_ls.builtins.formatting.prettier_eslint,
  null_ls.builtins.formatting.prettierd.with({
    filetypes = {
      'javascript',
      'javascriptreact',
      'typescript',
      'typescriptreact',
      'vue',
      'css',
      'scss',
      'less',
      'html',
      'json',
      'jsonc',
      'yaml',
      'markdown',
      'markdown.mdx',
      'graphql',
      'handlebars',
    },
    condition = function(utils)
      vim.dbglog(utils.has_file({ '.prettierrc', '.prettierrc.js' }))
      return utils.has_file({ '.prettierrc.js', '.prettierrc', '.prettierrc.json' })
    end,
    extra_args = function(params)
      return {
        '--indent-size',
        vim.api.nvim_buf_get_option(params.bufnr, 'shiftwidth'),
        '--html-whitespace-sensitivity',
        'ignore',
      }
    end,
  }),
  -- null_ls.builtins.formatting.prettier.with({
  --   filetypes = { 'css', 'html', 'less', 'scss', 'toml', 'yaml' },
  --   extra_args = function(params)
  --     return {
  --       '--print-width',
  --       vim.api.nvim_buf_get_option(params.bufnr, 'textwidth'),
  --       '--tab-width',
  --       vim.api.nvim_buf_get_option(params.bufnr, 'shiftwidth'),
  --     }
  --   end,
  -- }),
  -- null_ls.builtins.formatting.puppet_lint,
  -- https://github.com/anordal/shellharden/blob/master/how_to_do_things_safely_in_bash.md
  -- null_ls.builtins.formatting.shellharden.with({ filetypes = { 'sh', 'bash' } }),
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
        '--collapse-simple-statement',
        'Never',
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
  -- null_ls.builtins.formatting.remark,
  null_ls.builtins.formatting.rubocop,
  -- null_ls.builtins.formatting.rubyfmt,
  -- null_ls.builtins.formatting.terrafmt,
  -- null_ls.builtins.formatting.terraform_fmt,
  -- null_ls.builtins.formatting.tidy,

  null_ls.builtins.formatting.trim_newlines.with({
    filetypes = { 'tex', 'markdown', 'text', 'txt', 'org' },
    extra_args = function(params)
      return {
        '--no-trim-blank-lines',
        '--no-trim-empty-lines',
        '--no-trim-final-newlines',
      }
    end,
  }),
  null_ls.builtins.formatting.trim_whitespace.with({
    filetypes = { 'tex', 'markdown', 'text', 'txt', 'org' },
  }), -- only works for ff=unix

  null_ls.builtins.formatting.xmlformat,
  null_ls.builtins.formatting.xmllint,
  null_ls.builtins.formatting.yamlfix,
  null_ls.builtins.formatting.yamlfmt,
  -- null_ls.builtins.formatting.yq,
  null_ls.builtins.formatting.golines.with({ extra_args = { '--max-len=120', '--base-formatter=gofumpt' } }),
}
