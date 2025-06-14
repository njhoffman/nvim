-- vim.loop.walk(function(handle)
--   vim.schedule(function()
--     if not handle:is_closing() then
--       vim.dbglog(handle)
--       -- handle:close()
--     end
--   end)
-- end)
local allbufs = vim.api.nvim_list_bufs()

local toremove = {}
for _, bufnr in ipairs(allbufs) do
  local bufinfo = vim.fn.getbufinfo(bufnr)[1] or {}
  local filesize = vim.fn.getfsize(bufinfo.name)
  local stats = vim.api.nvim__buf_stats(bufnr)
  local name = vim.fn.empty(bufinfo.name) == 0 and bufinfo.name or ""

  local key_trans = {
    line_count = " ",
    current_lnum = "󰗧 ",
    flush_count = " ",
    line_dirty = " ",
    uhp_extmark_size = "(uhp)",
    virt_blocks = " ",
    window_nums = "󱇛 ",
    filetype = "",
    buftype = "",
  }

  local info = vim.tbl_deep_extend("force", bufinfo, stats, {
    buftype = vim.api.nvim_get_option_value("buftype", { buf = bufnr }),
    filetype = vim.api.nvim_get_option_value("filetype", { buf = bufnr }),
    window_nums = table.concat(bufinfo.windows or {}, ","),
    line_count = vim.api.nvim_buf_line_count(bufnr),
  })

  local flags = table.concat({
    tostring(info.loaded),
    tostring(info.hidden == 1 and 0 or 1),
    tostring(info.listed),
  }, "")

  local details = ""
  for _, key in ipairs(vim.tbl_keys(info)) do
    if
      (key == "line_count" and tonumber(info[key]) >= 1)
      or (vim.fn.empty(info[key]) == 0 and key_trans[key])
    then
      details = details .. " " .. tostring(info[key]) .. key_trans[key]
    end
  end

  local size = filesize > -1 and (tostring(filesize) .. "b") or ""

  if info.listed == 0 and info.buftype == "nofile" then
    table.insert(toremove, bufnr)
  end

  vim.dbglog(
    string.format(
      "%3s '%3s' %25s %s %-30s %s",
      bufnr,
      flags,
      details,
      vim.fn.empty(name) == 0 and "\n" or "",
      vim.fn.empty(name) == 0 and ("'" .. name:gsub(tostring(os.getenv("HOME")), "~") .. "'") or "",
      vim.fn.empty(name) == 0 and size or ""
    )
  )
end

local start_mem = string.format("%.0f", collectgarbage("count") / 1000) .. "K"

for _, bufnr in ipairs(toremove) do
  vim.api.nvim_buf_delete(bufnr, { force = true })
end
collectgarbage("collect")

local end_mem = string.format("%.0f", collectgarbage("count") / 1000) .. "K"

vim.dbglog(
  string.format("Total: %-4s (%3s) \t %5s  %-5s", #allbufs, "-" .. #toremove, start_mem, end_mem)
)
