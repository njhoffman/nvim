local M = {}

local diagnostic_utils = require("lsp.lsp_lines.diagnostic_utils")
local render = require("lsp.lsp_lines.render")

local function render_current_line(diagnostics, ns, bufnr, opts)
  local current_line_diag = {}
  local lnum = vim.api.nvim_win_get_cursor(0)[1] - 1

  for _, diagnostic in pairs(diagnostics) do
    local show = diagnostic.end_lnum and (lnum >= diagnostic.lnum and lnum <= diagnostic.end_lnum)
      or (lnum == diagnostic.lnum)
    if show then
      table.insert(current_line_diag, diagnostic)
    end
  end

  render.show(ns, bufnr, current_line_diag, opts)
end

local default_opts = {
  only_current_line = false,
  highlight_whole_line = false,
  symbol_arrow = "──── ",
}
---
---@class Opts
---@field virtual_lines OptsVirtualLines Options for lsp_lines plugin

---@class OptsVirtualLines
---@field only_current_line boolean|number Only render for current line, if number delay ms
---@field highlight_whole_line boolean Highlight empty space to the left of a diagnostic
---@field symbol_arrow string Symbol of arrow pointing to error

-- Registers a wrapper-handler to render lsp lines.
-- This should usually only be called once, during initialisation.
M.setup = function(init_opts)
  init_opts = vim.tbl_deep_extend("force", default_opts, init_opts or {})
  vim.api.nvim_create_augroup("LspLines", { clear = true })
  -- TODO: On LSP restart (e.g.: diagnostics cleared), errors don't go away.
  vim.diagnostic.handlers.virtual_lines = {
    ---@param namespace number
    ---@param bufnr number
    ---@param diagnostics table
    ---@param opts boolean|Opts
    show = function(namespace, bufnr, diagnostics, opts)
      opts = vim.tbl_deep_extend("force", init_opts, opts or {})
      local ns = vim.diagnostic.get_namespace(namespace)
      if not ns.user_data.virt_lines_ns then
        ns.user_data.virt_lines_ns = vim.api.nvim_create_namespace("")
      end

      diagnostics = diagnostic_utils.filter(bufnr, diagnostics, opts.virtual_lines)
      diagnostics = diagnostic_utils.format(bufnr, diagnostics, opts.virtual_lines)

      vim.api.nvim_clear_autocmds({ group = "LspLines" })
      if opts.virtual_lines.only_current_line then
        vim.api.nvim_create_autocmd("CursorMoved", {
          buffer = bufnr,
          callback = function()
            render_current_line(diagnostics, ns.user_data.virt_lines_ns, bufnr, opts)
          end,
          group = "LspLines",
        })
        -- Also show diagnostics for the current line before the first CursorMoved event
        render_current_line(diagnostics, ns.user_data.virt_lines_ns, bufnr, opts)
      else
        render.show(ns.user_data.virt_lines_ns, bufnr, diagnostics, opts)
      end
    end,
    ---@param namespace number
    ---@param bufnr number
    hide = function(namespace, bufnr)
      local ns = vim.diagnostic.get_namespace(namespace)
      if ns.user_data.virt_lines_ns then
        render.hide(ns.user_data.virt_lines_ns, bufnr)
        vim.api.nvim_clear_autocmds({ group = "LspLines" })
      end
    end,
  }
end

---@return boolean
M.toggle = function()
  local new_value = not vim.diagnostic.config().virtual_lines
  vim.diagnostic.config({ virtual_lines = new_value })
  return new_value
end

return M
