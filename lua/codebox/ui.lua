local lib = require("codebox.lib")
local utils = require("codebox.utils")
local config = require("codebox.config")
local mappings = require("codebox.mappings")

local lsp = require("codebox.handlers.lsp")
local syntax = require("codebox.handlers.syntax")

local setup = function(_conf)
  local conf = config.setup(_conf) or {}
  utils.logger.debug("non-lib:", vim.inspect(conf))

  lib.setup_lib(conf)
  lib.setup_aucmds()

  if conf.default_mappings then
    mappings.apply_default_mappings()
  end
  if conf.resizing_mappings then
    mappings.apply_resizing_mappings()
  end
end

local view_syntax = function(target, opts)
  local params = vim.lsp.util.make_position_params(0, "utf-8")
  syntax.get_handler({ opts, params, target })
end

local close_all_win = function()
  local windows = vim.api.nvim_tabpage_list_wins(0)
  for _, win in pairs(windows) do
    local index = utils.table_find(lib.windows, win)
    table.remove(lib.windows, index)
    pcall(lib.close_if_is_goto_preview, win)
  end
end

local M = {}

M.remove_win = lib.remove_win
M.buffer_entered = lib.buffer_entered
M.dismiss_preview = lib.dismiss_preview
M.dock_to_edge = lib.dock_to_edge

M.goto_preview_definition = lsp.request_definition
M.goto_preview_type_definition = lsp.request_type_definition
M.goto_preview_implementation = lsp.request_implementation
M.goto_preview_references = lsp.request_references

M.view_syntax = view_syntax
M.close_all_win = close_all_win
M.setup = setup

return M
