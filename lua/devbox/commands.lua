local devbox_lsp = require("devbox.lsp")
local devbox_methods = require("devbox.methods")
local state = require("devbox.state")
local methods = require("devbox.methods")

local update_preview = function()
  local line_idx = 0

  for _, method in pairs(devbox_methods.ext) do
    local name = method[1]
    state.timings[name] = state.timings[name] or { n = 0, total = 0 }

    ---@diagnostic disable-next-line: missing-parameter
    local start_time = vim.fn.reltime()
    local ret = method[2](start_time, state.timings[name])

    vim.api.nvim_buf_set_lines(state.prev_bufnr, line_idx, line_idx + 1, false, { ret.summary })
    vim.api.nvim_buf_add_highlight(state.prev_bufnr, 0, "Comment", line_idx, 1, 10)
    vim.api.nvim_buf_add_highlight(state.prev_bufnr, 0, ret.hl, line_idx, 10, 11 + string.len(method[1]))
    vim.diagnostic.reset(nil, state.prev_bufnr)
    line_idx = line_idx + 1
  end

  for _, method in pairs(devbox_methods.lsp) do
    local name = method[1]
    state.timings[name] = state.timings[name] or { n = 0, total = 0 }
    local lsp_cb = function(lsp_ret)
      if lsp_ret ~= nil and lsp_ret.summary ~= nil then
        local line = lsp_ret.summary
        local idx = lsp_ret.idx
        vim.api.nvim_buf_set_lines(state.prev_bufnr, idx, idx + 1, false, { line })
        vim.api.nvim_buf_add_highlight(state.prev_bufnr, 0, "Comment", idx, 1, 10)
        vim.api.nvim_buf_add_highlight(state.prev_bufnr, 0, lsp_ret.hl, idx, 10, 11 + string.len(method[1]))
        vim.diagnostic.reset(nil, state.prev_bufnr)
        return
      end
      return lsp_ret
    end

    ---@diagnostic disable-next-line: missing-parameter
    local start_time = vim.fn.reltime()
    if devbox_lsp.enabled(name) then
      devbox_lsp.method(method, start_time, line_idx, state.timings[name], lsp_cb)
      line_idx = line_idx + 1
    end
  end
end

local stop = function()
  local has_group = function(name)
    local has_match = false
    for _, augroup in ipairs(vim.fn.split(vim.fn.execute("augroup"))) do
      has_match = augroup == name or has_match
    end
    return has_match
  end
  vim.api.nvim_del_user_command("DevboxStop")
  if has_group("Devbox") then
    vim.api.nvim_del_augroup_by_name("Devbox")
  end
end

local start = function()
  local parent = {
    w = vim.api.nvim_win_get_width(0),
    h = vim.api.nvim_win_get_height(0),
  }

  local linecnt = #methods.ext + #methods.lsp

  local prev_winnr = vim.api.nvim_open_win(0, false, {
    relative = "win",
    height = linecnt,
    width = 50,
    focusable = false,
    border = "rounded",
    bufpos = { 0, 0 },
    row = parent.h / 2,
    col = parent.w,
    anchor = "SE",
    zindex = 2,
    style = "minimal",
  })

  state.base_bufnr = vim.api.nvim_get_current_buf()
  state.prev_bufnr = vim.api.nvim_create_buf(false, true)
  state.prev_winnr = prev_winnr
  vim.api.nvim_win_set_buf(state.prev_winnr, state.prev_bufnr)

  update_preview()
  vim.diagnostic.reset(nil, state.prev_bufnr)
end

local setup = function()
  vim.api.nvim_del_user_command("Devbox")

  vim.api.nvim_create_user_command("DevboxStop", function()
    vim.api.nvim_win_close(state.prev_winnr, true)
  end, { desc = "Stop Devbox inspection" })

  vim.api.nvim_create_augroup("Devbox", { clear = true })
  local au_cursor_id = 0
  local au_cursor = function(_bufnr)
    au_cursor_id = vim.api.nvim_create_autocmd("CursorMoved", {
      callback = function()
        update_preview()
      end,
      group = "Devbox",
      buffer = _bufnr,
    })
  end
  au_cursor(vim.api.nvim_win_get_buf(0))

  vim.api.nvim_create_autocmd("BufEnter", {
    callback = function(ev)
      vim.api.nvim_del_autocmd(au_cursor_id)
      au_cursor(tonumber(ev.match))
    end,
    group = "Devbox",
  })

  vim.api.nvim_create_autocmd("WinClosed", {
    callback = function(ev)
      if ev.match == tostring(state.prev_winnr) then
        stop()
      end
    end,
    group = "Devbox",
  })

  start()
end

local init = function()
  vim.api.nvim_create_user_command("Devbox", function()
    setup()
  end, { desc = "Start devbox inspection window" })
end

return {
  update_preview = update_preview,
  start = start,
  stop = stop,
  init = init,
}
