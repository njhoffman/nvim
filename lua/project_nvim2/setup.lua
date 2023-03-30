local notify = require("project_nvim.utils.notify")
local history = require("project_nvim.utils.history")
local config = require("project_nvim.config")
local project = require("project_nvim.project")

local function add_project_manually()
  local current_dir = vim.fn.expand("%:p:h", true)
  project.set_pwd(current_dir, { method = "manual" })
end

local function setup_user_commands()
  local cmd = vim.api.nvim_create_user_command
  cmd("ProjectAdd", add_project_manually, { desc = "Add project root manually" })
  cmd("ProjectGetRoot", notify.show_root, { desc = "Get project root" })
  cmd("ProjectWrite", history.write_projects, { desc = "Write session data to history file" })
  cmd("ProjectDbg", function()
    vim.dbg(require("project_nvim.state"))
  end, { desc = "Dump debugging data" })
end

local function setup_au_commands()
  vim.api.nvim_create_augroup("project_nvim", { clear = true })
  vim.api.nvim_create_autocmd({ "BufEnter" }, {
    pattern = "*",
    callback = project.on_buf_enter,
    desc = "Check new buffer paths to identify project changes",
    group = "project_nvim",
    nested = true,
  })
  vim.api.nvim_create_autocmd("VimLeavePre", {
    pattern = "*",
    callback = history.write_projects,
    desc = "Write the projects stored in the session to state file",
    group = "project_nvim",
  })
end

local function setup(user_opts)
  config.init(user_opts)

  -- if vim.tbl_contains(config.options.detection_methods, "lsp") then
  --   attach_to_lsp()
  -- end

  setup_user_commands()
  -- setup_au_commands()
  history.read_projects()
end

return setup
