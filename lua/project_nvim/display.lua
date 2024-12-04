local get_icon = function(method, lsp)
  -- local devicons = require("nvim-web-devicons")
  local MiniIcons = require("mini.icons")

  local get_by_ft = function(ft)
    return MiniIcons.get("filetype", ft) -- Has `'M'` as icon
    -- devicons.get_icon_by_filetype
  end

  local get_by_ext = function(ext)
    return MiniIcons.get("extension", ext) -- Has `'M'` as icon
    -- return devicons.get_icon("", ext)
  end


  -- stylua: ignore
  local icon_map =     {
    ["null-ls"] =            { get_by_ft("conf") },
    awk_ls =                 { get_by_ft("awk") },
    bashls =                 { get_by_ft("sh") },
    clangd =                 { get_by_ft("c") },
    copilot =                 {''},
    cssls =                  { get_by_ft("css") },
    dockerls =               { get_by_ft("dockerfile") },
    efm =                    { get_by_ft("conf") },
    eslint =                 { get_by_ft("js") },
    golangci_lint_ls =       { get_by_ft("go") },
    gopls =                  { get_by_ft("go") },
    gradle_language_server = { get_by_ft("kotlin") },
    graphql =                { get_by_ft("graphql") },
    html =                   { get_by_ft("html") },
    jdtls =                  { get_by_ft("java") },
    jqls =                   { get_by_ft("jq") },
    jsonls =                 { get_by_ft("json") },
    kotlin_language_server = { get_by_ft('kotlin')},
    ltex =                   { get_by_ft("markdown") },
    lua_ls =                 { get_by_ft("lua") },
    marksman  =              { get_by_ft("markdown") },
    pyright =                { get_by_ft("py") },
    pylsp =                  { get_by_ft("py") },
    sqls =                   { get_by_ft("sql") },
    stylelint_lsp =          { get_by_ft("scss") },
    tailwindcss =            { get_by_ft("less") },
    tsserver =               { get_by_ft("js") },
    ts_ls =                  { get_by_ft("js") },
    vimls =                  { get_by_ft("vim") },
    yamlls =                 { get_by_ft("yaml") },
  }

  local icon = { " ", "DevIconDart" }
  if method == ".git" then
    -- icon = get_by_ft('git')
    icon = { " ", "GitLogo" }
  elseif type(lsp) == "string" and lsp ~= "" then
    if
      type(icon_map) == "table"
      and type(icon_map[lsp]) == "table"
      and type(icon_map[lsp][1]) == "string"
    then
      icon = icon_map[lsp]
    else
      vim.dbglog(icon_map, lsp)
      vim.notify("no matching icon found: " .. lsp, 4)
    end
  end
  return icon[1], icon[2]
end

return { get_icon = get_icon }
