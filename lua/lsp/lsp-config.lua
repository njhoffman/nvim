local config = require("config")
local api = vim.api
local lsp = vim.lsp
local util = require('lspconfig.util')

vim.lsp.set_log_level(config.LSP.log_level)

function len(t)
  local count = 0
  for _ in pairs(t) do count = count + 1 end
  return count
end

require('vim.lsp.log').set_format_func(function(messages)
  local inspected = vim.inspect(messages)
  local formatted = ""
  if type(messages) == "table" then formatted = formatted .. 'Length: ' .. len(messages) .. "\n" end
  for line in string.gmatch(inspected, '[^\n\r]+') do
    formatted = formatted .. '\n  ' .. line
  end
  return formatted
end)

local M = {}

function M.show_line_diagnostics()
  local opts = {
    focusable = false,
    close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
    border = 'rounded',
    source = 'always',  -- show source in diagnostic popup window
    prefix = ' '
  }
  vim.diagnostic.open_float(nil, opts)
end

local custom_attach = function(client, bufnr)
  local function buf_set_keymap(...)
    api.nvim_buf_set_keymap(bufnr, ...)
  end

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

  -- if vim.g.logging_level == 'debug' then
    local msg = string.format("Language server %s started!", client.name)
    vim.notify(msg, 'info', {title = 'nvim lsp-config'})
  -- end
end


local capabilities = require('cmp_nvim_lsp').update_capabilities(lsp.protocol.make_client_capabilities())
capabilities.textDocument.completion.completionItem.snippetSupport = true

local lspconfig = require("lspconfig")

lspconfig.pylsp.setup({
  on_attach = custom_attach,
  capabilities = capabilities,
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
})

lspconfig.bashls.setup({
  on_attach = custom_attach,
  capabilities = capabilities,
  cmd = { "bash-language-server", "start" },
  cmd_env = {
    GLOB_PATTERN = "*@(.sh|.inc|.bash|.command)",
  },
  filetypes = { "sh" },
  single_file_support = true,
  root_dir = util.find_git_ancestor,
})

lspconfig.clangd.setup({
  on_attach = custom_attach,
  capabilities = capabilities,
  filetypes = { "c", "cpp", "cc" },
  flags = {
    debounce_text_changes = 500,
  },
})

lspconfig.dockerls.setup({
  on_attach = custom_attach,
  capabilities = capabilities,
  cmd = { "docker-langserver", "--stdio" },
  filetypes = { "dockerfile" },
  root_dir = util.root_pattern("Dockerfile"),
  single_file_support = true,

})

-- Commands:

-- Default Values:
--   cmd = { "vscode-html-language-server", "--stdio" }
--   filetypes = { "html" }
--   init_options = {
--     configurationSection = { "html", "css", "javascript" },
--     embeddedLanguages = {
--       css = true,
--       javascript = true
--     }
--   }
--   root_dir = function(startpath)
--       return M.search_ancestors(startpath, matcher)
--     end
--   settings = {}
--   single_file_support = true
lspconfig.gopls.setup({
  on_attach = custom_attach,
  capabilities = capabilities,
  cmd = { "gopls" },
  filetypes = { "go", "gomod" },
  root_dir = util.root_pattern("go.mod", ".git")
})

local sumneko_binary_path = vim.fn.exepath("lua-language-server")
if sumneko_binary_path ~= "" then
  local sumneko_root_path = vim.fn.fnamemodify(sumneko_binary_path, ":h:h:h")

  local runtime_path = vim.split(package.path, ";")
  table.insert(runtime_path, "lua/?.lua")
  table.insert(runtime_path, "lua/?/init.lua")

  require("lspconfig").sumneko_lua.setup({
    capabilities = capabilities,
    on_attach = custom_attach,
    root_dir = util.root_pattern('.project', '.git'),
    -- root_dir = util.root_pattern('.project', '.git') or bufdir,
    cmd = { sumneko_binary_path, "-E", sumneko_root_path .. "/main.lua" },
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
  })


  lspconfig.jsonls.setup({
    on_attach = custom_attach,
    capabilities = capabilities,
    cmd = { "vscode-json-language-server", "--stdio" },
    filetypes = { "json" },
    init_options = {
      provideFormatter = true
    },
    single_file_support = true,
    root_dir = util.find_git_ancestor
  })


  lspconfig.terraformls.setup({
    on_attach = custom_attach,
    capabilities = capabilities,
    cmd = { "terraform-ls", "serve" },
    filetypes = { "terraform" },
    root_dir = util.root_pattern(".terraform", ".git")
  })

  lspconfig.yamlls.setup({
    on_attach = custom_attach,
    capabilities = capabilities,
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
  })

-- set up vim-language-server
  lspconfig.vimls.setup({
    capabilities = capabilities,
    on_attach = custom_attach,
    flags = {
      debounce_text_changes = 500,
    },
  })

end

-- Change diagnostic signs.
-- if LSP.signs == "hidden" then
--   -- just color numbers, dont show icons
--   vim.fn.sign_define("LspDiagnosticsSignError", { text = "", numhl = "LspDiagnosticsSignError" })
--   vim.fn.sign_define("LspDiagnosticsSignWarning", { text = "", numhl = "LspDiagnosticsSignWarning" })
--   vim.fn.sign_define("LspDiagnosticsSignInformation", { text = "", numhl = "LspDiagnosticsSignInformation" })
--   vim.fn.sign_define("LspDiagnosticsSignHint", { text = "", numhl = "LspDiagnosticsSignHint" })
-- elseif LSP.signs ~= false and LSP.signs ~= 0 then
vim.fn.sign_define(
  "DiagnosticSignError",
  { texthl = "LspDiagnosticsSignError", text = "", numhl = "LspDiagnosticsSignError" }
)
vim.fn.sign_define("DiagnosticSignWarn", {
  texthl = "LspDiagnosticsSignWarning",
  text = "",
  -- numhl = "LspDiagnosticsSignWarning",
})
vim.fn.sign_define("DiagnosticSignInformation", {
  texthl = "LspDiagnosticsSignInformation",
  text = "",
  -- numhl = "LspDiagnosticsSignInformation",
})
vim.fn.sign_define("DiagnosticSignHint", {
  texthl = "LspDiagnosticsSignHint",
  text = "",
  -- numhl = "LspDiagnosticsSignHint",
})
-- end

-- global config for diagnostic
vim.diagnostic.config({
  update_in_insert = true,
  underline = false,
  virtual_text = false,
  signs = true,
  severity_sort = true,
})

-- lsp.handlers["textDocument/publishDiagnostics"] = lsp.with(lsp.diagnostic.on_publish_diagnostics, {
--   underline = false,
--   virtual_text = false,
--   signs = true,
--   update_in_insert = false,
-- })

-- Change border of documentation hover window, See https://github.com/neovim/neovim/pull/13998.
lsp.handlers["textDocument/hover"] = lsp.with(vim.lsp.handlers.hover, {
  border = "rounded",
})

return M
