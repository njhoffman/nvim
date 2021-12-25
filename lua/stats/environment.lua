local M = {}

M.get_counts = function()
  local counts = {
    filetype = vim.api.nvim_eval('&filetype'),
    changes = 0,
    commands = 0,
    functions = 0,
    highlights = 0,
    history_commands = 0,
    menus = 0,
    messages = 0,
    scriptnames = 0,
    options = 0,
    syntax_items = 0,
    variables = 0,
    packer_lines = 0,
    plugins_size = 0
  }

  counts.packer_lines = table.remove(vim.fn.systemlist('wc -l ' .. vim.fn.stdpath('config') .. '/lua/packer_compiled.lua | tail -n1 | cut -f1 -d" "'), 1)
  counts.plugins_size  = table.remove(vim.fn.systemlist('du -shc * ' .. vim.fn.stdpath('data') .. '/site/pack/packer/start | tail -n1 | cut -f1'), 1)
  counts.start_time = table.remove(vim.fn.systemlist('cat /tmp/nvim-startuptime | tail -n1'), 1)
  local pid = vim.fn.getpid()
  counts.memory = table.remove(vim.fn.systemlist('ps h -p ' .. pid .. ' -o rss'), 1)
  counts.virtual_memory = table.remove(vim.fn.systemlist('ps h -p ' .. pid .. ' -o vsz'), 1)

  -- local lazy_plugins_size  = vim.fn.systemlist('du -shc * ' .. vim.fn.stdpath('data') .. '/site/pack/packer/opt | tail -n1')

  vim.cmd[[
    let temp_reg = @" | redir @" | silent! execute ":command" | redir END
    let output = copy(@") | let @" = temp_reg | let w:output_len=len(split(output, "\n"))
  ]]
  counts.commands=vim.api.nvim_eval('w:output_len')

  vim.cmd[[
    let temp_reg = @" | redir @" | silent! execute ":changes" | redir END
    let output = copy(@") | let @" = temp_reg | let w:output_len=len(split(output, "\n"))
  ]]
  counts.changes=vim.api.nvim_eval('w:output_len')

  vim.cmd[[
    let temp_reg = @" | redir @" | silent! execute ":function" | redir END
    let output = copy(@") | let @" = temp_reg | let w:output_len=len(split(output, "\n"))
  ]]
  counts.functions=vim.api.nvim_eval('w:output_len')

  vim.cmd[[
    let temp_reg = @" | redir @" | silent! execute ":highlight" | redir END
    let output = copy(@") | let @" = temp_reg | let w:output_len=len(split(output, "\n"))
  ]]
  counts.highlights=vim.api.nvim_eval('w:output_len')

  vim.cmd[[
    let temp_reg = @" | redir @" | silent! execute ":history" | redir END
    let output = copy(@") | let @" = temp_reg | let w:output_len=len(split(output, "\n"))
  ]]
  counts.history_commands=vim.api.nvim_eval('w:output_len')

  vim.cmd[[
    let temp_reg = @" | redir @" | silent! execute ":menu" | redir END
    let output = copy(@") | let @" = temp_reg | let w:output_len=len(split(output, "\n"))
  ]]
  counts.menus=vim.api.nvim_eval('w:output_len')

  vim.cmd[[
    let temp_reg = @" | redir @" | silent! execute ":message" | redir END
    let output = copy(@") | let @" = temp_reg | let w:output_len=len(split(output, "\n"))
  ]]
  counts.messages=vim.api.nvim_eval('w:output_len')

  vim.cmd[[
    let temp_reg = @" | redir @" | silent! execute ":scriptnames" | redir END
    let output = copy(@") | let @" = temp_reg | let w:output_len=len(split(output, "\n"))
  ]]
  counts.scriptnames=vim.api.nvim_eval('w:output_len')

  vim.cmd[[
    let temp_reg = @" | redir @" | silent! execute ":set" | redir END
    let output = copy(@") | let @" = temp_reg | let w:output_len=len(split(output, "\n"))
  ]]
  counts.options=vim.api.nvim_eval('w:output_len')


  vim.cmd[[
    let temp_reg = @" | redir @" | silent! execute ":let" | redir END
    let output = copy(@") | let @" = temp_reg | let w:output_len=len(split(output, "\n"))
  ]]
  counts.variables=vim.api.nvim_eval('w:output_len')

  vim.cmd[[
    let temp_reg = @" | redir @" | silent! execute ":syntax" | redir END
    let output = copy(@") | let @" = temp_reg | let w:output_len=len(split(output, "\n"))
  ]]
  counts.syntax_items=vim.api.nvim_eval('w:output_len')
  return counts
end

M.get_counts()

return M
