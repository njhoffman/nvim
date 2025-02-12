require("lsp.float-diag")

local opts = {
  signs_priority = 6,
  inlay_hints = false,
  underline = false,
  virtual_text = false,
}

local diag_defaults = {
  severity_sort = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  virtual_lines = false,
  virtual_text = true,
}

local diag_cfg = vim.deepcopy(diag_defaults)
for _, key in ipairs(vim.tbl_keys(diag_defaults)) do
  if opts[key] ~= nil then
    diag_cfg[key] = opts[key]
  end
end

local is_legacy = not vim.fn.has("nvim-0.10.0")

-- underline = { severity = { min = vim.diagnostic.severity.ERROR } },
-- virtual_lines = false, -- { only_current_line = true, highlight_whole_line = false },
-- local virtual_text_config = {
-- source = "if_many",
-- spacing = 2,
-- -- severity = 0. -- ERROR, NFO, HINT
-- severity = { min = vim.diagnostic.severity.WARN },
-- -- format = function(diagnostic)
-- --   if diagnostic.severity == vim.diagnostic.severity.ERROR then
-- --     return string.format("E: %s", diagnostic.message)
-- --   end
-- --   return diagnostic.message
-- -- end,
-- }

if diag_cfg.signs then
  local icons = require("lsp.icons").get_icons("diagnostics")
  if not is_legacy and type(diag_cfg.signs) ~= "table" then
    diag_cfg.signs = { priority = opts.signs_priority }
  end

  local define_sign = function(level)
    local name = "DiagnosticsSign" .. level:gsub("^%l", string.upper)
    local idx = vim.diagnostic.severity[string.upper(level)]
    local props = {
      text = icons[level],
      texthl = "Lsp" .. name,
      priority = opts.signs_priority, -- if not set default is 10
    }

    if is_legacy then
      vim.fn.sign_define(name, props)
    else
      for _, attr in ipairs({ "text", "texthl", "numhl" }) do
        diag_cfg.signs[attr] = diag_cfg.signs[attr] or {}
        diag_cfg.signs[attr][idx] = props[attr]
      end
    end
  end

  for _, level in ipairs({ "error", "warn", "info", "hint" }) do
    define_sign(level)
  end
  vim.api.nvim_set_hl(0, "DiagnosticUnnecessary", { link = "Comment" })
end

-- inlay hints
-- if opts.inlay_hints and is_legacy then
--   LazyVim.lsp.on_supports_method("textDocument/inlayHint", function(client, buffer)
--     if
--       vim.api.nvim_buf_is_valid(buffer)
--       and vim.bo[buffer].buftype == ""
--       and not vim.tbl_contains(opts.inlay_hints.exclude, vim.bo[buffer].filetype)
--     then
--       vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
--     end
--   end)
-- end

-- code lens
-- if opts.codelens and vim.lsp.codelens then
--   LazyVim.lsp.on_supports_method("textDocument/codeLens", function(client, buffer)
--     vim.lsp.codelens.refresh()
--     vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
--       buffer = buffer,
--       callback = vim.lsp.codelens.refresh,
--     })
--   end)
-- end

vim.diagnostic.config(diag_cfg)

-- Show line diagnostics in floating popup on hover, except insert mode (CursorHoldI)
-- vim.cmd([[autocmd CursorHold * lua vim.diagnostic.open_float()]]):format()

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
