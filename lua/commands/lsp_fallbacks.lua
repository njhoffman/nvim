-- handlers for lsp/treesitter fallback functions

local ts_locals = require("commands.treesitter.locals")

local logger = require("logger").init("lsp_fallbacks")

local native_rename = function(target_name) end
local native_incremental_selection = function()
  -- selection_range({direction}, {timeout_ms})
  --   direction number of expand steps, negative to shrink
end

local native_goto_definition = function() end
local native_references = function() end
local native_document_highlight = function() end

local check_lsp = function(capability)
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  for _, client in ipairs(clients) do
    if client.server_capabilities[capability] then
      return true
    end
  end
  return false
end

M = {}

M.goto_definition = function()
  local target_definition = vim.fn.expand("<cword>")
  if check_lsp("definitionProvider") then
    vim.lsp.buf.definition(target_definition)
  else
    native_goto_definition(target_definition)
  end
end

M.rename = function()
  -- check if inc-rename is available
  local target_name = vim.fn.expand("<cword>")
  local bufnr = vim.api.nvim_get_current_buf()

  if check_lsp("renameProvider") then
    if vim.api.nvim_buf_get_var(0, "inc_rename_available") then
      vim.cmd("IncRename " .. target_name)
    else
      vim.lsp.buf.rename({ bufnr = bufnr })
    end
  else
    native_rename(target_name)
  end
end

return M
