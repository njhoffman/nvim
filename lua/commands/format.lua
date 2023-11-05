local state = { timer = nil }

local function throttle(func, delay)
  if state.timer then
    return
  end
  state.timer = vim.fn.timer_start(delay, function()
    -- local args = { ... }
    pcall(vim.schedule_wrap(function()
      func(config)
    end))
    vim.fn.timer_stop(state.timer)
    state.timer = nil
  end)
end

local function format(arg)
  -- throttle(function()
  local bufnr = arg.fargs[1] and tonumber(arg.fargs[1]) or 0
  local lsp_name = arg.fargs[2] or ''
  if vim.b.format_on_write == 0 then
    vim.notify('Skipping format on write: ' .. lsp_name, 1)
    return
  end
  vim.notify('Formatting: ' .. lsp_name)
  vim.lsp.buf.format({
    --   filter = function(client) return client.name ~= "tsserver" end
    async = false,
    bufnr = bufnr,
    timeout = 3000,
  })
  -- end, 200)
end

-- vim.api.nvim_create_user_command("PasteChar", function()
--   local txt = vim.g
-- end, { desc = "Paste primary buffer charwise (strip line endings)" })
-- vim.api.nvim_create_user_command( "PasteLinewise"
-- )

local truncate_log = function()
  local ext = vim.fn.expand('%:e')
  if ext ~= 'log' then
    vim.notify('Not truncating log, wrong extension: ' .. ext)
  else
    local file = vim.fn.expand('%:p')
    local cmd = { 'truncate', '--size', '0', file }
    vim.fn.jobstart(cmd, {
      on_exit = function(_, code)
        if code == 0 then
          vim.notify('truncated: ' .. file)
          vim.api.nvim_command('edit')
        else
          vim.notify('Code: ' .. code .. ' - problem truncating file: ' .. file, 4)
        end
      end,
    })
  end
end

-- -- Performs 'inccommand' preview if invoked as a preview cb (preview_ns is non-nil).
local function trim_space(opts, preview_ns, preview_buf)
  local line1 = opts.line1
  local line2 = opts.line2
  local buf = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(buf, line1 - 1, line2, false)
  local new_lines = {}
  local preview_buf_line = 0

  for i, line in ipairs(lines) do
    local startidx, endidx = string.find(line, '%s+$')

    if startidx ~= nil then
      -- Highlight the match if in command preview mode
      if preview_ns ~= nil then
        vim.api.nvim_buf_add_highlight(buf, preview_ns, 'Substitute', line1 + i - 2, startidx - 1, endidx)

        -- Add lines and highlight to the preview buffer
        -- if inccommand=split
        if preview_buf ~= nil then
          local prefix = string.format('|%d| ', line1 + i - 1)

          vim.api.nvim_buf_set_lines(preview_buf, preview_buf_line, preview_buf_line, 0, { prefix .. line })
          vim.api.nvim_buf_add_highlight(
            preview_buf,
            preview_ns,
            'Substitute',
            preview_buf_line,
            #prefix + startidx - 1,
            #prefix + endidx
          )

          preview_buf_line = preview_buf_line + 1
        end
      end
    end

    if not preview_ns then
      new_lines[#new_lines + 1] = string.gsub(line, '%s+$', '')
    end
  end

  -- Don't make any changes to the buffer if previewing
  if not preview_ns then
    vim.api.nvim_buf_set_lines(buf, line1 - 1, line2, 0, new_lines)
  end

  -- When called as a preview callback, return the value of the
  -- preview type
  if preview_ns ~= nil then
    return 2
  end
end

local function delete_special()
  if vim.api.nvim_get_current_line():match('^%s*$') then
    return '"_dd'
  else
    return 'dd'
  end
end

-- vim.keymap.set("n", "dd", delete_special, { noremap = true, expr = true })

local function delete_special_v()
  local l, _ = unpack(vim.api.nvim_win_get_cursor(0))
  for _, line in ipairs(vim.api.nvim_buf_get_lines(0, l - 1, l, true)) do
    if line:match('^%s*$') then
      return '"_d'
    end
  end
  return 'd'
end

local create_cmd_truncate = function(_bufnr)
  local bufnr = _bufnr or vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_create_user_command(bufnr, 'Truncate', truncate_log, {
    desc = 'Truncate logfile',
  })
end
-- vim.keymap.set("v", "d", delete_special_v, { noremap = true, expr = true })
--
return { format = format, trim_space = trim_space, truncate_log = truncate_log }
