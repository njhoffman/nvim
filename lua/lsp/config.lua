require("lsp.float-diag")

local virtual_text_config = {
  source = "if_many",
  spacing = 2,
  -- severity = 0. -- ERROR, NFO, HINT
  severity = { min = vim.diagnostic.severity.WARN },
  -- format = function(diagnostic)
  --   if diagnostic.severity == vim.diagnostic.severity.ERROR then
  --     return string.format("E: %s", diagnostic.message)
  --   end
  --   return diagnostic.message
  -- end,
}

local diagnostic_config = {
  virtual_text = false,
  signs = true,
  underline = false,
  -- underline = {
  --   severity = { min = vim.diagnostic.severity.ERROR },
  -- },
  update_in_insert = false,
  severity_sort = true,
  virtual_lines = false, -- { only_current_line = true, highlight_whole_line = false },
}
vim.api.nvim_set_hl(0, "DiagnosticUnnecessary", { link = "Comment" })
vim.diagnostic.config(diagnostic_config)

-- Show line diagnostics in floating popup on hover, except insert mode (CursorHoldI)
-- vim.cmd([[autocmd CursorHold * lua vim.diagnostic.open_float()]])):format()

local logger = require("logger").init("lsp") or {}

vim.api.nvim_create_autocmd("LspProgress", {
  callback = function(args)
    if args.file == "begin" then
      logger:debug(
        "LspStarted: "
          .. args.buf
          .. " ("
          .. args.data.client_id
          .. ") "
          .. args.data.params.value.title
      )
    elseif args.file == "end" then
      -- data.client_id, dta.params.token, data.params.value.kind/title
      logger:debug(
        "LspEnded: "
          .. args.buf
          .. " ("
          .. args.data.client_id
          .. ") "
          .. args.data.params.value.title
      )
    end
    -- local client = vim.lsp.get_client_by_id(args.data.client_id)
    -- if client.server_capabilities.completionProvider then
    --   vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'
    -- end
    -- if client.server_capabilities.definitionProvider then
    --   vim.bo[bufnr].tagfunc = 'v:lua.vim.lsp.tagfunc'
    -- end
  end,
})
