local handle_merge = function(_messages)
  local todo = {}
  local groups = {}
  -- loop from 0 to 5
  for i = 0, 5 do
    local messages = {}
    local content = {}
    for _, m in ipairs(_messages) do
      local lvl_num = m.level or 1
      if type(lvl_num) == "string" then
        lvl_num = vim.lsp.log_levels[string.upper(lvl_num)]
      end
      if lvl_num == i then
        table.insert(messages, m)
        table.insert(content, m:content())
      end
    end
    if #messages > 0 or #content > 0 then
      groups[i] = groups[i]
        or {
          content = {},
          messages = {},
          title = nil,
          timeout = nil,
        }
    end
    for _, msg in ipairs(messages) do
      if msg.opts then
        if groups[i].opts ~= nil and table.concat(msg.opts) ~= table.concat(groups[i].opts) then
          vim.dbglog("**NOTIFY VIEW**", "opts mismatch", groups[i].opts, msg.opts)
        end
        groups[i].opts = msg.opts
      end
      if msg.opts.title then
        if groups[i].title ~= nil and msg.opts.title ~= groups[i].title then
          vim.dbglog("**NOTIFY VIEW**", "title mismatch", groups[i].title, msg.opts.title)
        end
        groups[i].title = msg.opts.title
      end
      table.insert(groups[i].messages, msg)
    end
    for _, line in ipairs(content) do
      table.insert(groups[i].content, line)
    end
  end
  for lvl, group in pairs(groups) do
    table.insert(todo, {
      content = vim.fn.join(group.content, "\n"),
      messages = group.messages,
      level = lvl,
      title = group.title,
      opts = group.opts,
    })
  end
  return todo
end

return handle_merge
