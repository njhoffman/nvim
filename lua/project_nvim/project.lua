local history = require("project_nvim.utils.history")
local path = require("project_nvim.utils.path")
local config = require("project_nvim.config")
local root = require("project_nvim.root")

local M = {}

-- Internal states
M.attached_lsp = false
M.last_project = nil

---@diagnostic disable-next-line: unused-local
local on_attach_lsp = function(client, bufnr)
  M.on_buf_enter() -- Recalculate root dir after lsp attaches
end

local attach_to_lsp = function()
  if M.attached_lsp then
    return
  end

  local _start_client = vim.lsp.start_client
  vim.lsp.start_client = function(lsp_config)
    if lsp_config.on_attach == nil then
      lsp_config.on_attach = on_attach_lsp
    else
      local _on_attach = lsp_config.on_attach
      lsp_config.on_attach = function(client, bufnr)
        on_attach_lsp(client, bufnr)
        _on_attach(client, bufnr)
      end
    end
    return _start_client(lsp_config)
  end

  M.attached_lsp = true
end

local function is_file()
  local buf_type = vim.api.nvim_buf_get_option(0, "buftype")

  local whitelisted_buf_type = { "", "acwrite" }
  local is_in_whitelist = false
  for _, wtype in ipairs(whitelisted_buf_type) do
    if buf_type == wtype then
      is_in_whitelist = true
      break
    end
  end
  if not is_in_whitelist then
    return false
  end

  return true
end

local set_user_option = function(dir, method)
  local opt = vim.import("utils.options")
  if type(opt) == "table" then
    local bufnr = vim.api.nvim_get_current_buf()
    local project_path = string.gsub(dir, os.getenv("HOME"), "~")
    local project_name = ""
    if project_path ~= nil and project_path ~= "" then
      project_path, project_name = string.match(project_path, "(.*)%/(.*)")
      last_buffer = vim.fn.bufnr()
    end
    opt.set_local("projectmethod", method, bufnr)
    opt.set_local("projectpath", project_path, bufnr)
    opt.set_local("projectname", project_name, bufnr)
  end
end

local set_cwd = function(dir, method)
  vim.api.nvim_set_current_dir(dir)
  if config.options.silent_chdir == false then
    if type(config.options.chdir_func) == "function" then
      config.options.chdir_func(dir, method)
    else
      vim.notify("CWD:" .. dir .. " (" .. method .. ") ", "debug")
    end
  end
end

M.set_pwd = function(dir, method)
  if dir ~= nil then
    M.last_project = dir
    history.add_session(dir)
    set_user_option(dir, method)
    if vim.fn.getcwd() ~= dir then
      set_cwd(dir, method)
    end
    return true
  end
  return false
end

function M.on_buf_enter()
  if vim.v.vim_did_enter == 0 then
    return
  end
  if not is_file() then
    return
  end

  local current_dir = vim.fn.expand("%:p:h", true)
  if path.is_excluded(current_dir) then
    return
  end

  local root_path, method = root.get_project_root()
  M.set_pwd(root_path, method)
end

local function setup_user_commands()
  local cmd = vim.api.nvim_create_user_command
  -- cmd("ProjectAdd", add_project_manually, { desc = "Add project root manually" })
  -- cmd("ProjectGetRoot", notify.show_root, { desc = "Get project root" })
  cmd("ProjectWrite", history.write_projects_to_history, { desc = "Write session data to history file" })
  cmd("ProjectDbg", function()
    vim.dbg(require("project_nvim.state"))
  end, { desc = "Dump debugging data" })
end

local function setup_au_commands()
  vim.api.nvim_create_augroup("project_nvim", { clear = true })
  if not config.options.manual_mode then
    vim.api.nvim_create_autocmd({ "BufEnter" }, {
      pattern = "*",
      callback = M.on_buf_enter,
      desc = "Check new buffer paths to identify project changes",
      group = "project_nvim",
      nested = true,
    })
    if vim.tbl_contains(config.options.detection_methods, "lsp") then
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

function M.init()
  -- local autocmds = {}
  -- if not config.options.manual_mode then
  --   autocmds[#autocmds + 1] = 'autocmd VimEnter,BufEnter * ++nested lua require("project_nvim.project").on_buf_enter()'
  --   if vim.tbl_contains(config.options.detection_methods, "lsp") then
  --     attach_to_lsp()
  --   end
  -- end

  setup_au_commands()
  setup_user_commands()
  -- vim.cmd([[
  --   command! ProjectRoot lua require("project_nvim.project").on_buf_enter()
  --   command! ProjectWrite lua require("project_nvim.utils.history").write_projects_to_history()
  --   command! ProjectDbg lua vim.dbg({ recent = require('project_nvim.utils.history').recent_projects, session = require('project_nvim.utils.history').session_projects, meta = require('project_nvim.utils.history').projects_meta })
  -- ]])

  -- autocmds[#autocmds + 1] =
  --   'autocmd VimLeavePre * lua require("project_nvim.utils.history").write_projects_to_history()'
  --
  -- vim.cmd([[
  --   augroup project_nvim
  --   au!
  -- ]])
  -- for _, value in ipairs(autocmds) do
  --   vim.cmd(value)
  -- end
  -- vim.cmd("augroup END")

  history.read_projects_from_history()
end

M.get_project_root = root.get_project_root

return M
