local keymap = vim.api.nvim_set_keymap
local keymap_buf = vim.api.nvim_buf_set_keymap

local keymap_opts = { noremap = true, silent = true }

local color_provider = function(client, bufnr)
  local cap = client.server_capabilities
  if cap.colorProvider then
    require("lsp.documentcolors").buf_attach(bufnr, { single_column = true })
  else
    vim.notify("Lost colorProvider: \n" .. vim.inspect(cap), 4)
  end
end

--- @return fun() @function that calls the provided fn, but with no args

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
    return vim.notify("Could not find codelens to run.", 3)
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
  local group = vim.api.nvim_create_augroup("LspCodelens", {})
  vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave", "BufWritePost", "CursorHold" }, {
    buffer = bufnr,
    group = group,
    callback = function()
      return vim.lsp.codelens.refresh()
    end,
  })
  local opts = vim.tbl_extend("keep", keymap_opts, { buffer = true })
  vim.keymap.set("n", "gL", find_and_run_codelens, opts)
end

local document_formatting_provider = function(client, bufnr)
  local augroup = vim.api.nvim_create_augroup("LspFormatting", { clear = false })
  local name = type(client) == "table" and client.name or client or ""
  local command = "Format " .. bufnr .. " " .. name
  vim.api.nvim_create_autocmd("BufWritePre", { group = augroup, buffer = bufnr, command = command })
  keymap_buf(bufnr, "n", "<Leader>ff", "<cmd>" .. command .. "<CR>", keymap_opts)
end

local document_formatting_range_provider = function(_, bufnr)
  keymap_buf(bufnr, "v", "<Leader>p", ":'<,'>lua vim.lsp.buf.range_formatting()<CR>", keymap_opts)
end

local ts_utils = require("nvim-treesitter.ts_utils")
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

local document_highlight_provider = function(client, bufnr)
  if not require("lazy-utils").is_installed("vim-illuminate") then
    if client.server_capabilities.documentHighlightProvider then
      local group = vim.api.nvim_create_augroup("LspHighlight", {})
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        buffer = bufnr,
        group = group,
        callback = highlight_references,
      })
      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        buffer = bufnr,
        group = group,
        callback = function()
          return vim.lsp.buf.clear_references()
        end,
      })
    else
      vim.notify("Lost documentHighlightProvider \n" .. vim.inspect(client.server_abilities), 4)
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

  local function scroll_float(mapping)
    -- Using the global config of the lsp_signature plugin
    local window_id = _G._LSP_SIG_CFG.winnr
    if is_lsp_float_open(window_id) then
      vim.fn.win_execute(window_id, "normal! " .. mapping)
    end
  end

  local cfg = {
    bind = true,
    zindex = 99, -- <100 so that it does not hide completion popup.
    close_timeout = 2000,
    max_width = 95,
    doc_lines = 50,
    toggle_key = "<M-x>",
    select_signature_key = "<M-n>",
    extra_trigger_chars = { "(", "," },
    move_cursor_key = "<M-'>",
    transparency = 10,
  }
  require("lsp_signature").on_attach(cfg, bufnr)
  keymap_buf(bufnr, "n", "gK", "<cmd>lua vim.lsp.buf.signature_help()<CR>", keymap_opts)

  local scroll_up_mapping = escape_term_codes("<PageUp>")
  local scroll_down_mapping = escape_term_codes("<PageDown>")
  vim.keymap.set({ "i", "n" }, "<C-Up>", function()
    scroll_float(scroll_up_mapping)
  end, keymap_opts)
  vim.keymap.set({ "i", "n" }, "<C-Down>", function()
    scroll_float(scroll_down_mapping)
  end, keymap_opts)
end

local hover_provider = function(_, bufnr)
  -- vim already has builtin docs
  if vim.bo.ft ~= "vim" then
    vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", keymap_opts)
  end
end

