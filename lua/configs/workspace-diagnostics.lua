require("workspace-diagnostics").setup({
  -- workspace_files = function()
  --   return { 'index.js', 'lib/banana.js' }
  -- end
})

local get_workspace_diags = function()
  for _, client in ipairs(vim.lsp.buf_get_clients()) do
    require("workspace-diagnostics").populate_workspace_diagnostics(client, 0)
  end
end

vim.api.nvim_create_user_command("DiagWorkspace", get_workspace_diags, {
  desc = "all workspace diagnostics",
})
