-- modules.markdown.wrap_scroll: turn off mini.animate scrolling in buffers where render-markdown
-- wraps table rows. A wrapped row is drawn as virtual lines over a concealed source line, and
-- render-markdown always shows the raw line under the cursor, so the row shrinks to one line when
-- the cursor reaches it. With scrolloff=999 that re-centers the view, and animating that scroll
-- fights the cursor move. Without animation it is one instant re-center.
-- Wired into render-markdown's on.render / on.clear callbacks (configs/render-markdown), so it
-- only runs for buffers render-markdown attaches to.
local M = {}

local override = { scroll = { enable = false } }

-- Per buffer: decorator generation the answer was computed for, and the answer.
local cache = {}

--- Whether render-markdown's current marks for the buffer include a wrapped table row. Reads the
--- decorator, not the buffer's extmarks: the row under the cursor is removed from the buffer, so
--- a buffer whose only wrapped row is the cursor row would otherwise flip back and forth.
--- @param buf integer
--- @return boolean
function M.has_wrapped(buf)
  buf = buf == 0 and vim.api.nvim_get_current_buf() or buf
  local ok, ui = pcall(require, "render-markdown.core.ui")
  if not ok or type(ui.cache) ~= "table" then
    return false
  end
  local decorator = ui.cache[buf]
  if not decorator then
    return false
  end
  local entry = cache[buf]
  if entry and entry.n == decorator.n then
    return entry.wrapped
  end
  local wrapped = false
  local got, extmarks = pcall(decorator.get, decorator)
  for _, extmark in ipairs(got and extmarks or {}) do
    local mark = extmark:get()
    if mark.replace and mark.opts and mark.opts.conceal_lines then
      wrapped = true
      break
    end
  end
  cache[buf] = { n = decorator.n, wrapped = wrapped }
  return wrapped
end

--- Restore the buffer's own mini.animate config, if this module replaced it.
--- @param buf integer
function M.restore(buf)
  if not vim.api.nvim_buf_is_valid(buf) or not vim.b[buf].wrap_scroll_active then
    return
  end
  vim.b[buf].minianimate_config = vim.b[buf].wrap_scroll_prev
  vim.b[buf].wrap_scroll_prev = nil
  vim.b[buf].wrap_scroll_active = nil
end

--- Disable scroll animation in the buffer, keeping the rest of its mini.animate config.
--- @param buf integer
function M.disable(buf)
  if vim.b[buf].wrap_scroll_active then
    return
  end
  local prev = vim.b[buf].minianimate_config
  vim.b[buf].wrap_scroll_prev = prev
  vim.b[buf].minianimate_config = vim.tbl_deep_extend("force", prev or {}, override)
  vim.b[buf].wrap_scroll_active = true
end

--- on.render callback: match the buffer's scroll animation to whether it has wrapped rows.
--- @param ctx { buf: integer, win: integer }
function M.on_render(ctx)
  if not vim.api.nvim_buf_is_valid(ctx.buf) then
    cache[ctx.buf] = nil
    return
  end
  if M.has_wrapped(ctx.buf) then
    M.disable(ctx.buf)
  else
    M.restore(ctx.buf)
  end
end

--- on.clear callback: nothing is rendered (insert mode, disabled), so nothing collapses.
--- @param ctx { buf: integer, win: integer }
function M.on_clear(ctx)
  cache[ctx.buf] = nil
  M.restore(ctx.buf)
end

return M
