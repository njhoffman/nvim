-- Error executing Lua callback: vim/_editor.lua:0: nvim_exec2()..function <SNR>195_bdelete, line 48: Vim(bdelete):E315: ml_get: Invalid lnum: 1
-- stack traceback:
--   [C]: in function 'nvim_exec2'
--   vim/_editor.lua: in function 'cmd'
--   /home/nicholas/.config/nvim/lua/commands/ui.lua:119: in function </home/nicholas/.config/nvim/lua/commands/ui.lua:96>
vim.diagnostic.handlers['my/notify'] = {
  show = function(namespace, bufnr, diagnostics, opts)
    -- In our example, the opts table has a "log_level" option
    local level = opts['my/notify'].log_level

    local name = vim.diagnostic.get_namespace(namespace).name
    local msg = string.format('%d diagnostics in buffer %d from %s', #diagnostics, bufnr, name)
    vim.notify(msg, level)
  end,
}

-- Users can configure the handler
vim.diagnostic.config({
  ['my/notify'] = {
    log_level = vim.log.levels.INFO,
  },
})
