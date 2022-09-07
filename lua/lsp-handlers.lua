-- local function tsserver_organize_imports()
--   local params = {
--     command = "_typescript.organizeImports",
--     arguments = { vim.api.nvim_buf_get_name(0) },
--   }
--   vim.lsp.buf.execute_command(params)
--   vim.notify("Imports organized.")
-- end
--
-- function _G.show_capabilities()
--   for _, client in pairs(vim.lsp.buf_get_clients(0)) do
--     print(
--       vim.inspect(client.name)
--       .. "\n\n"
--       .. vim.inspect(client.server_capabilities)
--       .. "\n\n"
--     )
--   end
-- end

-- local function tsserver_organize_imports()
--   local params = {
--     command = "_typescript.organizeImports",
--     arguments = { vim.api.nvim_buf_get_name(0) },
--   }
--   vim.lsp.buf.execute_command(params)
--   vim.notify("Imports organized.")
-- end
--
-- function _G.show_capabilities()
--   for _, client in pairs(vim.lsp.buf_get_clients(0)) do
--     print(
--       vim.inspect(client.name)
--       .. "\n\n"
--       .. vim.inspect(client.server_capabilities)
--       .. "\n\n"
--     )
--   end
-- end
--
local keymap = vim.api.nvim_set_keymap
local keymap_buf = vim.api.nvim_buf_set_keymap
local ts_utils = require("nvim-treesitter.ts_utils")

local keymap_opts = { noremap = true, silent = true }
local color_provider = function(_, bufnr)
  require("lsp-documentcolors").buf_attach(bufnr, { single_column = true })
end

--- @return fun() @function that calls the provided fn, but with no args
local function w(fn)
  return function()
    return fn()
  end
end

-- Finds and runs the closest codelens (searches upwards only)
local function find_and_run_codelens()
  -- "<cmd>lua vim.lsp.codelens.run()<CR>"
  local bufnr = vim.api.nvim_get_current_buf()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local lenses = vim.lsp.codelens.get(bufnr)

  lenses = vim.tbl_filter(function(lense)
    return lense.range.start.line < row
  end, lenses)

  if #lenses == 0 then
    return vim.notify("Could not find codelens to run.")
  end

  table.sort(lenses, function(a, b)
    return a.range.start.line > b.range.start.line
  end)

  vim.api.nvim_win_set_cursor(0, { lenses[1].range.start.line + 1, lenses[1].range.start.character })
  vim.lsp.codelens.run()
  vim.api.nvim_win_set_cursor(0, { row, col }) -- restore cursor, TODO: also restore position
end

vim.cmd("highlight default link LspCodeLens NonText")
vim.cmd("highlight default link LspCodeLensSeparator NonText")

local code_lens_provider = function(bufnr)
  local group = vim.api.nvim_create_augroup("lsp_document_codelens", {})
  vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave", "BufWritePost", "CursorHold" }, {
    buffer = bufnr,
    group = group,
    callback = w(vim.lsp.codelens.refresh),
  })
  keymap_buf(bufnr, "n", "<Leader>L", find_and_run_codelens, keymap_opts)
end

local document_formatting_provider = function(bufnr)
  local augroup = vim.api.nvim_create_augroup("Formatting", {})
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = augroup,
    buffer = bufnr,
    command = "Format",
  })
  keymap_buf(
    bufnr,
    "n",
    "<Leader>p",
    -- null-ls might run prettier and blade-formatter, which should have higher precedence than formatting by html and php language servers
    "<cmd>lua vim.lsp.buf.formatting_seq_sync(nil, 1000, { 'html', 'php', 'null-ls' })<CR>",
    keymap_opts
  )
  keymap_buf(bufnr, "n", "<Leader>P", "<cmd>lua vim.lsp.buf.formatting()<CR>", keymap_opts)
end

