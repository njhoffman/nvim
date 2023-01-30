-- local function tsserver_organize_imports()
-- if lsp_name == "tsserver" then
--     map_buf(bufnr, "cxo", tsserver_organize_imports)
-- elseif lsp_name == "pyright" then
--     map_buf(bufnr, "cxo", function()
--         vim.cmd("silent PyrightOrganizeImports")
--     end)
-- end
--   local params = {
--     command = "_typescript.organizeImports",
--     arguments = { vim.api.nvim_buf_get_name(0) },
--   }
--   vim.lsp.buf.execute_command(params)
--   vim.notify("Imports organized.")
-- end

local keymap = vim.api.nvim_set_keymap
local keymap_buf = vim.api.nvim_buf_set_keymap
local ts_utils = require("nvim-treesitter.ts_utils")

local keymap_opts = { noremap = true, silent = true }

local color_provider = function(_, bufnr)
  -- TODO: this sometimes tries to attach when it shouldnt
  -- require("lsp-documentcolors").buf_attach(bufnr, { single_column = true })
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

local code_lens_provider = function(_, bufnr)
  local group = vim.api.nvim_create_augroup("lsp_document_codelens", {})
  vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave", "BufWritePost", "CursorHold" }, {
    buffer = bufnr,
    group = group,
    callback = w(vim.lsp.codelens.refresh),
  })
  -- keymap_buf(bufnr, "n", "<Leader>L", find_and_run_codelens, keymap_opts)
end

local document_formatting_provider = function(_, bufnr)
  local augroup = vim.api.nvim_create_augroup("Formatting", { clear = false })
  -- null-ls might run prettier and blade-formatter, which should have higher precedence than formatting by html and php language servers
  vim.api.nvim_create_autocmd("BufWritePre", { group = "Formatting", buffer = bufnr, command = "Format" })
  keymap_buf(bufnr, "n", "<Leader>ff", "<cmd>Format<CR>", keymap_opts)
end

local document_formatting_range_provider = function(_, bufnr)
  keymap_buf(bufnr, "v", "<Leader>p", ":'<,'>lua vim.lsp.buf.range_formatting()<CR>", keymap_opts)
end

local function highlight_references()
  local node = ts_utils.get_node_at_cursor()
  while node ~= nil do
    local node_type = node:type()
    if
      node_type == "string"
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

local document_highlight_provider = function(_, bufnr)
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

local signature_help_provider = function(_, bufnr)
  local lsp_sig = require("lsp.signature")
  require("lsp_signature").on_attach(lsp_sig.cfg, bufnr)
  keymap_buf(bufnr, "n", "gK", "<cmd>lua vim.lsp.buf.signature_help()<CR>", keymap_opts)
end

local hover_provider = function(_, bufnr)
  -- vim already has builtin docs
  if vim.bo.ft ~= "vim" then
    vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", keymap_opts)
  end
end

local code_action_provider = function(_, bufnr)
  keymap_buf(bufnr, "n", "<Leader>a", "<cmd>lua vim.lsp.buf.code_action()<CR>", keymap_opts)
  keymap_buf(bufnr, "x", "<Leader>a", ":'<,'>lua vim.lsp.buf.range_code_action()<CR>", keymap_opts)

  -- -- keymap("n", "<leader>q", "<cmd>Telescope lsp_code_actions<CR>", opts)
  -- keymap("n", "<leader>la", "<cmd>Telescope lsp_code_actions<CR>", opts)
end

local definition_provider = function(_, bufnr)
  keymap_buf(bufnr, "n", "gqd", "<Cmd>lua vim.lsp.buf.definition()<CR>", keymap_opts)
  if vim.fn.exists(":Telescope") then
    local theme = 'require("telescope.themes").get_dropdown()'
    keymap_buf(
      bufnr,
      "n",
      "gd",
      "<cmd>lua require('telescope.builtin').lsp_definitions(" .. theme .. ")<CR>",
      keymap_opts
    )
  end
end

local implementation_provider = function(_, bufnr)
  keymap_buf(bufnr, "n", "gqi", "<cmd>lua vim.lsp.buf.implementation()<CR>", keymap_opts)
  if vim.fn.exists(":Telescope") then
    local theme = 'require("telescope.themes").get_dropdown()'
    keymap_buf(
      bufnr,
      "n",
      "gI",
      "<cmd>lua require('telescope.builtin').lsp_implementations(" .. theme .. ")<CR>",
      keymap_opts
    )
  end
end

local references_provider = function(_, bufnr)
  keymap_buf(bufnr, "n", "gqr", "<cmd>lua vim.lsp.buf.references()<CR>", keymap_opts)
  if vim.fn.exists(":Telescope") then
    local theme = 'require("telescope.themes").get_dropdown()'
    keymap_buf(
      bufnr,
      "n",
      "gr",
      "<cmd>lua require('telescope.builtin').lsp_references(" .. theme .. ")<CR>",
      keymap_opts
    )
  end
end

local type_definition_provider = function(_, bufnr)
  keymap("n", "gy", "<cmd>lua vim.lsp.buf.type_definition()<CR>", keymap_opts)
  if vim.fn.exists(":Telescope") then
    local theme = 'require("telescope.themes").get_dropdown()'
    keymap_buf(
      bufnr,
      "n",
      "gY",
      "<cmd>lua require('telescope.builtin').lsp_type_definitions(" .. theme .. ")<CR>",
      keymap_opts
    )
  end
end

local declaration_provider = function(_, bufnr)
  keymap_buf(bufnr, "n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", keymap_opts)
end

local rename_provider = function(_, bufnr)
  keymap_buf(bufnr, "n", "gR", "<cmd>lua vim.lsp.buf.rename()<CR>", keymap_opts)
end

local document_symbol_provider = function(client, bufnr)
  local navic = require("nvim-navic")
  navic.setup({ highlight = true })
  navic.attach(client, bufnr)
end

local workspace = function(_, bufnr)
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
-- keymap("n", "ca", "<cmd>CodeActionMenu<cr>", opts)
-- -- actions
-- keymap("n", "<leader>lc", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
-- keymap("n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)

local handlers = {
  codeActionProvider = code_action_provider,
  codeLensProvider = code_lens_provider,
  colorProvider = color_provider,
  declarationProvider = declaration_provider,
  definitionProvider = definition_provider,
  documentFormattingProvider = document_formatting_provider,
  documentFormattingRangeProvider = document_formatting_range_provider,
  documentHighlightProvider = document_highlight_provider,
  documentSymbolProvider = document_symbol_provider,
  referencesProvider = references_provider,
  hoverProvider = hover_provider,
  implementationProvider = implementation_provider,
  renameProvider = rename_provider,
  signatureHelpProvider = signature_help_provider,
  typeDefinitionProvider = type_definition_provider,
  workspace = workspace,
}

local try_capability = function(client, bufnr, capability)
  local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")
  -- vim.notify("checking " .. capability, "trace")

  local function log_lsp()
    vim.notify("lsp: " .. client.name .. " - " .. bufnr .. " " .. capability .. " ft: " .. ft, 1)
  end

  if client.server_capabilities[capability] then
    if handlers[capability] and client.server_capabilities[capability] == true then
      log_lsp()
      handlers[capability](client, bufnr)
    end
  end
end

return { try_capability = try_capability }