local code_action_provider = function(_, bufnr)
  -- keymap_buf(bufnr, "n", "gC", "<cmd>lua vim.lsp.buf.code_action()<CR>", keymap_opts)
  keymap_buf(bufnr, "n", "gG", "<cmd>CodeActionMenu<CR>", keymap_opts)
  keymap_buf(bufnr, "n", "gC", "<cmd>CodeActionMenu<CR>", keymap_opts)
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

  vim.keymap.set("n", "gpd", "<cmd>lua require('goto-preview').goto_preview_definition()<CR>", { noremap = true })
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
  vim.keymap.set("n", "gpi", "<cmd>lua require('goto-preview').goto_preview_implementation()<CR>", { noremap = true })
end

local references_provider = function(_, bufnr)
  keymap_buf(bufnr, "n", "gqr", "<cmd>lua vim.lsp.buf.references()<CR>", keymap_opts)
  if vim.fn.exists(":Telescope") then
    local theme = 'require("telescope.themes").get_dropdown()'
    keymap_buf(
      bufnr,
      "n",
      "gr",
      "<cmd>lua require('telescope.builtin').lsp_references(" .. tostring(theme) .. ")<CR>",
      keymap_opts
    )
  end
  vim.keymap.set("n", "gpr", "<cmd>lua require('goto-preview').goto_preview_references()<CR>", { noremap = true })
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
  vim.keymap.set("n", "gpt", "<cmd>lua require('goto-preview').goto_preview_type_definition()<CR>", { noremap = true })
end

local declaration_provider = function(_, bufnr)
  keymap_buf(bufnr, "n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", keymap_opts)
end

local rename_provider = function(_, bufnr)
  keymap_buf(bufnr, "n", "gR", "<cmd>lua vim.lsp.buf.rename()<CR>", keymap_opts)
end

local document_symbol_provider = function(client, bufnr)
  local navic = require("lsp.nvim-navic")
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
-- -- actions
-- keymap("n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)

-- local function show_handler(err, result, ctx, config)
--     if err or not result then
--         return
--     end
--     vim.api.nvim_buf_clear_namespace(0, namespace, 0, -1)
--     local bufnr = ctx.bufnr
--     for _, value in pairs(result) do
--         local line = tonumber(value.position.line)
--         local label = value.label
--         if type(label) == "table" then
--             label = label.value or label[1].value
--         end
--         pcall(set_mark, bufnr, line, label, config and config.highlight or "NonText")
--     end
-- end
--
-- local function apply_edits_handler(err, result, ctx, config)
--     if err or not result then
--         return
--     end
--     local bufnr = ctx.bufnr
--     local text_edits = {}
--     for _, value in pairs(result) do
--         if value.textEdits then
--             for _, edit in pairs(value.textEdits) do
--                 table.insert(text_edits, edit)
--             end
--         end
--     end
--     if next(text_edits) ~= nil then
--         vim.lsp.util.apply_text_edits(text_edits, bufnr, "utf-16")
--     end
-- end
--
-- function M.show(start_pos, end_pos, config)
--     if not enabled then
--         return
--     end
--     start_pos = start_pos or { 1, 0 }
--     end_pos = end_pos or { vim.api.nvim_buf_line_count(0) - 1, 0 }
--     local params = vim.lsp.util.make_given_range_params(start_pos, end_pos)
--     vim.lsp.buf_request(0, "textDocument/inlayHint", params, function(err, result, ctx, _)
--         show_handler(err, result, ctx, config)
--     end)
-- end
--
-- function M.apply(start_pos, end_pos, config)
--     local params = vim.lsp.util.make_given_range_params(start_pos, end_pos)
--     vim.lsp.buf_request(0, "textDocument/inlayHint", params, function(err, result, ctx, _)
--         apply_edits_handler(err, result, ctx, config)
--     end)
-- end
--
-- vim.lsp.handlers["textDocument/inlayHint"] = show_handler
local execute_command = function(args)
  vim.dbglog({ "executeCommand", args })
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
  signatureHelpProvider = signature_help_provider,
  typeDefinitionProvider = type_definition_provider,
  workspace = workspace,
  -- executeCommandProvider, semanticTokensProvider, inlayHintProvider, foldingRangeProvider, workspaceSymbolProvider
}

return handlers
