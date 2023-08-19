require('neo-zoom').setup({
  callback = function()
    vim.dbglog('MY CALLBACK')
  end,
  popup = {
    enabled = true,
    exclude_filetypes = {},
    exclude_buftypes = {},
  },
  exclude_buftypes = { 'terminal' },
  exclude_filetypes = { 'lspinfo', 'mason', 'lazy', 'fzf', 'qf', 'noice' },
  winopts = {
    offset = {
      -- top = 0,
      -- left = 0.17,
      width = 0.90,
      height = 0.90,
    },
    border = 'rounded',
  },
  presets = {
    -- {
    --   filetypes = { '*' },
    --   callback = function()
    --     vim.dbglog('DOING PRESETS')
    --     vim.api.nvim_win_set_option(0, 'number', false)
    --     vim.api.nvim_win_set_option(0, 'relativenumber', false)
    --     vim.api.nvim_win_set_option(0, 'signcolumn', 'no')
    --   end,
    -- },
    {
      filetypes = { 'dapui_.*', 'dap-repl' },
      winopts = {
        offset = { top = 0.02, left = 0.26, width = 0.74, height = 0.25 },
      },
    },
    {
      filetypes = { 'markdown' },
      callbacks = {
        function()
          vim.wo.wrap = true
        end,
      },
    },
  },
})

-- vim.keymap.set('n', '<CR>', function()
--   vim.cmd('NeoZoomToggle')
-- end, { silent = true, nowait = true })

-- vim.api.nvim_create_autocmd({ 'WinEnter' }, {
--   callback = function(ev)
--     local zoom_book = require('neo-zoom').zoom_book
--     -- local winid = vim.api.nvim_get_current_win()
--     -- vim.api.nvim_buf_set_option(ev.buf, 'buftype', 'neozoom')
--     -- local bufnr = vim.api.nvim_win_get_buf(winid)
--     -- vim.api.nvim_buf_set_option(bufnr, 'buftype', 'neozoom')
--     -- vim.api.nvim_win_set_option(winid, 'indentline', false)
--     -- vim.api.nvim_win_set_option(0, 'winhighlight', 'Normal:PmenuSel,NormalNC:PmenuSbar')
--     -- vim.api.nvim_buf_set_option(bufnr, 'filetype', 'neozoom')
--
--     if require('neo-zoom').is_neo_zoom_float() then
--       for z, _ in pairs(zoom_book) do
--         vim.wo[z].winbl = 0
--       end
--     else
--       -- local win_ns = vim.api.nvim_create_namespace('neozoom')
--       for z, _ in pairs(zoom_book) do
--         -- vim.api.nvim_win_set_hl_ns(z, win_ns)
--         -- vim.api.nvim_set_hl(win_ns, 'Normal', { bg = '#101826' })
--         -- vim.api.nvim_win_set_option(z, 'winhl', 'Normal:Float')
--         vim.wo[z].winbl = 20
--       end
--     end
-- end,
-- })
