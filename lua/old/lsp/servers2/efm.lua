local lua_format = {
  formatCommand = "lua-format -i --config=$HOME/.config/nvim/lua/lsp/efm/lua-format.cfg",
  formatStdin = true
}

local luafmt = {
  formatCommand = "luafmt --indent-count 2 --line-width 100 --stdin",
  formatStdin = true
}

local luacheck = {
  lintCommand = "luacheck --globals vim --formatter visual_studio -",
  lintIgnoreExitCode = true,
  lintStdin = true,
  lintFormats = { "%f(%l,%c) : %tarning %m", "%f(%l,%c) : %trror %m" }
}

-- shellcheck shortcomings/bad advice
-- https://freebsdfrau.gitbook.io/serious-shell-programming/shellcheck/introduction
local shellcheck = {
  lintCommand = "shellcheck -x -f gcc -P SCRIPTDIR/ -e SC2004,SC2034,SC2166,SC2169 -",
  -- lintCommand = "shellcheck -f gcc -x",
  lintStdin = true,
  lintIgnoreExitCode = true,
  -- lintFormats = { "%f=%l:%c: %trror: %m", "%f=%l:%c: %tarning: %m", "%f=%l:%c: %tote: %m" },
  lintFormats = { "%f:%l:%c: %trror: %m", "%f:%l:%c: %tarning: %m", "%f:%l:%c: %tote: %m" }
}

local sqlFormat = {
  formatCommand = "sqlformat -a --keywords upper --identifiers lower -",
  formatStdin = true
}

local prettier = {
  -- parser flow|babel|babel-flow|babel-ts|typescript|espree|meriyah|css|less|scss|
  -- json|json5|json-stringify|graphql|markdown|mdx|vue|yaml|glimmer|html|angular|lwc|ruby|rbs|haml
  formatCommand = "prettier --stdin-filepath ${INPUT} --print-width 120 --single-quote --arrow-parens 'avoid' --trailing-comma all",
  formatStdin = true
}

local shfmt = {
  formatCommand = "shfmt -ln bash -i 2 -ci -bn -s",
  lintIgnoreExitCode = true,
  formatStdin = true
}

local languages = {
  -- lua = { luafmt, luacheck },
  -- lua = { luacheck },
  yaml = { prettier },
  bash = { shfmt, shellcheck },
  sh = { shfmt, shellcheck },
  bats = { shfmt, shellcheck },
  sql = { sqlFormat },
  pgsql = { sqlFormat },
  typescript = { prettier }, -- {prettier, eslint}
  javascript = { prettier },
  typescriptreact = { prettier },
  javascriptreact = { prettier }
  -- json = {prettier}
  -- html = {prettier},
  -- scss = {prettier},
  -- css = {prettier},
  -- markdown = {prettier},
  -- rust = {rustfmt}
  -- python = {autopep}
}

local M = {}
local config = require("settings")

M.setup = function()
  require('lspconfig')['efm'].setup{
    settings = {
      languages = languages,
      rootMarkers = {
        -- ".eslintrc.cjs",
        -- ".eslintrc",
        -- ".eslintrc.json",
        -- ".eslintrc.js",
        ".lua-format",
        ".prettierrc",
        ".prettierrc.js",
        ".prettierrc.json",
        ".prettierrc.yml",
        ".prettierrc.yaml",
        ".prettier.config.js",
        ".prettier.config.cjs"
      }
    },
    filetypes = vim.tbl_keys(languages),
    single_file_support = true,
    flags = {
      debounce_text_changes = 150
    },
  }
end

return M
