local devbox_lsp = require("devbox.lsp")
local devbox_methods = require("devbox.methods")

local update_preview = function(bufnr)
  local line_idx = 0
  for _, method in pairs(devbox_methods.ext) do
    local start_time = vim.fn.reltime()
    local ret = method[2](start_time)
    vim.api.nvim_buf_set_lines(bufnr, line_idx, line_idx + 1, false, { ret.summary })
    vim.api.nvim_buf_add_highlight(bufnr, 0, "Comment", line_idx, 1, 10)
    vim.api.nvim_buf_add_highlight(bufnr, 0, ret.hl, line_idx, 10, 11 + string.len(method[1]))
    line_idx = line_idx + 1
  end

  for _, method in pairs(devbox_methods.lsp) do
    local lsp_cb = function(lsp_ret)
      if lsp_ret ~= nil and lsp_ret.summary ~= nil then
        local line = lsp_ret.summary
        local idx = lsp_ret.idx
        vim.api.nvim_buf_set_lines(bufnr, idx, idx + 1, false, { line })
        vim.api.nvim_buf_add_highlight(bufnr, 0, "Comment", idx, 1, 10)
        vim.api.nvim_buf_add_highlight(bufnr, 0, lsp_ret.hl, idx, 10, 11 + string.len(method[1]))
        return
      end
      return lsp_ret
    end

    local start_time = vim.fn.reltime()
    if devbox_lsp.enabled(method[2]) then
      devbox_lsp.method(method, start_time, line_idx, lsp_cb)
      line_idx = line_idx + 1
    end
  end
end

return {
  update_preview = update_preview,
}
