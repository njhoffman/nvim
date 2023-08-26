-- reference for comment formatting/diagnostic directives

local d = {
  lua_language_server = {
    -- .luarc.json
    workspace = [[{ "diagnostics.disable": [ "unused-local" ] } ]],
    file = [[---@diagnostic disable: unused-function, unused-local ]],
    line = [[---@diagnostic disable-next-line: unused-local ]],
  },
  luacheck = {
    -- .luacheckrc
    workspace = [[ globals = { "vim" }, ignore = { "631" } ]],
    file = [[-- luacheck: ignore ]],
  },
  editorconfig_checker = {
    -- .editorconfig
    workspace = [[
      [{*.lua,*.tl,}]
      indent_size              = 2 ]],
    file = [[ -- editorconfig-checker-disable-file ]],
    block = [[
    -- editorconfig-checker-disable
    -- ...
    -- editorconfig-checker-enable ]],
    line = [[ ... -- editorconfig-checker-disable-line ]],
  },
}

local f = {
  -- .lua-format
  -- .shellcheckrc
  -- .stylua
  stylua = {
    block = [[
    -- stylua: ignore start
    -- ...
    -- stylua: ignore end
    file = [[ -- stylua: ignore ]],
  },
}

local filetypes = {
  lua = { { d.editorconfig_checker, d.lua_language_server }, { f.stylua } },
  sh = { { d.shellcheck }, { f.shell_format } },
}

local ft_lookup = function() end

return { diagnostics = d, formatters = f, filetypes = filetypes }
