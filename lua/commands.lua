vim.api.nvim_create_user_command(
  "Format",
  vim.lsp.buf.format,
  {
    desc = "Format buffer using lsp"
  }
)

local truncate_log = function()
  local ext = vim.fn.expand("%:e")
  if ext ~= "log" then
    vim.notify("Not truncating log, wrong extension: " .. ext)
  else
    local file = vim.fn.expand("%:p")
    local cmd = { "truncate", "--size", "0", file }
    vim.fn.jobstart(
      cmd,
      {
        on_exit = function(_, code)
          if (code == 0) then
            vim.notify("truncated: " .. file)
            vim.api.nvim_command('edit')
          else
            vim.notify("Code: " .. code .. " - problem truncating file: " .. file, "error")
          end
        end
      }
    )
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

return M
