local setup = function()
  local lab_command = function(opts)
    if opts.args == 'run' then
      require('lab.code_runner').run()
    end
    if opts.args == 'stop' then
      require('lab.code_runner').stop()
    end
    if opts.args == 'panel' then
      require('lab.code_runner').panel()
    end
    if opts.args == 'config' then
      require('lab.code_runner').config()
    end
  end

  vim.api.nvim_create_user_command('Lab', lab_command, {
    nargs = '*',
  })
end

return { setup = setup }
