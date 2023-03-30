local history = require("project_nvim.utils.history")
local notify = require("project_nvim.utils.notify")
local path = require("project_nvim.utils.path")
local root = require("project_nvim.root")
local state = require("project_nvim.state")

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

local set_user_options = function(dir, props)
  local opt = require("utils.options")
  if type(opt) == "table" then
    local bufnr = vim.api.nvim_get_current_buf()
    local project_path = string.gsub(dir, os.getenv("HOME") or "", "~")
    local project_name = ""
    if project_path ~= nil and project_path ~= "" then
      project_path, project_name = string.match(project_path, "(.*)%/(.*)")
      -- last_buffer = vim.fn.bufnr()
    end
    opt.set_local("projectpath", project_path, bufnr)
    opt.set_local("projectname", project_name, bufnr)

    if vim.fn.empty(props) == 0 and vim.fn.empty(props.method) == 0 then
      local method = props.method .. " "
      if vim.fn.empty(props.method_type) == 0 then
        method = method .. " (" .. props.method_type .. ")"
      end
      opt.set_local("projectmethod", method, bufnr)
    end
  end
end

local function set_pwd(dir, props)
  if dir ~= nil then
    state.last_project = dir
    history.add_session(dir)
    history.update_meta(dir, props)
    if vim.fn.getcwd() ~= dir then
      set_user_options(dir, props)
      vim.api.nvim_set_current_dir(dir)
      notify.cwd_change(dir, props)
    end
  end
end

local function on_buf_enter()
  if vim.v.vim_did_enter == 0 or not is_file() then
    return
  end

  if path.is_excluded(vim.fn.expand("%:p:h", true)) then
    return
  end

  local root_path, props = root.get_project_root()
  set_pwd(root_path, props or {})
end

local attach_to_lsp = function()
  if state.attached_lsp then
    return
  end

  local on_attach_lsp = function()
    -- Recalculate root dir after lsp attaches
    on_buf_enter()
  end

  local _start_client = loadstring(string.dump(vim.lsp.start_client))
  vim.lsp.start_client = function(lsp_config)
    if lsp_config.on_attach == nil then
      lsp_config.on_attach = on_attach_lsp
    else
      local _on_attach = lsp_config.on_attach
      lsp_config.on_attach = function(client, bufnr)
        on_attach_lsp()
        _on_attach(client, bufnr)
      end
    end
    if type(_start_client) ~= nil then
      return _start_client(lsp_config)
    end
  end
  state.attached_lsp = true
end

return {
  attach_to_lsp = attach_to_lsp,
  on_buf_enter = on_buf_enter,
  set_pwd = set_pwd,
}
