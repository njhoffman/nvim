require('globals.impatient')
require('globals.importer')
vim.import('globals.variables')
vim.import("user-options")
vim.import("vim-options")

vim.import('inspect', function(inspect)
  vim.inspect = inspect
  vim.import('debuglog', function(debuglog)
    vim.dbg     = debuglog.dbg
    vim.dbglog  = debuglog.log
    vim.dbgbuf  = debuglog.buf
    vim.dbgtime = debuglog.timer
    vim.import('logger', function(logger)
      vim.logger = logger.init("root")
      vim.notify = logger.notify
      vim.notify(string.format("Initializing neovim at %s ... ", os.date("%H:%M:%S")), "trace")
    end)
  end)
end)
