local map = require("mapper2").map
local vmap = require("mapper2").vmap

local opts = { noremap = true, silent = true, buffer = true, category = "LSP" }

local mapping = {
  declarations = function()
    map("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
  end,
  rename = function()
    map("n", "gR", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
  end,
  references = function()
    map("n", "gqr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
    if vim.fn.exists(":Telescope") then
      map("n", "gr", "<cmd>lua require('telescope.run')('builtin', 'lsp_references')<cr>", opts)
    else
      map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
    end
  end,
  references_preview = function()
    map("n", "gPr", "<cmd>lua require('goto-preview').goto_preview_references()<CR>", opts)
  end,
  implementation = function()
    map("n", "gqi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
    if vim.fn.exists(":Telescope") then
      map("n", "gI", "<cmd>lua require('telescope.run')('builtin', 'lsp_definitions')<cr>", opts)
    else
      map("n", "gI", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
    end
  end,
  implementation_preview = function()
    map("n", "gPi", "<cmd>lua require('goto-preview').goto_preview_implementation()<CR>", opts)
  end,
  type_definition = function()
    map("n", "gqt", "<Cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
    if vim.fn.exists(":Telescope") then
      map("n", "gy", "<cmd>lua require('telescope.run')('builtin', 'lsp_type_definitions')<cr>", opts)
    else
      map("n", "gy", "<Cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
    end
  end,
  type_definition_preview = function()
    map("n", "gPt", "<cmd>lua require('goto-preview').goto_preview_type_definition()<CR>", opts)
  end,
  definition = function()
    map("n", "gqd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
    if vim.fn.exists(":Telescope") then
      map("n", "gd", "<cmd>lua require('telescope.run')('builtin', 'lsp_definitions')<cr>", opts)
    else
      map("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
    end
  end,
  definition_preview = function()
    map("n", "gPd", "<cmd>lua require('goto-preview').goto_preview_definition()<CR>", opts)
  end,
  code_action = function()
    -- "<cmd>lua vim.lsp.buf.code_action()<CR>"
    map("n", "gC", "<cmd>CodeActionMenu<CR>", opts)
  end,
  hover = function()
    map("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
  end,
  codelens = function(cmd)
    map("n", "gL", cmd, opts)
  end,
  formatting = function(cmd)
    map("n", "<Leader>ff", cmd, opts)
  end,
  formatting_range = function()
    map("v", "<Leader>p", ":'<,'>lua vim.lsp.buf.range_formatting()<CR>", opts)
  end,
  signature_hover = function()
    map("n", "gK", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  end,
  signature_preview_up = function(cmd)
    map({ "i", "n" }, "<C-Up>", cmd, opts)
  end,
  signature_preview_down = function(cmd)
    map({ "i", "n" }, "<C-Down>", cmd, opts)
  end,
  signature_toggle = function()
    -- vmap("i", "<M-x>", { desc = "", label = ""})
    return "<M-x>"
  end,
  signature_select = function()
    -- vmap
    return "<M-n>"
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
