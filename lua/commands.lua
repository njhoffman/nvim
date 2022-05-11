if type(vim.lsp.buf.format) == 'function' then
  vim.api.nvim_create_user_command("Format", vim.lsp.buf.format, {})
else
  vim.api.nvim_create_user_command("Format", vim.lsp.buf.formatting_sync, {})
end
