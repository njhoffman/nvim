local c = require("configs.dap.util").create_cmd
local f = require("configs.dap.util.functions")

local M = {}
local session_eval = function()
  return require("dap").session() ~= nil
end

-- 	config = function()
-- 		require("dap").configurations.lua = {
-- 			{ type = "nlua", request = "attach", name = "Attach to running Neovim instance" },
-- 		}
-- 		require("dap").adapters.nlua = function(callback, config)
-- 			callback {
-- 				type = "server",
-- 				host = config.host or "127.0.0.1", ---@diagnostic disable-line: undefined-field
-- 				port = config.port or 8086, ---@diagnostic disable-line: undefined-field
-- 			}
-- 		end
-- 	end,
-- 	-- INFO this debugger the only one that needs manual starting, other
-- 	-- debuggers start with `continue` by themselves
-- 	keys = {
-- 		-- 1. Two nvim instances, one for debuggee and one for debugger
-- 		--   a) `require("osv").launch` must be used on debuggee-instance
-- 		--   b) breakpoints must be set in debugger-instance
-- 		{
-- 			"<leader>dl",
-- 			function() require("osv").launch() end,
-- 			ft = "lua",
-- 			desc = " Use instance as debuggee",
-- 		},
-- 		-- 2. One nvim instance, runs current file via * `require("osv").run_this`
-- 		-- less flexible, but quicker to start. Useful just to check code samples.
-- 		{
-- 			"7",
-- 			function()
-- 				if require("dap").status() == "" then
-- 					require("osv").run_this()
-- 				else
-- 					require("dap").continue()
-- 				end
-- 			end,
-- 			ft = "lua",
-- 			desc = " Continue (lua)",
-- 		},
-- 	},
function M.setup(dap)
  dap = dap or require("dap")
  local widgets = require("dap.ui.widgets")
  -- user commands
  c("DapClearBreakpoints", function()
    local message = session_eval()
        and string.format("Breakpoints disabled for '%s'", dap.session().config.name)
      or string.format("Breakpoints disabled")
    vim.notify(message, vim.log.levels.INFO)
    dap.clear_breakpoints()
  end)
  c("DapConditionalBreakpoints", function()
    require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
  end)
  c("DapReplTab", function()
    f.tab_cb(dap.repl.toggle, session_eval)
  end)
  c("DapReplSplit", function()
    if session_eval() then
      dap.repl.toggle({ height = 12 }, "split")
    end
  end)
  c("DapReplVSplit", function()
    if session_eval() then
      dap.repl.toggle({ width = 50 }, "vsplit")
    end
  end)
  c("DapScopesTab", function()
    widgets.scopes.new_buf()
  end)
  c("DapScopesVSplit", function()
    if session_eval() then
      widgets.sidebar(widgets.scopes, { width = 50 }, "vsplit").open()
    end
  end)
  c("DapScopesTab", function()
    if session_eval() then
      vim.api.nvim_command("tabnew")
      widgets
        .builder(widgets.scopes)
        .new_buf(function()
          return vim.api.nvim_create_buf(false, true)
        end)
        .new_win(function()
          return vim.api.nvim_get_current_win()
        end)
        .build()
        .open()
    end
  end)
  local win_opts = { border = "rounded" }
  c("DapScopesFloat", function()
    widgets.cursor_float(widgets.scopes, win_opts)
  end)
  c("DapFramesFloat", function()
    widgets.cursor_float(widgets.frames, win_opts)
  end)
  c("DapThreadsFloat", function()
    widgets.cursor_float(widgets.threads, win_opts)
  end)

  -- keybindings
  local map = require("mapper").map
  local function set_km(key, cmd)
    map("n", "<leader>" .. key, cmd)
  end
  local keymaps = {
    ds = "DapScopesFloat",
    dS = "DapScopesTab",
    du = "DapFramesFloat",
    dt = "DapThreadsFloat",
    dr = "DapReplSplit",
    dV = "DapReplVSplit",
    dR = "DapReplTab",
    dv = "DapScopesVSplit",
    dw = "DapViewWatch",
  }
  for key, cmd in pairs(keymaps) do
    set_km(key, "<cmd>" .. cmd .. "<cr>")
  end

  local launch_osv = function()
    vim.dbglog("Attempting to launch osv")
    require("osv").launch({ port = 8086 })
  end

  c("DapOsvLaunch", launch_osv)
  map("n", "<leader>dl", launch_osv)
end

return M
