local M = {}

local get_icon = function(method, lsp)
  local icon_map = {
    awk_ls           = " ",
    bashls           = " ",
    clangd           = " ",
    cssls            = " ",
    dockerls         = " ",
    efm              = " ",
    golangci_lint_ls = " ",
    gopls            = " ",
    graphql          = " ",
    html             = " ",
    jsonls           = " ",
    pylsp            = " ",
    sqls             = " ",
    sumneko_lua      = " ",
    terraformls      = " ",
    tsserver         = " ",
    vimls            = " ",
    -- "yamlls"
  }

  local icon = " "
  if method == ".git" then
    icon = " "
  elseif type(lsp) == "string" and lsp ~= "" then
    if type(icon_map[lsp]) == "string" then
      icon = icon_map[lsp]
    else
      vim.notify('no matching icon found: ' .. lsp, 'warn')
    end
  end
  return icon
end

M.change_project = function(dir, method)
  local lsp = string.match(method, '"([^%s]+)" lsp')
  dir = dir:gsub(vim.fn.getenv("HOME"), "~")
  local icon = get_icon(method, lsp)
  local msg = icon .. " "
  msg = msg .. dir
  -- msg = msg .. lsp .. " " .. dir
  vim.notify(msg, "trace")
end

M.project_config = {
  -- Manual mode doesn't automatically change your root directory, so you have
  -- the option to manually do so using `:ProjectRoot` command.
  manual_mode = false,
  -- Methods of detecting the root directory. **"lsp"** uses the native neovim
  -- lsp, while **"pattern"** uses vim-rooter like glob pattern matching. Here
  -- order matters: if one is not detected, the other is used as fallback. You
  -- can also delete or rearangne the detection methods.
  detection_methods = { "lsp", "pattern" },
  -- All the patterns used to detect root dir, when **"pattern"** is in
  -- detection_methods
  patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json" },
  -- Table of lsp clients to ignore by name
  -- eg: { "efm", ... }
  ignore_lsp = {},
  -- Don't calculate root dir on specific directories
  -- Ex: { "~/.cargo/*", ... }
  exclude_dirs = {},
  -- Show hidden files in telescope
  show_hidden = true,
  -- When set to false, you will get a message when project.nvim changes your
  -- directory.
  silent_chdir = false,
  -- Path where project.nvim will store the project history for use in
  -- telescope
  datapath = vim.fn.stdpath("data"),
  chdir_func = M.change_project
}

return M
