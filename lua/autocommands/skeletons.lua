-- SKELETIONS (TEMPLATES)
-- filetype -> extension
local skeletons = {
  python = 'py',
  applescript = 'applescript',
  javascript = 'jxa',
  make = 'make',
  sh = 'zsh',
}

vim.api.nvim_create_autocmd('FileType', {
  pattern = vim.tbl_keys(skeletons),
  callback = function(ctx)
    vim.defer_fn(function()
      local fileStats = vim.loop.fs_stat(vim.fn.expand('%'))
      local specialBuffer = vim.bo.buftype ~= ''
      if specialBuffer or not fileStats then
        return
      end

      local filetype = ctx.match
      local ext = skeletons[filetype]
      local skeletonFile = vim.fn.stdpath('config') .. '/templates/skeleton.' .. ext
      local noSkeleton = vim.loop.fs_stat(skeletonFile) == nil
      if noSkeleton then
        vim.notify('Skeleton', 'Skeleton file not found.', 'error')
        return
      end

      local fileIsEmpty = fileStats.size < 4 -- account for linebreaks
      if not fileIsEmpty then
        return
      end

      -- write file
      -- (idempotent, since Filetype event sometimes triggered multiple times)
      local file = io.open(skeletonFile, 'r')
      if not file then
        return
      end
      local lines = vim.split(file:read('*a'), '\n')
      file:close()
      vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
      vim.api.nvim_win_set_cursor(0, { #lines, 0 })
    end, 1)
  end,
})
