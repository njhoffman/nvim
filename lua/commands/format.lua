vim.api.nvim_create_user_command(
  "Format", vim.lsp.buf.format, {
  desc = "Format buffer using lsp"
})

vim.api.nvim_create_user_command(
  "PasteChar",
  function()
    local txt = vim.g
  end,
  { desc = "Paste primary buffer charwise (strip line endings)" }
)

-- vim.api.nvim_create_user_command( "PasteLinewise"
-- )

local truncate_log = function()
  local ext = vim.fn.expand("%:e")
  if ext ~= "log" then
    vim.notify("Not truncating log, wrong extension: " .. ext)
  else
    local file = vim.fn.expand("%:p")
    local cmd = { "truncate", "--size", "0", file }
    vim.fn.jobstart(cmd, {
      on_exit = function(_, code)
        if (code == 0) then
          vim.notify("truncated: " .. file)
          vim.api.nvim_command('edit')
        else
          vim.notify("Code: " .. code .. " - problem truncating file: " .. file, "error")
        end
      end
    })
  end
end


local M = {}
M.create_cmd_truncate = function(bufnr)
  local bufnr = bufnr or vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_create_user_command(
    bufnr,
    "Truncate",
    truncate_log,
    {
      desc = "Format buffer using lsp"
    }
  )
end


-- Trims trailing whitespace in the current buffer.
-- Performs 'inccommand' preview if invoked as a preview cb (preview_ns is non-nil).
local function trim_space(opts, preview_ns, preview_buf)
  local line1 = opts.line1
  local line2 = opts.line2
  local buf = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(buf, line1 - 1, line2, 0)
  local new_lines = {}
  local preview_buf_line = 0

  for i, line in ipairs(lines) do
    local startidx, endidx = string.find(line, '%s+$')

    if startidx ~= nil then
      -- Highlight the match if in command preview mode
      if preview_ns ~= nil then
        vim.api.nvim_buf_add_highlight(
          buf, preview_ns, 'Substitute', line1 + i - 2, startidx - 1,
          endidx
        )

        -- Add lines and highlight to the preview buffer
        -- if inccommand=split
        if preview_buf ~= nil then
          local prefix = string.format('|%d| ', line1 + i - 1)

          vim.api.nvim_buf_set_lines(
            preview_buf, preview_buf_line, preview_buf_line, 0,
            { prefix .. line }
          )
          vim.api.nvim_buf_add_highlight(
            preview_buf, preview_ns, 'Substitute', preview_buf_line,
            #prefix + startidx - 1, #prefix + endidx
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

-- Create the user command
vim.api.nvim_create_user_command(
  'TrimTrailingWhitespace',
  trim_space,
  { nargs = '?', range = '%', addr = 'lines', preview = trim_space }
)
