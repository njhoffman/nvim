local utils = require("codebox.utils")
local ui = require("codebox.ui")

local get_config = function(data)
  require("codebox.utils").logger.debug("data from the lsp", vim.inspect(data))
  local uri = data.targetUri or data.uri
  local range = data.targetRange or data.range
  return uri, { range.start.line + 1, range.start.character }
end

local function print_lsp_error(lsp_call)
  print("codebox: Error calling LSP" + lsp_call + ". The current language lsp might not support it.")
end

local handle = function(result, opts)
  if not result then
    return
  end

  local data = result[1] or result

  if vim.tbl_isempty(data) then
    utils.logger.debug("The LSP returned no results. No preview to display.")
    return
  end

  local uri, cursor_position = get_config(data)
  local bufnr = vim.uri_to_bufnr(uri) or data
  ui.open_floating_win(bufnr, cursor_position, opts)
end

local handle_references = function(result)
  if not result then
    return
  end
  local items = {}

  vim.list_extend(items, vim.lsp.util.locations_to_items(result, "utf-8") or {})
  require("codebox.telescope").open_references_previewer("References", items)
end

local get_handler = function(lsp_call, target, opts)
  return function(_, result, _, _)
    if lsp_call ~= nil and lsp_call == "textDocument/references" then
      utils.logger.debug("raw result", vim.inspect(result))
      handle_references(result)
    else
      handle(result, target, opts)
    end
  end
end

local M = {}
--- Preview implementation.
--- @param opts table: Custom config
---        • focus_on_open boolean: Focus the floating window when opening it.
---        • dismiss_on_move boolean: Dismiss the floating window when moving the cursor.
--- @see require("codebox").setup()
M.request_implementation = function(opts)
  local params = vim.lsp.util.make_position_params()
  local lsp_call = "textDocument/implementation"
  local success, _ = pcall(vim.lsp.buf_request, 0, lsp_call, params, M.get_handler(lsp_call, opts))
  if not success then
    print_lsp_error(lsp_call)
  end
end

M.request_references = function(opts)
  local params = vim.lsp.util.make_position_params()
  utils.logger.debug("params pre manipulation", vim.inspect(params))
  if not params.context then
    params.context = {
      includeDeclaration = true,
    }
  end
  utils.logger.debug("params post manipulation", vim.inspect(params))
  local lsp_call = "textDocument/references"
  local success, _ = pcall(vim.lsp.buf_request, 0, lsp_call, params, M.get_handler(lsp_call, opts))
  if not success then
    print_lsp_error(lsp_call)
  end
end

--- Preview definition.
--- @param opts table: Custom config
---        • focus_on_open boolean: Focus the floating window when opening it.
---        • dismiss_on_move boolean: Dismiss the floating window when moving the cursor.
--- @see require("codebox").setup()
M.request_definition = function(target, opts)
  local params = vim.lsp.util.make_position_params()
  local lsp_call = "textDocument/definition"
  local success, _ = pcall(vim.lsp.buf_request, 0, lsp_call, params, get_handler(lsp_call, opts))
  if not success then
    print_lsp_error(lsp_call)
  end
end

--- Preview type definition.
--- @param opts table: Custom config
---        • focus_on_open boolean: Focus the floating window when opening it.
---        • dismiss_on_move boolean: Dismiss the floating window when moving the cursor.
--- @see require("codebox").setup()
M.request_type_definition = function(target, opts)
  local params = vim.lsp.util.make_position_params()
  local lsp_call = "textDocument/typeDefinition"
  local success, _ = pcall(vim.lsp.buf_request, 0, lsp_call, params, M.get_handler(lsp_call, opts))
  if not success then
    print_lsp_error(lsp_call)
  end
end

return M