local document_formatting_range_provider = function(_, bufnr)
  keymap_buf(
    bufnr,
    "n",
    "<Leader>p",
    -- null-ls might run prettier and blade-formatter, which should have higher precedence than formatting by html and php language servers
    "<cmd>lua vim.lsp.buf.formatting_seq_sync(nil, 1000, { 'html', 'php', 'null-ls' })<CR>",
    keymap_opts
  )
  keymap_buf(bufnr, "v", "<Leader>p", ":'<,'>lua vim.lsp.buf.range_formatting()<CR>", keymap_opts)
end

local function highlight_references()
  local node = ts_utils.get_node_at_cursor()
  while node ~= nil do
    local node_type = node:type()
    if node_type == "string"
      or node_type == "string_fragment"
      or node_type == "template_string"
      or node_type == "document" -- for inline gql`` strings
    then
      -- who wants to highlight a string? i don't. yuck
      return
    end
    node = node:parent()
  end
  vim.lsp.buf.document_highlight()
end

local document_highlight_provider = function(bufnr)
  local group = vim.api.nvim_create_augroup("lsp_document_highlight", {})
  vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
    buffer = bufnr,
    group = group,
    callback = highlight_references,
  })
  vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
    buffer = bufnr,
    group = group,
    callback = w(vim.lsp.buf.clear_references),
  })
end

local type_definition_provider = function(bufnr)
  keymap_buf(bufnr, "n", "<Leader>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", keymap_opts)
  keymap("n", "gy", "<cmd>lua vim.lsp.buf.type_definition()<CR>", keymap_opts)
  -- if vim.fn.exists(":Telescope") then
  --   -- buf_set_keymap('n', 'gt', '<cmd>Telescope lsp_type_definitions<CR>', opts)
end

local signature_help_provider = function(bufnr)
  local lsp_sig = require("lsp.signature")
  require("lsp_signature").on_attach(lsp_sig.cfg, bufnr)
  keymap_buf(bufnr, "n", "gK", "<cmd>lua vim.lsp.buf.signature_help()<CR>", keymap_opts)
end

