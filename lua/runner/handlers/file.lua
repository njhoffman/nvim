local run_file_handler = function(ev)
  local handlers = {
    lua = function(f)
      vim.cmdd('luafile %')
    end,
    vim = function()
      vim.cmd('source %')
    end,
    javascript = function() end,
  }
end

return run_file_handler
