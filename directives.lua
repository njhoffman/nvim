-- reference for comment formatting/diagnostic directives

local d = {
  tl_ls = {
    line = [[// @ts-ignore: ignore next line]],
    file = [[// @ts-nocheck: ignore this file]],
  },
  eslint = { -- .eslintrc, .eslintrc.json, .eslintrc.js
    line = [[// eslint-disable-next-line max-len ]],
    file = [[// eslint-disable-file ]],
  },
  lua_language_server = { -- .luarc.json
    workspace = [[{ "diagnostics.disable": [ "unused-local" ] } ]],
    file = [[---@diagnostic disable: unused-function, unused-local ]],
    line = [[---@diagnostic disable-next-line: unused-local ]],
  },
  luacheck = { -- .luacheckrc
    workspace = [[ globals = { "vim" }, ignore = { "631" } ]],
    file = [[-- luacheck: ignore ]],
  },
  editorconfig_checker = { -- .editorconfig
    file = [[ -- editorconfig-checker-disable-file ]],
    line = [[ ... -- editorconfig-checker-disable-line ]],
    workspace = [[
      [{*.lua,*.tl,}]
      indent_size              = 2 ]],
    block = [[
    -- editorconfig-checker-disable
    -- ...
    -- editorconfig-checker-enable ]],
  },
}

local f = {
  -- .lua-format
  -- .shellcheckrc
  stylua = { -- .stylua
    file = [[ -- stylua: ignore ]],
    block = [[
    -- stylua: ignore start
    -- ...
    -- stylua: ignore end ]],
  },
}

local filetypes = {
  lua = { { d.editorconfig_checker, d.lua_language_server }, { f.stylua } },
  sh = { { d.shellcheck }, { f.shell_format } },
}

local ft_lookup = function() end

return { diagnostics = d, formatters = f, filetypes = filetypes }
