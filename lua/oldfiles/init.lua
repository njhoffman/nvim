local logger = require('logger').init('mru')

-- | if &bufhidden =~ 'wipe' && &buftype =~ 'nofile' && &buftype =~ hidden | silent! wshada | silent! !~/bin/wshada.sh | endif",
-- local shadaEventsViml = { { "BufWrite", "*", [[call ShadaWrite()]] }, { "Signal", "SIGUSR1", [[call ShadaRead()]] } }

local config = {
  shada_events = { 'BufRead' },
}

vim.api.nvim_create_autocmd(config.shada_events, {
  group = vim.api.nvim_create_augroup('ShaDaEvents', { clear = true }),
  callback = function(args)
    local old_count = #vim.v.oldfiles
    vim.cmd('silent! wshada')
    os.execute('touch -a ' .. args.file)
    vim.cmd('silent! rshada!')
    logger:trace(args.event .. ' ' .. old_count .. ' -> ' .. #vim.v.oldfiles .. ' ' .. args.file)
  end,
})
