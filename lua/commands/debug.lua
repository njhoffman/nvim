#!/usr/bin/env lua

local get_runtime_files = function()
  local rtpaths = vim.api.nvim_list_runtime_paths()
  return vim.fn.sort(rtpaths)
end

local get_scriptnames = function()
  vim.cmd([[
    let scriptnames_output = ''
    redir => scriptnames_output
      silent scriptnames
    redir END

    let scripts = {}
    for line in split(scriptnames_output, "\n")
      if line =~ '\S'
      let nr = matchstr(line, '\d\+')
      let name = substitute(line, '.\+:\s*', '', '')
      let scripts[nr] = name
      endif
    endfor
    let w:scriptnames = scriptnames_output
    unlet scriptnames_output
  ]])
  local scriptnames = vim.api.nvim_eval("w:scriptnames")
  return scriptnames
end

local get_paths = function()
  local all_paths = {}
  all_paths.rtpaths = get_runtime_files()
  local opacks = {}
  for match in (vim.o.packpath .. ","):gmatch("(.-)" .. ",") do
    table.insert(opacks, match)
  end
  all_paths.opacks = vim.fn.sort(opacks)
  all_paths.scriptnames = get_scriptnames()

  for key, val in pairs(all_paths) do
    vim.notify(key .. " " .. #val, 3)
  end
  vim.dbglog(vim.dump(all_paths.rtpaths))

  -- vim.ui.select(opacks)
end

return { get_paths = get_paths }
