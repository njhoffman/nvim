-- -- IMPROVES ASTERISK BEHAVIOR
-- "haya14busa/vim-asterisk",
-- config = function()
--   vim.keymap.set('n', '*',
--     [[<Plug>(asterisk-z*)<Cmd>lua require('hlslens').start()<CR>]],
--     {})
--   vim.keymap.set('n', '#',
--     [[<Plug>(asterisk-z#)<Cmd>lua require('hlslens').start()<CR>]],
--     {})
--   vim.keymap.set('n', 'g*',
--     [[<Plug>(asterisk-gz*)<Cmd>lua require('hlslens').start()<CR>]],
--     {})
--   vim.keymap.set('n', 'g#',
--     [[<Plug>(asterisk-gz#)<Cmd>lua require('hlslens').start()<CR>]],
--     {})

--   vim.keymap.set('x', '*',
--     [[<Plug>(asterisk-z*)<Cmd>lua require('hlslens').start()<CR>]],
--     {})
--   vim.keymap.set('x', '#',
--     [[<Plug>(asterisk-z#)<Cmd>lua require('hlslens').start()<CR>]],
--     {})
--   vim.keymap.set('x', 'g*',
--     [[<Plug>(asterisk-gz*)<Cmd>lua require('hlslens').start()<CR>]],
--     {})
--   vim.keymap.set('x', 'g#',
--     [[<Plug>(asterisk-gz#)<Cmd>lua require('hlslens').start()<CR>]],
--     {})
-- end

local override_lens = function(render, posList, nearest, idx, _)
  -- formats virtual text as a bubble
  local lnum, col = unpack(posList[idx])
  local text = ('%d/%d'):format(idx, #posList)
  local chunks = {
    { ' ', 'Ignore' }, -- = padding
    { '', 'HLSearchReversed' },
    { text, 'HlSearchLensNear' },
    { '', 'HLSearchReversed' },
  }
  render.setVirt(0, lnum - 1, col - 1, chunks, nearest)
end

local override_lens_2 = function(render, plist, nearest, idx, r_idx)
  local sfw = vim.v.searchforward == 1
  local indicator, text, chunks
  local abs_r_idx = math.abs(r_idx)
  if abs_r_idx > 1 then
    indicator = string.format('%d%s', abs_r_idx, sfw ~= (r_idx > 1) and '󰁞' or '󰁆')
  elseif abs_r_idx == 1 then
    indicator = sfw ~= (r_idx == 1) and '󰁞' or '󰁆'
  else
    indicator = ''
  end

  local lnum, col = unpack(plist[idx])
  if nearest then
    local cnt = #plist
    if indicator ~= '' then
      text = string.format('[%s %d/%d]', indicator, idx, cnt)
    else
      text = string.format('[%d/%d]', idx, cnt)
    end
    chunks = { { ' ', 'Ignore' }, { text, 'HlSearchLensNear' } }
  else
    text = string.format('[%s %d]', indicator, idx)
    chunks = { { ' ', 'Ignore' }, { text, 'HlSearchLens' } }
  end
  render.set_virt(0, lnum - 1, col - 1, chunks, nearest)
end

local hlslens_config = {
  override_lens = override_lens,
  auto_enable = true,
  calm_down = true,
  nearest_only = true,
  nearest_float_when = 'auto',
  virt_priority = 100,
  build_position_cb = function(plist, _, _, _)
    require('scrollbar.handlers.search').handler.show(plist.start_pos)
  end,
}

require('hlslens').setup(hlslens_config)

vim.cmd([[
    augroup scrollbar_search_hide
        autocmd!
        autocmd CmdlineLeave : lua require('scrollbar.handlers.search').handler.hide()
    augroup END
]])

-- -- run `:nohlsearch` and export results to quickfix
-- -- if Neovim is 0.8.0 before, remap yourself.
-- vim.keymap.set({'n', 'x'}, '<Leader>L', function()
--     vim.schedule(function()
--         if require('hlslens').exportLastSearchToQuickfix() then
--             vim.cmd('cw')
--         end
--     end)
--     return ':noh<CR>'
-- end, {expr = true})
-- ---@return boolean
-- local function should_format_lua_func()
--   local line = vim.api.nvim_get_current_line()
--   local col = vim.fn.getpos('.')[3]
--   local pattern = '%)%s*end'
--   local start_pos, end_pos = line:find(pattern)
--
--   if start_pos then
--     local res = col > start_pos and col <= end_pos
--     return res
--   end
--
--   return false
-- end
--
-- local id = nil
-- local ns = vim.api.nvim_create_namespace('search_virt')
--
-- local function clear()
--   if id ~= nil then
--     vim.api.nvim_buf_del_extmark(0, ns, id)
--   end
-- end
--
-- local function draw_virt()
--   local count = vim.fn.searchcount()
--   clear()
--   if count.current == 0 and count.total == 0 then
--     return
--   end
--   return vim.api.nvim_buf_set_extmark(0, ns, vim.api.nvim_win_get_cursor(0)[1] - 1, 0, {
--     virt_text = { { '[' .. count.current .. '/' .. count.total .. ']', 'NoiceVirtualTextOn' } },
--     virt_text_pos = 'eol',
--   })
-- end
--
-- vim.on_key(function(char)
--   local tchar = vim.fn.keytrans(char)
--   local mode = vim.fn.mode()
--   local is_cr = '<CR>' == tchar
--
--   if mode == 'c' and is_cr and vim.fn.getcmdtype() == '/' then
--     id = draw_virt()
--     return
--   end
--
--   if mode == 'n' then
--     vim.schedule(function()
--       local new_hlsearch = vim.tbl_contains({ 'n', 'N', '*', '#', '?', '/' }, char)
--       vim.opt.hlsearch = new_hlsearch
--       clear()
--
--       if new_hlsearch then
--         id = draw_virt()
--         return
--       end
--     end)
--   end
--
--   if mode == 'i' and vim.bo.ft == 'lua' and should_format_lua_func() and is_cr then
--     vim.api.nvim_feedkeys('O', 'n', true)
--     return
--   end
-- end, ns)
