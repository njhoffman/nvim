local map = require("mapper").map
local vmap = require("mapper").vmap
local is_installed = require("utils.lazy").is_installed
local opts = {
  noremap = true,
  silent = true,
  buffer = true,
  category = "LSP",
}

-- keymap('n', 'ge', vim.diagnostic.goto_next, { desc = '󰒕 Next Diagnostic' })
-- keymap('n', 'gE', vim.diagnostic.goto_prev, { desc = '󰒕 Previous Diagnostic' })
-- keymap({ 'n', 'v', 'i' }, '<D-g>', vim.lsp.buf.signature_help, { desc = '󰏪 Signature' })
-- -- needs remapping since `gf` is used for LSP-references
-- keymap('n', 'gp', 'gf', { desc = ' Goto Path under cursor' })
-- -- quickfix
-- keymap('n', 'gq', '<cmd>cnext<CR>zv', { desc = ' Next Quickfix' })
-- keymap('n', 'gQ', '<cmd>cprevious<CR>zv', { desc = ' Prev Quickfix' })
-- keymap('n', 'dQ', '<cmd>cexpr []<CR>', { desc = ' Delete Qf List' })
--

-- TODO: next/prev reference
local mapping = {
  rename = function()
    -- opts.desc = "rename buffer"
    -- map('n', 'gM', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    -- map("n", "gM", "<cmd>Rename<CR>", opts)
  end,
  references = function()
    -- references and definitions taken care of in plugin
    opts.desc = "lsp references in telescope"
    map("n", "glr", "<cmd>lua require('telescope.run')('builtin', 'lsp_references')<cr>", opts)
    opts.desc = "lsp references"
    map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
  end,
  references_preview = function()
    opts.desc = "preview lsp references"
    map("n", "g?r", "<cmd>lua require('goto-preview').goto_preview_references()<CR>", opts)
  end,
  implementation = function()
    opts.desc = "lsp implementations in quickfix"
    map("n", "gQi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
    opts.desc = "lsp implementations in telescope"
    map("n", "gli", "<cmd>lua require('telescope.run')('builtin', 'lsp_definitions')<cr>", opts)
  end,
  implementation_preview = function()
    opts.desc = "preview lsp implementaitons"
    map("n", "g?i", "<cmd>lua require('goto-preview').goto_preview_implementation()<CR>", opts)
  end,
  type_definition = function()
    opts.desc = "lsp type definitions in telescope"
    map(
      "n",
      "glt",
      "<cmd>lua require('telescope.run')('builtin', 'lsp_type_definitions')<cr>",
      opts
    )
    opts.desc = "lsp type definitions in quickfix"
    map("n", "gQt", "<Cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
  end,
  type_definition_preview = function()
    opts.desc = "preview lsp type definitions"
    map("n", "gPt", "<cmd>lua require('goto-preview').goto_preview_type_definition()<CR>", opts)
  end,
  definition = function()
    opts.desc = "lsp definitions in telescope"
    map("n", "gld", "<cmd>lua require('telescope.run')('builtin', 'lsp_definitions')<cr>", opts)
    opts.desc = "lsp definitions in quickfix"
    map("n", "gQd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
  end,
  definition_preview = function()
    opts.desc = "preview lsp definitions"
    map("n", "g?d", "<cmd>lua require('goto-preview').goto_preview_definition()<CR>", opts)
  end,
  declaration = function()
    opts.desc = "lsp declarations in quickfix"
    map("n", "gQd", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
  end,
  code_action = function()
    opts.desc = "view code action menu"
    -- "<cmd>lua vim.lsp.buf.code_action()<CR>"
    map("n", "glc", '<cmd>lua require("actions-preview").code_actions()<CR>', opts)
    map("n", "gG", "<cmd>CodeActionMenu<CR>", opts)
  end,
  hover = function()
    opts.desc = "hover provider under cursor"
    pcall(vim.keymap.del, "n", "K")
    map("n", "K", "<Cmd>Hover<CR>", opts)
    -- map('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  end,
  codelens = function(cmd)
    -- opts.desc = 'lsp code lens'
    -- map('n', 'gL', cmd, opts)
  end,
  formatting = function(cmd)
    opts.desc = "lsp file format"
    map("n", "<Leader>ff", cmd, opts)
  end,
  formatting_range = function()
    opts.desc = "lsp file format range"
    map("v", "<Leader>ff", ":'<,'>lua vim.lsp.buf.range_formatting()<CR>", opts)
  end,
  signature_hover = function()
    opts.desc = "lsp signature hover"
    map("n", "gK", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  end,
  signature_preview_up = function(cmd)
    opts.desc = "lsp signature preview up"
    map({ "i", "n" }, "<C-S-Up>", cmd, opts)
  end,
  signature_preview_down = function(cmd)
    opts.desc = "lsp signature preview down"
    map({ "i", "n" }, "<C-S-Down>", cmd, opts)
  end,
  signature_preview_page_up = function(cmd)
    opts.desc = "lsp signature preview up"
    map({ "i", "n" }, "<M-b>", cmd, opts)
  end,
  signature_preview_page_down = function(cmd)
    opts.desc = "lsp signature preview down"
    map({ "i", "n" }, "<M-f>", cmd, opts)
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

local setup_mappings = function(client, bufnr)
  vim.api.nvim_set_keymap(
    "n",
    "<C-t>",
    "<cmd>lua require('telescope.run')('builtin', 'diagnostics', { bufnr = true })<cr>",
    { silent = true, desc = "show buffer diagnostics" }
  )

  vim.api.nvim_set_keymap(
    "n",
    "<M-T>",
    "<cmd>lua require('telescope.run')('builtin', 'diagnostics')<cr>",
    { silent = true, desc = "show workspace  diagnostics" }
  )

  -- vim.api.nvim_set_keymap('n', '<M-C-T>', '', {
  --   silent = true,
  --   desc = 'show full workspace  diagnostics',
  --   callback = function()
  --     require('workspace-diagnostics').populate_workspace_diagnostics(client, bufnr)
  --     require('telescope.run')('builtin', 'diagnostics')
  --   end,
  -- })

  vim.api.nvim_set_keymap(
    "n",
    "<Leader>e",
    "<cmd>lua vim.diagnostic.open_float()<CR>",
    { silent = true, desc = "open diagnostic float" }
  )
  vim.api.nvim_set_keymap(
    "n",
    "[d",
    '<cmd>lua _G.diagnostic_goto("prev")<cr>',
    { silent = true, desc = "prev diagnostic problem" }
  )
  vim.api.nvim_set_keymap(
    "n",
    "]d",
    '<cmd>lua _G.diagnostic_goto("next")<cr>',
    { silent = true, desc = "next diagnostic problem" }
  )
  vim.api.nvim_set_keymap(
    "n",
    "[e",
    '<cmd>lua _G.diagnostic_goto("prev", vim.diagnostic.severity.ERROR)<cr>',
    { silent = true, desc = "jump to prev error" }
  )

  vim.api.nvim_set_keymap(
    "n",
    "]e",
    '<cmd>lua _G.diagnostic_goto("next", vim.diagnostic.severity.ERROR)<cr>',
    { silent = true, desc = "jump to next error" }
  )

  vim.api.nvim_set_keymap(
    "n",
    "gQd",
    "<cmd>lua vim.diagnostic.setqflist({ open = true  })<CR>",
    { silent = true, desc = "diagnostics to quickfix" }
  )

  -- if the file is .sql
  if vim.bo.filetype == "sql" then
    vim.keymap.set("n", "<leader>", ":!sqlfluff fix -fq --dialect=postgres %<cr>")
  end
end
return { mapping = mapping, setup_mappings = setup_mappings }

-- map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
-- map("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
-- map("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
-- map("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
-- map("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
-- map("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
-- map("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })
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
