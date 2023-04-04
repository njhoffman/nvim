local get_buffers = function(_opts)
  local lines = {}
  local hl = {}
  local current_buffer = vim.api.nvim_get_current_buf()
  local loclist_items = {}

  for _, buffer in ipairs(vim.api.nvim_list_bufs()) do
    if buffer ~= current_buffer then
      local ignored = false
      local bufname = vim.api.nvim_buf_get_name(buffer)
      if bufname == "" then
        ignored = true
      end

      -- always ignore terminals
      if string.match(bufname, "term://.*") then
        ignored = true
      end

      if not ignored then
        local name_hl = "BuddyNormal"
        local modified = ""

        if buffer == current_buffer then
          name_hl = "BuddyBuffersActive"
        end

        if vim.api.nvim_buf_get_option(buffer, "modified") then
          modified = " *"
        end

        -- sorting = "id"
        local order = buffer
        -- if config["buffers"].sorting == "name" then
        --   order = bufname
        -- end

        local numbers_text = {}
        numbers_text = { text = buffer .. " ", hl = "SidebarNvimBuffersNumber" }

        loclist_items[#loclist_items + 1] = {
          group = "buffers",
          left = {
            get_fileicon(bufname),
            numbers_text,
            { text = bufname .. modified, hl = name_hl },
          },
          data = { buffer = buffer, filepath = bufname },
          order = order,
        }
      end
    end
  end

  local entries = {}
  for i, item in pairs(loclist_items) do
    -- left = {
    --     [1] = {
    --         hl = "Normal",
    --         text = "   "
    --     },
    --     [2] = {
    --         hl = "SidebarNvimBuffersNumber",
    --         text = "24 "
    --     },
    --     [3] = {
    --         hl = "BuddyNormal",
    --         text = "/home/nicholas/ghq/github.com/njhoffman/nvim-navbuddy/SidebarNvim_184306"
    --     }

    table.insert(entries, item.left)
  end

  -- for _, hl in pairs(line) do
  --   vim.api.nvim_buf_add_highlight(bufnr, 0, hl[1], linenum - 1 + i, hl[2], hl[3])
  -- end
  -- loclist:set_items(loclist_items, { remove_groups = false })
  -- loclist:draw(ctx, lines, hl)
  --
  -- if lines == nil or #lines == 0 then
  --     return "<no buffers>"
  -- else
  --     return { lines = lines, hl = hl }
  -- end
  return entries
end

-- local lines = {}
-- -- local parent = node.parent
--
-- local bufs = get_buffers()
-- local hls = {}
--
-- for _, bufitem in ipairs(bufs) do
--   local text = bufitem[1].text .. " " .. bufitem[2].text .. " " .. bufitem[3].text
--   table.insert(lines, text)
--   table.insert(hls, {
--     { bufitem[1].hl, #bufitem[1].text },
--     { bufitem[2].hl, #bufitem[2].text },
--     { bufitem[3].hl, #bufitem[3].text },
--   })
-- end
--
-- vim.dbglog("SET LINES", lines)
-- vim.api.nvim_buf_set_lines(buf.bufnr, 0, #lines - 1, false, lines)

--   -- • {hl_group}   Name of the highlight group to use
--   -- • {line}       Line to highlight (zero-indexed)
--   -- • {col_start}  Start of (byte-indexed) column range to highlight
--   -- • {col_end}    End of (byte-indexed) column range to highlight, or -1 to
--
-- for i, hl in ipairs(hls) do
--   local myhl = hl[1][2]
-- end
--   local start = 0
--   for col, hlpart in ipairs(hl) do
--     vim.dbglog(col, hlpart)
--   end
-- local start = 0
-- local end = hl[1][2]

-- vim.dbglog(i, hl)

-- vim.api.nvim_buf_add_highlight(buf.bufnr, 0, hl[1][1], i, start, end)
-- vim.api.nvim_buf_add_highlight(buf.bufnr, 0, hl[2][1], i, start, hl[2][2] + start)
-- {buffer}, {ns_id}, {hl_group}, {line}, {col_start}, {col_end})

-- u.set_bufopt(buf.bufnr, "modifiable", true)
--   for _, hl in pairs(line) do
--     vim.api.nvim_buf_add_highlight(bufnr, 0, hl[1], linenum - 1 + i, hl[2], hl[3])
--   end
-- end
-- u.set_bufopt(buf.bufnr, "modifiable", true)
-- u.set_lines(buf.bufnr, 0, -1, false, lines)
-- u.set_bufopt(buf.bufnr, "modifiable", false)
