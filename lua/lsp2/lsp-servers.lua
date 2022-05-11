-- https://raw.githubusercontent.com/neovim/nvim-lspconfig/master/doc/server_configurations.md

-- local lsp_status = require('lsp-status')
local lspconfig = require("lspconfig")

local util = require("lspconfig.util")
local lsp = vim.lsp

local lspservers = {}

lspservers["awk_ls"] = {
  cmd = {"awk-language-server"},
  filetypes = {"awk"},
  single_file_support = true
}

lspservers["bashls"] = {
  cmd = {"bash-language-server", "start"},
  cmd_env = {GLOB_PATTERN = "*@(.sh|.inc|.bash|.command)"},
  filetypes = {"sh"},
  single_file_support = true,
  root_dir = util.find_git_ancestor
}

lspservers["clangd"] = {filetypes = {"c", "cpp", "cc"}, flags = {debounce_text_changes = 500}}

lspservers["cmake"] = {
  cmd = {"cmake-language-server"},
  filetypes = {"cmake"},
  init_options = {
    buildDirectory = "build"
  },
  -- root_dir = function(dirname) {
  --   return util.root_pattern(".git", "compile_commands.json", "build") or dirname
  -- },
  single_file_support = true
}

lspservers["dockerls"] = {
  cmd = {"docker-langserver", "--stdio"},
  filetypes = {"dockerfile"},
  flags = {debounce_text_changes = 500},
  root_dir = util.root_pattern("Dockerfile"),
  single_file_support = true
}

lspservers["gopls"] = {
  cmd = {"gopls"},
  filetypes = {"go", "gomod"},
  flags = {debounce_text_changes = 500},
  root_dir = util.root_pattern("go.mod", ".git"),
  single_file_support = true
}

lspservers["golangci_lint_ls"] = {
  cmd = {"golangci-lint-langserver"},
  filetypes = {"go", "gomod"},
  flags = {debounce_text_changes = 500},
  init_options = {
    command = {"golangci-lint", "run", "--out-format", "json"}
  },
  root_dir = util.root_pattern("go.work") or util.root_pattern("go.mod", ".golangci.yaml", ".git"),
  single_file_support = true
}

lspservers["graphql"] = {
  cmd = {"graphql-lsp", "server", "-m", "stream"},
  filetypes = {"graphql", "typescriptreact", "javascriptreact"},
  root_dir = util.root_pattern(".git", ".graphqlrc*", ".graphql.config.*")
}

lspservers["jsonls"] = {
  cmd = {"vscode-json-language-server", "--stdio"},
  filetypes = {"json"},
  single_file_support = true,
  flags = {debounce_text_changes = 500},
  root_dir = util.find_git_ancestor,
  init_options = {provideFormatter = true},
  settings = {
    json = {
      schemas = {
        {fileMatch = {"package.json"}, url = "https://json.schemastore.org/package.json"},
        {fileMatch = {"tsconfig*.json"}, url = "https://json.schemastore.org/tsconfig.json"},
        {
          fileMatch = {".prettierrc", ".prettierrc.json", "prettier.config.json"},
          url = "https://json.schemastore.org/prettierrc.json"
        },
        {fileMatch = {".eslintrc", ".eslintrc.json"}, url = "https://json.schemastore.org/eslintrc.json"},
        {
          fileMatch = {".babelrc", ".babelrc.json", "babel.config.json"},
          url = "https://json.schemastore.org/babelrc.json"
        },
        {fileMatch = {"lerna.json"}, url = "https://json.schemastore.org/lerna.json"},
        {fileMatch = {"now.json", "vercel.json"}, url = "https://json.schemastore.org/now.json"},
        {
          fileMatch = {".stylelintrc", ".stylelintrc.json", "stylelint.config.json"},
          url = "http://json.schemastore.org/stylelintrc.json"
        }
      }
    }
  }
}

