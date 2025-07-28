-- local ts_ctx = require("treesitter-context")
local state = { started = false }
-- <cmd>silent! execute "normal! 3<C-d><cr>  <cmd>normal! 3<C-d><cr>
-- map('n', '<c-f>', '<cmd>execute "normal! "<cr>', {
--   category = 'Motion',
--   plugin = 'vim-smoothie',
--   label = ' scroll forwards',
--   desc = ' smoothie scroll forwards',
--   noremap = false,
--    silent = true
--  })
--  map('n', '<c-b>', '<cmd>execute "normal! "<cr>', {
--    category = 'Motion',
--    plugin = 'vim-smoothie',
--    label = ' scroll forwards',
-- desc = ' smoothie scroll forwards',
-- noremap = false,
--   silent = true
-- })

-- map('n', '<c-b>', '<Plug>(SmoothieBackwards)', {
--   category = 'Motion',
--   plugin = 'vim-smoothie',
--   label = ' scroll backwards',
--   desc = ' smoothie scroll backwards',
--   noremap = false,
--   silent = true
-- })

-- map('n', '<c-f>', '<Plug>(SmoothieDownwards)', {
--   category = 'Motion',
--   plugin = 'vim-smoothie',
--   label = ' scroll forwards',
--   desc = ' smoothie scroll forwards',
--   noremap = false,
--   silent = true
-- })

-- map('n', '<M-f>', '<Plug>(SmoothieDownwards)', {
--   category = 'Motion',
--   plugin = 'vim-smoothie',
--   label = ' scroll forwards',
--   desc = ' smoothie scroll forwards',
--   noremap = false,
--   silent = true
-- })

-- map('n', '<M-b>', '<Plug>(SmoothieUpwards)', {
--   category = 'Motion',
--   plugin = 'vim-smoothie',
--   label = ' scroll forwards',
--   desc = ' smoothie scroll forwards',
--   noremap = false,
--   silent = true
-- })

--[[
   '<C-D>'                  'z+'
   '<C-U>'                   'z^'
   '<C-F>'                   'zt'
   '<S-Down>'                'z<CR>'
   '<PageDown>'              'z.'
   '<C-B>'                   'zz'
   '<S-Up>'                  'z-'
   '<PageUp>'                'zb'
    '<ScrollWheelDown>'       'H'
    '<ScrollWheelUp>'         'M'
    'gg'                      'L'
    'G'                       '{'
    'n'                       '}'
    'N'                       'j'
    '#'                       'k'
    '*'
    'g*'
    'g#'
  ]]
local get_state = function()
  -- stylua: ignore
  local smooth_status = type(package.loaded.smoothcursor) == 'table' and require('smoothcursor.utils').smoothcursor_status()
  return vim.tbl_extend("force", state, {
    relativenumber = vim.api.nvim_get_option_value("relativenumber", { win = 0 }),
    -- tscontext = ts_ctx.enabled(),
    minianimate = type(package.loaded["mini.animate"]) == "table" and not vim.b.minianimate_disable,
    cursor = vim.o.guicursor ~= "a:noCursor",
    smoothcursor = smooth_status,
    smearcursor = type(package.loaded["smear_cursor"]) == "table"
      and require("smear_cursor").enabled,
  })
end

local cfg = {
  -- ignore_events = { "WinScrolled", "CursorMoved" },
  events_ignored = {},
  relativenumber_off = true,
  tscontext_disable = true,
  cursor_hide = false,
  animate_disable = true,
  hlchunk_disable = true,
  smearcursor_disable = true,
  smoothcursor_disable = true,
}

local hook_start = function()
  local curr = get_state()
  if not curr.started then
    state.started = true
    if cfg.animate_disable and curr.minianimate then
      vim.b.minianimate_disable = true
    end
    if cfg.relativenumber_off and curr.relativenumber then
      state.prev_relativenumber = true
      vim.cmd([[setlocal norelativenumber number]])
      vim.opt_local.relativenumber = false
    end
    if cfg.tscontext_disable and curr.tscontext then
      -- ts_ctx.disable()
    end
    if cfg.cursor_hide and curr.cursor then
      state.prev_cursor = vim.o.guicursor
      vim.opt.guicursor = "a:noCursor"
    end
    if cfg.smearcursor_disable and curr.smearcursor then
      require("smear_cursor").toggle()
      state.smearcursor_disabled = true
    end
    if cfg.smoothcursor_disable and curr.smoothcursor then
      require("smoothcursor.utils").smoothcursor_stop()
      state.smoothcursor_disabled = true
    end
    vim.opt.eventignore:append(cfg.events_ignored)
  end
end

