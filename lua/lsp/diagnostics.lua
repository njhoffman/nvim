-- LSP Diagnostics Configuration
-- Configures diagnostic display, signs, and severity

local log = require("logger").init("lsp.diagnostics")

local M = {}

-- Configuration options
local opts = {
  log_level = 2,
  signs_priority = 6,
  underline = false,
  jump = {
    on_jump = function()
      vim.diagnostic.open_float()
    end,
    wrap = true,
  },
  severity_sort = true,
}

-- Set LSP log level
vim.lsp.log.set_level(opts.log_level)

-- Build diagnostic config
local diag_cfg = {
  float = true,
  severity_sort = opts.severity_sort,
  signs = true,
  underline = opts.underline,
  update_in_insert = false,
  virtual_lines = false,
  virtual_text = false,
  jump = opts.jump,
}

-- Configure diagnostic signs
local function setup_signs()
  local icons = require("lsp.icons").get_icons("diagnostics")
  local is_legacy = not vim.fn.has("nvim-0.10.0")

  if type(diag_cfg.signs) ~= "table" then
    diag_cfg.signs = { priority = opts.signs_priority }
  end

  local define_sign = function(level)
    local name = "DiagnosticsSign" .. level:gsub("^%l", string.upper)
    local idx = vim.diagnostic.severity[string.upper(level)]
    local props = {
      text = icons[level],
      texthl = "Lsp" .. name,
      priority = opts.signs_priority,
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

  -- Make unnecessary code less prominent
  vim.api.nvim_set_hl(0, "DiagnosticUnnecessary", { link = "Comment" })
end

setup_signs()

-- Apply diagnostic configuration
vim.diagnostic.config(diag_cfg)

log:debug("Diagnostic configuration applied")

-- Track LSP progress events
vim.api.nvim_create_autocmd("LspProgress", {
  callback = function(args)
    if not args.data or not args.data.params then
      return
    end

    local value = args.data.params.value
    if not value then
      return
    end

    local title = value.title or "unknown"
    local client_id = args.data.client_id or "?"

    if args.file == "begin" then
      log:debug("LspProgress begin: buffer=" .. args.buf .. " client=" .. client_id .. " " .. title)
    elseif args.file == "end" then
      log:debug("LspProgress end: buffer=" .. args.buf .. " client=" .. client_id .. " " .. title)
    end
  end,
})

return M
