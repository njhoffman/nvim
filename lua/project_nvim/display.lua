local devicons = require('nvim-web-devicons')
local get_by_ft = devicons.get_icon_by_filetype

local get_by_ext = function(ext)
  return devicons.get_icon('', ext)
end

local get_icon = function(method, lsp)

  -- stylua: ignore
  local icon_map =     {
    ["null-ls"] =      { get_by_ft("conf") },
    awk_ls =           { get_by_ft("awk") },
    bashls =           { get_by_ft("sh") },
    clangd =           { get_by_ft("c") },
    cssls =            { get_by_ft("css") },
    dockerls =         { get_by_ft("dockerfile") },
    efm =              { get_by_ft("conf") },
    eslint =           { get_by_ft("javascript") },
    golangci_lint_ls = { get_by_ft("go") },
    gopls =            { get_by_ft("go") },
    graphql =          { get_by_ft("graphql") },
    html =             { get_by_ft("html") },
    jsonls =           { get_by_ft("json") },
    lua_ls =           { get_by_ft("lua") },
    pyright =          { get_by_ft("python") },
    pylsp =            { get_by_ft("python") },
    sqls =             { get_by_ft("sql") },
    stylelint_lsp =    { get_by_ft("scss") },
    tailwindcss =      { get_by_ft("less") },
    terraformls =      { get_by_ext("tf") },
    tsserver =         { get_by_ft("javascript") },
    vimls =            { get_by_ft("vim") },
  }

  local icon = { ' ', 'DevIconDart' }
  if method == '.git' then
    -- icon = get_by_ft('git')
    icon = { ' ', 'GitLogo' }
  elseif type(lsp) == 'string' and lsp ~= '' then
    if type(icon_map) == 'table' and type(icon_map[lsp]) == 'table' and type(icon_map[lsp][1]) == 'string' then
      icon = icon_map[lsp]
    else
      vim.notify('no matching icon found: ' .. lsp, 4)
    end
  end
  return icon[1], icon[2]
end

return { get_icon = get_icon }
