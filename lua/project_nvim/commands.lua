local root = require("project_nvim.root")
local state = require("project_nvim.state")
local history = require("project_nvim.utils.history")
local path = require("project_nvim.utils.path")
local logger = require("logger").init("project")

local set_cwd = function(dir, method)
  local options = require("project_nvim.config").get()
  vim.api.nvim_set_current_dir(dir)
  logger:info("cwd " .. path.home_path(dir) .. " (" .. tostring(method) .. ")")
  if options.silent_chdir == false then
    if type(options.chdir_func) == "function" then
      options.chdir_func(dir, method)
    else
    end
  end
end

local set_pwd = function(dir, method)
  if dir ~= nil then
    state.last_project = dir
    history.add_session_project(dir, method)
    -- set_user_option(dir, method)
    logger:trace("pwd " .. path.home_path(dir) .. " (" .. tostring(method) .. ")")
    if vim.fn.getcwd() ~= dir then
      history.write_projects_to_history(true)
      set_cwd(dir, method)
    end
    return true
  end
  return false
end

local on_buf_enter = function(ev)
  if vim.v.vim_did_enter == 0 or not path.is_file() then
    return
  end

  local current_dir = vim.fn.expand("%:p:h", true)
  if path.is_excluded(current_dir) then
    return
  end

  local root_path, method = root.get_project_root()

  local _, buf_skip = pcall(vim.api.nvim_get_var, "project_buf_skip")
  if buf_skip == 1 then
    logger:trace(
      "skip buf " .. path.home_path(tostring(root_path)) .. " (" .. tostring(method) .. ")"
    )
    vim.api.nvim_set_var("project_buf_skip", 0)
    vim.g.project_buf_skip = 0
    return
  end

  logger:trace(
    "buf: " .. path.home_path(tostring(root_path)) .. " (" .. tostring(method) .. ") " .. ev.event
  )
  set_pwd(root_path, method)
end

local on_attach_lsp = function(client, bufnr)
  logger:trace("attaching lsp: " .. client.name)
  on_buf_enter({ event = "LspAttach", buf = bufnr }) -- Recalculate root dir after lsp attaches
end

local attach_to_lsp = function()
  if state.attached_lsp then
    return
  end

  -- LspAttach fires for clients started by vim.lsp.start/vim.lsp.enable; the old
  -- vim.lsp.start_client monkey-patch never ran for those (and returned nil)
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("project_nvim_lsp_attach", { clear = true }),
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client then
        on_attach_lsp(client, args.buf)
      end
    end,
  })
  state.attached_lsp = true
end

local function setup_user()
  local cmd = vim.api.nvim_create_user_command
  cmd(
    "ProjectWrite",
    history.write_projects_to_history,
    { desc = "Write session data to history file" }
  )
  -- cmd("ProjectAdd", add_project_manually, { desc = "Add project root manually" })
  -- cmd("ProjectGetRoot", notify.show_root, { desc = "Get project root" })
end

local function setup_au()
  vim.api.nvim_create_augroup("project_nvim", { clear = true })
  local options = require("project_nvim.config").get()
  if not options.manual_mode then
    vim.api.nvim_create_autocmd({ "BufEnter", "LspAttach" }, {
      pattern = "*",
      callback = on_buf_enter,
      desc = "Check new buffer paths to identify project changes",
      group = "project_nvim",
      nested = true,
    })
    if vim.tbl_contains(options.detection_methods, "lsp") then
      attach_to_lsp()
    end
  end

  vim.api.nvim_create_autocmd("VimLeavePre", {
    pattern = "*",
    callback = history.write_projects_to_history,
    desc = "Write the projects stored in the session to state file",
    group = "project_nvim",
  })
end

return {
  setup_au = setup_au,
  setup_user = setup_user,
  set_pwd = set_pwd,
}
