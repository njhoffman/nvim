local null_ls = require('null-ls')
local h = require('null-ls.helpers')
local scan = require('plenary.scandir')

local root_files = {
  eslint = {
    '.eslintrc',
    '.eslintrc.js',
    '.eslintrc.json',
  },
  prettier = {
    '.prettierrc',
    '.prettierrc.js',
    '.prettierrc.json',
  },
  stylua = {
    'stylua.toml',
    '.stylua.toml',
  },
  elm = {
    'elm.json',
  },
}

local lsp_util = require('lspconfig/util')
-- local stylua_found = util.root_pattern({'stylua.toml', '.stylua.toml'})(params.bufname)

function search_ancestors(path, patterns)
  local stats = vim.loop.fs_stat(path)
  local parent = vim.fn.fnamemodify(path, ':h')
  if stats and stats.type == 'directory' then
    local matched_files = scan.scan_dir(path, {
      depth = 1,
      add_dirs = false,
      hidden = true,
      search_pattern = patterns,
    })
    if #matched_files > 0 then
      return matched_files[1]
    end
  end
  if parent ~= nil and path ~= '/' then
    return search_ancestors(parent, patterns)
  else
    return false
  end
end

local get_config_file = function(patterns, start_dir)
  start_dir = start_dir or vim.fn.expand('%:p:h')
  patterns = patterns or {}
  local config_file = search_ancestors(start_dir, patterns)
  -- vim.dbglog('get_config_file', config_file)
  return config_file
end

return {
  -- Formatters
  -- null_ls.builtins.formatting.asmfmt,
  null_ls.builtins.formatting.beautysh.with({
    filetypes = { 'sh', 'bash' },
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
    condition = function()
      -- local prettier_found = search_ancestors(vim.fn.expand("%:p:h"), "%.prettierrc")
      -- if prettier_found and #prettier_found > 0 then
      --   vim.notify("prettierd: " .. prettier_found[1], 0)
      --   return true
      -- end
      return true
    end,
    cwd = h.cache.by_bufnr(function(params)
      return lsp_util.root_pattern({
        '.prettierrc',
        '.prettierrc.json',
        '.prettierrc.yml',
        '.prettierrc.yaml',
        '.prettierrc.json5',
        '.prettierrc.js',
        '.prettierrc.cjs',
        '.prettierrc.toml',
        'prettier.config.js',
        'prettier.config.cjs',
        'package.json',
      })(params.bufname)
    end),
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
  null_ls.builtins.formatting.rustfmt.with({
    extra_args = function(params)
      local Path = require('plenary.path')
      local cargo_toml = Path:new(params.root .. '/' .. 'Cargo.toml')
      if cargo_toml:exists() and cargo_toml:is_file() then
        for _, line in ipairs(cargo_toml:readlines()) do
          local edition = line:match([[^edition%s*=%s*%"(%d+)%"]])
          if edition then
            return { '--edition=' .. edition }
          end
        end
      end
      -- default edition when we don't find `Cargo.toml` or the `edition` in it.
      return { '--edition=2021' }
    end,
  }),
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
  -- --Shell
  -- formatting.shfmt,
  -- diagnostics.shellcheck.with { diagnostics_format = "#{m} [#{c}]" },
  --
  -- --python
  -- formatting.autopep8.with { extra_args = { "--style", "{IndentWidth:2 }" } },
  -- diagnostics.flake8,
  --
  -- -- cpp, cmake
  -- formatting.clang_format.with { extra_args = { "--style", "{IndentWidth: 2}" } },
  -- diagnostics.clang_check,
  --
  -- --Code Spell Checker
  -- diagnostics.codespell.with { args = { "--ignore-words-list=Tung" } },
  null_ls.builtins.formatting.sqlfluff.with({
    extra_args = function(params)
      local file_extension = vim.fn.fnamemodify(params.bufname, ':e')
      -- ANSI,Athena,BigQuery,ClickHouse,DataBricks,dbt,Exasol,Firebird,Greenplum,
      -- Hive,Impala,Materialize,MySQL,Oracle,PostgreSQL,Redshift,Spark,SQLServer,Snowflake,
      -- SQLite,T-SQL,Teradata,Trino
      return {
        '--dialect',
        'postgres',
        '--indentation',
        vim.api.nvim_buf_get_option(params.bufnr, 'shiftwidth'),
      }
    end,
  }),
  -- null_ls.builtins.formatting.sqlfmt,
  null_ls.builtins.formatting.standardrb,
  -- null_ls.builtins.formatting.standardts,
  null_ls.builtins.formatting.stylelint,
  null_ls.builtins.formatting.stylua.with({
    _config_file = get_config_file(root_files.stylua),
    filetypes = { 'lua' },
    condition = function()
      if vim.bo.filetype ~= 'lua' then
        return false
      end
      local config_file = get_config_file(root_files.stylua)
      return vim.fn.executable('stylua') > 0 and config_file
    end,
    -- -- cwd = h.cache.by_bufnr(function(params)
    -- --   local util = require "lspconfig/util"
    -- --   return stylua_found
    -- -- end),
    -- -- params.bufnr, client_id, command, content, cwd, lsp_method, method, options, root
    extra_args = function(params)
      local local_config = get_config_file(root_files.stylua)
      local bufnr = params.bufnr or 0
      local column_width = vim.api.nvim_buf_get_option(bufnr, 'textwidth')
      column_width = column_width > 0 and column_width or 100
      local args = {
        '--call-parentheses',
        'Always',
        '--collapse-simple-statement',
        'Never',
        '--quote-style',
        'AutoPreferSingle',
        '--column-width',
        column_width,
        '--indent-width',
        vim.api.nvim_buf_get_option(bufnr, 'shiftwidth'),
      }
      if local_config ~= nil then
        table.insert(args, '--config-path')
        table.insert(args, local_config)
      end
      return args
      -- sources.root, sources.cwd
      -- editorconfig generator.opts._last_args, _last_command, _last_cwd
      -- local sources = require("null-ls.sources")
      -- local lua_src = sources.get_available('lua')
    end,
  }),
  -- null_ls.builtins.formatting.remark,
  null_ls.builtins.formatting.rubocop,
  -- null_ls.builtins.formatting.rubyfmt,
  -- null_ls.builtins.formatting.terrafmt,
  -- null_ls.builtins.formatting.terraform_fmt,
  -- null_ls.builtins.formatting.tidy,

  -- null_ls.builtins.formatting.trim_newlines.with({
  --   -- filetypes = {
  --   --   'tex',
  --   --   'markdown',
  --   --   'text',
  --   --   'txt',
  --   --   'org',
  --   -- },
  --   extra_args = function(params)
  --     return {
  --       '--no-trim-blank-lines',
  --       '--no-trim-empty-lines',
  --       '--no-trim-final-newlines',
  --     }
  --   end,
  -- }),

  null_ls.builtins.formatting.xmlformat,
  null_ls.builtins.formatting.xmllint,
  null_ls.builtins.formatting.yamlfix,
  null_ls.builtins.formatting.yamlfmt,
  -- null_ls.builtins.formatting.yq,
  null_ls.builtins.formatting.golines.with({
    extra_args = {
      '--max-len=120',
      '--base-formatter=gofumpt',
    },
  }),
}