local find_references_provider = function(bufnr)
  keymap_buf(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", keymap_opts)
  -- keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
  -- -- keymap("n", "<C-S-]>", "cyle references, diagnostics, gotofiles", opts)
  -- if vim.fn.exists(":Telescope") then
  --   -- buf_set_keymap('n', 'gr', '<cmd>Telescope lsp_references<CR>', opts)
end

local hover_provider = function(bufnr)
  -- vim already has builtin docs
  if vim.bo.ft ~= "vim" then
    vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", keymap_opts)
  end
end

local code_action_provider = function(bufnr)
  keymap_buf(bufnr, "n", "<Leader>a", "<cmd>lua vim.lsp.buf.code_action()<CR>", keymap_opts)
  keymap_buf(bufnr, "x", "<Leader>a", ":'<,'>lua vim.lsp.buf.range_code_action()<CR>", keymap_opts)

  -- -- keymap("n", "<leader>q", "<cmd>Telescope lsp_code_actions<CR>", opts)
  -- keymap("n", "<leader>la", "<cmd>Telescope lsp_code_actions<CR>", opts)
end

local goto_definition_provider = function(bufnr)
  keymap_buf(bufnr, "n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", keymap_opts)
end

local implementation_provider = function(bufnr)
  keymap_buf(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", keymap_opts)
  -- keymap("n", "<leader>lI", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  -- if vim.fn.exists(":Telescope") then
  --   keymap("n", "<leader>gi", "<cmd>Telescope lsp_implementations<CR>", opts)
end

local declaration_provider = function(bufnr)
  keymap_buf(bufnr, "n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", keymap_opts)
  -- keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
end

local rename_provider = function(bufnr)
  keymap_buf(bufnr, "n", "<Leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", keymap_opts)

  -- keymap("n", "<leader>gr", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
  -- keymap("n", "gR", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
end


local document_symbol_provider = function(client, bufnr)
  local navic = require("nvim-navic")
  navic.setup({ highlight = true })
  navic.attach(client, bufnr)
end

local workspace = function(bufnr)
  keymap_buf(bufnr, "n", "<Leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", keymap_opts)
  keymap_buf(bufnr, "n", "<Leader>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", keymap_opts)
  keymap_buf(
    bufnr,
    "n",
    "<Leader>wl",
    "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
    keymap_opts
  )

  -- keymap("n", "<leader>lwa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
  -- keymap("n", "<leader>lwr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
  -- keymap("n", "<leader>lwl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
end

--
-- local function keybindings_hover_keyword(bufnr, server_capabilities, filetype)
--     if filetype == "lua" then
--         vim.opt_local.keywordprg = ":help"
--     elseif server_capabilities.hoverProvider then
--         if filetype ~= "vim" then
--             map_buf(bufnr, "K", vim.lsp.buf.hover)
--         end
--     else
--         map_buf(bufnr, "K", function()
--             vim.notify("Hover not supported by LSP.", vim.log.levels.ERROR)
--         end)
--     end
-- end
--
-- local function keybindings_organizeimports(bufnr, lsp_name)
--     if lsp_name == "tsserver" then
--         map_buf(bufnr, "cxo", tsserver_organize_imports)
--     elseif lsp_name == "pyright" then
--         map_buf(bufnr, "cxo", function()
--             vim.cmd("silent PyrightOrganizeImports")
--         end)
--     end
-- end
--
-- keymap("n", "<C-]>", "gd tags or definitions or help or man, opts)
-- if vim.fn.exists(":Telescope") then
--   keymap("n", "<leader><gh>", ":Telescope help_tags<cr>", opts)
-- end
--
-- keymap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev({ enable_popup = false })<CR>", opts)
-- keymap("n", "]d", "<cmd>lua vim.diagnostic.goto_next({ enable_popup = false })<CR>", opts)
-- keymap("n", "[g", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
-- keymap("n", "]g", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
-- keymap("n", "K", ":lua require('lsp.handlers').show_documentation()<cr>", opts)
-- keymap("n", "gh", ":lua require('lsp.handlers').show_help()<cr>", opts)
-- keymap("n", "<leader>lwd", "<cmd>Telescope lsp_workspace_diagnostics<CR>", opts)
-- keymap("n", "<leader>ld", "<cmd>lua vim.diagnostic.show_line_diagnostics()<CR>", opts)
-- keymap("n", "<leader>lq", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
-- keymap("n", "<leader>k", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
-- keymap("n", "gff", "<cmd>lua vim.lsp.buf.format()<CR>", opts)
-- keymap("n", "ca", "<cmd>CodeActionMenu<cr>", opts)
--
-- -- actions
-- keymap("n", "<leader>lc", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
-- keymap("n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)

local handlers = {
  codeActionProvider = code_action_provider,
  codeLensProvider = code_lens_provider,
  colorProvider = color_provider,
  declarationProvider = declaration_provider,
  documentFormattingProvider = document_formatting_provider,
  documentFormattingRangeProvider = document_formatting_range_provider,
  documentHighlightProvider = document_highlight_provider,
  documentSymbolProvider = document_symbol_provider,
  findReferencesProvider = find_references_provider,
  gotoDefinitionProvider = goto_definition_provider,
  hoverProvider = hover_provider,
  implementationProvider = implementation_provider,
  renameProvider = rename_provider,
  signatureHelpProvider = signature_help_provider,
  typeDefinitionProvider = type_definition_provider,
  workspace = workspace,
}

local check_capability = function(client, bufnr, capability)
  local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")
  vim.dbglog("checking " .. capability)
  if client.server_capabilities[capability] then
    if capability == "documentFormattingProvider" and client.server_capabilities[capability] == true
      or ft == "sh"
      or ft == "bash"
    then
      local augroup = vim.api.nvim_create_augroup("Formatting", {})
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        command = "Format",
      })
      vim.dbglog("format: " .. client.name .. " - " .. capability .. " ft: " .. ft)
      document_formatting_provider(bufnr)
    elseif capability == "documentSymbolProvider"
      and type(client.server_capabilities[capability]) ~= nil then
      document_symbol_provider(client, bufnr)
    elseif handlers[capability] then
      vim.dbglog("lsp: " .. client.name .. " - " .. capability .. " ft: " .. ft)
      handlers[capability](bufnr)
    end
  end
end

return { check_capability = check_capability }
