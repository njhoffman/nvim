local error_patterns = {
  -- '^E[%d]+: Error',
  "^E[%d]+:",
  "^Error executing Lua callback",
  "^Vim:Error executing Lua callback",
}

local title_ignore = {
  "Notify",
  "Notification",
  "Messages",
  "Warning",
  "hardtime",
}

local render = function(bufnr, notif, highlights, config)
  local title = (notif.title and type(notif.title) == "table" and notif.title[1]) and notif.title[1]
    or ""
  -- if notif.level == 'ERROR' and #title == 0 then
  --   title = 'ERROR'
  --   notif.title[1] = title
  -- end

  local first_line = type(notif.message) == "table" and notif.message[1]
    or vim.fn.split(notif.message, "\n")[1]

  local is_error = false
  for _, pattern in ipairs(error_patterns) do
    is_error = is_error or string.match(first_line, pattern)
  end

  if is_error then
    -- return require('notify.render.error')(bufnr, notif, highlights, config)
    -- notif.level = 'ERROR'
    -- return require('notify.render.wrapped-compact')(bufnr, notif, highlights, config)
    return require("notify.render.simple-notitle")(bufnr, notif, highlights, config)
  elseif #title > 0 and not vim.tbl_contains(title_ignore, title) then
    -- return require('notify.render.compact')(bufnr, notif, highlights, config)
    return require("notify.render.wrapped-compact")(bufnr, notif, highlights, config)
    -- return require('notify.render.' .. render_title)(bufnr, notif, highlights, config)
  else
    return require("notify.render.simple-notitle")(bufnr, notif, highlights, config)
    -- return require('notify.')(bufnr, notif, highlights)
  end
end

return render
