-- local lsp_status = require('lsp-status')
local util = require("lspconfig.util")
local api = vim.api
local lsp = vim.lsp

-- local sumneko_binary_path = vim.fn.exepath("lua-language-server")
-- local sumneko_root_path = vim.fn.fnamemodify(sumneko_binary_path, ":h:h:h")
local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

local show_documentation = function(bufnr)
  local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")

  if (ft == "lua") then
  else
  end
  -- " Use K to show documentation in preview window
  -- nnoremap <silent> K :call <SID>show_documentation()<CR>

  -- function! s:show_documentation()
  --   if (&filetype == 'lua')
  --     let s:word = expand('<cWORD>')
  --     echo s:word
  --     if (stridx(s:word, 'vim.api.') >= 0 || stridx(s:word, 'api.') >= 0)
  --       execute 'h ' . expand('<cword>')
  --     else
  --       call CocAction('doHover')
  --     endif
  --   elseif (index(['vim','help'], &filetype) >= 0)
  --     execute 'h '.expand('<cword>')
  --   else
  --     call CocAction('doHover')
  --   endif
  -- endfunction
end

local custom_attach = function(client, bufnr)
  local function buf_set_keymap(...) api.nvim_buf_set_keymap(bufnr, ...) end

  -- lsp_status.on_attach(client)
  require"lsp_signature".on_attach({
    bind = true, -- This is mandatory, otherwise border config won't get registered.
    handler_opts = { border = "rounded" },
  }, bufnr)
  -- Mappings.

  local opts = { noremap = true, silent = true }
  buf_set_keymap("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
  buf_set_keymap("n", "<C-]>", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
  buf_set_keymap("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
  buf_set_keymap("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  buf_set_keymap("n", "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
  buf_set_keymap("n", "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
  buf_set_keymap("n", "<space>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
  buf_set_keymap("n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
  buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
  buf_set_keymap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
  buf_set_keymap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
  buf_set_keymap("n", "<space>q", "<cmd>lua vim.diagnostic.setqflist({open = true})<CR>", opts)
  buf_set_keymap("n", "<space>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)

  vim.cmd([[
    autocmd CursorHold <buffer> lua require('config.lsp').show_line_diagnostics()
  ]])

  -- Set some key bindings conditional on server capabilities
  if client.resolved_capabilities.document_formatting then
    buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting_sync()<CR>", opts)
  end
  if client.resolved_capabilities.document_range_formatting then
    buf_set_keymap("x", "<space>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR><ESC>", opts)
  end

  -- The blow command will highlight the current variable and its usages in the buffer.
  if client.resolved_capabilities.document_highlight then
    vim.cmd([[
      hi link LspReferenceRead Visual
      hi link LspReferenceText Visual
      hi link LspReferenceWrite Visual
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]])
  end

  if client.resolved_capabilities.document_formatting then
    buf_set_keymap("n", "<Leader>aa", "<cmd>lua vim.lsp.buf.formatting()<cr>", {})
    vim.api.nvim_command([[augroup Format]])
    vim.api.nvim_command([[autocmd! * <buffer>]])
    vim.api.nvim_command([[autocmd BufWritePost <buffer> lua vim.lsp.buf.formatting_sync(nil, 500)]])
    vim.api.nvim_command([[augroup END]])
    -- vim.cmd([[ autocmd BufWritePre * :lua vim.lsp.buf.formatting_sync(nil, 500) ]])
    -- if client.name ~= "tsserver" then
    -- end
    vim.notify(string.format("Formatting supported %s", client.name), "debug")
  end

  vim.api.nvim_command("setlocal omnifunc=v:lua.vim.lsp.omnifunc")
  local msg = string.format("Language server %s started!", client.name)
  vim.notify(msg, "trace", { title = "nvim lsp-config" })
end

local lspservers = {}

lspservers["pylsp"] = {
  root_dir = function(fname)
    local root_files = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile" }
    return util.root_pattern(table.unpack(root_files))(fname) or util.find_git_ancestor(fname)
  end,
  single_file_support = true,
  settings = {
    pylsp = {
      plugins = {
        pylint = { enabled = true, executable = "pylint" },
        pyflakes = { enabled = false },
        pycodestyle = { enabled = false },
        jedi_completion = { fuzzy = true },
        pyls_isort = { enabled = true },
        pylsp_mypy = { enabled = true },
      },
    },
  },
  flags = { debounce_text_changes = 200 },
}

lspservers["bashls"] = {
  cmd = { "bash-language-server", "start" },
  cmd_env = { GLOB_PATTERN = "*@(.sh|.inc|.bash|.command)" },
  filetypes = { "sh" },
  single_file_support = true,
  root_dir = util.find_git_ancestor,
}

lspservers["clangd"] = { filetypes = { "c", "cpp", "cc" }, flags = { debounce_text_changes = 500 } }

lspservers["dockerls"] = {
  cmd = { "docker-langserver", "--stdio" },
  filetypes = { "dockerfile" },
  root_dir = util.root_pattern("Dockerfile"),
  single_file_support = true,
}

lspservers["gopls"] = { cmd = { "gopls" }, filetypes = { "go", "gomod" },
                        root_dir = util.root_pattern("go.mod", ".git") }

lspservers["jsonls"] = {
  cmd = { "vscode-json-language-server", "--stdio" },
  filetypes = { "json" },
  single_file_support = true,
  root_dir = util.find_git_ancestor,
  init_options = { provideFormatter = true },
  settings = {
    json = {
      schemas = {
        { fileMatch = { "package.json" }, url = "https://json.schemastore.org/package.json" },
        { fileMatch = { "tsconfig*.json" }, url = "https://json.schemastore.org/tsconfig.json" },
        {
          fileMatch = { ".prettierrc", ".prettierrc.json", "prettier.config.json" },
          url = "https://json.schemastore.org/prettierrc.json",
        },
        { fileMatch = { ".eslintrc", ".eslintrc.json" }, url = "https://json.schemastore.org/eslintrc.json" },
        {
          fileMatch = { ".babelrc", ".babelrc.json", "babel.config.json" },
          url = "https://json.schemastore.org/babelrc.json",
        },
        { fileMatch = { "lerna.json" }, url = "https://json.schemastore.org/lerna.json" },
        { fileMatch = { "now.json", "vercel.json" }, url = "https://json.schemastore.org/now.json" },
        {
          fileMatch = { ".stylelintrc", ".stylelintrc.json", "stylelint.config.json" },
          url = "http://json.schemastore.org/stylelintrc.json",
        },
      },
    },
  },
}

lspservers["sumneko_lua"] = {
  root_dir = util.root_pattern(".project", ".git"),
  -- root_dir = util.root_pattern('.project', '.git') or bufdir,
  -- cmd = { sumneko_binary_path, "-E", sumneko_root_path .. "/main.lua" },
  -- single_file_support = true,
  settings = {
    Lua = {
      completion = { keywordSnippet = "Disable" },
      diagnostics = { globals = { "vim", "use" }, disable = { "lowercase-global" } },
      runtime = { version = "LuaJIT", path = runtime_path },
      workspace = {
        -- Make the server aware of Neovim runtime files
        -- library = api.nvim_get_runtime_file("", true),
        library = { [vim.fn.expand("$VIMRUNTIME/lua")] = true, [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true },
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = { enable = false },
    },
  },
}
-- -- Formatting via efm
-- local prettier = require "efm/prettier"
-- -- local eslint = require "efm/eslint"
-- local luafmt = require "efm/luafmt"
-- local rustfmt = require "efm/rustfmt"
-- -- local autopep = require "efm/autopep8"

local luafmt = {
  formatCommand = "lua-format -i --config=$HOME/.config/nvim/lua/lsp/efm/lua-format.cfg",
  formatStdin = true,
}

local shellcheck = {
  lintCommand = "shellcheck -f gcc -x -",
  lintStdin = true,
  lintIgnoreExitCode = true,
  lintFormats = { "%f=%l:%c: %trror: %m", "%f=%l:%c: %tarning: %m", "%f=%l:%c: %tote: %m" },
}

local luacheck = {
  lintCommand = "luacheck --globals vim --formatter visual_studio -",
  lintIgnoreExitCode = true,
  lintStdin = true,
  lintFormats = { "%f(%l,%c) : %tarning %m", "%f(%l,%c) : %trror %m" },
}

local prettier = {
  -- parser flow|babel|babel-flow|babel-ts|typescript|espree|meriyah|css|less|scss|
  -- json|json5|json-stringify|graphql|markdown|mdx|vue|yaml|glimmer|html|angular|lwc|ruby|rbs|haml
  formatCommand = "prettier --stdin-filepath ${INPUT} --print-width 120 --single-quote --arrow-parens 'avoid' --trailing-comma all",
  formatStdin = true,
}

local shfmt = { formatCommand = "shfmt -ln bash -i 2 -bn -ci -sr -kp", lintIgnoreExitCode = true, formatStdin = true }

local languages = {
  lua = { luafmt, luacheck },
  yaml = { prettier },
  sh = { shfmt, shellcheck },
  json = { prettier },
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
  root_dir = util.root_pattern({ "yarn.lock", "package.json", ".project", ".git", vim.fn.getcwd() }),
  single_file_support = true,
  filetypes = vim.tbl_keys(languages),
  init_options = { documentFormatting = true, hover = true, documentSymbol = true, codeAction = true },
  settings = {
    languages = languages,
    log_level = 1,
    log_file = vim.fn.stdpath("cache") .. "/efm.log",
    rootMarkers = {
      ".lua-format",
      -- ".eslintrc.cjs",
      -- ".eslintrc",
      -- ".eslintrc.json",
      -- ".eslintrc.js",
      ".prettierrc",
      ".prettierrc.js",
      ".prettierrc.json",
      ".prettierrc.yml",
      ".prettierrc.yaml",
      ".prettier.config.js",
      ".prettier.config.cjs",
    },
  },
}

lspservers["sqls"] = {
  filetypes = { "sql", "mysql", "pgsql" },
  settings = {
    sqls = {
      connections = {
        {
          driver = "postgresql",
          dataSourceName = "host=localhost port=5432 user=spadash password=spadash dbname=spadash_august sslmode=disable",
        },
      },
    },
  },
}

lspservers["terraformls"] = {
  cmd = { "terraform-ls", "serve" },
  filetypes = { "terraform" },
  root_dir = util.root_pattern(".terraform", ".git"),
}

lspservers["yamlls"] = {
  cmd = { "yaml-language-server", "--stdio" },
  filetypes = { "yaml", "yaml.docker-compose" },
  settings = { redhat = { telemetry = { enabled = false } } },
  single_file_support = true,
  root_dir = util.find_git_ancestor,
}

lspservers["vimls"] = { flags = { debounce_text_changes = 500 } }

local capabilities = require("cmp_nvim_lsp").update_capabilities(lsp.protocol.make_client_capabilities())
capabilities.textDocument.completion.completionItem.snippetSupport = true
-- capabilities = vim.tbl_extend('keep', capabilities or {}, lsp_status.capabilities)

require("nvim-lsp-installer").on_server_ready(function(server)
  -- (optional) Customize the options passed to the server
  local server_config = lspservers[server.name] or {}
  server_config.capabilities = capabilities
  if (server.name == "sqls") then
    server_config.on_attach = function(client, bufnr)
      client.resolved_capabilities.execute_command = true
      client.commands = require("sqls").commands -- Neovim 0.6+ only
      require("sqls").setup { picker = "telescope" }
      custom_attach(client, bufnr)
    end
  else
    server_config.on_attach = custom_attach
  end
  server:setup(server_config)
end)