-- local sumneko_binary_path = vim.fn.exepath("lua-language-server")
-- local sumneko_root_path = vim.fn.fnamemodify(sumneko_binary_path, ":h:h:h")
local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")
local sumneko_config = {
  root_dir = util.root_pattern(".project", ".git"),
  -- root_dir = util.root_pattern('.project', '.git') or bufdir,
  -- cmd = { sumneko_binary_path, "-E", sumneko_root_path .. "/main.lua" },
  single_file_support = true,
  flags = {debounce_text_changes = 500},
  settings = {
    Lua = {
      format = {enable = false},
      -- completion = {keywordSnippet = "Disable"},
      -- runtime = {version = "LuaJIT", path = runtime_path},
      diagnostics = {globals = {"vim", "use"}, disable = {"lowercase-global"}},
      -- workspace = {
      --   -- Make the server aware of Neovim runtime files
      --   library = vim.api.nvim_get_runtime_file("", true)
      --   -- library = {[vim.fn.expand("$VIMRUNTIME/lua")] = true, [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true}
      -- },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {enable = false}
    }
  }
}
local lua_dev = require("lua-dev").setup({runtime_path = false, lspconfig = sumneko_config})
lspservers["sumneko_lua"] = lua_dev

lspservers["pylsp"] = {
  root_dir = function(fname)
    local root_files = {"pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile"}
    return util.root_pattern(unpack(root_files))(fname) or util.find_git_ancestor(fname)
  end,
  single_file_support = true,
  flags = {debounce_text_changes = 500},
  settings = {
    pylsp = {
      plugins = {
        pylint = {enabled = true, executable = "pylint"},
        pyflakes = {enabled = false},
        pycodestyle = {enabled = false},
        jedi_completion = {fuzzy = true},
        pyls_isort = {enabled = true},
        pylsp_mypy = {enabled = true}
      }
    }
  }
}

lspservers["sqls"] = {
  filetypes = {"sql", "mysql", "pgsql", "psql"},
  flags = {debounce_text_changes = 500},
  settings = {
    format = {enable = false},
    sqls = {
      lowercaseKeywords = false,
      connections = {
        {
          driver = "postgresql",
          dataSourceName = "host=localhost port=5432 user=spadash password=spadash database=spadash sslmode=disable"
        }
      }
    }
  }
}

lspservers["terraformls"] = {
  cmd = {"terraform-ls", "serve"},
  filetypes = {"terraform"},
  flags = {debounce_text_changes = 500},
  root_dir = util.root_pattern(".terraform", ".git"),
  single_file_support = true
}

lspservers["tsserver"] = {
  cmd = {"typescript-language-server", "--stdio"},
  single_file_support = true,
  flags = {debounce_text_changes = 500},
  filetypes = {"javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx"},
  init_options = {
    hostInfo = "neovim"
  },
  root_dir = util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git")
}

lspservers["yamlls"] = {
  cmd = {"yaml-language-server", "--stdio"},
  filetypes = {"yaml", "yaml.docker-compose"},
  flags = {debounce_text_changes = 500},
  settings = {redhat = {telemetry = {enabled = false}}},
  single_file_support = true,
  root_dir = util.find_git_ancestor
}

lspservers["vimls"] = {flags = {debounce_text_changes = 500}}

-- -- Formatting via efm
-- https://github.com/tsuyoshicho/vim-efm-langserver-settings
-- local prettier = require "efm/prettier"
-- -- local eslint = require "efm/eslint"
-- local luafmt = require "efm/luafmt"
-- local rustfmt = require "efm/rustfmt"
-- -- local autopep = require "efm/autopep8"

local lua_format = {
  formatCommand = "lua-format -i --config=$HOME/.config/nvim/lua/lsp/efm/lua-format.cfg",
  formatStdin = true
}

local luafmt = {
  formatCommand = "luafmt --indent-count 2 --line-width 120 --stdin",
  formatStdin = true
}

local luacheck = {
  lintCommand = "luacheck --globals vim --formatter visual_studio -",
  lintIgnoreExitCode = true,
  lintStdin = true,
  lintFormats = {"%f(%l,%c) : %tarning %m", "%f(%l,%c) : %trror %m"}
}

-- shellcheck shortcomings/bad advice
-- https://freebsdfrau.gitbook.io/serious-shell-programming/shellcheck/introduction
local shellcheck = {
  lintCommand = "shellcheck -x -f gcc -P SCRIPTDIR/ -e SC2004,SC2034,SC2166,SC2169 -",
  -- lintCommand = "shellcheck -f gcc -x",
  lintStdin = true,
  lintIgnoreExitCode = true,
  -- lintFormats = { "%f=%l:%c: %trror: %m", "%f=%l:%c: %tarning: %m", "%f=%l:%c: %tote: %m" },
  lintFormats = {"%f:%l:%c: %trror: %m", "%f:%l:%c: %tarning: %m", "%f:%l:%c: %tote: %m"}
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
  lua = {luafmt, luacheck},
  yaml = {prettier},
  bash = {shfmt, shellcheck},
  sh = {shfmt, shellcheck},
  sql = {sqlFormat},
  pgsql = {sqlFormat}
  -- json = {prettier}
  -- typescript = {prettier, eslint},
  -- javascript = {prettier, eslint},
  -- typescriptreact = {prettier, eslint},
  -- javascriptreact = {prettier, eslint},
  -- html = {prettier},
  -- scss = {prettier},
  -- css = {prettier},
  -- markdown = {prettier},
  -- rust = {rustfmt}
  -- python = {autopep}
}

lspservers["efm"] = {
  root_dir = util.root_pattern({"yarn.lock", "package.json", ".project", ".git", vim.fn.getcwd()}),
  single_file_support = true,
  filetypes = vim.tbl_keys(languages),
  init_options = {documentFormatting = true, hover = true, documentSymbol = true, codeAction = true},
  settings = {
    languages = languages,
    -- log_level = 1,
    log_file = vim.fn.stdpath("cache") .. "/lsp/efm.log",
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
  }
}

-- Floating border
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or {{" ", "FloatBorder"}}
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

local utils = require("lsp.utils")
local lsp_formatting = function(bufnr)
  vim.lsp.buf.format {
    bufnr = bufnr,
    filter = function(clients)
      return vim.tbl_filter(
        function(client)
          if client.name == "eslint" then
            return true
          end
          if client.name == "null-ls" then
            return not utils.table.some(
              clients,
              function(_, other_client)
                return other_client.name == "eslint"
              end
            )
          end
        end,
        clients
      )
    end
  }
end

local opts = {noremap = true, silent = true, nowait = true}

vim.api.nvim_set_keymap("n", "<space>e", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
vim.api.nvim_set_keymap("n", "<space>lp", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
vim.api.nvim_set_keymap("n", "<space>ln", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
vim.api.nvim_set_keymap("n", "<space>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)

local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
  vim.api.nvim_buf_set_keymap(
    bufnr,
    "n",
    "<space>wl",
    "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
    opts
  )
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>lr", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>lc", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>lf", "<cmd>lua vim.lsp.buf.format()<CR>", opts)

  if client.supports_method "textDocument/formatting" then
    utils.buf_command(
      bufnr,
      "LspFormatting",
      function()
        lsp_formatting(bufnr)
      end
    )

    vim.api.nvim_clear_autocmds {group = augroup, buffer = bufnr}
    vim.api.nvim_create_autocmd(
      "BufWritePre",
      {
        group = augroup,
        buffer = bufnr,
        command = "LspFormatting"
      }
    )
  end
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
local had_cmp_nvim_lsp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if had_cmp_nvim_lsp then
  capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)
end

local had_lspconfig = pcall(require, "lspconfig")
if had_lspconfig then
  for name, server in pairs(lspservers) do
    -- require("lsp.servers." .. server).setup(on_attach, capabilities)
    lspconfig[name].setup(server)
  end
end

-- Gutter sign icons
for type, icon in pairs(utils.signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, {text = icon, texthl = hl, numhl = ""})
end

-- Prefix diagnostic virtual text
vim.diagnostic.config {
  virtual_text = {
    source = "always",
    prefix = " ",
    spacing = 6
  },
  float = {
    header = false,
    source = "always"
  },
  signs = true,
  underline = false,
  update_in_insert = false
}

-- local lsp_installer = require "nvim-lsp-installer"
-- local custom_attach = require("lsp/on_attach").custom_attach

-- for name, def in pairs(lspservers) do
--   local server_is_found, server = lsp_installer.get_server(name)
--   if server_is_found and not server:is_installed() then
--     vim.notify("Installing " .. name, "info")
--     server:install()
--   end
--   def.on_attach = custom_attach
--   lspconfig[name].setup(def)
-- end

-- -- local capabilities = require("cmp_nvim_lsp").update_capabilities(lsp.protocol.make_client_capabilities())

-- -- local capabilities = vim.lsp.protocol.make_client_capabilities()
-- -- local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())
-- -- capabilities.textDocument.completion.completionItem.snippetSupport = true

-- -- for _, server in ipairs(lsp_installer.get_installed_servers()) do
-- --   -- (optional) Customize the options passed to the server
-- --   local server_config = lspservers[server.name] or {}
-- --   server_config.capabilities = capabilities
-- --   if (server.name == "sqls") then
-- --     server_config.on_attach = function(client, bufnr)
-- --       require("sqls").setup {picker = "default"} -- telescope, fzf, default
-- --       client.server_capabilities.execute_command = true
-- --       client.server_capabilities.document_formatting = false
-- --       client.server_capabilities.document_range_formatting = false
-- --       client.commands = require("sqls").commands -- Neovim 0.6+ only
-- --       custom_attach(client, bufnr)
-- --     end
-- --   elseif (server.name == "sumneko_lua") then
-- --     server_config.on_attach = function(client, bufnr)
-- --       client.server_capabilities.document_formatting = false
-- --       client.server_capabilities.document_range_formatting = false
-- --       custom_attach(client, bufnr)
-- --     end
-- --   else
-- --     server_config.on_attach = custom_attach
-- --   end
-- -- end
