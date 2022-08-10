local display_print = require('utils.options.display.print')
local display_notify = require('utils.options.display.notify')
local display_list = require('utils.options.display.list')


local function enable_colorizer(bufnr)
  require("colorizer").setup()
  vim.cmd("augroup nvim_colorizer_buf_" .. bufnr)
  vim.cmd([[ ColorizerAttachToBuffer | au! ]])
  vim.cmd("autocmd FileType <buffer=" .. bufnr .. "> lua require'colorizer'.setup()")
  vim.cmd([[
    augroup END
    command! -buffer DisableNvimColorizer :lua require"utils.options".disable_colorizer(vim.api.nvim_get_current_buf())
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

local output_options = function(bufnr, config)
  config = config or { notify = true }
  if config.notify == true then
    return display_notify(bufnr)
  else
    display_print(bufnr)
  end
end

return {
  display_options   = output_options,
  list_options      = display_list,
  enable_colorizer  = enable_colorizer,
  disable_colorizer = disable_colorizer
}
