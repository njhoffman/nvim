local colors = {
  [0] = '#000000',
  [1] = '#8c1010',
  [2] = '#3f9487',
  [3] = '#9a8877',
  [4] = '#2081bc',
  [5] = '#6e5bdf',
  [6] = '#5172bf',
  [7] = '#7a8cb8',
  [8] = '#3f4f67',
}
for i, color in ipairs(colors) do
  vim.g['terminal_color_' .. i] = color
end

local cfg = {
  name = 'BaleiaColors',
  strip_ansi_codes = true,
  automatitically = true,
  line_starts_at = 1,
  colors = require('baleia.nvim.colors').theme(colors),
}

vim.cmd([[
  let s:baleia = luaeval("require('baleia').setup { log = 'DEBUG' }")
  command! BaleiaLogs call s:baleia.logger.show()

  " let s:baleia = luaeval("require('baleia').setup { }")
  " autocmd BufWinEnter my-buffer call s:baleia.automatically(bufnr('%'))

]])

vim.api.nvim_create_user_command('BaleiaColorize', function()
  require('baleia').setup({}).once(vim.api.nvim_get_current_buf())
end, { force = true })

require('baleia').setup(cfg)
