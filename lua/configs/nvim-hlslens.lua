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
