-- local options = require('utils.options')
local prjutils = require('utils.project')

local M = {}
M.project_chdir = function(dir, method)
  local project = prjutils.change_project(dir, method)
  vim.dbglog({ 'Project ' .. dir, project })

  local lsp = string.match(method, '"([^%s]+)" lsp')
  local icon_map = {
    awk_ls = " ",
    bashls = " ",
    clangd = " ",
    cssls = " ",
    dockerls = " ",
    efm = " ",
    golangci_lint_ls = " ",
    gopls = " ",
    graphql = " ",
    html = " ",
    jsonls = " ",
    pylsp = "  ",
    sqls = " ",
    sumneko_lua = " ",
    terraformls = " ",
    tsserver = " ",
    vimls = " ",
    -- "yamlls"
  }

  local icon = "  "
  dir = dir:gsub(vim.fn.getenv("HOME"), "~")
  local msg = icon .. " " .. dir
  if method == ".git" then
    icon = "  "
    msg = icon .. " " .. method
    vim.dbglog('git project: ' .. msg)

  elseif type(lsp) == "string" and lsp ~= "" then
    if type(icon_map[lsp]) == "string" then
      icon = icon_map[lsp]
    end
    msg = icon .. " " .. dir
    -- msg = icon .. "[" .. lsp .. "] " .. dir
    vim.dbglog('lsp project: ' .. msg)
  end
  vim.notify(msg, "debug")
end


vim.api.nvim_create_user_command(
  "ProjectGetRoot",
  function()
    local root = require("project_nvim.project").get_project_root()
    vim.notify(root, "debug")
  end,
  {
    nargs = 0,
    desc = "Get project root"
  }
)
vim.api.nvim_create_user_command(
  "ProjectGetRecent",
  function()
    local history = require("project_nvim.utils.history")
    vim.notify(history.get_recent_projects(), "inspect")
  end,
  {
    nargs = 0,
    desc = "Get recent projects list"
  }
)

prjutils.chdir_func = M.project_chdir
require("project_nvim").setup(prjutils.project_config)
