vim.on_key(function(key, typed)
  vim.dbglog.log(key, typed)

  -- local statusline_enabled = vim.g.screenkey_statusline_component
  -- if not active and not statusline_enabled then
  --   kill_timer()
  --   return
  -- end
  -- if Util.should_disable() then
  --   return
  -- end
  -- typed = typed or key
  -- if not typed or #typed == 0 then
  --   return
  -- end
  -- time = 0
  -- if not timer then
  --   create_timer()
  -- end
  -- local transformed_keys = transform_input(typed)
  -- for _, k in pairs(transformed_keys) do
  --   table.insert(queued_keys, k)
  -- end
  -- if active then
  --   queued_keys = Config.options.filter(queued_keys)
  --   display_text()
  -- end
  -- if not Config.options.disable.events and statusline_enabled then
  --   vim.api.nvim_exec_autocmds("User", { pattern = "ScreenkeyUpdated" })
  -- end
end, ns_id)
