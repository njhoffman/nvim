-- Utility functions shared between progress reports for LSP and DAP
local function configure_progress_notifs()
  local notify = require("notifications.recipes.nvim-notify")
  local spinners = {}

  vim.api.nvim_create_autocmd("User", {
    group = vim.api.nvim_create_augroup("LspNotify", { clear = true }),
    pattern = "LspProgressUpdate",
    desc = "LSP progress notifications",
    callback = function()
      for _, c in pairs(vim.lsp.get_active_clients()) do
        for token, ctx in pairs(c.messages.progress) do
          if not spinners[c.id] then
            spinners[c.id] = {}
          end
          local s = spinners[c.id][token]
          if not ctx.done then
            if not s then
              local msg = notify.format_message(ctx.message, ctx.percentage)
              local opts = { title = notify.format_title(ctx.title, c.name), hide_from_history = true }

              local lvl = vim.log.levels.TRACE
              if ctx.title == "Loading workspace" then
                lvl = vim.log.levels.DEBUG
                opts.hide_from_history = false
              end
              spinners[c.id][token] = notify.Spinner(msg, lvl, opts)
            else
              s:update(notify.format_message(ctx.message, ctx.percentage))
            end
          else
            c.messages.progress[token] = nil
            if s then
              s:done(ctx.message or "Complete", nil, { icon = "" })
              spinners[c.id][token] = nil
            end
          end
        end
      end
    end,
  })
end

return { config = configure_progress_notifs }
