local display_print = require('options.display.print')
local display_notify = require('options.display.notify')
local display_list = require('options.display.list')

local function enable_colorizer(bufnr)
  require("colorizer").setup()
  vim.cmd("augroup nvim_colorizer_buf_" .. bufnr)
  vim.cmd([[ ColorizerAttachToBuffer | au! ]])
  vim.cmd("autocmd FileType <buffer=" .. bufnr .. "> lua require'colorizer'.setup()")
  vim.cmd([[
    augroup END
    command! -buffer DisableNvimColorizer :lua require"options".disable_colorizer(vim.api.nvim_get_current_buf())
  ]])
end

local function disable_colorizer(bufnr)
  vim.cmd("augroup nvim_colorizer_buf_" .. bufnr)
  vim.cmd([[ 
    au!  | augroup END
    delcommand DisableNvimColorizer
    ColorizerDetachFromBuffer
  ]])
end

return {
  print_options     = display_print,
  notify_options    = display_notify,
  list_options      = display_list,
  enable_colorizer  = enable_colorizer,
  disable_colorizer = disable_colorizer
}
