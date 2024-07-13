local mapper = require('mapper')
local map = mapper.map
vim.cmd([[
  " nnoremap <expr> j v:count ? 'j' : 'gj'
  " nnoremap <expr> k v:count ? 'k' : 'gk'
"    nnoremap <C-y> 3<C-y>
"   nnoremap <C-e> 3<C-e>
  " nnoremap <C-d> 40jzz
  " nnoremap <C-u> 40kzz
  ]])
local events = { 'WinScrolled', 'CursorMoved' }
local scroll_aucmds = function()
  -- when scrolling quickly with relative numbering on
  -- this autocommand turns relative numbering off when we begin to scroll
  local ts_ctx = require('treesitter-context')
  vim.api.nvim_create_autocmd({ 'WinScrolled' }, {
    callback = function(ev)
      if vim.o.relativenumber then
        vim.cmd('set relativenumber norelativenumber')
      end
      if ts_ctx.enabled() then
        ts_ctx.disable()
      end
      -- vim.opt.eventignore:append(events)
    end,
  })

  -- this autocommand turns relative numberin on when we have idled (stopped scrolling)
  vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
    callback = function(ev)
      if not vim.o.relativenumber then
        vim.cmd('set relativenumber relativenumber')
      end

      -- vim.opt.eventignore:remove(events)
      if not ts_ctx.enabled() then
        ts_ctx.enable()
      end
    end,
  })
end

-- scroll_aucmds()

local setup_paging = function()
  local page_down = vim.api.nvim_replace_termcodes('<C-f>', true, true, true)
  local page_up = vim.api.nvim_replace_termcodes('<C-b>', true, true, true)
  local bottom_margin = 5

  local scroll_up = function()
    local winheight = vim.api.nvim_win_get_height(0)
    local cursor = vim.api.nvim_win_get_cursor(0)
    local top_margin = math.max(bottom_margin, winheight - cursor[1] - 1)
    -- vim.cmd('normal! ' .. winheight .. 'k') --  .. page_up)
    vim.cmd('normal! ' .. winheight .. 'k') --  .. page_up)
    -- vim.cmd('normal ' .. page_up)
    -- if cursor[1] - (winheight * 1) < top_margin then
    --   vim.cmd('normal! gg')
    -- else
    -- vim.cmd('normal! ' .. winheight .. 'k') --  .. page_up)
    -- vim.cmd('normal! ' .. winheight .. page_up)
    -- end
  end
  -- map('n', '<C-b>', scroll_up, {
  --   category = 'motion',
  --   desc = ' scroll upwards',
  --   silent = true,
  -- })

  local scroll_down = function()
    local winheight = vim.api.nvim_win_get_height(0)
    local cursor = vim.api.nvim_win_get_cursor(0)
    local last_line = vim.fn.line('$')
    local top_margin = math.max(bottom_margin, winheight - cursor[1] - 1)

    -- vim.cmd('normal! ')
    -- vim.cmd('normal! ' .. winheight .. 'j') --  .. page_up)
    -- if cursor[1] + (winheight * 1) > last_line then
    --   vim.cmd('normal! G')
    -- else
    -- end
  end

  vim.cmd([[
    noremap <silent> <Plug>(SmoothieDownwards) <cmd>call smoothie#downwards()           <CR>
    noremap <silent> <Plug>(SmoothieUpwards)   <cmd>call smoothie#upwards()             <CR>
    noremap <silent> <Plug>(SmoothieForwards)  <cmd>call smoothie#forwards()            <CR>
    noremap <silent> <Plug>(SmoothieBackwards) <cmd>call smoothie#backwards()           <CR>
    noremap <silent> <Plug>(Smoothie_gg)       <cmd>call smoothie#cursor_movement('gg') <CR>
    noremap <silent> <Plug>(Smoothie_G)        <cmd>call smoothie#cursor_movement('G')  <CR>


    " silent! map <C-D>      <Plug>(SmoothieDownwards)
    " silent! map <C-U>      <Plug>(SmoothieUpwards)
    " silent! map <C-F>      <Plug>(SmoothieForwards)
    " silent! map <C-B>      <Plug>(SmoothieBackwards)
    silent! map <C-F>      <Plug>(SmoothieDownwards)<Plug>(SmoothieDownwards)
    silent! map <C-B>      <Plug>(SmoothieUpwards)<Plug>(SmoothieUpwards)
    silent! map <Space>    <Plug>(SmoothieDownwards)<Plug>(SmoothieDownwards)<Plug>(SmoothieDownwards)<Plug>(SmoothieDownwards)
    silent! map <S-Up>     <Plug>(SmoothieBackwards)
    silent! map <PageUp>   <Plug>(SmoothieBackwards)
    silent! map <S-Down>   <Plug>(SmoothieForwards)
    silent! map <PageDown> <Plug>(SmoothieForwards)
    silent! map  G       <Plug>(Smoothie_G)
    silent! map gg       <Plug>(Smoothie_gg)
    " noremap <silent> <Plug>(Smoothie_gg)       <cmd>call smoothie#cursor_movement('gg') <CR>
  "    silent! map <unique> <C-f>      <Plug>(SmoothieDownwards)<Plug>(SmoothieDownwards)
  "    silent! map <unique> <C-b>      <Plug>(SmoothieUpwards)
  "   let g:smoothie_remapped_commands = ['<C-D>', '<C-U>', '<C-F>', '<S-Down>', '<PageDown>', '<C-B>', '<S-Up>', '<PageUp>', 'z+', 'z^', 'zt', 'z<CR>', 'z.', 'zz', 'z-', 'zb']
  "   let g:smoothie_remapped_commands += ['gg', 'G']
  "   " Add mappings to override commands which should be smoothened
  "   for remapped_command in g:smoothie_remapped_commands
  "   for mapping_command in ['nnoremap', 'vnoremap']
  "   execute 'silent! ' . mapping_command . ' <unique> ' . remapped_command . ' <cmd>call smoothie#do("' . substitute(remapped_command, '<', '\\<lt>', '') . '") <CR>'
  "     endfor
  "   endfor
  ]])

  -- map('n', '<C-f>', '<Plug>(SmoothieDownwards)', {
  --   category = 'Motion',
  --   desc = ' scroll downwards',
  --   noremap = false,
  --   silent = true,
  -- })

  -- vim.api.nvim_buf_del_var(0, 'minianimate_disable')
  -- map('n', '<space>', '<cmd>normal! <C-f><C-f><cr>', {
  -- map('n', '<space>', '<Plug>(SmoothieDownwards)<Plug>(SmoothieDownwards)', {
  --   category = 'Motion',
  --   desc = ' scroll forwards x2',
  --   noremap = false,
  --   silent = true,
  -- })
end

local function setup_gg()
  -- map('n', 'gg', '<Plug>(Smoothie_gg)', {
  --   category = 'Motion',
  --   desc = ' scroll top',
  --   silent = true,
  -- })
end

local function setup_G()
  -- map('n', 'G', '<Plug>(Smoothie_G)', {
  --   category = 'Motion',
  --   plugin = 'vim-smoothie',
  --   desc = ' scroll bottom',
  --   silent = true,
  -- })
end

map('n', '<PageUp>', '<Plug>(SmoothieUpwards)', {
  category = 'Motion',
  plugin = 'vim-smoothie',
  desc = ' scroll upwards',
  silent = true,
})

map('n', '<PageDown>', '<Plug>(SmoothieDownwards)', {
  category = 'Motion',
  plugin = 'vim-smoothie',
  desc = ' scroll downwards',
  silent = true,
})

return { setup_paging = setup_paging, setup_gg = setup_gg, setup_G = setup_G }
