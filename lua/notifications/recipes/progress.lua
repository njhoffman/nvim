-- Utility functions shared between progress reports for LSP and DAP
function round2(num, numDecimalPlaces)
  return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

local function configure_progress_notifs()
  local notify = require("notifications.recipes.nvim-notify")
  local spinners = {}

  local actions = {
    "diagnostics",
    "diagnostics_on_open",
    "loading workspace",
    "processing file symbols",
    "formatting",
    "processing references",
    "processing files",
    "processing completion",
    "processing hover",
  }

  vim.api.nvim_create_autocmd("User", {
    group = vim.api.nvim_create_augroup("LspNotify", { clear = true }),
    pattern = "LspProgressUpdate",
    desc = "LSP progress notifications",
    callback = function()
      for _, client in pairs(vim.lsp.get_active_clients()) do
        for token, ctx in pairs(client.messages.progress) do
          if not spinners[client.id] then
            spinners[client.id] = {}
          end
          local s = spinners[client.id][token]
          if not ctx.done then
            if not s then
              local msg = notify.format_message(ctx.message, ctx.percentage)
              local opts = { title = notify.format_title(ctx.title, client.name), hide_from_history = true }
              ctx.start_time = vim.fn.reltime()
              ctx.lsp_name = client.name
              if type(opts.title) ~= nil and #opts.title > 0 then
                ctx.width = #opts.title + 2
              end
              local lvl = vim.log.levels.TRACE
              if ctx.title == "Loading workspace" then
                ctx.total_items = vim.fn.split(ctx.message, "/")[2]
                ctx.items_label = "files"
                lvl = vim.log.levels.DEBUG
              end
              spinners[client.id][token] = notify.Spinner(msg, lvl, opts)
            else
              s:update(notify.format_message(ctx.message, ctx.percentage))
            end
          else
            client.messages.progress[token] = nil
            if s then
              local message = ctx.message or "Completed: "
              if ctx.total_items then
                message = message .. ctx.total_items .. " " .. ctx.items_label
              end
              message = message .. " " .. round2(vim.fn.reltimestr(vim.fn.reltime(ctx.start_time)), 4) .. "s"
              s:done(message, nil, { icon = " ", hide_from_history = false })
              spinners[client.id][token] = nil
            end
          end
        end
      end
    end,
  })
end

return { config = configure_progress_notifs }
