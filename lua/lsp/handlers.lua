local mapping = require('lsp.mapping')

local color_provider = function(client, bufnr)
  local cap = client.server_capabilities
  if cap.colorProvider and false then
    require('lsp.documentcolors').buf_attach(bufnr, { single_column = true })
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
    return vim.notify('Could not find codelens to run.', 3)
  end

  table.sort(lenses, function(a, b)
    return a.range.start.line > b.range.start.line
  end)

  vim.api.nvim_win_set_cursor(0, { lenses[1].range.start.line + 1, lenses[1].range.start.character })
  vim.lsp.codelens.run()
  vim.api.nvim_win_set_cursor(0, { row, col }) -- restore cursor
end

local code_lens_provider = function(_, bufnr)
  vim.cmd('highlight default link LspCodeLens NonText')
  vim.cmd('highlight default link LspCodeLensSeparator NonText')

  local group = vim.api.nvim_create_augroup('LspCodelens', {})
  vim.api.nvim_create_autocmd({ 'BufEnter', 'InsertLeave', 'BufWritePost', 'CursorHold' }, {
    buffer = bufnr,
    group = group,
    callback = function()
      return vim.lsp.codelens.refresh()
    end,
  })
  mapping.codelens(find_and_run_codelens)
end

local document_formatting_provider = function(client, bufnr)
  local augroup = vim.api.nvim_create_augroup('LspFormatting', { clear = false })
  local name = type(client) == 'table' and client.name or client or ''
  local command = 'Format ' .. bufnr .. ' ' .. name
  vim.api.nvim_create_autocmd('BufWritePre', { group = augroup, buffer = bufnr, command = command })
  command = '<cmd>' .. command .. '<cr>'
  mapping.formatting(command)
end

local document_formatting_range_provider = function(_, _)
  mapping.formatting_range()
end

local function highlight_references()
  local ts_utils = require('nvim-treesitter.ts_utils')
  local node = ts_utils.get_node_at_cursor()
  while node ~= nil do
    local node_type = node:type()
    if
      node_type == 'string'
      or node_type == 'string_fragment'
      or node_type == 'template_string'
      or node_type == 'document' -- for inline gql`` strings
    then
      -- who wants to highlight a string? i don't. yuck
      return
    end
    node = node:parent()
  end
  vim.lsp.buf.document_highlight()
end

local document_highlight_provider = function(client, bufnr)
  if not require('utils.lazy').is_installed('vim-illuminate') then
    if client.server_capabilities.documentHighlightProvider then
      local group = vim.api.nvim_create_augroup('LspHighlight', {})
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = bufnr,
        group = group,
        callback = highlight_references,
      })
      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = bufnr,
        group = group,
        callback = function()
          return vim.lsp.buf.clear_references()
        end,
      })
    else
      vim.notify('Lost documentHighlightProvider \n' .. vim.inspect(client.server_abilities), 4)
    end
  end
end

local signature_help_provider = function(_, bufnr)
  local function escape_term_codes(str)
    return vim.api.nvim_replace_termcodes(str, true, false, true)
  end

  local function is_lsp_float_open(window_id)
    return window_id and window_id ~= 0 and vim.api.nvim_win_is_valid(window_id)
  end

  local function scroll_float(sendkeys)
    -- Using the global config of the lsp_signature plugin
    ---@diagnostic disable-next-line: undefined-field
    local window_id = _G._LSP_SIG_CFG.winnr
    if is_lsp_float_open(window_id) then
      vim.fn.win_execute(window_id, 'normal! ' .. sendkeys)
    end
  end

  local cfg = {
    bind = true,
    zindex = 99, -- <100 so that it does not hide completion popup.
    close_timeout = 2000,
    max_width = 95,
    doc_lines = 50,
    -- extra_trigger_chars = { "(", "," },
    transparency = 10,
    toggle_key = mapping.signature_toggle(),
    select_signature_key = mapping.signature_select(),
    move_cursor_key = mapping.signature_move_cursor(),
  }
  -- require('lsp_signature').on_attach(cfg, bufnr)

  -- TODO: calculate page down length and initialize scroll down with scrolloffset

  -- mapping.signature_hover()

  local page_up_mapping = escape_term_codes('<PageUp>')
  local page_down_mapping = escape_term_codes('<PageDown>')
  local scroll_up_mapping = escape_term_codes('<Up>')
  local scroll_down_mapping = escape_term_codes('<Down>')

  -- mapping.signature_preview_up(function()
  --   scroll_float(scroll_up_mapping)
  -- end)
  -- mapping.signature_preview_down(function()
  --   scroll_float(scroll_down_mapping)
  -- end)
  --
  -- mapping.signature_preview_page_up(function()
  --   scroll_float(page_up_mapping)
  -- end)
  --
  -- mapping.signature_preview_page_down(function()
  --   scroll_float(page_down_mapping)
  -- end)
end

local hover_provider = function(_, _)
  -- vim already has builtin docs
  if vim.bo.ft ~= 'vim' then
    mapping.hover()
  end
end

local code_action_provider = function(_, _)
  mapping.code_action()
end

local definition_provider = function(_, _)
  mapping.definition()
  mapping.definition_preview()
end

local implementation_provider = function(_, _)
  mapping.implementation()
  mapping.implementation_preview()
end

local references_provider = function(_, _)
  mapping.references()
  mapping.references_preview()
end

local type_definition_provider = function(_, _)
  mapping.type_definition()
  mapping.type_definition_preview()
end

local declaration_provider = function(_, _)
  mapping.declaration()
end

local rename_provider = function(_, _)
  mapping.rename()
end

local document_symbol_provider = function(client, bufnr)
  local navic = require('lsp.nvim-navic')
  navic.attach(client, bufnr)
end

local workspace = function(_, _)
  -- keymap_buf(bufnr, "n", "<Leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", keymap_opts)
  -- keymap_buf(bufnr, "n", "<Leader>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", keymap_opts)
  -- keymap_buf(
  --   bufnr,
  --   "n",
  --   "<Leader>wl",
  --   "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
  --   keymap_opts
  -- )
  -- keymap("n", "<leader>lwa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
  -- keymap("n", "<leader>lwr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
  -- keymap("n", "<leader>lwl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
end

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
-- -- actions
-- keymap("n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
--
-- vim.lsp.handlers["textDocument/inlayHint"] = show_handler
local execute_command = function(args)
  vim.dbglog({ 'executeCommand', args })
  vim.lsp.buf.execute_command(args)
end

local handlers = {
  codeActionProvider = code_action_provider,
  codeLensProvider = code_lens_provider,
  colorProvider = color_provider,
  declarationProvider = declaration_provider,
  -- vim.lsp.handlers["textDocument/inlayHint"] = show_handler
  definitionProvider = definition_provider,
  documentFormattingProvider = document_formatting_provider,
  documentFormattingRangeProvider = document_formatting_range_provider,
  documentHighlightProvider = document_highlight_provider,
  documentSymbolProvider = document_symbol_provider,
  executeCommand = execute_command,
  referencesProvider = references_provider,
  hoverProvider = hover_provider,
  implementationProvider = implementation_provider,
  renameProvider = rename_provider,
  -- semanticTokensProvider = function() end,
  signatureHelpProvider = signature_help_provider,
  typeDefinitionProvider = type_definition_provider,
  workspace = workspace,
  -- executeCommandProvider, , inlayHintProvider, foldingRangeProvider, workspaceSymbolProvider
}

return handlers
