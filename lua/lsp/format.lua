local lsp_formatting = function(bufnr)
  local pos = vim.api.nvim_win_get_cursor(0)
  vim.lsp.buf.format(
    {
      bufnr = bufnr
      -- filter = function(clients)
      -- return vim.tbl_filter(function(client) end)
      --     vim.logger:debug(client)
      --     -- if client.name == "sqls" then
      --     --   return false
      --     -- end
      --     return client
      --   end, clients)
      -- end
    }
  )
  vim.cmd("$g/^$/d")
  vim.api.nvim_win_set_cursor(0, pos)
end

local attach_formatting = function(bufnr, client)
  if client.supports_method "textDocument/formatting" then
    vim.api.nvim_exec(
      [[
      augroup LspAutocommands
      autocmd! * <buffer>
      autocmd BufWritePre <buffer> lua local pos = vim.api.nvim_win_get_cursor(0); vim.lsp.buf.format(); vim.cmd("$g/^$/d"); vim.api.nvim_win_set_cursor(0, pos)
      augroup END
      ]],
      true
    )
  -- local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

  -- vim.api.nvim_buf_create_user_command(
  --   bufnr,
  --   "LspFormatting",
  --   function()
  --     vim.notify("FORMAT", "debug")
  --     lsp_formatting(bufnr)
  --   end,
  --   {}
  -- )
  -- -- vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }

  -- vim.api.nvim_create_autocmd(
  --   "BufWritePre",
  --   {
  --     group = augroup,
  --     buffer = bufnr,
  --     command = "LspFormatting"
  --   }
  -- )
  end
end

return attach_formatting
