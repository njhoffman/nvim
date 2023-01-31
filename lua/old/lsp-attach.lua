local M = {}

local function is_lsp_loaded(client_name)
  for _, client in pairs(vim.lsp.buf_get_active_clients(0)) do
    if client.name == client_name then
      return true
    end
  end
  return false
end

local function is_correct_lsp_loaded(filetype)
  if filetype == "terraform" then
    return is_lsp_loaded("terraformls")
  else
    return true
  end
end

local function lsp_document_format(lsp_name)
  lsp_name = lsp_name or ""
  return function()
    if not is_correct_lsp_loaded(vim.bo.filetype) then
      vim.notify("Required LSPs not yet loaded, please wait a bit and retry.", vim.log.levels.ERROR)
      return
    end

    -- vim.notify("Formatting document synchronously, please wait...")
    vim.cmd("redraw")

    local fname = vim.api.nvim_buf_get_name(0)
    local TIMEOUT = 3000
    vim.lsp.buf.format({ timeout_ms = TIMEOUT })
    vim.notify("Format (" .. lsp_name .. ")\n" .. fname, 1)
  end
end

local function tsserver_organize_imports()
  local params = {
    command = "_typescript.organizeImports",
    arguments = { vim.api.nvim_buf_get_name(0) },
  }
  vim.lsp.buf.execute_command(params)
  vim.notify("Imports organized.")
end

function _G.show_capabilities()
  for _, client in pairs(vim.lsp.buf_get_active_clients(0)) do
    print(vim.inspect(client.name) .. "\n\n" .. vim.inspect(client.server_capabilities) .. "\n\n")
  end
end

M.keybindings_defaults = function()
  local map = function(keys, action_desc)
    vim.keymap.set("n", keys, function()
      vim.notify("Don't know how to " .. action_desc .. " this filetype.", vim.log.levels.ERROR)
    end, {
      silent = true,
    })
  end

  map("cxo", "organize imports for")
  map("cxa", "apply code actions for")
  map("gQ", "document format")
end

local map_buf = function(bufnr, lhs, rhs)
  local opts = { buffer = bufnr, silent = true }

  vim.keymap.set("n", lhs, rhs, opts)
end

M.keybindings_formatting = function(bufnr, lsp_name)
  map_buf(bufnr, "gQ", lsp_document_format(lsp_name))
end

M.keybindings_codeaction = function(bufnr)
  map_buf(bufnr, "cxa", vim.lsp.buf.code_action)
end

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
M.format_on_save = function(bufnr, lsp_name)
  -- vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()")
  vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = augroup,
    buffer = bufnr,
    callback = lsp_document_format(lsp_name),
  })
end

local function format_on_save_check(bufnr, server_capabilities, lsp_name)
  if server_capabilities.documentFormattingProvider then
    M.format_on_save(bufnr, lsp_name)
  end
end

local function keybindings_formatting_check(bufnr, server_capabilities, lsp_name)
  if server_capabilities.documentFormattingProvider then
    M.keybindings_formatting(bufnr, lsp_name)
  end
end

local function keybindings_codeaction_check(bufnr, server_capabilities)
  if server_capabilities.codeActionProvider then
    M.keybindings_codeaction(bufnr)
  end
end

local function keybindings_hover_keyword(bufnr, server_capabilities, filetype)
  if filetype == "lua" then
    vim.opt_local.keywordprg = ":help"
  elseif server_capabilities.hoverProvider then
    if filetype ~= "vim" then
      map_buf(bufnr, "K", vim.lsp.buf.hover)
    end
  else
    map_buf(bufnr, "K", function()
      vim.notify("Hover not supported by LSP.", vim.log.levels.ERROR)
    end)
  end
end

local function keybindings_organizeimports(bufnr, lsp_name)
  if lsp_name == "tsserver" then
    map_buf(bufnr, "cxo", tsserver_organize_imports)
  elseif lsp_name == "pyright" then
    map_buf(bufnr, "cxo", function()
      vim.cmd("silent PyrightOrganizeImports")
    end)
  end
end

M.on_attach = function(client, bufnr)
  local lsp_name = client.name
  local server_capabilities = client.server_capabilities
  local filetype = vim.bo.filetype

  -- vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"
  -- vim.opt_local.tagfunc = "v:lua.vim.lsp.tagfunc"
  format_on_save_check(bufnr, server_capabilities, lsp_name)
  keybindings_formatting_check(bufnr, server_capabilities, lsp_name)
  keybindings_codeaction_check(bufnr, server_capabilities)
  keybindings_hover_keyword(bufnr, server_capabilities, filetype)
  keybindings_organizeimports(bufnr, lsp_name)

  vim.api.nvim_create_user_command("LspWhatCapabilities", "Capture call v:lua.show_capabilities()", {})
end

return M
