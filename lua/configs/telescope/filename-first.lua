vim.api.nvim_create_autocmd('FileType', {
  pattern = 'TelescopeResults',
  callback = function(ctx)
    vim.api.nvim_buf_call(ctx.buf, function()
      vim.fn.matchadd('TelescopeParent', '\t\t.*$')
      vim.api.nvim_set_hl(0, 'TelescopeParent', { link = 'Comment' })
    end)
  end,
})

local function filename_first(opts, path)
  local tail = require('telescope.utils').path_tail(path)
  local root = vim.fs.dirname(path)

  if root == '.' then
    return tail
  end

  return string.format('%s\t\t%s', tail, root)
end
-- vim.api.nvim_create_autocmd('FileType', {
--   pattern = 'TelescopeResults',
--   callback = function(ctx)
--     vim.api.nvim_buf_call(ctx.buf, function()
--       vim.fn.matchadd('TelescopeParent', '\t\t.*$')
--       vim.api.nvim_set_hl(0, 'TelescopeParent', { link = 'Comment' })
--     end)
--   end,
-- })
--
-- local function filename_first(_, path)
--   local tail = vim.fs.basename(path)
--   local parent = vim.fs.dirname(path)
--   if parent == '.' then
--     return tail
--   end
--   return string.format('%s\t\t%s', tail, parent)
-- end

-- require('telescope').setup({
--   pickers = {
--     find_files = {
--       path_display = filenameFirst,
--     },
--   },
-- })
--
return filename_first
