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

-- function M.quicklog(opts)
-- 	if not (opts) then opts = {addLineNumber = false} end
--
-- 	local varname = wordUnderCursor()
-- 	local logStatement
-- 	local ft = bo.filetype
-- 	local lnStr = ""
-- 	if opts.addLineNumber then
-- 		lnStr = "L" .. tostring(lineNo(".")) .. " "
-- 	end
--
-- 	if ft == "lua" then
-- 		logStatement = 'print("' .. lnStr .. varname .. ':", ' .. varname .. ")"
-- 	elseif ft == "python" then
-- 		logStatement = 'print("' .. lnStr .. varname .. ': " + ' .. varname .. ")"
-- 	elseif ft == "javascript" or ft == "typescript" then
-- 		logStatement = 'console.log("' .. lnStr .. varname .. ': " + ' .. varname .. ");"
-- 	elseif ft == "zsh" or ft == "bash" or ft == "fish" or ft == "sh" then
-- 		logStatement = 'echo "' .. lnStr .. varname .. ": $" .. varname .. '"'
-- 	elseif ft == "applescript" then
-- 		logStatement = 'log "' .. lnStr .. varname .. ': " & ' .. varname
-- 	else
-- 		vim.notify("Quicklog does not support " .. ft .. " yet.", logWarn)
-- 		return
-- 	end
--
-- 	append(".", logStatement)
-- 	cmd [[normal! j==]] -- move down and indent
-- end

return { get_paths = get_paths }
