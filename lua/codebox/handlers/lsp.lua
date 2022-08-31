local M = {}
local telescope = require("codebox.telescope")
local lib = require("codebox.lib")
local utils = require("codebox.utils")
local config = require("codebox.config")

local function open_references_previewer(prompt_title, items)
  if telescope.has_telescope then
    local opts = config.conf.references.telescope
    local entry_maker = telescope.make_entry.gen_from_quickfix(opts)
    local previewer = nil

    if not opts.hide_preview then
      previewer = telescope.conf.qflist_previewer(opts)
    end

    telescope.pickers
      .new(opts, {
        prompt_title = prompt_title,
        finder = telescope.finders.new_table({
          results = items,
          entry_maker = entry_maker,
        }),
        previewer = previewer,
        sorter = telescope.conf.generic_sorter(opts),
        attach_mappings = function(prompt_bufnr)
          telescope.actions.select_default:replace(function()
            local selection = telescope.action_state.get_selected_entry()
            telescope.actions.close(prompt_bufnr)

            local val = selection.value
            lib.open_floating_win(vim.uri_from_fname(val.filename), { val.lnum, val.col })
          end)

          return true
        end,
      })
      :find()
  else
    error("goto_preview_references requires Telescope.nvim")
  end
end

local handle = function(result, target, opts)
  if not result then
    return
  end

  local data = result[1] or result
  local _target = nil
  local cursor_position = {}

  if vim.tbl_isempty(data) then
    utils.logger.debug("The LSP returned no results. No preview to display.")
    return
  end

  _target, cursor_position = config.conf.lsp_configs.get_config(data)
  -- opts: focus_on_open, dismiss_on_move, etc.
  lib.open_floating_win(_target, cursor_position, opts)
end

local handle_references = function(result)
  if not result then
    return
  end
  local items = {}
  vim.list_extend(items, vim.lsp.util.locations_to_items(result, "utf-8") or {})
  open_references_previewer("References", items)
end

local function print_lsp_error(lsp_call)
  print("codebox: Error calling LSP" + lsp_call + ". The current language lsp might not support it.")
end

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
  local success, _ = pcall(vim.lsp.buf_request, 0, lsp_call, params, M.get_handler(lsp_call, target, opts))
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
  local success, _ = pcall(vim.lsp.buf_request, 0, lsp_call, params, M.get_handler(lsp_call, target, opts))
  if not success then
    print_lsp_error(lsp_call)
  end
end

M.get_handler = function(lsp_call, target, opts)
  return function(_, result, _, _)
    if lsp_call ~= nil and lsp_call == "textDocument/references" then
      utils.logger.debug("raw result", vim.inspect(result))
      handle_references(result)
    else
      handle(result, target, opts)
    end
  end
end

return M
