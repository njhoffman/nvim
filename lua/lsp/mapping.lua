local map = require('mapper').map
local vmap = require('mapper').vmap
local is_installed = require('utils.lazy').is_installed
local opts = {
  noremap = true,
  silent = true,
  buffer = true,
  category = 'LSP',
}

local use_defref_plugin = true
-- keymap('n', 'ge', vim.diagnostic.goto_next, { desc = '󰒕 Next Diagnostic' })
-- keymap('n', 'gE', vim.diagnostic.goto_prev, { desc = '󰒕 Previous Diagnostic' })
-- keymap({ 'n', 'v', 'i' }, '<D-g>', vim.lsp.buf.signature_help, { desc = '󰏪 Signature' })
--
-- -- needs remapping since `gf` is used for LSP-references
-- keymap('n', 'gp', 'gf', { desc = ' Goto Path under cursor' })
--
-- -- quickfix
-- keymap('n', 'gq', '<cmd>cnext<CR>zv', { desc = ' Next Quickfix' })
-- keymap('n', 'gQ', '<cmd>cprevious<CR>zv', { desc = ' Prev Quickfix' })
-- keymap('n', 'dQ', '<cmd>cexpr []<CR>', { desc = ' Delete Qf List' })
--

-- TODO: next/prev reference
local mapping = {
  rename = function()
    opts.desc = 'rename buffer'
    map('n', 'gr', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  end,
  references = function()
    opts.desc = 'lsp references in quickfix'
    map('n', 'gQr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    -- references and definitions taken care of in plugin
    if not use_defref_plugin then
      if is_installed('telescope.nvim') then
        opts.desc = 'lsp references in telescope'
        map('n', 'gr', "<cmd>lua require('telescope.run')('builtin', 'lsp_references')<cr>", opts)
      else
        map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
      end
    end
  end,
  references_preview = function()
    opts.desc = 'preview lsp references'
    map('n', 'gPr', "<cmd>lua require('goto-preview').goto_preview_references()<CR>", opts)
  end,
  implementation = function()
    opts.desc = 'lsp implementations in quickfix'
    map('n', 'gQi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    if vim.fn.exists(':Telescope') then
      opts.desc = 'lsp implementations in telescope'
      map('n', 'gI', "<cmd>lua require('telescope.run')('builtin', 'lsp_definitions')<cr>", opts)
    else
      map('n', 'gI', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    end
  end,
  implementation_preview = function()
    opts.desc = 'preview lsp implementaitons'
    map('n', 'gPi', "<cmd>lua require('goto-preview').goto_preview_implementation()<CR>", opts)
  end,
  type_definition = function()
    opts.desc = 'lsp type definitions in quickfix'
    map('n', 'gQt', '<Cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    if vim.fn.exists(':Telescope') then
      opts.desc = 'lsp type definitions in telescope'
      map('n', 'gy', "<cmd>lua require('telescope.run')('builtin', 'lsp_type_definitions')<cr>", opts)
    else
      map('n', 'gy', '<Cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    end
  end,
  type_definition_preview = function()
    opts.desc = 'preview lsp type definitions'
    map('n', 'gPt', "<cmd>lua require('goto-preview').goto_preview_type_definition()<CR>", opts)
  end,
  definition = function()
    opts.desc = 'lsp definitions in quickfix'
    map('n', 'gQd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
    -- handled in plugin
    if not use_defref_plugin then
      if vim.fn.exists(':Telescope') then
        opts.desc = 'lsp definitions in telescope'
        map('n', 'gd', "<cmd>lua require('telescope.run')('builtin', 'lsp_definitions')<cr>", opts)
      else
        map('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
      end
    end
  end,
  definition_preview = function()
    opts.desc = 'preview lsp definitions'
    map('n', 'gPd', "<cmd>lua require('goto-preview').goto_preview_definition()<CR>", opts)
  end,
  declaration = function()
    opts.desc = 'lsp declarations in quickfix'
    map('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  end,
  code_action = function()
    opts.desc = 'view code action menu'
    -- "<cmd>lua vim.lsp.buf.code_action()<CR>"
    map('n', 'gG', '<cmd>lua require("actions-preview").code_actions()<CR>', opts)
    map('n', 'gC', '<cmd>lua require("actions-preview").code_actions()<CR>', opts)
    map('n', '<leader>ca', '<cmd>CodeActionMenu<CR>', opts)
  end,
  hover = function()
    opts.desc = 'hover provider under cursor'
    pcall(vim.keymap.del, 'n', 'K')
    map('n', 'K', '<Cmd>Hover<CR>', opts)
    -- map('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  end,
  codelens = function(cmd)
    opts.desc = 'lsp code lens'
    map('n', 'gL', cmd, opts)
  end,
  formatting = function(cmd)
    opts.desc = 'lsp file format'
    map('n', '<Leader>ff', cmd, opts)
  end,
  formatting_range = function()
    opts.desc = 'lsp file format range'
    map('v', '<Leader>ff', ":'<,'>lua vim.lsp.buf.range_formatting()<CR>", opts)
  end,
  signature_hover = function()
    opts.desc = 'lsp signature hover'
    map('n', 'gK', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  end,
  signature_preview_up = function(cmd)
    opts.desc = 'lsp signature preview up'
    map({ 'i', 'n' }, '<Up>', cmd, opts)
  end,
  signature_preview_down = function(cmd)
    opts.desc = 'lsp signature preview down'
    map({ 'i', 'n' }, '<Down>', cmd, opts)
  end,
  signature_preview_page_up = function(cmd)
    opts.desc = 'lsp signature preview up'
    map({ 'i', 'n' }, '<M-b>', cmd, opts)
    map({ 'i', 'n' }, '<C-Up>', cmd, opts)
  end,
  signature_preview_page_down = function(cmd)
    opts.desc = 'lsp signature preview down'
    map({ 'i', 'n' }, '<M-f>', cmd, opts)
    map({ 'i', 'n' }, '<C-Down>', cmd, opts)
  end,
  signature_toggle = function()
    -- vmap("i", "<M-x>", { desc = "", label = ""})
    return '<M-x>'
  end,
  signature_select = function()
    -- vmap
    return '<M-n>'
  end,
  signature_move_cursor = function()
    -- vmap
    return "<M-'>"
  end,
}

return mapping

-- M.map("LSP", "n", "K", "hover_doc1")
-- M.map("LSP", "n", "gk", "hover_doc2")
-- M.map("LSP", "n", "gs", "signature_help1")
-- M.map("LSP", "n", "[d", "diagnostic_prev")
-- M.map("LSP", "n", "]d", "diagnostic_next")
-- M.map("LSP", "n", "<leader>la", "code_action")
-- M.map("LSP", "n", "<leader>lA", "range_code_action")
-- M.map("LSP", "n", "<leader>ld", "doc_diagnostics")
-- M.map("LSP", "n", "<leader>lD", "workspace_diagnostics")
-- M.map("LSP", "n", "<leader>le", "view_log")
-- M.map("LSP", "n", "<leader>ll", "line_diagnostics")
-- M.map("LSP", "n", "<leader>lf", "finder2")
-- M.map("LSP", "n", "<leader>li", "server_info")
-- M.map("LSP", "n", "<leader>lk", "signature_help2")
-- M.map("LSP", "n", "<leader>lF", "format_buffer")
-- M.map("LSP", "n", "<leader>lp", "preview_definition")
-- M.map("LSP", "n", "<leader>lr", "rename")
-- M.map("LSP", "n", "<leader>ls", "doc_symbols")
-- M.map("LSP", "n", "<leader>lS", "workspace_symbols")
-- M.map("LSP", "n", "<leader>l.a", "stop_all")
-- M.map("LSP", "n", "<C-t>", "doc_diagnostics_ivy")
