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
}

require('hlslens').setup(hlslens_config)
-- vim.cmd [[nmap <silent> n nzz:call BlingHighight()<CR>]]

-- integrate with vim-visual-multi multiple cursors
-- aug VMlens
--   au!
--   au User visual_multi_start lua require('vmlens').start()
--   au User visual_multi_exit lua require('vmlens').exit()
-- aug END
vim.api.nvim_set_keymap(
  'n',
  'n',
  [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  'n',
  'N',
  [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
  { noremap = true, silent = true }
)

vim.api.nvim_set_keymap('n', '*', [[*<Cmd>lua require('hlslens').start()<CR>]], {
  noremap = true,
  silent = true,
  -- label = 'search forward cursor',
  desc = 'search forward word nearest to the cursor.',
})

vim.api.nvim_set_keymap('n', '#', [[#<Cmd>lua require('hlslens').start()<CR>]], {
  noremap = true,
  silent = true,
  -- label = 'search backward cursor',
  desc = 'search backward word nearest to the cursor.',
})

vim.api.nvim_set_keymap('n', 'g*', [[g*<Cmd>lua require('hlslens').start()<CR>]], {
  noremap = true,
  silent = true,
  -- label = 'search forward partial',
  desc = 'search forward partial nearest to the cursor.',
})

vim.api.nvim_set_keymap('n', 'g#', [[g#<Cmd>lua require('hlslens').start()<CR>]], {
  noremap = true,
  silent = true,
  -- label = 'search backward partial',
  desc = 'search backward partial nearest to the cursor.',
})
-- vim.api.nvim_set_keymap('n', '*', [[<Plug>(asterisk-z*)<Cmd>lua require('hlslens').start()<CR>]], {})
-- vim.api.nvim_set_keymap('n', '#', [[<Plug>(asterisk-z#)<Cmd>lua require('hlslens').start()<CR>]], {})
-- vim.api.nvim_set_keymap('n', 'g*', [[<Plug>(asterisk-gz*)<Cmd>lua require('hlslens').start()<CR>]], {})
-- vim.api.nvim_set_keymap('n', 'g#', [[<Plug>(asterisk-gz#)<Cmd>lua require('hlslens').start()<CR>]], {})
--
-- vim.api.nvim_set_keymap('x', '*', [[<Plug>(asterisk-z*)<Cmd>lua require('hlslens').start()<CR>]], {})
-- vim.api.nvim_set_keymap('x', '#', [[<Plug>(asterisk-z#)<Cmd>lua require('hlslens').start()<CR>]], {})
-- vim.api.nvim_set_keymap('x', 'g*', [[<Plug>(asterisk-gz*)<Cmd>lua require('hlslens').start()<CR>]], {})
-- vim.api.nvim_set_keymap('x', 'g#', [[<Plug>(asterisk-gz#)<Cmd>lua require('hlslens').start()<CR>]], {})
