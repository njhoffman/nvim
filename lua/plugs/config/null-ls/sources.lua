-- luacheck: globals vim
local M = {}

local null_ls = require('null-ls')
local null_ls_helpers = require('null-ls.helpers')

local SEVERITIES = null_ls_helpers.diagnostics.severities

local diagnostics_by_line_results = function(content, match_regex, name)
  local result = {}

  for line_number = 1, #content do
    match_regex(function(regex, message, severity)
      local line = content[line_number]
      local start_byte, end_byte = regex:match_str(line)

      if start_byte ~= nil then
        table.insert(result, {
          message = message,
          severity = severity,
          row = line_number,
          col = start_byte + 1,
          end_row = line_number,
          end_col = end_byte + 1,
          source = name,
        })
      end
    end)
  end

  return result
end

local diagnostics_by_line = function(options)
  return {
    method = null_ls.methods.DIAGNOSTICS,
    name = options.name,
    filetypes = {},
    disabled_filetypes = options.disabled_filetypes,
    generator = {
      async = true,
      fn = function(params, done)
        return done(diagnostics_by_line_results(params.content, options.fn, options.name))
      end,
    },
  }
end

local REGEX_TODO = vim.regex('TODO')
local REGEX_FIXME = vim.regex('FIXME')

-- lua: .editorconfig, .stylua.toml,  .lua-format, .luacheckrc

M.sources = {
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
  null_ls.builtins.code_actions.proselint,
  null_ls.builtins.code_actions.proselint.with({
    filetypes = { 'markdown', 'tex' },
    command = 'proselint',
    args = { '--json' },
  }),
  -- Diagnostics
  null_ls.builtins.diagnostics.actionlint,
  null_ls.builtins.diagnostics.ansiblelint,
  null_ls.builtins.diagnostics.checkmake,
  -- null_ls.builtins.diagnostics.clang_check,
  null_ls.builtins.diagnostics.dotenv_linter,
  null_ls.builtins.diagnostics.editorconfig_checker,
  null_ls.builtins.diagnostics.hadolint,
  null_ls.builtins.diagnostics.eslint_d,
  null_ls.builtins.diagnostics.gitlint.with({ extra_args = { '--ignore', 'B6' } }),
  null_ls.builtins.diagnostics.golangci_lint,
  null_ls.builtins.diagnostics.gospel,
  null_ls.builtins.diagnostics.jsonlint,
  -- null_ls.builtins.diagnostics.luacheck,
  null_ls.builtins.diagnostics.markdownlint,
  -- null_ls.builtins.diagnostics.markuplint,
  -- null_ls.builtins.diagnostics.mdl,
  null_ls.builtins.diagnostics.misspell.with({ filetypes = { 'tex' }, args = { '$FILENAME' } }),
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
  null_ls.builtins.diagnostics.todo_comments,
  null_ls.builtins.diagnostics.trail_space.with({
    -- for 'mail' it's just annoying
    disabled_filetypes = { 'dirbuf', 'gitcommit', 'lua', 'markdown', 'mail' },
  }),
  -- null_ls.builtins.diagnostics.tsc,

  null_ls.builtins.diagnostics.write_good.with({
    filetypes = { 'tex', '' },
    extra_filetypes = { 'txt', 'text' },
    args = { '--text=$TEXT', '--parse' },
    command = 'write-good',
  }),

  null_ls.builtins.diagnostics.vint,
  null_ls.builtins.diagnostics.yamllint,
  null_ls.builtins.diagnostics.zsh,

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
  diagnostics_by_line({
    name = 'todo-fixme',
    -- disabled for 'gitcommit'/'gitrebase' because it doesn't make any
    -- sense, sometimes we will want to write TODO and that's a valid part
    -- of the message.
    disabled_filetypes = { 'dirbuf', 'gitcommit', 'gitrebase' },
    fn = function(match_regex)
      match_regex(REGEX_TODO, 'TODO', SEVERITIES.hint)
      match_regex(REGEX_FIXME, 'FIXME', SEVERITIES.hint)
    end,
  }),
}

return M