local hook_stop = function()
  local curr = get_state()
  if curr.started then
    state.started = false
    if cfg.animate_disable and not curr.minianimate then
      vim.b.minianimate_disable = false
    end
    if cfg.relativenumber_off and not curr.relativenumber and state.prev_relativenumber then
      vim.cmd([[setlocal relativenumber number]])
      state.prev_relativenumber = nil
    end
    if cfg.tscontext_disable and not curr.tscontext then
      -- ts_ctx.enable()
    end
    if cfg.smoothcursor_disable and not curr.smoothcursor and curr.smoothcursor_disabled then
      require("smoothcursor.utils").smoothcursor_start()
      state.smoothcursor_disabled = nil
    end
    if cfg.smearcursor_disable and not curr.smearcursor and curr.smearcursor_disabled then
      require("smear_cursor").toggle()
      state.smearcursor_disabled = nil
    end
    if cfg.cursor_hide and not curr.cursor then
      vim.o.guicursor = state.prev_cursor
      state.prev_cursor = nil
    end
    vim.opt.eventignore:remove(cfg.events_ignored)
  end
end

local setup_aucmds = function()
  vim.api.nvim_create_autocmd("User", {
    pattern = { "ScrollStart", "ScrollStop", "MiniAnimateDoneCursor", "MiniAnimateDoneScroll" },
    callback = function(ev)
      if ev.match == "ScrollStart" then
        hook_start()
        -- vim.dbglog("start", get_state())
      else
        hook_stop()
        -- vim.dbglog("stop", get_state())
      end
    end,
  })

  vim.api.nvim_create_autocmd({ "WinScrolled", "CursorHold", "CursorHoldI" }, {
    callback = function(ev)

      -- if state.started == true and ev.event == "CursorHold" or ev.event == "CursorHoldI" then
      --   vim.dbglog(" hold:", ev.event, get_state())
      -- elseif not state.started and ev.event == "WinScrolled" then
      --   vim.dbglog(" scroll:", get_state())
      -- end
      -- if ev.match == "WinScrolled" then
      --   hook_start()
      -- else
      --   hook_stop()
      -- end
    end,
  })
end

local mapper = require("mapper")
local map = mapper.map
local setup_keymaps = function()
  vim.cmd([[
    noremap <silent> <Plug>(SmoothieDownwards) <cmd>call smoothie#downwards()           <CR>
    noremap <silent> <Plug>(SmoothieUpwards)   <cmd>call smoothie#upwards()             <CR>
    noremap <silent> <Plug>(SmoothieForwards)  <cmd>call smoothie#forwards()            <CR>
    noremap <silent> <Plug>(SmoothieBackwards) <cmd>call smoothie#backwards()           <CR>
    noremap <silent> <Plug>(Smoothie_gg)       <cmd>call smoothie#cursor_movement('gg') <CR>
    noremap <silent> <Plug>(Smoothie_G)        <cmd>call smoothie#cursor_movement('G')  <CR>

    " nnoremap <unique> <C-D> <cmd>call smoothie#do("\<C-D>") <CR>
    " vnoremap <unique> <C-D> <cmd>call smoothie#do("\<C-D>") <CR>
  ]])

  map({ "n", "x" }, "gg", "<Plug>(Smoothie_gg)", {
    category = "Motion",
    plugin = "vim-smoothie",
    desc = " scroll top",
  })

  map({ "n", "x" }, "G", "<Plug>(Smoothie_G)", {
    category = "Motion",
    plugin = "vim-smoothie",
    desc = " scroll bottom",
  })

  map({ "n", "x" }, "<C-f>", "<Plug>(SmoothieDownwards)<Plug>(SmoothieDownwards)", {
    category = "Motion",
    plugin = "vim-smoothie",
    desc = " scroll downwards",
    remap = false,
  })

  map({ "n", "x" }, "<C-b>", "<Plug>(SmoothieUpwards)<Plug>(SmoothieUpwards)", {
    category = "Motion",
    plugin = "vim-smoothie",
    desc = " scroll upwards",
    remap = false,
  })
  map({ "n", "x" }, "<PageUp>", "<Plug>(SmoothieBackwards)", {
    category = "Motion",
    plugin = "vim-smoothie",
    desc = " scroll upwards",
    remap = false,
  })

  map({ "n", "x" }, "<PageDown>", "<Plug>(SmoothieForwards)", {
    category = "Motion",
    plugin = "vim-smoothie",
    desc = " scroll downwards",
    remap = false,
  })

  map(
    { "n", "x" },
    "<space>",
    "<Plug>(SmoothieDownwards)<Plug>(SmoothieDownwards)<Plug>(SmoothieDownwards)",
    {
      category = "Motion",
      desc = " scroll forwards x,2",
    }
  )
end

local setup_keymaps_v2 = function()
  vim.cmd([[
  nnoremap <unique> <C-F> <cmd>call smoother#do("\<C-D>") <CR>
  vnoremap <unique> <C-F> <cmd>call smoother#do("\<C-D>") <CR>
  nnoremap <unique> <C-B> <cmd>call smoother#do("\<C-U>") <CR>
  vnoremap <unique> <C-B> <cmd>call smoother#do("\<C-U>") <CR>
]])
end

return {
  -- setup_keymaps = setup_keymaps,
  setup_keymaps = setup_keymaps,
  setup_aucmds = setup_aucmds,
}
