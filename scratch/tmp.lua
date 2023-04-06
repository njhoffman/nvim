local cfg = {}
local start_with_backend = function(backend)
  return function()
    local opts = vim.tbl_deep_extend("force", cfg, { backends = { backend } })
    require("aerial").setup(opts)
    require("aerial").toggle()
  end
end

local setup_cmds = function()
  local backends = require("aerial.backends")
  local supported = {
    lsp = backends.is_supported(0, "lsp"),
    ts = backends.is_supported(0, "treesitter"),
    man = backends.is_supported(0, "man"),
    help = backends.is_supported(0, "help"),
  }
  if supported.lsp == true then
    vim.api.nvim_create_user_command("AerialLsp", start_with_backend("lsp"), { desc = "Start Aerial with LSP backend" })
  end
  if supported.ts == true then
    vim.api.nvim_create_user_command("AerialTS", start_with_backend("ts"), { desc = "Start Aerial with TS backend" })
  end
  if supported.man == true then
    vim.api.nvim_create_user_command("AerialMan", start_with_backend("man"), { desc = "Start Aerial with Man backend" })
  end
  if supported.help == true then
    vim.api.nvim_create_user_command(
      "AerialHelp",
      start_with_backend("help"),
      { desc = "Start Aerial with Help backend" }
    )
  end
end

local augroup_ok, _ = pcall(vim.api.nvim_get_autocmds, { group = "AerialBuffer" })
if not augroup_ok then
  vim.api.nvim_create_augroup("AerialBuffer", { clear = false })
end
--
vim.api.nvim_create_autocmd({ "BufEnter" }, {
  group = "AerialBuffer",
  desc = "Create commands depending on aerial backend capabilities",
  callback = setup_cmds,
})
--
