local handle_diff = function(level, list, msgs)
  -- vim.dbglog("IM HERE notify")
  -- require('telescope.builtin').live_grep({ grep_open_files = true }) -- , level, list, msgs)

  -- log.info('send_notify ' .. #msgs .. ' msgs, ' ..
  --   'level: ' .. level .. ', list: ' .. list.name)
end

return {
  handle_diff = handle_diff,
}
