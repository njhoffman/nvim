local M = {}


-- vim.api.nvim_get_var, mark, mode, proc, vvar, keymap, option, context, commands, hl_by_id, chan_info, color_map, hl_by_name, namespaces, current_buf, current_win, option_info, current_line, runtime_file, color_by_name, hl_id_by_name, proc_children, current_tabpage, all_options_info
-- vim.api.nvim__get_hl_defs, lib_dir, runtime
-- vim.api.nvim_buf_get_var, buf, mark, name, lines, keymap, number, offset, option, commands, extmarks, changedtick, extmark_by_id
-- vim.api.nvim_win_get_buf, var, width, config, cursor, height, number, option, tabpage, position,
-- vim.api.nvim_tabpage_get_var, win, number
-- local cmd_output = vim.fn.execute("verb autocmd *", "silent")
-- local locations = vim.fn.getqflist()


-- local lazy_plugins_size  = vim.fn.systemlist('du -shc * ' .. vim.fn.stdpath('data') .. '/site/pack/packer/opt | tail -n1')

M.get_packer_lines = function()
  return table.remove(vim.fn.systemlist('wc -l ' .. vim.fn.stdpath('config') .. '/lua/packer_compiled.lua | tail -n1 | cut -f1 -d" "'), 1)
end
M.get_plugins_size = function()
  return table.remove(vim.fn.systemlist('du -shc * ' .. vim.fn.stdpath('data') .. '/site/pack/packer/start | tail -n1 | cut -f1'), 1)
end

M.get_startup_time = function()
  return table.remove(vim.fn.systemlist('cat /tmp/nvim-startuptime | tail -n1'), 1)
end

M.get_memory_rss = function()
  local pid = vim.fn.getpid()
  return table.remove(vim.fn.systemlist('ps h -p ' .. pid .. ' -o rss'), 1)
end

M.get_memory_vsz = function()
  local pid = vim.fn.getpid()
  return table.remove(vim.fn.systemlist('ps h -p ' .. pid .. ' -o vsz'), 1)
end

M.get_commands = function()
  vim.cmd[[
    let temp_reg = @" | redir @" | silent! execute ":command" | redir END
    let output = copy(@") | let @" = temp_reg | let w:output_len=len(split(output, "\n"))
  ]]
  return vim.api.nvim_eval('w:output_len')
end

M.get_changes = function()
  vim.cmd[[
    let temp_reg = @" | redir @" | silent! execute ":changes" | redir END
    let output = copy(@") | let @" = temp_reg | let w:output_len=len(split(output, "\n"))
  ]]
  return vim.api.nvim_eval('w:output_len')
end

M.get_functions = function()
  vim.cmd[[
    let temp_reg = @" | redir @" | silent! execute ":function" | redir END
    let output = copy(@") | let @" = temp_reg | let w:output_len=len(split(output, "\n"))
  ]]
  return vim.api.nvim_eval('w:output_len')
end

M.get_highlights = function()
  vim.cmd[[
    let temp_reg = @" | redir @" | silent! execute ":highlight" | redir END
    let output = copy(@") | let @" = temp_reg | let w:output_len=len(split(output, "\n"))
  ]]
  return vim.api.nvim_eval('w:output_len')
end

M.get_history_commands = function()
  vim.cmd[[
    let temp_reg = @" | redir @" | silent! execute ":history" | redir END
    let output = copy(@") | let @" = temp_reg | let w:output_len=len(split(output, "\n"))
  ]]
  return vim.api.nvim_eval('w:output_len')
end


M.get_menus = function()
  vim.cmd[[
    let temp_reg = @" | redir @" | silent! execute ":menu" | redir END
    let output = copy(@") | let @" = temp_reg | let w:output_len=len(split(output, "\n"))
  ]]
  return vim.api.nvim_eval('w:output_len')
end

M.get_messages = function()
  vim.cmd[[
    let temp_reg = @" | redir @" | silent! execute ":message" | redir END
    let output = copy(@") | let @" = temp_reg | let w:output_len=len(split(output, "\n"))
  ]]
  return vim.api.nvim_eval('w:output_len')
end

M.get_scriptnames = function()
  vim.cmd[[
    let temp_reg = @" | redir @" | silent! execute ":scriptnames" | redir END
    let output = copy(@") | let @" = temp_reg | let w:output_len=len(split(output, "\n"))
  ]]
  return vim.api.nvim_eval('w:output_len')
end

M.get_options = function()
  vim.cmd[[
    let temp_reg = @" | redir @" | silent! execute ":set" | redir END
    let output = copy(@") | let @" = temp_reg | let w:output_len=len(split(output, "\n"))
  ]]
  return vim.api.nvim_eval('w:output_len')
end

M.get_variables = function()
  vim.cmd[[
    let temp_reg = @" | redir @" | silent! execute ":let" | redir END
    let output = copy(@") | let @" = temp_reg | let w:output_len=len(split(output, "\n"))
  ]]
  return vim.api.nvim_eval('w:output_len')
end

M.get_syntax_items = function()
  vim.cmd[[
    let temp_reg = @" | redir @" | silent! execute ":syntax" | redir END
    let output = copy(@") | let @" = temp_reg | let w:output_len=len(split(output, "\n"))
  ]]
  return vim.api.nvim_eval('w:output_len')
end

M.get_aucommands = function()
  return "666"
end

M.get_augroups = function()
  return "69"
end

return M
