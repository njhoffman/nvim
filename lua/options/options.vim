function options#complete(arg_lead, L, P)
  return luaeval("require'options'.list_options('" . a:arg_lead . "')")
endfunction

function options#complete_buf_local(arg_lead, L, P)
  return luaeval("require'options'.list_options('" . a:arg_lead . "', true)")
endfunction

command! -nargs=* -complete=customlist,options#complete Set :lua require'options'.run_set_cmd(<q-args>, nil)
command! -nargs=* -complete=customlist,options#complete_buf_local Setlocal :lua require'options'.run_set_cmd(<q-args>, vim.api.nvim_get_current_buf())
