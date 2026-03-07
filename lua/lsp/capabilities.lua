-- LSP Capabilities
-- Handles capability creation and display

local log = require("logger").init("lsp.capabilities")

local M = {}

-- Create capabilities with cmp_nvim_lsp enhancements
function M.make()
  local capabilities =
    require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

  -- Enable folding support (for nvim-ufo)
  capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
  }

  -- Enable snippet support
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = { "documentation", "detail", "additionalTextEdits" },
  }

  return capabilities
end

-- Display capabilities for all active LSP clients
function M.show()
  local windows = require("lsp.windows")
  local lspdefs = require("lsp.definitions")

  local buf_clients = vim.lsp.get_clients()
  if #buf_clients == 0 then
    vim.notify("No LSP clients attached", vim.log.levels.WARN)
    return
  end

  local win_info = windows.percentage_range_window(0.8, 0.7)
  local bufnr, win_id = win_info.bufnr, win_info.win_id

  local buf_lines = {}
  local buf_client_names = {}

  for _, client in ipairs(buf_clients) do
    table.insert(buf_client_names, client.name)
  end

  local function make_client_info(client)
    local filtered, skipped = {}, {}
    for key, val in pairs(client.server_capabilities) do
      if vim.tbl_contains(lspdefs.display_keys, key) and client.server_capabilities[key] ~= false then
        table.insert(filtered, key)
      else
        table.insert(skipped, key)
      end
    end

    local lines = {
      "Client: " .. client.name .. " (id " .. tostring(client.id) .. ")",
    }
    for _, key in ipairs(vim.fn.sort(filtered)) do
      table.insert(lines, "      " .. key)
    end
    for _, key in ipairs(vim.fn.sort(skipped)) do
      table.insert(lines, "    󰍴  " .. key)
    end
    return lines
  end

  for _, client in ipairs(buf_clients) do
    vim.list_extend(buf_lines, make_client_info(client))
    vim.list_extend(buf_lines, { "" })
  end

  vim.api.nvim_set_option_value("wrap", true, { win = win_id })
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, buf_lines)
  vim.api.nvim_set_option_value("modifiable", false, { buf = bufnr })
  vim.api.nvim_set_option_value("filetype", "lspinfo", { buf = bufnr })

  local configs_pattern = [[\%(]] .. table.concat(buf_client_names, [[\|]]) .. [[\)]]
  vim.cmd([[syntax match Title /\%(Client\):.*\zs]] .. configs_pattern .. "/")
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<esc>", "<cmd>bd<CR>", { noremap = true })

  log:debug("Displayed capabilities for " .. #buf_clients .. " clients")
end

-- Resolve capabilities for a client/buffer pair
function M.resolve(client, bufnr)
  log:debug("Resolving capabilities for " .. client.name .. " on buffer " .. bufnr)
  for key, _ in pairs(client.server_capabilities) do
    if client.server_capabilities[key] then
      log:debug("  " .. key)
    end
  end
end

-- Create user command
vim.api.nvim_create_user_command("LspCapabilities", function()
  M.show()
end, { desc = "Show LSP capabilities" })

return M
