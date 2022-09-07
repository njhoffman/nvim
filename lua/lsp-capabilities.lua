local lspdefs = require("lsp-definitions")
local windows = require("lspconfig/ui/windows")

local function close_preview_window(winnr, bufnrs)
  vim.schedule(function()
    -- exit if we are in one of ignored buffers
    if bufnrs and vim.tbl_contains(bufnrs, vim.api.nvim_get_current_buf()) then
      return
    end

    local augroup = "preview_window_" .. winnr
    pcall(vim.api.nvim_del_augroup_by_name, augroup)
    pcall(vim.api.nvim_win_close, winnr, true)
  end)
end

local function close_preview_autocmd(events, winnr, bufnrs)
  local augroup = vim.api.nvim_create_augroup("preview_window_" .. winnr, {
    clear = true,
  })

  -- close the preview window when entered a buffer that is not
  -- the floating window buffer or the buffer that spawned it
  vim.api.nvim_create_autocmd("BufEnter", {
    group = augroup,
    callback = function()
      close_preview_window(winnr, bufnrs)
    end,
  })

  if #events > 0 then
    vim.api.nvim_create_autocmd(events, {
      group = augroup,
      buffer = bufnrs[2],
      callback = function()
        close_preview_window(winnr)
      end,
    })
  end
end

-- UI just like `:LspInfo` to show which capabilities each attached server has
vim.cmd("command! LspCapabilities lua require'lsp-capabilities'()")

return function()
  local buf_clients = vim.lsp.get_active_clients()
  local win_info = windows.percentage_range_window(0.8, 0.7)
  local bufnr, win_id = win_info.bufnr, win_info.win_id

  local buf_lines = {}

  local buf_client_names = {}
  for _, client in ipairs(buf_clients) do
    table.insert(buf_client_names, client.name)
  end

  --   vim.lsp._request_name_to_capability
  local function available_capabilities(server_capabilities)
    -- these are the capabilities that might be interesting to the user
    return vim.tbl_filter(function(key)
      -- keep only the capabilities that are interesting & available
      return vim.tbl_contains(lspdefs.display_keys, key) and server_capabilities[key] == true
    end, vim.tbl_keys(server_capabilities))
  end

  local function make_client_info(client)
    return {
      "Client: " .. client.name .. " (id " .. tostring(client.id) .. ")",
      "resolved: \t" .. table.concat(available_capabilities(client.server_capabilities or {}), ", "),
      "raw: \t" .. table.concat(vim.tbl_keys(client.server_capabilities or {}), ", "),
    }
  end

  for _, client in ipairs(buf_clients) do
    vim.list_extend(buf_lines, make_client_info(client))
    vim.list_extend(buf_lines, { "" })
  end

  vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, buf_lines)
  vim.api.nvim_buf_set_option(bufnr, "modifiable", false)
  vim.api.nvim_buf_set_option(bufnr, "filetype", "lspcapabilities")
  local configs_pattern = [[\%(]] .. table.concat(buf_client_names, [[\|]]) .. [[\)]]
  vim.cmd([[syntax match Title /\%(Client\):.*\zs]] .. configs_pattern .. "/")
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<esc>", "<cmd>bd<CR>", { noremap = true })
  -- close_preview_autocmd({ "BufHidden", "BufLeave" }, win_id, { bufnr })
end
