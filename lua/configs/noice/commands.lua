local restore_routes = nil
local lsp_clients = nil

local silence_start = function()
  if vim.diagnostic.is_enabled() then
    vim.diagnostic.enable(false)
  end
  lsp_clients = vim.lsp.get_clients()
  vim.lsp.stop_client(lsp_clients)
  local notify_stats = {
    pending = require("notify").pending(),
    history = require("notify").history(),
    noice = #require("noice.message.manager")._history,
    -- { filetype = "markdown", icon = "", id = 3, level = "INFO", message = { "Live commands", "   ➜ `Norm <keys>`", "   ➜ `5Reg a`", "   ➜ `G/^$/d`", "   ➜ `%Spattern/replace`" }, render = <function 3>, time = 1707851316, title = { "format", "13:08:36" } }
  }

  local noice_count = require("notify").dismiss({ silent = true, pending = true })
  vim.notify(
    "Messages and lsp silenced - "
      .. "pending: "
      .. notify_stats.pending
      .. " - noice: "
      .. notify_stats.noice,
    "info",
    { title = "Silence", timeout = 5000 }
  )
  require("notify").dismiss({ silent = true, pending = true })
  require("notify").setup({ level = 5 })

  -- require('noice').disable()
  restore_routes = vim.fn.deepcopy(require("noice.config").routes)
  require("noice").setup({
    routes = {
      -- { filter = { event = "msg_show", ["not"] = { kind = { "confirm", "confirm_sub" }, }, }, opts = { skip = true }, },
      { filter = { event = "msg_show.*", kind = "" }, opts = { skip = true } },
      { filter = { event = "notify.*", kind = "" }, opts = { skip = true } },
    },
  })
end

local silence_stop = function()
  require("noice").enable()
  require("notify").setup({ level = 2 })
  if lsp_clients then
    vim.schedule(function()
      vim.lsp.start_client(lsp_clients)
    end)
    lsp_clients = nil
  end
  if restore_routes then
    require("noice").setup({ routes = restore_routes })
    restore_routes = nil
  end
  if not vim.diagnostic.is_enabled() then
    vim.diagnostic.enable(true)
  end
end

local redirect_cmd = function(force_close)
  local cmd = vim.fn.getcmdline()
  require("noice").redirect(cmd)
  -- local cmdline = require('noice.ui.cmdline')
  -- cmdline.message:append(cmdline, 'NoiceCmdlinePopup')
  -- cmdline.message:clear()
  -- cmdline.disable() / on_hide
  -- cmdline.update()
end

local noice_flush = function()
  local count = #require("noice.message.manager")._history
  require("noice.message.manager")._history = {}
  vim.notify("Flushed " .. count .. " history entries")
end

local setup = function()
  vim.api.nvim_create_user_command("NoiceFlush", noice_flush, { desc = "flush noice history" })
  vim.api.nvim_create_user_command(
    "Silence",
    silence_start,
    { desc = "silence messaging by redirect and skip output of all routes in noice" }
  )
  vim.api.nvim_create_user_command(
    "SilenceStop",
    silence_stop,
    { desc = "Undo silence command redirects and options" }
  )

  vim.keymap.set("n", "<M-C-C>", function()
    silence_start()
  end, { desc = "silence messaging and skip noice routes output" })

  vim.keymap.set("c", "<S-CR>", function()
    redirect_cmd()
  end, { desc = "fork cmdline output to popup view" })

  vim.keymap.set("c", "<C-CR>", function()
    redirect_cmd(true)
  end, { desc = "redirect cmdline output to popup view" })
end

return { setup = setup }
