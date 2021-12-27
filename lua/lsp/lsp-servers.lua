local lsp_installer = require("nvim-lsp-installer")
local lsp_status = require('lsp-status')
local util = require('lspconfig.util')
local api = vim.api
local lsp = vim.lsp

-- local sumneko_binary_path = vim.fn.exepath("lua-language-server")
-- local sumneko_root_path = vim.fn.fnamemodify(sumneko_binary_path, ":h:h:h")
local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

local custom_attach = function(client, bufnr)
  local function buf_set_keymap(...)
    api.nvim_buf_set_keymap(bufnr, ...)
  end

  -- lsp_status.on_attach(client)

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

  vim.api.nvim_command('setlocal omnifunc=v:lua.vim.lsp.omnifunc')
  local msg = string.format("Language server %s started!", client.name)
  vim.notify(msg, 'trace', {title = 'nvim lsp-config'})
end

local lspservers = {
  pylsp = {
    root_dir = function(fname)
      local root_files = {
        'pyproject.toml',
        'setup.py',
        'setup.cfg',
        'requirements.txt',
        'Pipfile',
      }
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
    flags = {
      debounce_text_changes = 200,
    },
  },
  bashls = {
    cmd = { "bash-language-server", "start" },
    cmd_env = {
      GLOB_PATTERN = "*@(.sh|.inc|.bash|.command)",
    },
    filetypes = { "sh" },
    single_file_support = true,
    root_dir = util.find_git_ancestor,
  },
  clangd = {
    filetypes = { "c", "cpp", "cc" },
    flags = {
      debounce_text_changes = 500,
    },
  },
  dockerls = {
    cmd = { "docker-langserver", "--stdio" },
    filetypes = { "dockerfile" },
    root_dir = util.root_pattern("Dockerfile"),
    single_file_support = true,
  },
  gopls = {
    cmd = { "gopls" },
    filetypes = { "go", "gomod" },
    root_dir = util.root_pattern("go.mod", ".git")
  },
  jsonls = {
    cmd = { "vscode-json-language-server", "--stdio" },
    filetypes = { "json" },
    init_options = {
      provideFormatter = true
    },
    single_file_support = true,
    root_dir = util.find_git_ancestor
  },
  efm = {
    cmd = { "efm-langserver" },
    single_file_support = true,
    filetypes = { 'sh', 'bash', 'zsh', 'lua' },
    settings = {
      rootMarkers = {".project", ".git/"},
      languages = {
        lua = {
          {formatCommand = "lua-format -i", formatStdin = true}
        }
      }
    }
  },
  sumneko_lua = {
    root_dir = util.root_pattern('.project', '.git'),
    -- root_dir = util.root_pattern('.project', '.git') or bufdir,
    -- cmd = { sumneko_binary_path, "-E", sumneko_root_path .. "/main.lua" },
    -- single_file_support = true,
    settings = {
      Lua = {
        completion = {
          keywordSnippet = "Disable",
        },
        diagnostics = {
          globals = {"vim", "use"},
          disable = {"lowercase-global"}
        },
        runtime = {
          version = "LuaJIT",
          path = runtime_path
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          -- library = api.nvim_get_runtime_file("", true),
          library = {
            [vim.fn.expand("$VIMRUNTIME/lua")] = true,
            [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
          },
        },
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = {
          enable = false,
        },
      },
    },
  },
  terraformls = {
    cmd = { "terraform-ls", "serve" },
    filetypes = { "terraform" },
    root_dir = util.root_pattern(".terraform", ".git")
  },
  yamlls = {
    cmd = { "yaml-language-server", "--stdio" },
    filetypes = { "yaml", "yaml.docker-compose" },
    settings = {
      redhat = {
        telemetry = {
          enabled = false
        }
      }
    },
    single_file_support = true,
    root_dir = util.find_git_ancestor,
  },
  vimls = {
    flags = {
      debounce_text_changes = 500,
    },
  }
}

local capabilities = require('cmp_nvim_lsp').update_capabilities(lsp.protocol.make_client_capabilities())
capabilities.textDocument.completion.completionItem.snippetSupport = true
-- capabilities = vim.tbl_extend('keep', capabilities or {}, lsp_status.capabilities)

lsp_installer.on_server_ready(function (server)
  -- (optional) Customize the options passed to the server
  local server_config = lspservers[server.name] or {}
  server_config.capabilities = capabilities
  server_config.on_attach = custom_attach
  server:setup(server_config)
end)
