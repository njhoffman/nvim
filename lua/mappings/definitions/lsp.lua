return {
  hover_doc1 = {
    cmd   = "<cmd>Lspsaga hover_doc<cr>",
    short = "lsp hover document",
  },
  definitions = {
    cmd   = "<cmd>Telescope lsp_definitions<cr>",
    short = "lsp definitions",
  },
  declaration = {
    cmd = "<cmd>lua vim.lsp.buf_declaration()<cr>",
    short = "lsp declaration",
  },
  hover_doc2 = {
    cmd   = "<cmd>Lspsaga hover_doc<cr>",
    short = "lsp hover document ",
  },
  organize_imports = {
    cmd = "<cmd>TSLspOrganize<cr>",
    short = "lsp organize imports",
  },
  finder1 = {
    cmd   = "<cmd>Telescope lsp_finder<cr>",
    short = "lsp finder",
  },
  references = {
    cmd   = "<cmd>Telescope lsp_references<cr>",
    short = "lsp references",
  },
  signature_help1 = {
    cmd = "<cmd>Telescope lsp_signature_help<cr>",
    short = "lsp signature help",
  },
  buffer_definitions = {
    cmd = "<cmd>lua vim.lsp.buf.type_definition()<cr>",
    short = "lsp buffer definitions",
  },
  diagnostic_prev = {
    cmd = "<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>",
    short = "lsp diagnostic prev ",
  },
  diagnostic_next = {
    cmd = "<cmd>lua vim.lsp.diagnostic.goto_next()<cr>",
    short = "lsp diagnostic next",
  },
  code_action = {
    cmd   = "<cmd>Lspsaga code_action<cr>",
    short = "lsp code action",
  },
  range_code_action = {
    cmd = "<cmd>Lspsaga range_code_action<cr>",
    short = "lsp range code action",
  },
  doc_diagnostics = {
    cmd = "<cmd>lua _G._LspDiagDocument()<cr>",
    short = "lsp document diagnostics",
    long = "lsp document diagnostics"
  },
  doc_diagnostics_2 = {
    cmd = "<cmd>lua _G._LspDiagDocument()<cr>",
    short = "lsp document diagnostics",
  },
  doc_diagnostics_ivy = {
    cmd = "<cmd>lua _G._LspDiagDocumentIvy()<cr>",
    short = "lsp document diagnostics",
    long = "lsp document diagnostics ivy theme"
  },
  doc_diagnostics_fzf = {
    cmd = "<cmd>FzfLua lsp_document_diagnostics<cr>",
    short = "lsp document diagnostics",
    long = "lsp document diagnostics"
  },
  workspace_diagnostics = {
    cmd = "<cmd>lua _G._LspDiagWorkspace<cr>",
    short = "lsp workspace diagnostics",
  },
  workspace_diagnostics_ivy = {
    cmd = "<cmd>lua _G._LspDiagWorkspaceIvy()<cr>",
    short = "lsp workspace diag ivy",
    long = "lsp workspace diagnostics ivy theme"
  },
  view_log = {
    cmd = "<cmd>lua vim.cmd('e'..vim.lsp.get_log_path())<cr>",
    short = "lsp view log",
  },
  line_diagnostics = {
    cmd = "<cmd>Lspsaga show_line_diagnostics<cr>",
    short = "lsp line diagnostics",
  },
  finder2 = {
    cmd   = "<cmd>Lspsaga lsp_finder<cr>",
    short = "lsp finder",
  },
  server_info = {
    cmd   = "<cmd>LspInfo<cr>",
    short = "lsp server info",
  },
  signature_help2 = {
    cmd = "<cmd>Lspsaga signature_help<cr>",
    short = "lsp signature help",
  },
  format_buffer = {
    cmd = "<cmd>lua vim.lsp.buf.format({ async = true })<cr>",
    short = "lsp format buffer",
  },
  preview_definition = {
    cmd = "<cmd>Lspsaga preview_definition<cr>",
    short = "lsp preview definition",
  },
  rename = {
    cmd   = "<cmd>Lspsaga rename<cr>",
    short = "lsp rename",
  },
  doc_symbols = {
    cmd = "<cmd>Telescope lsp_document_symbols<cr>",
    short = "lsp document symbols",
  },
  workspace_symbols = {
    cmd = "<cmd>Telescope lsp_workspace_symbols<cr>",
    short = "lsp workspace symbols",
  },
  stop_all = {
    cmd   = "<cmd>LspStop<cr>",
    short = "lsp stop all",
  }
}

-- -- Add global keymappings for LSP actions
-- -- F3, F12: goto definition
-- vim.cmd [[
--   map  <F12>  gd
--   imap <F12>  <ESC>gd
--   map  <F3>   <F12>
--   imap <F3>   <F12>
-- ]]
-- -- Shift+F12: show usages/references
-- vim.cmd [[
--   map  <F24>  gr
--   imap <F24>  <ESC>gr
-- ]]
