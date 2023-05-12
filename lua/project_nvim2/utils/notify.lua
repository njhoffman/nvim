local get_icon = function(method, lsp)
  -- stylua: ignore
  local icon_map = {
    awk_ls           = " ", --  
    bashls           = " ",
    clangd           = " ",
    cssls            = " ",
    dockerls         = " ",
    efm              = " ",
    eslint           = " ",
    golangci_lint_ls = " ",
    gopls            = "󰟓 ", -- 
    graphql          = " ",
    html             = " ",
    ["null-ls"]      = " ",
    jsonls           = " ",
    pylsp            = " ",
    sqls             = " ",
    lua_ls           = " ", --  
    stylelint_lsp    = "󰌜 ",
    tailwindcss      = " ",
    terraformls      = " ",
    tsserver         = " ", -- 
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
      vim.notify("no matching icon found: " .. lsp, 4)
    end
  end
  return icon
end

local show_root = function()
  local path, props = require("project_nvim").get_root()
  props = props or {}

  local title = props.method
  if vim.fn.empty(props.match) == 0 then
    title = title .. " [" .. props.match .. "]"
  end
  vim.notify(path, 2, { title = title, anchor = "TC" })
end

local cwd_change = function(dir, props)
  props = props or {}
  dir = dir:gsub(vim.fn.getenv("HOME"), "~")
  local icon = get_icon(props.method, props.method_type)
  local msg = " " .. icon .. " " .. dir
  vim.notify(msg, 2, {})
  -- replace = id, on_close = function() id = nil end,
end

return { cwd_change = cwd_change, show_root = show_root }
