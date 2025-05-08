local init = function()
  vim.g.firenvim_config = {
    globalSettings = {
      -- alt = "all",
      -- ['<C-w>'] = 'noop',
      -- ['<C-n>'] = 'default'
      ignoreKeys = {
        all = { "<C-->" },
        normal = { "<C-1>", "<C-2>" },
      },
    },
    localSettings = {
      [".*"] = {
        -- cmdline = "neovim",
        content = "text", -- text, html
        priority = 0,
        -- selector = 'textarea:not([readonly], [aria-readonly]), div[role="textbox"]',
        takeover = "never",
        -- `always`, `empty`, `never`, `nonempty` or `once`.
      },
    },
  }
end
return init
-- vim.api.nvim_create_autocmd({ "UIEnter" }, {
--   callback = function(event)
--     local client = vim.api.nvim_get_chan_info(vim.v.event.chan).client
--     if client ~= nil and client.name == "Firenvim" then
--       vim.o.laststatus = 0
--     end
--   end,
-- })

-- ### Interacting with the page
-- You can execute javascript in the page by using `firenvim#eval_js`. The code has to be a valid javascript expression (NOT a statement). You can provide the name of a function that should be executed with the result of the expression. Note that some pages prevent evaluating JavaScript with their [CSP](https://developer.mozilla.org/en-US/docs/Web/HTTP/CSP) and this can't be worked around. Here's an example:
-- vim.fn['firenvim#eval_js']('alert("Hello World!")', 'MyFunction')
-- A function named `firenvim#press_keys()` will allow you to send key events to the underlying input field by taking a list of vim-like keys (e.g. `a`, `<CR>`, `<Space>`…) as argument. Note that this only "triggers" an event, it does not add text to the input field. For example if you'd like firenvim to send `<CR>` to the webpage when you press `<CR>` in the editor, you can use the following mapping which is useful with chat apps:
-- vim.api.nvim_create_autocmd({'BufEnter', {
--     pattern = "riot.im_*",
--     command = [[inoremap <CR> <Esc>:w<CR>:call firenvim#press_keys("<LT>CR>")<CR>ggdGa]],
-- })
-- Depending on how large the edited buffer is, this could be a little slow. This more sophisticated approach will throttle writes:
-- vim.api.nvim_create_autocmd({'TextChanged', 'TextChangedI'}, {
--     callback = function(e)
--       if vim.g.timer_started == true then
--         return
--       end
--       vim.g.timer_started = true
--       vim.fn.timer_start(10000, function()
--         vim.g.timer_started = false
--         vim.cmd('silent write')
--       end)
--     end
--   })
